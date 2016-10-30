//
//  User.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 28/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name : String!
    var email : String!
    var objectID: String!
    var isFriend : Bool = false
    
    init(objectID: String, name: String, email: String) {
        self.objectID = objectID
        self.name = name
        self.email = email
    }

}
