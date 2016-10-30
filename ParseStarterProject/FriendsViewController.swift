//
//  FriendsViewController.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 27/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class FriendsViewController: UITableViewController {

    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers()
        self.refreshControl = UIRefreshControl()
        let attributedTitle: NSAttributedString? = NSAttributedString(string: "Tira para recargar amigos")
        self.refreshControl?.attributedTitle = attributedTitle
        self.refreshControl?.addTarget(self, action: #selector(FriendsViewController.loadUsers), for: .valueChanged)
        // Do any additional setup after loading the view.
        self.loadUsers()
    }
    
    func loadUsers(){
        
       /* self.users = UsersFactory.sharedInstance.getUsers()
        self.refreshControl?.endRefreshing()*/
        
        
         
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
         
         self.refreshControl?.endRefreshing()
         self.tableView.reloadData()
         
         
         }
         }
         })
         
         self.users.append(myUser)
         }
         
         }
         }
         // self.tableView.reloadData()
         }
         })
         
        

    }
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].name
        
        if self.users[indexPath.row].isFriend{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none // si no se reutilizaria el chechmark al hacer scroll...
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        if self.users[indexPath.row].isFriend { // dejar de ser amigos
            cell?.accessoryType = .none
            self.users[indexPath.row].isFriend = false
            
            let query = PFQuery(className: "UserFriends")
            query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
            query.whereKey("idUserFriend", equalTo: self.users[indexPath.row].objectID)
            query.findObjectsInBackground(block: { (objects, error) in
                if error != nil{
                    print(error?.localizedDescription)
                } else {
                    if let objects = objects {
                        for object in objects{ // hacemos for por si se duplicara el registro de amigo
                            object.deleteInBackground()
                        }
                    }
                }
            })
            
            
        
        }else{
            cell?.accessoryType = .checkmark
            self.users[indexPath.row].isFriend = true
            let friendship = PFObject(className: "UserFriends")
            friendship["idUser"] = PFUser.current()?.objectId
            friendship["idUserFriend"] = self.users[indexPath.row].objectID
            //damos permisos para leer y escribir a todos
            let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true
            
            friendship.acl = acl
            friendship.saveInBackground()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
