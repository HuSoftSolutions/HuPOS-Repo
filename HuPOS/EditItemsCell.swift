//
//  EditItemsCell.swift
//  
//
//  Created by Cody Husek on 3/17/18.
//

import UIKit

protocol EditItemsCell_SaleItemsTVC_Protocol{
    func setEditModeOff()
}


class EditItemsCell: UITableViewCell {
    var editItemsCells:EditItemsCell_SaleItemsTVC_Protocol?
    

    @IBAction func stopEditingAction(_ sender: Any) {
        self.editItemsCells?.setEditModeOff()

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
