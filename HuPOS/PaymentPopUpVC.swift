
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

class PaymentPopUpVC:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (self.sale?.events?.count)!
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell:UITableViewCell = self.eventTableView.dequeueReusableCell(withIdentifier: "Cell")!
            let amt = self.sale!.events![indexPath.row].amount.description
            let type = self.sale!.events![indexPath.row].type.description
            cell.textLabel?.text = "- \(amt) : \(type)"
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .red
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            
            return cell
        }
    
    
    var sale:Sale?
    var eventType = EventType.cash
    var amtPaid = "0"
    var amtPaid_D = 0.0

    
    
    override func viewDidLoad() {
        let screenSize = UIScreen.main.bounds
        eventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        eventTableView.dataSource = self
        eventTableView.delegate = self
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
    
    @objc func acceptSaleAction(){
        let payment = self.amtPaid.toDouble()/100
        let totalDue = (self.sale?.remainingBalance)!
        print("PAYMENT ACTION")
        if(payment < totalDue && payment > 0.0){
            print("Payment \(payment) is less than total due \(totalDue)")
            // Prompt for confirmation sometime?
            let date = Date()
            
            
            let event = Event(_id: "", _type: self.eventType, _amount: payment, _userID: "ADMIN", _time: date)
            
            self.sale!.remainingBalance = totalDue - payment
            self.sale!.events!.append(event)
            self.eventTableView.reloadData()
            self.saleSubtotal.text = sale!.remainingBalance!.toCurrencyString()
            self.acceptBtn.setTitle("Pay  \(sale!.remainingBalance!.toCurrencyString())  \(self.eventType.description)", for: .normal)
            self.amtPaid = "0"
        }
        
        // print(self.sale?.description)
        for event in (self.sale?.events)! {
            //print(" - Event: \(event.type): \(event.amount)")
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
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
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
