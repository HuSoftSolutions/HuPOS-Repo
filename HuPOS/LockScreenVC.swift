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
import Firebase


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
    
    let db = Firestore.firestore()
    public var currentUser:User?
    
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = String(sender.tag)
        self.passcodeTextField.text?.append(digit)
    }
    
    @IBAction func clearPushed(_ sender: UIButton) {
        self.passcodeTextField.text = ""
    }
    

    
    func queryPin(isValid: @escaping (Bool) -> Void){
        // Check pin validity
        let query = db.collection("Users").whereField("Pin", isEqualTo: self.passcodeTextField.text ?? "")
        // Make sure new pins are not duplicated
        query.getDocuments { (documents, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                isValid(false)
            }else{
                if(documents?.count == 0){ print("No record found for \(self.passcodeTextField.text)")
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.passcodeView.backgroundColor = UIColor.red
                    },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.3) {
                                        self.passcodeView.backgroundColor = UIColor(displayP3Red: 39/255, green: 39/255, blue: 39/255, alpha: 0.69)                                            }
                    })
                    print("Auth Denied")
                    self.passcodeView.shake()
                    isValid(false)
                }else{
                    for document in documents!.documents {
                        let source = document.metadata.isFromCache ? "local cache" : "server"
                        print("Metadata: Data fetched from \(source)")
                        print("Comparing: \(self.currentUser?.id) to \(document.documentID)")
                        if(self.currentUser?.id == document.documentID){
                            
                            UIView.animate(withDuration: 0.3,
                                           animations: {
                                            self.passcodeView.backgroundColor = UIColor.green
                            },
                                           completion: { _ in
                                            UIView.animate(withDuration: 0.3) {
                                                self.passcodeView.backgroundColor = UIColor(displayP3Red: 39/255, green: 39/255, blue: 39/255, alpha: 0.69)                                            }
                            })
                            
                            
                            print("Auth Granted")
                        }
                    }
                    isValid(true)
                }
            }
        }
        self.passcodeTextField.text = ""
        // If valid, proceed to home scree n
        // performSegue(withIdentifier: "toHomeScreen", sender: " ")
    }
    
    
    
    @IBAction func enterPushed(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        queryPin { (isValid) in
            if isValid {
                self.view.isUserInteractionEnabled = true
                let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self.performSegue(withIdentifier: "to_HomeVC", sender: nil)
                }
            }else{
                self.view.isUserInteractionEnabled = true
            }
            
        }
    }
    
    @IBAction func userSwiped(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "to_HomeVC"){
            if let HomeVC = segue.destination as? HomeVC {
                HomeVC.currentUser = self.currentUser
            }
        }
    }
    
    override func viewDidLoad() {
        
        print("View loaded successfully! Welcome \(String(describing: currentUser?.name))!")
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


public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.3,withTranslation translation : Float = -10) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
    
    
}
