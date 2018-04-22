
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

class PaymentPopUpVC:UIViewController {
    
    var sale:Sale?
    var eventType = EventType.cash
    var amtPaid = "0"
    var amtPaid_D = 0.0
    
    @objc func digitPressed(sender:UIButton){
        let digit = sender.titleLabel?.text!
        amtPaid.append(digit!)
        self.acceptBtn.setTitle("Pay \(amtPaid.currencyInputFormatting()) \(self.eventType.description)", for: .normal)
    }
    @objc func backspaceAction(sender:UIButton){
        if(self.amtPaid.count > 0){
            self.amtPaid.removeLast()
            self.acceptBtn.setTitle("Pay \(amtPaid.currencyInputFormatting()) \(self.eventType.description)", for: .normal)
        }
    }
    
    @objc func clearAction(sender:UIButton){
        self.acceptBtn.setTitle("Pay \(self.sale?.remainingBalance?.toCurrencyString() ?? "$0.00") \(self.eventType.description)", for: .normal)

        self.amtPaid = "0"
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
            self.saleTotal.text = sale!.remainingBalance!.toCurrencyString()
            self.acceptBtn.setTitle("Pay \(sale!.remainingBalance!.toCurrencyString()) \(self.eventType.description)", for: .normal)
            self.amtPaid = "0"
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
        
        self.acceptBtn.setTitle("Pay  \(self.saleTotal.text ?? "$0.00")  \(self.eventType.description)", for: .normal)
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
        lbl.font = UIFont.systemFont(ofSize: 60)
        lbl.textColor = UIColor.white
        lbl.text = "Total:"
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()
    
    let saleTotal:UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 500)
        //txt.minimumFontSize = 10
        //txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        
        //txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.clear
        txt.textColor = UIColor.green.withAlphaComponent(0.5)
        txt.textAlignment = .right
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 150)
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
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
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    func setupViews(screen:CGRect){
        
        let EVENT_BTN_SPACES = 4.0
        
        let PAD = 0.5
        
        let MAIN_VIEW_WIDTH = Double(screen.width)
        let MAIN_VIEW_HEIGHT = Double(screen.height)
        
        let NUM_PAD_WIDTH = MAIN_VIEW_WIDTH * (4/10)
        let NUM_PAD_HEIGHT = MAIN_VIEW_HEIGHT * (4/6)
        
        let DIGIT_WIDTH = (NUM_PAD_WIDTH - 4*PAD) * (1/3)
        let DIGIT_HEIGHT = (NUM_PAD_HEIGHT - 5*PAD) * (1/4)
        
        let EVENT_BTN_WIDTH = MAIN_VIEW_WIDTH/EVENT_BTN_SPACES
        let EVENT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/6)
        
        _ = NUM_PAD_WIDTH - 2 * PAD
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

        
        view.addSubview(totalDueLbl)
        
        var remainingBalance = self.sale!.remainingBalance!
        
        self.saleTotal.text = self.sale!.getSaleTotal()
        self.acceptBtn.setTitle("Pay  \(self.sale!.getSaleTotal())  \(self.eventType.description)", for: .normal)
        // apply events first
        
    
        
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
            make.top.equalTo(cashEventBtn.snp.bottom).offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        twoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn)
            make.left.equalTo(oneBtn.snp.right).offset(PAD)
        }
        
        threeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn)
            make.left.equalTo(twoBtn.snp.right).offset(PAD)
        }
        
        fourBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(oneBtn.snp.bottom).offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        
        fiveBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn)
            make.left.equalTo(fourBtn.snp.right).offset(PAD)
        }
        
        sixBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn)
            make.left.equalTo(fiveBtn.snp.right).offset(PAD)
        }
        
        sevenBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(fourBtn.snp.bottom).offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        eightBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn)
            make.left.equalTo(sevenBtn.snp.right).offset(PAD)
        }
        nineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn)
            make.left.equalTo(eightBtn.snp.right).offset(PAD)
        }
        
        clearBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sevenBtn.snp.bottom).offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        zeroBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(clearBtn)
            make.left.equalTo(clearBtn.snp.right).offset(PAD)
        }
        enterBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(zeroBtn)
            make.left.equalTo(zeroBtn.snp.right).offset(PAD)
        }




        
        acceptBtn.snp.makeConstraints { (make) in
            make.width.equalTo(ACCEPT_BTN_WIDTH)
            make.height.equalTo(ACCEPT_BTN_HEIGHT)
            make.left.equalTo(cancelBtn.snp.right)//.offset(PAD)
            make.bottom.equalTo(mainView)//.offset(PAD)
        }
        
        totalDueLbl.snp.makeConstraints { (make) in
//            make.width.equalTo(EVENT_BTN_WIDTH)
//            make.height.equalTo(SALE_TOTAL_HEIGHT/2)
            make.top.equalTo(mainView).offset(EVENT_BTN_HEIGHT)
            make.left.equalTo(mainView).offset(NUM_PAD_WIDTH + PAD)
        }
        
        saleTotal.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH - NUM_PAD_WIDTH)
           // make.height. //.equalTo(SALE_TOTAL_HEIGHT)
            make.top.equalTo(totalDueLbl.snp.bottom)

            //make.top.equalTo(totalDueLbl.snp.bottom)//.offset(PAD)
            make.right.equalTo(mainView).offset(PAD*(-2))
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(CANCEL_BTN_WIDTH)
            make.height.equalTo(CANCEL_BTN_HEIGHT)
            make.bottom.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(mainView)//.offset(PAD)
            //make.right.equalTo(mainView)
        }
    }
    
        override func viewDidLoad() {
            let screenSize = UIScreen.main.bounds
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            view.addSubview(blurEffectView)
//            saleTotal.text = self.sale?.getSaleTotal()
            print("Inside payment view: \(self.sale!.description)")

            setupViews(screen: screenSize)
        }
}
