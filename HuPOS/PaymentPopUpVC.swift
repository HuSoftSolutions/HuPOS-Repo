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

class PaymentPopUpVC:UIViewController {
    
    var sale:Sale?
    
    @objc func digitPressed(sender:UIButton){
        let digit = sender.titleLabel?.text!
        miscPriceTotal.text?.append(digit!)
        miscPriceTotal.text = miscPriceTotal.text?.currencyInputFormatting()
        
        
    }
    @objc func enterAction(sender:UIButton){
    
    }
    
    @objc func clearAction(sender:UIButton){
        
        self.eventTotal.text?.removeAll()
        
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }

    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        //view.layer.cornerRadius = 5
        //view.layer.masksToBounds = true
        return view
    }()
    
    let eventTotal:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 80)
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
        txt.layer.cornerRadius = 5
        txt.layer.masksToBounds = true
        return txt
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
        btn.setTitle("Enter", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
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
    
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    func setupViews(screen:CGRect){
        
        let EVENT_BTN_SPACES = 5.0
        
        let PAD = 15.0
        
        let MAIN_VIEW_WIDTH = Double(screen.width)
        let MAIN_VIEW_HEIGHT = Double(screen.height)
        
        let NUM_PAD_WIDTH = MAIN_VIEW_WIDTH * (2/5)
        let NUM_PAD_HEIGHT = MAIN_VIEW_HEIGHT * (5/7)
        
        let DIGIT_WIDTH = NUM_PAD_WIDTH * (1/3)
        let DIGIT_HEIGHT = NUM_PAD_HEIGHT * (1/5)
        
        let EVENT_BTN_WIDTH = MAIN_VIEW_WIDTH/EVENT_BTN_SPACES
        let EVENT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (2*PAD)
        
        let EVENT_AMT_WIDTH = NUM_PAD_WIDTH
        let EVENT_AMT_HEIGHT = NUM_PAD_HEIGHT * (1/5)
        
        let CANCEL_BTN_WIDTH = NUM_PAD_WIDTH //- (2*PAD)
        let CANCEL_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)// - (2*PAD)
        
        let SALE_TOTAL_WIDTH = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH
        let SALE_TOTAL_HEIGHT = NUM_PAD_HEIGHT * (1/2)
        
        let ACCEPT_BTN_WIDTH = MAIN_VIEW_WIDTH - NUM_PAD_WIDTH
        let ACCEPT_BTN_HEIGHT = MAIN_VIEW_HEIGHT * (1/7)

        
        view.addSubview(mainView)
        view.addSubview(cancelBtn)
        view.addSubview(miscPriceTotal)
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
        
        
        
        mainView.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH)
            make.height.equalTo(MAIN_VIEW_WIDTH)
            make.center.equalTo(view)
        }
        
        miscPriceTotal.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 2)
            make.height.equalTo(MAIN_VIEW_WIDTH * (2/7))
            make.top.equalTo(mainView)
            make.left.equalTo(mainView)
            make.right.equalTo(mainView)
        }
        
        oneBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(miscPriceTotal.snp.bottom)
            make.left.equalTo(mainView)
        }
        twoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(miscPriceTotal.snp.bottom)
            make.left.equalTo(oneBtn.snp.right)
        }
        
        threeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(miscPriceTotal.snp.bottom)
            make.left.equalTo(twoBtn.snp.right)
        }
        
        fourBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(oneBtn.snp.bottom)
            make.left.equalTo(mainView)
        }
        
        fiveBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(twoBtn.snp.bottom)
            make.left.equalTo(fourBtn.snp.right)
        }
        
        sixBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(threeBtn.snp.bottom)
            make.left.equalTo(fiveBtn.snp.right)
        }
        
        sevenBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(fourBtn.snp.bottom)
            make.left.equalTo(mainView)
        }
        eightBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(fiveBtn.snp.bottom)
            make.left.equalTo(sevenBtn.snp.right)
        }
        nineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(sixBtn.snp.bottom)
            make.left.equalTo(eightBtn.snp.right)
        }
        
        clearBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(sevenBtn.snp.bottom)
            make.left.equalTo(mainView)
        }
        zeroBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(eightBtn.snp.bottom)
            make.left.equalTo(clearBtn.snp.right)
        }
        enterBtn.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH / 3)
            make.height.equalTo(NUM_PAD_HEIGHT / 4)
            make.top.equalTo(nineBtn.snp.bottom)
            make.left.equalTo(zeroBtn.snp.right)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.height.equalTo(MAIN_VIEW_WIDTH * (1/7) )
            make.width.equalTo(MAIN_VIEW_WIDTH / 2)
            make.bottom.equalTo(mainView)
            make.left.equalTo(mainView)
            make.right.equalTo(mainView)
        }
    }
    
        override func viewDidLoad() {
            let screenSize = UIScreen.main.bounds
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            setupViews(screen: screenSize)
        }
}
