//
//  AddItemPopUpVC.swift
//  HuPOS
//
//  Created by Cody Husek on 4/3/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AddItemPopUpVC:UIViewController {
    
    var taxOn:Bool = true
    
    let mainView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let itemImage:UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "default-profile")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let itemName:UITextField = {
        let txt = UITextField()
        txt.placeholder = "Item Name"
        txt.adjustsFontSizeToFitWidth = true
        txt.font = UIFont.systemFont(ofSize: 50)
        txt.sizeToFit()
        txt.backgroundColor = .lightGray
        return txt
    }()
    
    let itemCategory:UITextField = {
        let txt = UITextField()
        txt.font = UIFont.systemFont(ofSize: 50)
        txt.minimumFontSize = 10

        txt.placeholder = "Item Category"
        txt.adjustsFontSizeToFitWidth = true
        
        return txt
    }()
    
    let taxBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Tax ON", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.green
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(taxChangedAction), for: .touchUpInside)
        return btn
    }()
    
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    let addItemBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Add Item", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(addItemAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func itemPriceChanged(_ textField: UITextField){
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addItemAction(){
        
        let confirmationAlert = UIAlertController(title: "Alert", message: "Are you sure you want to add this item?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            // Add item
        }
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    @objc func taxChangedAction(){
        if(taxOn) {
            taxOn = false
            self.taxBtn.backgroundColor = UIColor.red
            self.taxBtn.setTitle("Tax OFF", for: .normal)
        }
        else {
            taxOn = true
            self.taxBtn.backgroundColor = UIColor.green
            self.taxBtn.setTitle("Tax ON", for: .normal)
           
        }
    }
    
    func setupViews(screen:CGRect){
        
        let MAIN_VIEW_WIDTH = screen.width / 2
        let IMG_WIDTH = screen.width / 6
        
        view.addSubview(mainView)
        view.addSubview(itemImage)
        view.addSubview(cancelBtn)
        view.addSubview(addItemBtn)
        view.addSubview(itemName)
        view.addSubview(itemCategory)
        view.addSubview(taxBtn)
        
        mainView.snp.makeConstraints { (make) in
            make.width.height.equalTo(MAIN_VIEW_WIDTH)
            make.center.equalTo(view)
        }
        
        itemImage.snp.makeConstraints { (make) in
            make.top.left.equalTo(mainView).offset(15)
            make.width.height.equalTo(IMG_WIDTH)
        }
        
        itemName.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(15)
            make.left.equalTo(itemImage.snp.right).offset(15)
            make.right.equalTo(mainView).offset(-15)
            make.height.equalTo(IMG_WIDTH / 3)
        }
        
        itemCategory.snp.makeConstraints { (make) in
            make.top.equalTo(itemName.snp.bottom)
            make.left.equalTo(itemImage.snp.right).offset(15)
            make.right.equalTo(mainView).offset(-15)
            make.height.equalTo(IMG_WIDTH / 3)
        }
        
        taxBtn.snp.makeConstraints { (make) in
            make.top.equalTo(itemCategory.snp.bottom)
            make.left.equalTo(itemImage.snp.right).offset(15)
            make.right.equalTo(mainView).offset(-15)
            make.height.equalTo(IMG_WIDTH / 3)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(mainView).offset(15)
            make.bottom.equalTo(mainView).offset(-15)
        }
        
        addItemBtn.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(mainView).offset(-15)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Add New Item"
        
        self.showAnimate()
        let screenSize = UIScreen.main.bounds
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        setupViews(screen: screenSize)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
