//
//  Post.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 28/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Post: NSObject {
    var objectID : String!
    var message : String?
    var image : UIImage?
    var user : User?
    var creationDate : Date!
    
    init(objectID: String, message: String, image: UIImage?, user: User?, creationDate: Date) {
        self.objectID = objectID
        self.message = message
        self.image = image
        self.user = user
        self.creationDate = creationDate
        
    }
    
    
}
