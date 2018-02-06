//
//  User.swift
//  HuPOS
//
//  Created by Cody Husek on 2/5/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation

public class User {
    var id:String?
    var pin:String?
    var name:String?
    var address:String?
    var photo:String?
    var type:UserType?
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["id"] as? String
        self.pin = dictionary["pin"] as? String
        self.name = dictionary["name"] as? String
        self.address = dictionary["address"] as? String
        self.photo = dictionary["photo"] as? String
        self.type = dictionary["type"] as? UserType
    }
}
