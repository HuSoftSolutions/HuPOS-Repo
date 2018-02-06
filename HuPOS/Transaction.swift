//
//  Transaction.swift
//  HuSoftPOS
//
//  Created by Cody Husek on 1/22/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation

// https://firebase.google.com/docs/firestore/query-data/queries

enum EventType { case cash, discount, credit, gift, comp, refund }

enum UserType { case superadmin, admin, manager, user }

private func getDateTimeNow() -> String{
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .long
    return formatter.string(from: Date())
}

private class Transaction {
    var id:String
    var open:Bool
    var startTime:String
    var endTime:String?
    var memberID:Int8
    var userID:Int8
    var total:Double
    var event:[Event]?
    
    init(_id:String, _memberID:Int8, _userID:Int8, _total:Double){
        self.id = _id
        self.open = true
        self.memberID = _memberID
        self.userID = _userID
        self.total = _total
        self.startTime = getDateTimeNow()
    }
}

private class Event {
    var id:String
    var type:EventType
    var amount:Double
    var userID:Int8
    
    init(_id:String, _type:EventType, _amount:Double, _userID:Int8){
        self.id = _id
        self.type = _type
        self.amount = _amount
        self.userID = _userID
    }
}

private class SalesItem {
    var transactionID:String
    var itemID:String
    var quantity:Int8
    
    init(_transactionID:String, _itemID:String, _quantity:Int8){
        self.transactionID = _transactionID
        self.itemID = _itemID
        self.quantity = _quantity
    }
    
    private class Item {
        var name:String
        var cost:Double
        var price:Double
        var tax:Bool
        var discount:Double
        
        init(_name:String, _cost:Double, _price:Double, _tax:Bool, _discount:Double){
            self.name = _name
            self.cost = _cost
            self.price = _price
            self.tax = _tax
            self.discount = _discount
        }
    }
    
   
}
