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
        
        tableView_.tableFooterView = button
        
        self.tableView_.layer.cornerRadius = 10
        self.tableView_.layer.masksToBounds = true
        self.signInButton.layer.cornerRadius = 10
        self.signInButton.layer.masksToBounds = true
        
        // get users
        self.refreshUserList()
        
    }
    
    func refreshUserList(){
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    @IBAction func addUserTapped(_ sender: Any) {
        print("tapped")
        
        
    }
}
