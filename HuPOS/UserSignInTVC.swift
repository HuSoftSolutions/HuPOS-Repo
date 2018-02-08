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

class UserTVC:UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    
}

class UserSignInTVC:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var users:[User] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tableView_: UITableView!
    
    // get list of users
    override func viewDidLoad() {
        let button = UIButton.init()
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 150)
        button.setTitle("Add User ✚", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(addUserTapped(_:)), for: .touchUpInside)
        
        self.tableView_.delegate = self
        self.tableView_.dataSource = self
        
        tableView_.tableFooterView = button
        
        self.tableView_.layer.cornerRadius = 10
        self.tableView_.layer.masksToBounds = true
        self.signInButton.layer.cornerRadius = 10
        self.signInButton.layer.masksToBounds = true
        
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
        cell.userName.text = self.users[indexPath.row].name
        print("INSIDE: \(user)")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        if indexPath.row % 2 == 0 {
//            cell.backgroundColor = UIColor(red: 211/255, green:211/255, blue: 211/255, alpha: 200/255)
//        }
        return cell
    }
    
    
    
    @IBAction func addUserTapped(_ sender: Any) {
        print("tapped")
        
        
    }
    
    
}
