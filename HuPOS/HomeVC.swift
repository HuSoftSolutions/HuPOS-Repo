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



class HomeVC:UIViewController, ItemsCVC_Home_Protocol {

    
   
   
    @IBOutlet weak var itemsCVC: UIView!
    
    @IBOutlet weak var saleItemsTVC: UIView!
    

    
    // Development Options
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    let defaults = UserDefaults.standard
    let BTPref = "BTDevicePreference"
    var currentUser:User?
    var pages:[Page]?
    var pageIndex = 0
    var saleDropDownButton = dropDownButton()
    
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
    
    @IBOutlet weak var saleDropDown: UIView!
    @IBOutlet weak var saleItemsTableView: UIView!
    
    func setEditModeOn() {
        print("Edit mode on! [HomeVC]")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "itemsCVC"){
        if let itemsCVC:ItemsCVC = segue.destination as! ItemsCVC {
            itemsCVC.itemsToHome = self
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
//        self.saleView.addSubview(saleDropDownButton)
//        self.saleView.bringSubview(toFront: saleDropDownButton)
//        
//        saleDropDownButton.centerXAnchor.constraint(equalTo: self.saleView.centerXAnchor).isActive = true
//        saleDropDownButton.centerYAnchor.constraint(equalTo: self.saleView.centerYAnchor).isActive = true
//        saleDropDownButton.topAnchor.constraint(equalTo:self.view.topAnchor)
//        saleDropDownButton.bottomAnchor.constraint(equalTo:self.saleView.topAnchor)
//        saleDropDownButton.widthAnchor.constraint(equalToConstant: self.payButton.frame.width).isActive = true
//        saleDropDownButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
//
//        saleDropDownButton.dropView.dropDownOptions = ["Hello","World"]
        
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBOutlet weak var saleView: UIView!
}
