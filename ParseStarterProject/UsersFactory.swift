//
//  UsersFactory.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 28/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UsersFactory: NSObject {
    //instancias compartidas... lol
    static let sharedInstance = UsersFactory()
    static let notificationName = Notification.Name("UsersLoaded")
    var users : [User] = []
    
    override init(){
        super.init()
        loadUsers()
        
       

    }
    
    func getUsers() -> [User]{
        self.loadUsers()
        return self.users
    }
    
    func loadUsers(){
        
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            } else {
                self.users.removeAll()
                for object in objects! {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.current()?.objectId {
                            
                            let email = user.email
                            let name = user.username?.components(separatedBy: "@")[0]
                            let objectID = user.objectId!
                            
                            
                            let myUser = User(objectID: objectID, name: name!.capitalized, email: email!)
                            
                            let query = PFQuery(className: "UserFriends")
                            
                            query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
                            query.whereKey("idUserFriend", equalTo: myUser.objectID)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil{
                                    print(error?.localizedDescription)
                                }else{
                                    if let objects = objects { //si existe el array son amigos ya
                                        if objects.count > 0 { // son amigos
                                            myUser.isFriend = true
                                        }
                                        
                                        
                                    }
                                }
                            })
                            
                            self.users.append(myUser)
                        }
                        
                    }
                }
                NotificationCenter.default.post(name: UsersFactory.notificationName, object: nil)
                // self.tableView.reloadData()
            }
        })
        
        
    }
    
    func findUser(idUser: String) -> User? {
        for user in self.users{
            if user.objectID == idUser{
                return user
            }
        }
        
        return nil
        
    }
    
    func findUserAt(index: Int) -> User? {
        if index >= 0 && index < self.users.count{
            return self.users[index]
            
        }
        return nil
    }
    
    
}
