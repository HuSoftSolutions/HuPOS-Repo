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
import YNDropDownMenu
import Firebase










protocol Home_SettingsTVC_Protocol{
    func setEditModeOff()
}

protocol Home_ItemsCVC_Protocol{
    func setEditModeOff()
}

protocol Home_SaleItemsTVC_Protocol{
    func setEditModeOn()
}

protocol dropDownProtocol {
    func dropDownPressed(string:String)
}















class dropDownButton: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        
        dropView = dropDownView.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
        dropView.delegate = self
        
        
    }
    override func didMoveToSuperview() {
        
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    
    func dismissDropDown(){
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            
            self.dropView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false{
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if(self.dropView.tableView.contentSize.height > 150){
                self.height.constant = 150
            }else{
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        }else{
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                
                self.dropView.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate:dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        tableView.backgroundColor = UIColor.blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dropDownOptions[indexPath.row])
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
}

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
    var collection:[String]?
    var items:[Item]?
}




























class HomeVC:UIViewController {
 
    // UI Object Variables
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var itemsCVC: UIView!
    
    @IBOutlet weak var saleItemsTVC: UIView!
    
    // protocol delegates
    public var homeToSalesItemsTVC:Home_SaleItemsTVC_Protocol?
    public var homeToItemsCVC:Home_ItemsCVC_Protocol?
    public var homeToSettingsTVC:Home_SettingsTVC_Protocol?
    
    // Development Options
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    let defaults = UserDefaults.standard
    let BTPref = "BTDevicePreference"
    var currentUser:User?
    var pages:[Page]?
    var pageIndex = 0
    var saleDropDownButton = dropDownButton()
    var saleItemChanged:NSObjectProtocol?
    
    @IBAction func pageBackAction(_ sender: Any) {
        
    }
    
    
    @IBAction func payTapped(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: .finalizeSale, object: nil)
        
//        BTCommunication.openDrawer()
//        BTCommunication.print()
//
        
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
    

    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "itemsCVC"){
            if let itemsCVC:ItemsCVC = segue.destination as! ItemsCVC {
//                itemsCVC.itemsToHome = self
//                self.homeToItemsCVC = itemsCVC
            }
            
        }else if(segue.identifier == "saleItemsTVC"){
            if let saleItemsTVC:SaleItemsTVC = segue.destination as! SaleItemsTVC{
//                saleItemsTVC.saleItemsToHome = self
//                self.homeToSalesItemsTVC = saleItemsTVC
            }
            
            
            
        }
    }



override func viewDidLoad() {
    let app = UIApplication.shared.delegate! as! AppDelegate
    if let viewControllers = app.window?.rootViewController?.childViewControllers {
        viewControllers.forEach{ vc in
            print("LISTED VIEW CONTROLLERS \(vc.description)")
        }
    }
    
    
//    Prime database with add cells
//    let db = Firestore.firestore()
//    for var i in (0..<25){
//        db.collection("Items").addDocument(data: ["Image":"", "Title":"", "Type":"addCell", "Index":0])
//    }
//
    self.navigationController?.isToolbarHidden = false
    self.navigationController?.toolbar.barTintColor = UIColor.black.withAlphaComponent(0.5)
    self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.5)
    self.payButton.layer.cornerRadius = 5
    self.payButton.layer.masksToBounds = true
    self.payButton.titleLabel?.adjustsFontSizeToFitWidth = true
    self.payButton.titleLabel?.minimumScaleFactor = 0.5
    SideMenuManager.defaultManager.menuPresentMode = .menuDissolveIn

    // Check BT Device Preference
    if let pref = defaults.value(forKey: BTPref) as? Bool{
        bluetoothSwitch.isOn = pref
    }
    Auth.auth().signIn(withEmail: currentUser!.email!, password: currentUser!.pin!, completion: nil)
    self.currentUserLabel.text = self.currentUser?.firstName
    print("Welcome to Home View \(String(describing: self.currentUser?.firstName))")
    
}


override func viewWillAppear(_ animated: Bool) {
    self.saleItemChanged = NotificationCenter.default.addObserver(forName: .saleItemChanged, object: nil, queue: OperationQueue.main, using: { (notification) in
        let saleTotals:[String] = notification.object as! [String]
    
        print("Total sales: \(saleTotals[0])\nTotal tax: \(saleTotals[1])")
        if(saleTotals[0] == "No Sale"){
            self.payButton.setTitle("No Sale", for: .normal)
        }else{
            self.payButton.setTitle("Pay \(saleTotals[0])", for: .normal)
        }
     })
}
    
    override func viewWillDisappear(_ animated: Bool) {
        if let saleItemChanged = self.saleItemChanged {
            NotificationCenter.default.removeObserver(self.saleItemChanged)
        }
    }

@IBOutlet weak var saleView: UIView!
}
