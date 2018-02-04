//
//  LockScreenVC.swift
//  HuSoftPOS
//
//  Created by Cody Husek on 1/14/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
//import Firebase


class LockScreenVC : UIViewController {
    
    @IBOutlet weak var passcodeView: UIView!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    //let db = Firestore.firestore()
    
    
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = String(sender.tag)
        self.passcodeTextField.text?.append(digit)
        print("\(digit) added.\nPasscode seq: \(String(describing: self.passcodeTextField.text))\n")
    }
    
    @IBAction func clearPushed(_ sender: UIButton) {
        self.passcodeTextField.text = ""
    }
    
    @IBAction func enterPushed(_ sender: UIButton) {
        // Check pin validity
        //let query = db.collection("Users").whereField("Pin", isEqual(self.passcodeTextField.text))
        // ~/Development/HuSoft/HuPOS-Repository/StarIO.hvar ref: DocumentReference? = nil
        
        // If valid, proceed to home scree n
        performSegue(withIdentifier: "toHomeScreen", sender: " ")
        
    }
    
    
    
    override func viewDidLoad() {

        self.oneButton.layer.cornerRadius = 10
        self.twoButton.layer.cornerRadius = 10
        self.threeButton.layer.cornerRadius = 10
        self.fourButton.layer.cornerRadius = 10
        self.fiveButton.layer.cornerRadius = 10
        self.sixButton.layer.cornerRadius = 10
        self.sevenButton.layer.cornerRadius = 10
        self.eightButton.layer.cornerRadius = 10
        self.nineButton.layer.cornerRadius = 10
        self.zeroButton.layer.cornerRadius = 10
        self.clearButton.layer.cornerRadius = 10
        self.enterButton.layer.cornerRadius = 10
        self.passcodeView.layer.cornerRadius = 10
    }
    
}
