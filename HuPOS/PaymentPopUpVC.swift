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

enum EventType { case cash, discount, credit, gift, check, refund }

class PaymentPopUpVC:UIViewController {
    
    var sale:Sale?
    var eventType = EventType.cash
    
    @objc func digitPressed(sender:UIButton){
        let digit = sender.titleLabel?.text!
        eventTotal.text?.append(digit!)
        eventTotal.text = eventTotal.text?.currencyInputFormatting() // -- ???
        
        
    }
    @objc func enterAction(sender:UIButton){
    
    }
    
    @objc func clearAction(sender:UIButton){
        
        self.eventTotal.text?.removeAll()
        
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func acceptSaleAction(){
        
    }
    
    @objc func eventTypeChanged(sender:UIButton){
        var oldEventType = self.eventType
        
        switch oldEventType {
        case .cash:
            self.cashEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .credit:
            self.creditEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .check :
            self.checkEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .gift :
            self.giftEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        case .discount :
            self.discountEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        default:
            self.cashEventBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
        print(sender.titleLabel!.text)
        switch sender.titleLabel!.text {
        case "Cash":
            self.eventType = .cash
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Credit":
            self.eventType = .credit
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Check" :
            self.eventType = .check
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Gift" :
            self.eventType = .gift
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case "Discount" :
            self.eventType = .discount
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        default:
            self.eventType = .cash
            self.cashEventBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
    }
    
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        //view.layer.cornerRadius = 5
        //view.layer.masksToBounds = true
        return view
    }()
    
    let totalDueLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 100)
        lbl.textColor = UIColor.black
        lbl.text = "Total Due:"
        return lbl
    }()
    
    let saleTotal:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 200)
        txt.minimumFontSize = 10
        txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.white
        txt.textColor = UIColor.green.withAlphaComponent(0.5)
        txt.textAlignment = .center
        txt.sizeToFit()
        txt.isUserInteractionEnabled = false
        txt.keyboardType = .phonePad
//        txt.layer.cornerRadius = 5
//        txt.layer.masksToBounds = true
        return txt
    }()
    
    let eventTotal:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 100)
        txt.minimumFontSize = 10
        txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.white
        txt.textColor = UIColor.black
        txt.textAlignment = .center
        txt.sizeToFit()
        txt.isUserInteractionEnabled = false
        txt.keyboardType = .phonePad
        //txt.layer.borderWidth = 0.25
