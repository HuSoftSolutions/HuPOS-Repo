//
//  SettingsTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/30/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

protocol SettingsTVC_HomeVC_Protocol {
    func setEditModeOn()
}

protocol SettingsTVC_SideMenu_Protocol {
    func setEditModeOn()
}

class SettingsTVC: UITableViewController {

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editModeSwitchAction(_ sender: Any) {

        if(self.EditModeSwitch.isOn){
            self.EditModeLabel.text = "On"
            self.SideMenu_Protocol?.setEditModeOn()
        }else{
            self.EditModeLabel.text = "Off"
        }
    }
    
    
    @IBOutlet weak var EditModeSwitch: UISwitch!
    @IBOutlet weak var EditModeLabel: UILabel!
    
    public var HomeVC_Protocol:SettingsTVC_HomeVC_Protocol?
    public var SideMenu_Protocol:SideMenuTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        self.EditModeSwitch.setOn(false, animated: false)
        self.EditModeLabel.text = "Off"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    public func setEditModeOff(){
        self.EditModeSwitch.setOn(false, animated: true)
        self.EditModeLabel.text = "Off"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
