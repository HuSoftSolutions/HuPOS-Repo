//
//  HuView.swift
//  HuPOS
//
//  Created by Cody Husek on 2/19/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation

extension UIView {
    @IBInspectable
    var CR: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var MTB: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = true
        }
    }
}
//
//extension UIButton {
//    @IBInspectable
//    var CR_B: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var MTB_B: Bool {
//        get {
//            return layer.masksToBounds
//        }
//        set {
//            layer.masksToBounds = true
//        }
//    }
//}

