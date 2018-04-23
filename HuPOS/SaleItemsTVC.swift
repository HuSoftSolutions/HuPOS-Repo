//
//  SaleItemsTVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth

let VOID_CELL_BACKGROUND_COLOR = UIColor(red: 240/255, green: 10/255, blue: 10/255, alpha: 0.5)
let ZERO_CELL_BACKGROUND_COLOR = UIColor(red: 240/255, green: 240/255, blue: 25/255, alpha: 0.5)

let STATE_TAX = 0.08


public class Event {
    var id:String?
    var type:EventType
    var amount:Double
    var userID:String
    var timestamp:Date
    
    init(_id:String, _type:EventType, _amount:Double, _userID:String, _time:Date){
        self.id = _id
        self.type = _type
        self.amount = _amount
        self.userID = _userID
        self.timestamp = _time
    }
}

public class Sale {
    
    var id:String?
    var timestamp:Date?
    var saleItems:[SaleItem]?
    var employeeId:String?
    var taxTotal:Double?
    var saleTotal:Double?
    var remainingBalance:Double?
    var events:[Event]?

    public var description: String { return "\n\n - Sale Total: \(saleTotal!)\n - Tax Total: \(taxTotal!)\n - Remaining Balance: \(remainingBalance!)\n - Events: \(events!.description)" }
//    public var eventsDescription: String {
//        
//    }
    
    func getSaleTotal() -> String {
        var saleTotalTemp = 0.0
        var taxTotalTemp = 0.0
        if(self.saleItems?.isEmpty)!{
            return "No Sale"
        }else{
            for sale in saleItems! {
                if(sale.inventoryItem?.tax)!{
                    
                    let sale_ = ((sale.inventoryItem?.price)! * sale.quantity) * (1 + STATE_TAX)
                    let tax_ = ((sale.inventoryItem?.price)! * sale.quantity) * (STATE_TAX)
                    saleTotalTemp += sale_
                   // print("+ Sale Total | \(sale_)")
                    taxTotalTemp += tax_
                   // print("+ Tax Total | \(tax_)")
                }else{
                    let sale_ = ((sale.inventoryItem?.price)! * sale.quantity)
                    let tax_ = ((sale.inventoryItem?.price)! * sale.quantity) - (((sale.inventoryItem?.price)! * sale.quantity) / (1 + STATE_TAX))
                    saleTotalTemp += sale_
                 //   print("+ Sale Total | \(sale_)")
                    taxTotalTemp += tax_
                 //   print("+ Tax Total | \(tax_)")
                }
            }
            var totals = [String]()
            
            let s_total = NumberFormatter.localizedString(from: NSNumber(value: saleTotalTemp), number: .currency)
            let t_total = NumberFormatter.localizedString(from: NSNumber(value: taxTotalTemp), number: .currency)
            totals.append(s_total)
            totals.append(t_total)
            
            self.saleTotal = saleTotalTemp
            self.taxTotal = taxTotalTemp
            self.remainingBalance = saleTotalTemp
            
            return s_total
        }
    }
    
}

public class SaleItem {
    var inventoryItem:InventoryItem?
    var quantity = 1.0
    var subtotal = 0.0
    var void = false
    var taxTotal:Double = 0.0
}

class SaleItemCell: UITableViewCell {
    
