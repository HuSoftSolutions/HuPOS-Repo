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
    var firstName:String?
    var lastName:String?
    var email:String?
    var photo:String?
    var position:String?
    var type:UserType?
    
    init(id:String, dictionary: [String:Any]) {
        self.id = id
        self.pin = dictionary["Pin"] as? String
        self.firstName = dictionary["FirstName"] as? String
        self.lastName = dictionary["LastName"] as? String
        self.email = dictionary["Email"] as? String
        self.photo = dictionary["Photo"] as? String
        self.position = dictionary["Position"] as? String
        self.type = dictionary["Type"] as? UserType
        
    }
    
    public func dictionary() -> [String : Any]{
        var data:[String:Any] = ["Id":String(), "Pin":String(), "FirstName":String(), "LastName":String(), "Address":String(), "Photo":String(), "Type":String()]
        data["Id"] = self.id
        data["Pin"] = self.pin
        data["FirstName"] = self.firstName
        data["LastName"] = self.lastName
        data["Email"] = self.email
        data["Photo"] = self.photo
        data["Position"] = self.position
        data["Type"] = self.type
        return data
    }
}
