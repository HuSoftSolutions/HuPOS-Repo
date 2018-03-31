//
//  AddUserVC.swift
//  HuPOS
//
//  Created by Cody Husek on 2/13/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class AddUserVC: UITableViewController {
    
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var pin1Field: UITextField!
    @IBOutlet weak var pin2Field: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var tableView_: UITableView!
    let db = Firestore.firestore()
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        self.tableView_.isUserInteractionEnabled = false
        
        super.viewDidLoad()
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.layer.masksToBounds = true
        self.cancelButton.layer.cornerRadius = 10
        self.cancelButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        let alertController = UIAlertController(title: "Not Authorized!", message: "You do not have permission to add a user.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        print("Comparing: \(Auth.auth().currentUser?.uid)")
        print("Current User: \(Auth.auth().currentUser?.email ?? "")")
            db.collection("Users").whereField("AuthID", isEqualTo: Auth.auth().currentUser?.uid).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.documents.count)
                        for document in querySnapshot!.documents {
                            let userType = document.data()["UserType"] as! String
                            if(userType != "Admin"){
                                self.present(alertController, animated: true)
                            }
                        }
                    }
        
        }
        self.tableView_.isUserInteractionEnabled = true
    }
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func fieldsAreValid()->(Bool, UIAlertController){
        let email = self.emailField.text
        let pin1 = self.pin1Field.text
        let pin2 = self.pin2Field.text
        let firstName = self.firstNameField.text
        let lastName = self.lastNameField.text
        let position = self.positionField.text
        
        let alert = UIAlertController(title: "There was a problem!", message: "", preferredStyle: .alert)
        
        var error = false
        
        if !isValid(email!) {
            error = true
            alert.message?.append("Invalid email: \(email!)")
            self.emailField.text = ""
        }
        if pin1 != pin2 {
            error = true
            alert.message?.append("\nPins do not match")
            self.pin1Field.text = ""
            self.pin2Field.text = ""
        }
        
        if (pin1?.count)! < 6 {
            error = true
            alert.message?.append("\nPin must be 6 digits long")
            self.pin1Field.text = ""
            self.pin2Field.text = ""
        }
        
        if firstName!.isEmpty || lastName!.isEmpty || position!.isEmpty {
            error = true
            alert.message?.append("\nCannot leave any fields blank")
        }
        return (error, alert)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        
        let (invalid, validityAlert) = self.fieldsAreValid()
        if(invalid){
            validityAlert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(validityAlert, animated: true)
            
        }else{
            var userDictionary:[String:Any] =
                [
                    "Email":self.emailField.text!,
                    "FirstName":self.firstNameField.text!,
                    "LastName":self.lastNameField.text!,
                    "Photo":"gs://hupos-bb538.appspot.com/usericon_id76rb.png",
                    "Pin":self.pin1Field.text!,
                    "Position":self.positionField.text!,
                    "UserType":"User",
                    "AuthID":""
            ]
            
            
            Auth.auth().createUser(withEmail: userDictionary["Email"] as! String, password: userDictionary["Pin"] as! String) { (fbuser, error) in
                if((error) != nil){
                    
                    let alertController = UIAlertController(title: "There was an error.", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    userDictionary["AuthID"] = fbuser?.uid
                    self.db.collection("Users").addDocument(data: userDictionary) { _ in
                        print("Successfully added: \(userDictionary)")
                        self.emailField.text = ""
                        self.pin1Field.text = ""
                        self.pin2Field.text = ""
                        self.firstNameField.text = ""
                        self.lastNameField.text = ""
                        self.positionField.text = ""
                    }
                }
            }
        }
    }
    
    
    private func getData(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
