//
//  SettingsTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/30/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit


class SettingsTVC: UITableViewController {

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editModeSwitchAction(_ sender: Any) {
        NotificationCenter.default.post(name: .editModeChanged, object: self.EditModeSwitch.isOn)
        self.setEditMode(editModeOn: self.EditModeSwitch.isOn)
    }
    
    @IBOutlet weak var EditModeSwitch: UISwitch!
    @IBOutlet weak var EditModeLabel: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.allowsSelection = false
        let editModeOn = defaults.bool(forKey: "EditModeOn")
        self.setEditMode(editModeOn: editModeOn)
        
       
    }

    func setEditMode(editModeOn:Bool){
        if editModeOn {
            self.EditModeLabel.text = "On"
            self.defaults.set(true, forKey: "EditModeOn")
        }else{
            self.EditModeLabel.text = "Off"
            self.defaults.set(false, forKey: "EditModeOn")
        }
        self.EditModeSwitch.setOn(editModeOn, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "to_Settings"){
            if let settingsMenu:SettingsTVC = segue.destination as! SettingsTVC {
            }
        }
        
    }
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