    let title:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        lbl.lineBreakMode = .byCharWrapping
        lbl.baselineAdjustment = .alignCenters
        return lbl
    }()
    
    let qtyLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Quantity: "
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let qty:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let qtyStepper:UIStepper = {
        let stpr = UIStepper(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        stpr.minimumValue = -1000
        stpr.maximumValue = 1000
        return stpr
    }()
    
    let unitPriceLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Unit Price: "
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let unitPrice:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let subtotalLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Subtotal: "
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let subtotal:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let voidLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "VOID"
        lbl.textColor = UIColor.red
        lbl.font = UIFont.systemFont(ofSize: 26)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        return lbl
    }()
    
    var saleItem:SaleItem? {
        didSet {
            title.text = saleItem?.inventoryItem?.title
            qty.text = String(Int((saleItem?.quantity)!))
            qtyStepper.value = Double((saleItem?.quantity)!)
            unitPrice.text = NumberFormatter.localizedString(from: NSNumber(value: (saleItem?.inventoryItem?.price)!), number: .currency)
            let itemPriceTotal = (saleItem?.quantity)! * (saleItem?.inventoryItem?.price)!
            var tax:Double = 0.0
            var itemRawCost = 0.0
            if(saleItem?.inventoryItem?.tax)!{
                tax = STATE_TAX * itemPriceTotal
                saleItem?.taxTotal = tax
                print("TAX ADDED: \(itemPriceTotal) + \(tax) = \(itemPriceTotal + tax)")
            }else{
                itemRawCost = (itemPriceTotal)/(1.0 + STATE_TAX)
                tax = (itemPriceTotal) - itemRawCost
                saleItem?.taxTotal = tax
                print("TAX INCLUDED: \(itemRawCost) + \(tax) = \(itemPriceTotal)")
                tax = 0.0
            }
            let s_total = ((saleItem?.quantity)! * (saleItem?.inventoryItem?.price)!) + tax
            subtotal.text = NumberFormatter.localizedString(from: NSNumber(value: s_total), number: .currency)
        }
    }
    
    override func prepareForReuse() {
        //self.qty.text = "1"
        self.qtyStepper.value = 1
        //self.saleItem?.quantity = 1
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.voidLbl.alpha = 0
    }
    
    
    
    func setup(){
        self.addSubview(title)
        self.addSubview(qtyLbl)
        self.addSubview(qty)
        self.addSubview(qtyStepper)
        self.addSubview(unitPriceLbl)
        self.addSubview(unitPrice)
        self.addSubview(subtotalLbl)
        self.addSubview(subtotal)
        self.addSubview(voidLbl)
        
        title.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(15)
            make.width.equalTo(self.bounds.width/2)
            // make.height.equalTo(self.bounds.height/2)
        }
        qtyLbl.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.left.equalTo(self).offset(15)
        }
        qty.snp.makeConstraints { (make) in
            make.centerY.equalTo(qtyLbl.snp.centerY)
            make.left.equalTo(qtyLbl.snp.right).offset(5)
        }
        qtyStepper.snp.makeConstraints { (make) in
            make.top.equalTo(qty.snp.bottom).offset(5)
            make.bottom.equalTo(self).offset(-15)
            make.left.equalTo(self).offset(15)
        }
        
        unitPrice.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(15)
        }
        unitPriceLbl.snp.makeConstraints { (make) in
            make.right.equalTo(unitPrice.snp.left).offset(-5)
            make.bottom.equalTo(unitPrice.snp.bottom)
        }
        subtotal.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-15)
        }
        subtotalLbl.snp.makeConstraints { (make) in
            make.right.equalTo(subtotal.snp.left).offset(-5)
            make.bottom.equalTo(self).offset(-15)
        }
        
        voidLbl.snp.makeConstraints { (make) in
            make.left.equalTo(qtyStepper.snp.right).offset(10)
            make.bottom.equalTo(qtyStepper.snp.bottom)
        }
        voidLbl.alpha = 0
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class SaleItemsTVC: UITableViewController {
    var cellId = "saleItemCell"
    var editModeObserver:NSObjectProtocol?
    var saleItemAddedObserver:NSObjectProtocol?
    var reloadTableViewObserver:NSObjectProtocol?
    var finalizeSaleObserver: NSObjectProtocol?
    var noSaleCell:UITableViewCell?
    var editModeOn = false
    var saleCells:[SaleItem] = []
    let defaults = UserDefaults.standard
    
    var currentSale:Sale?
    
    func createCell(){
        self.noSaleCell = UITableViewCell(style: .default, reuseIdentifier: "NoSaleCell")
        tableView?.register(SaleItemCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createCell()
        //tableView.register(NoSaleCell.self, forCellReuseIdentifier: "NoSaleCell")
        tableView.separatorStyle = .singleLine
        
    }
    
    func generateSaleTotal() -> Sale{
        var taxTotal = 0.0
        var saleTotal = 0.0
        for sale in self.saleCells {
            saleTotal += (sale.subtotal)
            taxTotal += sale.taxTotal
        }
        let sale = Sale()
        sale.employeeId = Auth.auth().currentUser?.displayName
        sale.timestamp = Date()
        sale.taxTotal = taxTotal
        sale.saleTotal = saleTotal
        sale.remainingBalance = saleTotal
        
        return sale
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        self.editModeOn = defaults.bool(forKey: "EditModeOn")
        
        editModeObserver = NotificationCenter.default.addObserver(forName: .editModeChanged, object: nil, queue: OperationQueue.main, using: { (notification) in
            let editModeOn = notification.object as! Bool
            if(editModeOn){
                // Edit mode was turned on
                self.editModeOn = true
            }else{
                // Edit mode was turned off
                self.editModeOn = false
            }
            self.tableView.reloadData()
        })
        
        print("SALE ITEM ADDED OBSERVER ADDED! +++++++++++++++")
        if(saleItemAddedObserver == nil){
            saleItemAddedObserver = NotificationCenter.default.addObserver(forName: .saleItemAdded, object: nil, queue: OperationQueue.main, using: { (notification) in
                let inventoryItem = notification.object as! Item_
                var exists = false
                for (i, item) in self.saleCells.enumerated() {
                    print("Comparing \(item.inventoryItem?.title) to \(inventoryItem.inventoryItemCell?.title)")
                    if(item.inventoryItem?.title == inventoryItem.inventoryItemCell?.title && !(item.inventoryItem?.miscPrice)!){
                        exists = true
                        self.saleCells[i].subtotal += (inventoryItem.inventoryItemCell?.price)!
                        
                        self.saleCells[i].quantity += 1
                        break
                    }
                }
                if(!exists){
                    let saleItem = SaleItem()
                    saleItem.inventoryItem = inventoryItem.inventoryItemCell
                    saleItem.subtotal = (inventoryItem.inventoryItemCell?.price!)!
                    self.saleCells.append(saleItem)
                }
                self.tableView.reloadData()
            })
        }
        
        reloadTableViewObserver = NotificationCenter.default.addObserver(forName: .reloadTableView, object: nil, queue: OperationQueue.main, using: { (notification) in
            self.tableView.reloadData()
        })
        
        finalizeSaleObserver = NotificationCenter.default.addObserver(forName: .finalizeSale, object: nil, queue: OperationQueue.main, using: { (notification) in
            let sale = self.getCurrentSale()
            if(!(sale.saleItems?.isEmpty)!){
                let _:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let paymentPopUp = PaymentPopUpVC()
                paymentPopUp.modalPresentationStyle = .overCurrentContext
                paymentPopUp.modalTransitionStyle = .crossDissolve
                _ = paymentPopUp.presentationController
               // paymentPopUp.delegate = self
                paymentPopUp.sale = sale
                print(sale.description)
                self.present(paymentPopUp, animated: true, completion: {
                    print("Finished presenting Payment Pad View!")
                })
            }
        })
        
        print(NotificationCenter.default.observationInfo)
        self.tableView.reloadData()
    }
    
    // Prevent memory leak
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let editModeObserver = editModeObserver {
            NotificationCenter.default.removeObserver(editModeObserver)
        }
        if saleItemAddedObserver != nil {
            print("SALE ITEM ADDED OBSERVER REMOVED! -------------")
            
            NotificationCenter.default.removeObserver(self.saleItemAddedObserver)
            self.saleItemAddedObserver = nil
        }
        if let reloadTableViewObserver = reloadTableViewObserver {
            NotificationCenter.default.removeObserver(reloadTableViewObserver)
        }
        if let finalizeSaleObserver = finalizeSaleObserver {
            NotificationCenter.default.removeObserver(finalizeSaleObserver)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    @objc func qtyStprAction(sender:UIStepper){
        self.saleCells[sender.tag].quantity = sender.value
        // self.saleItem?.quantity =
        // sender.value
        //self.saleItem?.subtotal = (self.saleItem?.quantity)! * sender.value
        //NotificationCenter.default.post(name: .reloadTableView, object: nil)
        self.tableView.reloadData()
        print("VALUE CHANGED: \(self.saleCells[sender.tag].quantity)")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete && !self.saleCells.isEmpty) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.saleCells.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.editModeOn || self.saleCells.count == 0){
            return 1
        }else{
            return self.saleCells.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var _:UITableViewCell?
        var saleItemCell:SaleItemCell?
        
        if(self.editModeOn){
            let cell_ = self.tableView.dequeueReusableCell(withIdentifier: "editModeCell") as! EditItemsCell
            
            cell_.selectionStyle = .none
            
            return cell_
            
        }else if(self.saleCells.count == 0){
            let cell_ = NoSaleCell(style: .default, reuseIdentifier: "NoSaleCell")
            cell_.selectionStyle = .none
            cell_.isUserInteractionEnabled = false
            NotificationCenter.default.post(name: .saleItemChanged, object: "No Sale")
            

            return cell_
            
        }else{
            
            saleItemCell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as? SaleItemCell
            saleItemCell?.selectionStyle = .none
            saleItemCell?.qtyStepper.tag = indexPath.row
            saleItemCell?.qtyStepper.addTarget(self, action: #selector(qtyStprAction(sender:)), for: .valueChanged)
            saleItemCell?.isUserInteractionEnabled = true
            saleItemCell?.saleItem = self.saleCells[indexPath.row]
            saleItemCell?.voidLbl.alpha = 0
            saleItemCell?.backgroundColor = .white
            
            if(saleItemCell?.saleItem?.quantity == 0.0){
                saleItemCell?.backgroundColor = ZERO_CELL_BACKGROUND_COLOR
                //self.saleCells[indexPath]
                
                saleItemCell?.saleItem?.subtotal = 0
            }else if(Int((saleItemCell?.saleItem?.quantity)!) < 0){
                saleItemCell?.backgroundColor = VOID_CELL_BACKGROUND_COLOR
                saleItemCell?.voidLbl.alpha = 1.0
                
            }
            print("Price: \((saleItemCell?.saleItem?.quantity)! * (saleItemCell?.saleItem?.inventoryItem?.price)!)")
            saleItemChanged_Notification()
            //print("Sent: \(sale.)")
            
            return saleItemCell!
        }
    }
    
    func getCurrentSale() -> Sale {
        print("Getting current sale...")
        var sale = Sale()
//        sale = self.generateSaleTotal()
//        print("Sale total: \(sale.saleTotal)")
//        print("Tax total: \(sale.taxTotal)")
//
//        sale.employeeId = Auth.auth().currentUser?.displayName
//        sale.timestamp = Date()
        sale.events = [Event]()
        sale.saleItems = self.saleCells
        sale.getSaleTotal()
        return sale
    }
    
    func saleItemChanged_Notification(){
        let sale = Sale()
        sale.employeeId = Auth.auth().currentUser?.displayName
        sale.timestamp = Date()
        sale.saleItems = self.saleCells
        NotificationCenter.default.post(name: .saleItemChanged, object: sale.getSaleTotal())
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(editModeOn){
            return 600
        }else if(self.saleCells.count == 0){
            return self.tableView.frame.height
        }else{
            return 150
        }
        
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
