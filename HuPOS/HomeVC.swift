//
//  HomeVC.swift
//  HuSoftPOS
//
//  Created by Cody Husek on 1/4/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
//import EmptyDataSet_Swift

class HomeVC:UIViewController, UITableViewDelegate
/*, EmptyDataSetSource, EmptyDataSetDelegate*/ {
    
    // Development Options
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    let defaults = UserDefaults.standard
    let BTPref = "BTDevicePreference"
    
    // UI Object Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var KPI1Label: UILabel!
    @IBOutlet weak var KPI2Label: UILabel!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    // UI Object Actions
    @IBAction func menuTapped(_ sender: UIButton) {
    }
    @IBAction func dashboardTapped(_ sender: UIButton) {
    }
    @IBAction func searchTapped(_ sender: UIButton) {
    }
    @IBAction func helpTapped(_ sender: UIButton) {
    }
    @IBAction func backTapped(_ sender: UIButton) {
    }
    @IBAction func homeTapped(_ sender: UIButton) {
    }
    @IBAction func payTapped(_ sender: UIButton) {
        BTCommunication.openDrawer()
        BTCommunication.print()
    }
    
    @IBAction func BTSwitchChanged(_ sender: UISwitch) {
            defaults.set(sender.isOn, forKey:BTPref)
    }
    
    override func viewDidLoad() {
        self.dashboardButton.layer.cornerRadius = 10
        self.payButton.layer.cornerRadius = 10
        
        //tableView.emptyDataSetSource = self
        //tableView.emptyDataSetDelegate = self
        
        // Check BT Device Preference
        if let pref = defaults.value(forKey: BTPref) as? Bool{
            bluetoothSwitch.isOn = pref
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}
