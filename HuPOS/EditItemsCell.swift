//
//  EditItemsCell.swift
//  
//
//  Created by Cody Husek on 3/17/18.
//

import UIKit


class EditItemsCell: UITableViewCell {
    let defaults = UserDefaults.standard

    @IBAction func stopEditingAction(_ sender: Any) {
        defaults.set(false, forKey: "EditModeOn")
        NotificationCenter.default.post(name: .editModeChanged, object: false)
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
