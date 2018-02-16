//
//  AddUserVC.swift
//  HuPOS
//
//  Created by Cody Husek on 2/13/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

class AddUserVC: UITableViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var tableView_: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func registerAction(_ sender: UIButton) {

        
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
