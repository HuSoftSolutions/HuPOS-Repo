//
//  SaleItemsTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//




import UIKit
import EmptyDataSet_Swift



protocol SaleItemsTVC_Home_Protocol{
    func setEditModeOff()
}


class SaleItemsTVC: UITableViewController {
    
    var editModeObserver:NSObjectProtocol?

    var noSaleCell:UITableViewCell?
    
    var editModeOn = false
    
    var saleCells:[String] = []
    
    
    func createCell(){
        
        self.noSaleCell = UITableViewCell(style: .default, reuseIdentifier: "NoSaleCell")
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        createCell()
        tableView.register(NoSaleCell.self, forCellReuseIdentifier: "NoSaleCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        self.editModeOn = defaults.bool(forKey: "EditModeOn")
        
        
        editModeObserver = NotificationCenter.default.addObserver(forName: .editModeChanged, object: nil, queue: OperationQueue.main, using: { (notification) in
            let settingsTVC = notification.object as! SettingsTVC
            if(settingsTVC.EditModeSwitch.isOn){
                // Edit mode was turned on
                self.editModeOn = true
            }else{
                // Edit mode was turned off
                self.editModeOn = false
            }
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    
    // Prevent memory leak
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(editModeObserver)

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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.editModeOn || self.saleCells.count == 0){
            return 1
        }else{
            return self.saleCells.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if(self.editModeOn){
            let cell_ = self.tableView.dequeueReusableCell(withIdentifier: "editModeCell") as! EditItemsCell
        
            cell_.selectionStyle = .none

            return cell_
            
        }else if(self.saleCells.count == 0){
            let cell_ = NoSaleCell(style: .default, reuseIdentifier: "NoSaleCell")
            cell_.selectionStyle = .none

            return cell_
            
        }else{
            cell = self.tableView.dequeueReusableCell(withIdentifier: "saleCell") as! SaleItemCell
            cell?.selectionStyle = .none

            return cell!
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(editModeOn){
            return 400
        }else if(self.saleCells.count == 0){
            return self.tableView.frame.height
        }else{
            return 150
        }
        
    }
    
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
