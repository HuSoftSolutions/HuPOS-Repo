//
//  NotificationNameExtension.swift
//  HuPOS
//
//  Created by Cody Husek on 3/31/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let editModeChanged = Notification.Name(rawValue: "editModeChanged")
    static let inventoryItemAdded = Notification.Name(rawValue: "inventoryItemAdded")
    static let saleItemAdded = Notification.Name(rawValue: "saleItemAdded")
    static let reloadTableView = Notification.Name(rawValue: "reloadTableView")
    static let reloadCollectionView = Notification.Name(rawValue: "reloadCollectionView")
    static let saleItemChanged = Notification.Name(rawValue: "saleItemChanged")
    static let finalizeSale = Notification.Name(rawValue: "finalizeSale")
}
