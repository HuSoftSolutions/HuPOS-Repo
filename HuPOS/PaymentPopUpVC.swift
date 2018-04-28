
//
//  PaymentPopUpVC.swift
//  HuPOS
//
//  Created by Cody Husek on 4/17/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import Firebase
import SnapKit
import UIKit
import IQKeyboardManagerSwift
import MessageUI

enum EventType {
    case cash, credit, gift, check
    
    var description : String {
        switch self {
        case .cash: return "Cash"
        case .check: return "Check"
        case .credit: return "Credit"
        case .gift: return "Gift"
        }
    }
}



extension Double {
    func toCurrencyString() -> String {
        //return String(format:"%.02", self).currencyInputFormatting()
        return NumberFormatter.localizedString(from: NSNumber(value: self), number: .currency)
    }
}

extension String {
    func toDouble() -> Double {
        return Double(self)!
    }
}

class EventTableViewCell : UITableViewCell {
    
    let typeLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        // lbl.lineBreakMode = .byCharWrapping
        //lbl.baselineAdjustment = .alignCenters
        return lbl
    }()
    
    let amountLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.red
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 40)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        //lbl.lineBreakMode = .byCharWrapping
        // lbl.baselineAdjustment = .alignCenters
        return lbl
    }()
    
    var event:Event?{
        didSet{
            amountLbl.text = "- \(event?.amount.toCurrencyString() ?? "$0.00")"
            typeLbl.text = event?.type.description
        }
    }
    
    func setup(){
        self.addSubview(amountLbl)
        self.addSubview(typeLbl)
        self.backgroundColor = .black
        amountLbl.snp.makeConstraints { (make) in
            //make.centerY.equalTo(self)
            //            make.top.equalTo(self)
            //            make.left.equalTo(self)
            //            make.bottom.equalTo(self)
            //            make.width.equalTo(self.bounds.width / 2)
            //            make.height.equalTo(self.bounds.width)
            
            make.right.equalTo(self).offset(-2)
            make.width.equalTo(self.bounds.width / 2)
            make.height.equalTo(self.bounds.height)
            make.bottom.equalTo(self)
            
        }
        
        typeLbl.snp.makeConstraints { (make) in
            //make.centerY.equalTo(self)
            make.right.equalTo(amountLbl.snp.left).offset(-10)
            make.bottom.equalTo(amountLbl.snp.bottom)
            //            make.width.equalTo(self.bounds.width / 2)
            //            make.height.equalTo(self.bounds.height)
            
            //            make.top.equalTo(self)
            //            make.right.equalTo(self)
            //            make.bottom.equalTo(self)
        }
        
        
        
        
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.amountLbl.text = ""
        self.typeLbl.text = ""
        
    }
}
class PaymentPopUpVC:UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.sale?.events?.count)!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventTableViewCell = self.eventTableView.dequeueReusableCell(withIdentifier: "EventCell")! as! EventTableViewCell
        let amt = self.sale!.events![indexPath.row].amount.toCurrencyString()
        let type = self.sale!.events![indexPath.row].type.description
        
        cell.isUserInteractionEnabled = false
        cell.event = self.sale?.events![indexPath.row]
        cell.amountLbl.text = "- \(amt)"
        cell.typeLbl.text = type
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete && !self.sale!.events!.isEmpty) {
            // handle delete (by removing the data from your array and updating the tableview)
            let removedSale = self.sale!.events!.remove(at: indexPath.row)
            self.sale!.remainingBalance! += removedSale.amount
            eventTableView.reloadData()
            self.refreshSale()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    var sale:Sale?
    var eventType = EventType.cash
    var amtPaid = "0"
    var amtPaid_D = 0.0
    
    
    
    override func viewDidLoad() {
        let screenSize = UIScreen.main.bounds
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        
        print("\nInside payment view: \(self.sale!.description)")
        
        setupViews(screen: screenSize)
    }
    
    @objc func digitPressed(sender:UIButton){
        let digit = sender.titleLabel?.text!
        amtPaid.append(digit!)
        print("Raw Amt Paid Added: \(amtPaid)")
        self.acceptBtn.setTitle("Pay  \((amtPaid.toDouble()/100).toCurrencyString())  \(self.eventType.description)", for: .normal)
    }
    
    @objc func backspaceAction(sender:UIButton){
        
        if(amtPaid.count > 1){
            amtPaid.removeLast()
        }
        print("Raw Amt Paid Deleted: \(amtPaid)")
        self.acceptBtn.setTitle("Pay  \((amtPaid.toDouble()/100).toCurrencyString())  \(self.eventType.description)", for: .normal)
        
    }
    
    
    @objc func clearAction(sender:UIButton){
        self.acceptBtn.setTitle("Pay  \(self.sale?.remainingBalance?.toCurrencyString() ?? "$0.00")  \(self.eventType.description)", for: .normal)
        
        self.amtPaid = "0"
        print("Raw Amt Paid Cleared: \(amtPaid)")
        
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshSale(){
        self.saleTotal.text = self.sale!.saleTotal!.toCurrencyString()
        self.saleSubtotal.text = self.sale!.remainingBalance!.toCurrencyString()
        self.amtPaid = "0"
        self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
    }
    

    
    @objc func acceptSaleAction(){
        var payment = self.amtPaid.toDouble()/100
        let totalDue = (self.sale?.remainingBalance?.roundTo(places: 2))!
        let date = Date()
        
        if(totalDue == 0.0){return}
        if(payment == 0.0){ payment = totalDue.roundTo(places: 2)}
        
        
        print("PAYMENT ACTION")
        
        if(payment < totalDue){
            // partial payment -- deduct from remaining balance
            print("Payment \(payment) is less than total due \(totalDue)")
            
            let event = Event(_id: "", _type: self.eventType, _amount: payment, _userID: (CURRENT_USER?.firstName!)!, _time: date)
            self.sale!.remainingBalance = totalDue.roundTo(places: 2) - payment
            self.sale!.events!.append(event)
            self.eventTableView.reloadData()
            self.eventTableView.scrollToRow(at: IndexPath(row: self.sale!.events!.count - 1, section: 0), at: .bottom, animated: true)
            self.saleSubtotal.text = sale!.remainingBalance!.toCurrencyString()
            self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
            self.amtPaid = "0"
        }
            
        else if(payment == totalDue.roundTo(places: 2) || payment == 0.0){
            // exact payment -- event marking the end of the sale
            print("Payment \(payment) is equal to the total due \(totalDue)")
            
            // add payment event
            let event = Event(_id: "", _type: self.eventType, _amount: payment, _userID: (CURRENT_USER?.firstName!)!, _time: date)
            self.sale!.remainingBalance = totalDue.roundTo(places: 2) - payment
            self.sale!.events!.append(event)
            self.sale!.changeGiven = 0.0
            self.eventTableView.reloadData()
            self.eventTableView.scrollToRow(at: IndexPath(row: self.sale!.events!.count - 1, section: 0), at: .bottom, animated: true)
            self.saleSubtotal.text = sale!.remainingBalance!.toCurrencyString()
            self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
            self.amtPaid = "0"
            
            // open drawer if cash, gift, check
            BTCommunication.openDrawer()
            
            // add sale to database
            self.addSaleToDatabase() // Add completion handler that finished when both database calls are successful -- ???
            NotificationCenter.default.post(name: .clearSaleItems, object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
            // pause and dismiss
            
        }else if(payment > totalDue){
            // payment exceeded remaining balance -- mark as tip or change to return
            print("Payment \(payment) is more than the total due \(totalDue) by \((payment - totalDue)) ")
            
            // add payment event
            let event = Event(_id: "", _type: self.eventType, _amount: payment, _userID: "ADMIN", _time: date)
            self.sale!.remainingBalance = totalDue - payment
            self.sale!.events!.append(event)
            self.sale!.changeGiven = payment - totalDue
            self.eventTableView.reloadData()
            self.eventTableView.scrollToRow(at: IndexPath(row: self.sale!.events!.count - 1, section: 0), at: .bottom, animated: true)
            self.saleSubtotal.text = sale!.remainingBalance!.toCurrencyString()
            self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
            self.amtPaid = "0"
            
            // open drawer if cash, gift, check
            BTCommunication.openDrawer()
            
            //Send receipt
//            let mailComposerVC = MFMailComposeViewController()
//            mailComposerVC.mailComposeDelegate = self
//            
//            mailComposerVC.setToRecipients(["codyhusek@gmail.com"])
//            mailComposerVC.setSubject("Hello")
//            mailComposerVC.setMessageBody("How are you doing?", isHTML: false)
    
            
            // pause and dismiss
            
            let changeAlert = UIAlertController(title: "Change Due: \(self.sale!.changeGiven!.toCurrencyString())", message: "The amount above is owed to the customer!", preferredStyle: .alert)
            let undo = UIAlertAction(title: "Undo", style: .default) { (alert) in
                let removedSale = self.sale?.events?.removeLast()
                self.sale!.remainingBalance! += (removedSale?.amount)!
                self.eventTableView.reloadData()
                self.refreshSale()
            }
            let dismiss = UIAlertAction(title: "Continue", style: .cancel) { (alert) in
                NotificationCenter.default.post(name: .clearSaleItems, object: nil)
                self.dismiss(animated: true, completion: nil)
                self.addSaleToDatabase()
            }
            changeAlert.addAction(undo)
            changeAlert.addAction(dismiss)
            
            self.present(changeAlert, animated: true)
        }
        
    }
    
    
    
    func addSaleToDatabase(){
        
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        

        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:mm:yyyy hh:mm:ss"
        ref = db.collection("Sales").addDocument(data: [
            "Timestamp":self.sale?.timestamp as Any,
            "Employee":sale?.employeeId as Any,
            "Tax Total":sale?.taxTotal?.roundTo(places: 2) as Any,
            "Sale Total":sale?.saleTotal?.roundTo(places: 2) as Any,
            "Remaining Balance":sale?.remainingBalance?.roundTo(places: 2) as Any,
            "Change":sale?.changeGiven?.roundTo(places: 2) as Any
        ]) { err in
            if let err = err {
                print("Error writing doucment: \(err)")
            }else{
                for event in (self.sale?.events)!{
                    
                    db.collection("Sales/\(ref!.documentID)/Events").addDocument(data: [
                        "Type":event.type.description,
                        "Amount":event.amount.roundTo(places: 2),
                        "Employee":event.userID,
                        "Timestamp":event.timestamp
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }else{
                            
                        }
                    }
                    
                }
                
                for saleItem in (self.sale?.saleItems)!{
                    db.collection("Sales/\(ref!.documentID)/Sale Items").addDocument(data: [
                        "Quantity":saleItem.quantity,
                        "Total":saleItem.subtotal.roundTo(places: 2),
                        //"Subtotal":saleItem.subtotal.
                        "Tax Total":saleItem.taxTotal.roundTo(places: 2),
                        "Void":saleItem.void,
                        "Inventory Item Id": saleItem.inventoryItem?.id,
                        "Tax Index": saleItem.inventoryItem?.taxIndex
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }else{
                            
                        }
                    }
                }
                
            }
            
        }
    }
    
    
    
    
    @objc func eventTypeChanged(sender:UIButton){
        
        switch self.eventType {
        case .cash:
            self.cashEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .credit:
            self.creditEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .check :
            self.checkEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .gift :
            self.giftEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            
        default:
            self.cashEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
        print(String(sender.titleLabel!.text!))
        let newEventType = (String(sender.titleLabel!.text!))
        switch newEventType {
        case "Cash":
            self.eventType = .cash
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Credit":
            self.eventType = .credit
            self.creditEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Check" :
            self.eventType = .check
            self.checkEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Gift" :
            self.eventType = .gift
            self.giftEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            
        default:
            self.eventType = .cash
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
        
        self.amtPaid = "0"
        self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
    }
    
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        //view.layer.cornerRadius = 5
        //view.layer.masksToBounds = true
        return view
    }()
    
    let totalDueLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 35)
        lbl.textColor = UIColor.white
        lbl.text = "Sale Total:"
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    let subtotalDueLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 35)
        lbl.textColor = UIColor.white
        lbl.text = "Subtotal:"
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    let saleTotal:UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 125)
        //txt.minimumFontSize = 10
        //txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        
        //txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.clear
        txt.textColor = UIColor.green.withAlphaComponent(0.5)
        txt.textAlignment = .right
        txt.adjustsFontSizeToFitWidth = true
        txt.sizeToFit()
        txt.isUserInteractionEnabled = false
        //txt.keyboardType = .phonePad
        //        txt.layer.cornerRadius = 5
        //        txt.layer.masksToBounds = true
        return txt
    }()
    let saleSubtotal:UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 250)
        //txt.minimumFontSize = 10
        //txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        txt.text = "$0.00"
        //txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.clear
        txt.textColor = UIColor.green.withAlphaComponent(0.5)
        txt.textAlignment = .right
        txt.adjustsFontSizeToFitWidth = true
        txt.sizeToFit()
        txt.isUserInteractionEnabled = false
        //txt.keyboardType = .phonePad
        //        txt.layer.cornerRadius = 5
        //        txt.layer.masksToBounds = true
        return txt
    }()
    
    
    
    let cashEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cash", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        //btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    let creditEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Credit", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        //btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    let checkEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Check", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        //btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    
    let giftEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Gift", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        //btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    
    let acceptBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Pay Cash", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 100)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(acceptSaleAction), for: .touchUpInside)
        //btn.layer.borderWidth = 0.25
        //        btn.layer.cornerRadius = 5
        //        btn.layer.masksToBounds = true
        return btn
    }()
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        //        btn.layer.cornerRadius = 5
        //        btn.layer.masksToBounds = true
        return btn
    }()
    
    let o:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    let c:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        //        btn.layer.cornerRadius = 5
        //        btn.layer.masksToBounds = true
        return btn
    }()
    
    
    
    
    let oneBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("1", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let twoBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("2", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let threeBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("3", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let fourBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("4", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let fiveBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("5", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let sixBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("6", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let sevenBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("7", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let eightBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("8", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let nineBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("9", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    let zeroBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("0", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        return btn
    }()
    
    let enterBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(backspaceAction), for: .touchUpInside)
        return btn
    }()
    let clearBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("C", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        return btn
    }()
    
    
    let eventTableView:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //tbl.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tbl.backgroundColor = .clear
        
        return tbl
    }()
    
    func setupViews(screen:CGRect){
        
        let EVENT_BTN_SPACES = 4.0
        
        let PAD = 2.0
        let DIGIT_PAD = 0.5
        
        let MAIN_VIEW_WIDTH = Double(screen.width)
        let MAIN_VIEW_HEIGHT = Double(screen.height)
        
        let NUM_PAD_WIDTH = MAIN_VIEW_WIDTH * (4/10)
        let NUM_PAD_HEIGHT = MAIN_VIEW_HEIGHT * (4/6)
        
        let DIGIT_WIDTH = (NUM_PAD_WIDTH - 4*DIGIT_PAD) * (1/3)
        let DIGIT_HEIGHT = (NUM_PAD_HEIGHT - 5*DIGIT_PAD) * (1/4)
        
        let EVENT_BTN_WIDTH = MAIN_VIEW_WIDTH/EVENT_BTN_SPACES
        let EVENT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/6)
        
        _ = NUM_PAD_WIDTH - 2 * DIGIT_PAD
        _ = saleTotal.font.capHeight + 10//DIGIT_HEIGHT
        
        let CANCEL_BTN_WIDTH = MAIN_VIEW_WIDTH * (1/10)
        let CANCEL_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/6)// - (PAD)
        
        _ = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH //- (PAD)
        _ = saleTotal.font.capHeight
        
        let ACCEPT_BTN_WIDTH = MAIN_VIEW_WIDTH - CANCEL_BTN_WIDTH// - (PAD)
        let ACCEPT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/6)// - (PAD)
        
        view.addSubview(mainView)
        view.addSubview(acceptBtn)
        view.addSubview(cancelBtn)
        view.addSubview(saleTotal)
        view.addSubview(cashEventBtn)
        view.addSubview(creditEventBtn)
        view.addSubview(checkEventBtn)
        view.addSubview(giftEventBtn)
        
        
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        view.addSubview(threeBtn)
        view.addSubview(fourBtn)
        view.addSubview(fiveBtn)
        view.addSubview(sixBtn)
        view.addSubview(sevenBtn)
        view.addSubview(eightBtn)
        view.addSubview(nineBtn)
        view.addSubview(zeroBtn)
        view.addSubview(clearBtn)
        view.addSubview(enterBtn)
        view.addSubview(eventTableView)
        
        view.addSubview(totalDueLbl)
        view.addSubview(subtotalDueLbl)
        view.addSubview(saleSubtotal)
        
        var remainingBalance = self.sale!.remainingBalance!
        self.saleTotal.text = self.sale!.getSaleTotal()
        self.saleSubtotal.text = self.sale!.remainingBalance?.toCurrencyString()
        self.acceptBtn.setTitle("Pay  \(self.sale!.getSaleTotal())  \(self.eventType.description)", for: .normal)
        // apply events first
        
        eventTableView.separatorColor = .clear
        
        mainView.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH)
            make.height.equalTo(MAIN_VIEW_HEIGHT)
            make.center.equalTo(view)
        }
        
        
        cashEventBtn.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(EVENT_BTN_HEIGHT)
            make.left.equalTo(mainView)//.offset(PAD)
            make.top.equalTo(mainView)//offset(PAD)
        }
        creditEventBtn.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(EVENT_BTN_HEIGHT)
            make.top.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(cashEventBtn.snp.right)//.offset(PAD)
        }
        checkEventBtn.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(EVENT_BTN_HEIGHT)
            make.top.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(creditEventBtn.snp.right)//.offset(PAD)
        }
        giftEventBtn.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(EVENT_BTN_HEIGHT)
            make.top.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(checkEventBtn.snp.right)//.offset(PAD)
        }
        //        discountEventBtn.snp.makeConstraints { (make) in
        //            make.width.equalTo(EVENT_BTN_WIDTH)
        //            make.height.equalTo(EVENT_BTN_HEIGHT)
        //            make.top.equalTo(mainView)//.offset(PAD)
        //            make.left.equalTo(giftEventBtn.snp.right)//.offset(PAD)
        //        }
        
        
        
        oneBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(cashEventBtn.snp.bottom).offset(DIGIT_PAD)
            make.left.equalTo(mainView).offset(DIGIT_PAD)
        }
        twoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn)
            make.left.equalTo(oneBtn.snp.right).offset(DIGIT_PAD)
        }
        
        threeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn)
            make.left.equalTo(twoBtn.snp.right).offset(DIGIT_PAD)
        }
        
        fourBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn.snp.bottom).offset(DIGIT_PAD)
            make.left.equalTo(mainView).offset(DIGIT_PAD)
        }
        
        fiveBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn)
            make.left.equalTo(fourBtn.snp.right).offset(DIGIT_PAD)
        }
        
        sixBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn)
            make.left.equalTo(fiveBtn.snp.right).offset(DIGIT_PAD)
        }
        
        sevenBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn.snp.bottom).offset(DIGIT_PAD)
            make.left.equalTo(mainView).offset(DIGIT_PAD)
        }
        eightBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn)
            make.left.equalTo(sevenBtn.snp.right).offset(DIGIT_PAD)
        }
        nineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn)
            make.left.equalTo(eightBtn.snp.right).offset(DIGIT_PAD)
        }
        
        clearBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn.snp.bottom).offset(DIGIT_PAD)
            make.left.equalTo(mainView).offset(DIGIT_PAD)
        }
        zeroBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(clearBtn)
            make.left.equalTo(clearBtn.snp.right).offset(DIGIT_PAD)
        }
        enterBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(zeroBtn)
            make.left.equalTo(zeroBtn.snp.right).offset(DIGIT_PAD)
        }
        
        
        
        
        
        acceptBtn.snp.makeConstraints { (make) in
            make.width.equalTo(ACCEPT_BTN_WIDTH)
            make.height.equalTo(ACCEPT_BTN_HEIGHT)
            make.left.equalTo(cancelBtn.snp.right)//.offset(PAD)
            make.bottom.equalTo(mainView)//.offset(PAD)
        }
        
        totalDueLbl.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            //            make.height.equalTo(SALE_TOTAL_HEIGHT/2)
            make.top.equalTo(creditEventBtn.snp.bottom).offset(PAD*5)
            make.left.equalTo(enterBtn.snp.right).offset(PAD*5)
        }
        
        
        
        
        
        saleTotal.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH - NUM_PAD_WIDTH)
            // make.height. //.equalTo(SALE_TOTAL_HEIGHT)
            make.top.equalTo(checkEventBtn.snp.bottom).offset(PAD*5)
            
            //make.top.equalTo(totalDueLbl.snp.bottom)//.offset(PAD)
            make.right.equalTo(mainView).offset(PAD*(-5))
        }
        
        eventTableView.snp.makeConstraints { (make) in
            make.width.equalTo((MAIN_VIEW_WIDTH - NUM_PAD_WIDTH)/2)
            //make.height.equalTo(NUM_PAD_HEIGHT - Double(saleTotal.frame.height) - Double(saleSubtotal.frame.height))
            make.top.equalTo(saleTotal.snp.bottom)
            make.bottom.equalTo(saleSubtotal.snp.top)
            //make.left.equalTo(sixBtn.snp.right)
            make.right.equalTo(mainView)
        }
        
        saleSubtotal.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH - NUM_PAD_WIDTH)
            // make.height. //.equalTo(SALE_TOTAL_HEIGHT)
            make.bottom.equalTo(acceptBtn.snp.top).offset(PAD*(-5))
            
            //make.top.equalTo(totalDueLbl.snp.bottom)//.offset(PAD)
            make.right.equalTo(mainView).offset(PAD*(-5))
        }
        
        subtotalDueLbl.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            //            make.height.equalTo(SALE_TOTAL_HEIGHT/2)
            make.bottom.equalTo(saleSubtotal.snp.top).offset(PAD*(-5))
            make.left.equalTo(threeBtn.snp.right).offset(PAD*5)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(CANCEL_BTN_WIDTH)
            make.height.equalTo(CANCEL_BTN_HEIGHT)
            make.bottom.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(mainView)//.offset(PAD)
            //make.right.equalTo(mainView)
        }
    }
    
    
}
