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
import SideMenu
import FirebaseAuth
//import EmptyDataSet_Swift

public class Item {
    var name:String?
    var category:String?
    var price:Double?
    var cost:Double?
    
    init(name_:String, category_:String, price_:Double, cost_:Double){
        self.name = name_
        self.category = category_
        self.price = price_
        self.cost = cost_
    }
}

public class Page {
    var name:String?
    var collection:[String]?
    var items:[Item]?
}

class HomeVC:UIViewController, UITableViewDelegate {
    
    // Development Options
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    let defaults = UserDefaults.standard
    let BTPref = "BTDevicePreference"
    var currentUser:User?
    var pages:[Page]?
    
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
    
    @IBAction func addItemCollectionAction(_ sender: Any) {
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print(error.localizedDescription)
            
        }
        
        
       // let signIn = UserSignInTVC()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func BTSwitchChanged(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey:BTPref)
    }
    
    override func viewDidLoad() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barTintColor = UIColor.black.withAlphaComponent(0.5)
        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.5)
        self.payButton.layer.cornerRadius = 10
        self.payButton.layer.masksToBounds = true
        
        SideMenuManager.defaultManager.menuPresentMode = .menuDissolveIn
        // self.navigationController?.navigationBar.isHidden = true
        //tableView.emptyDataSetSource = self
        //tableView.emptyDataSetDelegate = self
        
        // Check BT Device Preference
        if let pref = defaults.value(forKey: BTPref) as? Bool{
            bluetoothSwitch.isOn = pref
        }
        Auth.auth().signIn(withEmail: currentUser!.email!, password: currentUser!.pin!, completion: nil)
        self.currentUserLabel.text = self.currentUser?.firstName
        print("Welcome to Home View \(String(describing: self.currentUser?.firstName))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}