//        txt.layer.cornerRadius = 5
//        txt.layer.masksToBounds = true
        return txt
    }()
    
    let oneBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("1", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 80)
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
        btn.setTitle("Add To Sale", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
        return btn
    }()
    let clearBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        return btn
    }()
    
    let cashEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cash", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    
    let discountEventBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Discount", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.borderWidth = 0.25
        btn.addTarget(self, action: #selector(eventTypeChanged), for: .touchUpInside)
        return btn
    }()
    
    let acceptBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Accept", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 90)
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
    
    func setupViews(screen:CGRect){
        
        let EVENT_BTN_SPACES = 5.0
        
        let PAD = 2.0
        
        let MAIN_VIEW_WIDTH = Double(screen.width)
        let MAIN_VIEW_HEIGHT = Double(screen.height)
        
        let NUM_PAD_WIDTH = MAIN_VIEW_WIDTH * (2/5) - 3 * PAD
        let NUM_PAD_HEIGHT = MAIN_VIEW_HEIGHT * (5/7) - 4 * PAD
        
        let DIGIT_WIDTH = NUM_PAD_WIDTH * (1/3) //- (PAD)
        let DIGIT_HEIGHT = NUM_PAD_HEIGHT * (1/5) //- (PAD)
        
        let EVENT_BTN_WIDTH = MAIN_VIEW_WIDTH/EVENT_BTN_SPACES
        let EVENT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (PAD) * (1/7)
        
        let EVENT_AMT_WIDTH = NUM_PAD_WIDTH - (PAD)
        let EVENT_AMT_HEIGHT = NUM_PAD_HEIGHT * (1/5)// - (PAD)
        
        let CANCEL_BTN_WIDTH = NUM_PAD_WIDTH - (PAD)
        let CANCEL_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (PAD)
        
        let SALE_TOTAL_WIDTH = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH //- (PAD)
        let SALE_TOTAL_HEIGHT = NUM_PAD_HEIGHT * (1/2) - (PAD)
        
        let ACCEPT_BTN_WIDTH = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH// - (PAD)
        let ACCEPT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (PAD)
        
        view.addSubview(mainView)
        view.addSubview(acceptBtn)
        view.addSubview(cancelBtn)
        view.addSubview(eventTotal)
        view.addSubview(saleTotal)
        view.addSubview(cashEventBtn)
        view.addSubview(creditEventBtn)
        view.addSubview(checkEventBtn)
        view.addSubview(giftEventBtn)
        view.addSubview(discountEventBtn)
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
        
        // apply events first
        
        saleTotal.text = String(format: "%.02f", (self.sale?.saleTotal)!).currencyInputFormatting()
        
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
        discountEventBtn.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(EVENT_BTN_HEIGHT)
            make.top.equalTo(mainView)//.offset(PAD)
            make.left.equalTo(giftEventBtn.snp.right)//.offset(PAD)
        }
        eventTotal.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_AMT_WIDTH)
            make.height.equalTo(EVENT_AMT_HEIGHT)
            make.top.equalTo(cashEventBtn.snp.bottom)//.offset(PAD)
            make.left.equalTo(mainView)//.offset(PAD)
        }





        oneBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(eventTotal.snp.bottom).offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        twoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(eventTotal.snp.bottom).offset(PAD)
            make.left.equalTo(oneBtn.snp.right).offset(PAD)
        }

        threeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(eventTotal.snp.bottom).offset(PAD)
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
            make.top.equalTo(twoBtn.snp.bottom).offset(PAD)
            make.left.equalTo(fourBtn.snp.right).offset(PAD)
        }

        sixBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(threeBtn.snp.bottom).offset(PAD)
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
            make.top.equalTo(fiveBtn.snp.bottom).offset(PAD)
            make.left.equalTo(sevenBtn.snp.right).offset(PAD)
        }
        nineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(sixBtn.snp.bottom).offset(PAD)
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
            make.top.equalTo(eightBtn.snp.bottom).offset(PAD)
            make.left.equalTo(clearBtn.snp.right).offset(PAD)
        }
        enterBtn.snp.makeConstraints { (make) in
            make.width.equalTo(DIGIT_WIDTH)
            make.height.equalTo(DIGIT_HEIGHT)
            make.top.equalTo(nineBtn.snp.bottom).offset(PAD)
            make.left.equalTo(zeroBtn.snp.right).offset(PAD)
        }
        
        acceptBtn.snp.makeConstraints { (make) in
            make.width.equalTo(ACCEPT_BTN_WIDTH)
            make.height.equalTo(ACCEPT_BTN_HEIGHT)
            make.left.equalTo(cancelBtn.snp.right)//.offset(PAD)
            make.bottom.equalTo(mainView)//.offset(PAD)
        }
        
        totalDueLbl.snp.makeConstraints { (make) in
            make.width.equalTo(SALE_TOTAL_WIDTH)
            make.height.equalTo(SALE_TOTAL_HEIGHT/2)
            make.top.equalTo(checkEventBtn.snp.bottom)//.offset(PAD)
            make.left.equalTo(eventTotal.snp.right)//.offset(PAD)
        }
        
        saleTotal.snp.makeConstraints { (make) in
            make.width.equalTo(SALE_TOTAL_WIDTH)
            make.height.equalTo(SALE_TOTAL_HEIGHT)
            make.top.equalTo(totalDueLbl.snp.bottom)//.offset(PAD)
            make.left.equalTo(eventTotal.snp.right)//.offset(PAD)
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
            setupViews(screen: screenSize)
        }
}
