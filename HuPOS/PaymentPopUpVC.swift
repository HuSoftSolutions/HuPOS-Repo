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

enum EventType { case cash, discount, credit, gift, check, refund }

class PaymentPopUpVC:UIViewController {
    
    var sale:Sale?
    var eventType = EventType.cash
    
    @objc func digitPressed(sender:UIButton){

    }
    @objc func enterAction(sender:UIButton){
    
    }
    
    @objc func clearAction(sender:UIButton){
        
        
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
        
        self.acceptBtn.setTitle("Pay With \(newEventType)", for: .normal)
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
        lbl.font = UIFont.systemFont(ofSize: 60)
        lbl.textColor = UIColor.black
        lbl.text = "Total Due:"
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()
    
    let saleTotal:UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 200)
        //txt.minimumFontSize = 10
        //txt.placeholder = "0.00".currencyInputFormatting() // -- ???
        txt.adjustsFontSizeToFitWidth = true
        
        //txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.white
        txt.textColor = UIColor.green.withAlphaComponent(0.5)
        txt.textAlignment = .center
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
    
    let acceptBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Pay With Cash", for: .normal)
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
    
    func setupViews(screen:CGRect){
        
        let EVENT_BTN_SPACES = 4.0
        
        let PAD = 4.0
        
        let MAIN_VIEW_WIDTH = Double(screen.width)
        let MAIN_VIEW_HEIGHT = Double(screen.height)
        
        let NUM_PAD_WIDTH = MAIN_VIEW_WIDTH * (3/10)
        let NUM_PAD_HEIGHT = MAIN_VIEW_HEIGHT * (5/7)
        
        let DIGIT_WIDTH = (NUM_PAD_WIDTH - 4*PAD) * (1/3)
        let DIGIT_HEIGHT = (NUM_PAD_HEIGHT - 6*PAD) * (1/5)
        
        let EVENT_BTN_WIDTH = MAIN_VIEW_WIDTH/EVENT_BTN_SPACES
        let EVENT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)
        
        let EVENT_AMT_WIDTH = NUM_PAD_WIDTH - 2 * PAD
        let EVENT_AMT_HEIGHT = saleTotal.font.capHeight + 10//DIGIT_HEIGHT
        
        let CANCEL_BTN_WIDTH = MAIN_VIEW_WIDTH * (1/10)
        let CANCEL_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (PAD)
        
        let SALE_TOTAL_WIDTH = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH //- (PAD)
        let SALE_TOTAL_HEIGHT = saleTotal.font.capHeight
        
        let ACCEPT_BTN_WIDTH = MAIN_VIEW_WIDTH - CANCEL_BTN_WIDTH// - (PAD)
        let ACCEPT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (PAD)
        
        view.addSubview(mainView)
        view.addSubview(acceptBtn)
        view.addSubview(cancelBtn)
        view.addSubview(saleTotal)
        view.addSubview(cashEventBtn)
        view.addSubview(creditEventBtn)
        view.addSubview(checkEventBtn)
        view.addSubview(giftEventBtn)
        //view.addSubview(discountEventBtn)

        view.addSubview(totalDueLbl)
        
        // apply events first
        
        saleTotal.text = self.sale?.getSaleTotal()[0]
        
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
        
        






        
        acceptBtn.snp.makeConstraints { (make) in
            make.width.equalTo(ACCEPT_BTN_WIDTH)
            make.height.equalTo(ACCEPT_BTN_HEIGHT)
            make.left.equalTo(cancelBtn.snp.right)//.offset(PAD)
            make.bottom.equalTo(mainView)//.offset(PAD)
        }
        
        totalDueLbl.snp.makeConstraints { (make) in
            make.width.equalTo(EVENT_BTN_WIDTH)
            make.height.equalTo(SALE_TOTAL_HEIGHT/2)
            make.top.equalTo(checkEventBtn.snp.bottom)//.offset(PAD)
            make.left.equalTo(mainView).offset(PAD)
        }
        
        saleTotal.snp.makeConstraints { (make) in
            make.width.equalTo(SALE_TOTAL_WIDTH)
           // make.height. //.equalTo(SALE_TOTAL_HEIGHT)
          
            make.top.equalTo(totalDueLbl.snp.bottom)//.offset(PAD)
            make.left.equalTo(totalDueLbl.snp.right).offset(PAD)
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
