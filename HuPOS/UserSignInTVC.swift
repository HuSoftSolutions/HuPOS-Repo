//
//  UserSignInTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 2/5/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class UserTVC:UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
}

class UserSignInTVC:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var users:[User] = []
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tableView_: UITableView!
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
                                        
                                        self.passcodeView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)                                            }
                    })
                    print("Auth Denied")
                    self.passcodeView.shake()
                    isValid(false)
                }else{
                    for document in documents!.documents {
                        let source = document.metadata.isFromCache ? "local cache" : "server"
                        print("Metadata: Data fetched from \(source)")
                        print("Comparing: \(String(describing: self.currentUser?.id)) to \(document.documentID)")
                        if(self.currentUser?.id == document.documentID){
                            
//                            UIView.animate(withDuration: 0.3,
//                                           animations: {
//                                            self.passcodeView.backgroundColor = UIColor.green
//                            },
//                                           completion: { _ in
//                                            UIView.animate(withDuration: 0.3) {
//                                                 self.passcodeView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)                                            }
//                            })
                            
                            
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
//                let when = DispatchTime.now() + 0.5 // change to desired number of seconds
//                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self.performSegue(withIdentifier: "to_HomeVC", sender: nil)
               // }
            }else{
                self.view.isUserInteractionEnabled = true
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "to_HomeVC"){
            if let HomeVC = segue.destination as? HomeVC {
                HomeVC.currentUser = self.currentUser
            }
            //        }else if segue.identifier == "to-LockScreenVC"{
            //            let lockScreen:LockScreenVC = segue.destination as! LockScreenVC
            //            let index = sender as! Int
            //            lockScreen.currentUser = self.users[index]
            //        }
        }
    }
    
    
    
    
    // get list of users
    
    override func viewDidLoad() {
        
        print("View loaded successfully! Welcome \(String(describing: currentUser?.firstName))!")
        
        
        
        indicator.color = UIColor.white
        indicator.frame = CGRect.init(x:0, y:0, width:10, height:10)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.sizeToFit()
        indicator.startAnimating()
        
        //            let label = UILabel.init()
        //            label.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        //            label.text = "User Sign-In"
        //            label.font = UIFont.boldSystemFont(ofSize: 50)
        //            label.textColor = UIColor.white
        //            label.backgroundColor = UIColor.init(red: 63/255, green: 143/255, blue: 145/255, alpha: 1.0)
        //            label.textAlignment = .center
        //            label.layer.cornerRadius = 10
        //            label.layer.masksToBounds = true
        self.tableView_.delegate = self
        self.tableView_.dataSource = self
        //self.tableView_.backgroundColor = UIColor.clear
        // tableView_.tableHeaderView = label
        
        
        do{
            try Auth.auth().signOut()
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        // get users
        self.refreshUserList{ ()
            self.tableView_.reloadData()
        }
    }
    
    func refreshUserList(_ completion: @escaping () -> ()){
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.users.append(User(id: document.documentID, dictionary: document.data()))
                }
                print("\n\nRefreshed list: \(self.users.count)")
                
            }
            completion()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user was selected at indexPath.row
        self.currentUser = self.users[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Returning \(self.users.count)")
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTVC
        let user = self.users[indexPath.row]
        cell.userImage.layer.cornerRadius = 50
        cell.userImage.layer.masksToBounds = true
        cell.userName.text = self.users[indexPath.row].firstName
        print("INSIDE: \(user)")
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 0, green: 0.7098, blue: 0.749, alpha: 1.0) /* #00b5bf */

        
        cell.selectedBackgroundView = selectedView
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if(indexPath.row + 1 == self.users.count){self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true}
        return cell
    }
    
    
    func flash() {
        
        
    }
    
    @IBAction func addUserTapped(_ sender: UIButton) {
        //        UIButton.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        //
        //            sender.alpha = 0.0
        //
        //        }, completion: nil)
        
    }
    
    
    
}


