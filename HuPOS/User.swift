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
    
    init(id:String, dictionary: [String:Any]) {
        self.id = id
        self.pin = dictionary["Pin"] as? String
        self.name = dictionary["Name"] as? String
        self.address = dictionary["Address"] as? String
        self.photo = dictionary["Photo"] as? String
        self.type = dictionary["Type"] as? UserType
        
    }
}
