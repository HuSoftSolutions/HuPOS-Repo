//
//  SaleItemsTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//




import UIKit

protocol SaleItemsTVC_Home_Protocol{
    func setEditModeOff()
}




class SaleItemsTVC: UITableViewController, Home_SaleItemsTVC_Protocol, EditItemsCell_SaleItemsTVC_Protocol {
    
    
    
    var editMode = false
    
    var saleCells:[String] = []
    
    public var saleItemsToHome:SaleItemsTVC_Home_Protocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setEditModeOff(){
        print("Edit mode set off! [SaleItemsTVC]")
        self.editMode = false
        self.tableView.reloadData()
    }
    
    func setEditModeOn() {
        print("Edit mode set on! [SaleItemsTVC]")
        self.editMode = true
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.editMode == true){
            return 1
        }else if(self.saleCells.count == 0){
            return 1
        }else{
            return self.saleCells.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if(self.editMode == true){
            // cell = self.tableView.dequeueReusableCell(withIdentifier: "editModeCell") as! EditMenuCell
            let cell_ = self.tableView.dequeueReusableCell(withIdentifier: "editModeCell") as! EditItemsCell
            cell_.editItemsCells = self
            return cell_
            
            
            
        }else if(self.saleCells.count > 0){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "saleCell") as! SaleItemCell
            return cell!
        }else if(self.saleCells.count == 0){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "noSaleCell") as! NoSaleCell
            return cell!
        }else{
            print(self.saleCells.count)
            return cell!
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(editMode == true){
            return 400
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
