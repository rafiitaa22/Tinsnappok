//
//  FeedViewController.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 27/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
class FeedViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var posts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = UIRefreshControl()
        } else {
            // Fallback on earlier versions
        }
        let attributedTitle: NSAttributedString? = NSAttributedString(string: "Tira para recargar posts")
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl?.attributedTitle = attributedTitle
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl?.addTarget(self, action: #selector(FeedViewController.requestPosts), for: .valueChanged)
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }

    
    func requestPosts(){
        
        let query = PFQuery(className: "Post")
        // no funciona.. query.whereKey("idUser", notEqualTo: PFUser.current()?.objectId!)
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
                print(error?.localizedDescription)
                
            }else{
                
                self.posts.removeAll()
                for object in objects! {
                    
                    let objectID = object.objectId!
                    let creationDate = object.createdAt!
                    let message = object["message"] as! String
                    
                    let postPosition = self.posts.count
                    
                    let post : Post = Post(objectID: objectID, message: message, image: nil, user: nil, creationDate: creationDate)
                    self.posts.append(post)
                    
                    //DEFINIR EL USUARIO DEL POST
                    let idUser = object["idUser"]! as! String
                    
                    if let user = UsersFactory.sharedInstance.findUser(idUser: idUser) {
                        self.posts[postPosition].user = user
                        
                    }/* else{
                        let username = PFUser.current()?.username?.components(separatedBy: "@")[0].capitalized

                        self.posts[postPosition].user = User(objectID: (PFUser.current()?.objectId)!, name: username!, email: (PFUser.current()?.email)!)
                    }
                    */
                    
                    let imageFile = object["imageFile"] as! PFFile
                    imageFile.getDataInBackground(block: { (data, error) in
                        if let data = data { // si hay datos
                            let downloadedImage = UIImage(data: data)
                            
                            self.posts[postPosition].image = downloadedImage
                            if #available(iOS 10.0, *) {
                                self.tableView.refreshControl?.endRefreshing()
                            } else {
                                // Fallback on earlier versions
                            }
                            self.tableView.reloadData()
                        }
                    })
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.requestPosts), name: UsersFactory.notificationName, object: nil)
        _ = UsersFactory.sharedInstance.getUsers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UsersFactory.notificationName, object: nil)
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

extension FeedViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell   
        let post = self.posts[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        cell.dateLabel.text = formatter.string(from: post.creationDate)
        cell.contentLabel.text = post.message
        
        if post.user != nil{
            cell.usernameLabel.text = post.user?.name
            //falta añadir la img
        }
        if post.image != nil{
            cell.postImageView?.image = post.image
        }
        
        return cell
    }
    
    
}
