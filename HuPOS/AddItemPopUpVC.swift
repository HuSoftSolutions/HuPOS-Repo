//
//  AddItemPopUpVC.swift
//  HuPOS
//
//  Created by Cody Husek on 4/3/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit


class AddItemPopUpVC:UIViewController, UITextViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        

        self.showAnimate()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let screenSize = UIScreen.main.bounds
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let navView = UIView()
        navView.frame = CGRect(x: 0, y: 0, width: screenSize.width/2, height: screenSize.height - 350)
        navView.center.x = view.center.x
        navView.center.y = view.center.y
        navView.backgroundColor = UIColor.white
        navView.layer.cornerRadius = 5
        navView.layer.masksToBounds = true
        view.addSubview(navView)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: navView.frame.minY + 15, width: 0, height: 0))
        titleLbl.textAlignment = .center
        titleLbl.text = "Add New Item"
        titleLbl.font = UIFont(name: titleLbl.font.fontName, size: 50)
        titleLbl.sizeToFit()
        titleLbl.center.x = navView.center.x
        view.addSubview(titleLbl)
        
        let myImageView = UIImageView(frame: CGRect(x: navView.frame.minX + 50, y: titleLbl.frame.maxY, width: 120, height: 120))
        myImageView.image = #imageLiteral(resourceName: "default-profile")
        myImageView.contentMode = .scaleAspectFill
         //myImageView.center.x = view.center.x
        view.addSubview(myImageView)
        
        let taxLbl = UILabel(frame: CGRect(x: myImageView.frame.maxX + 20, y: myImageView.frame.midY - 10, width: 0, height: 0))
        taxLbl.textAlignment = .center
        taxLbl.text = "Tax"
        taxLbl.font = UIFont(name: titleLbl.font.fontName, size: 40)
        taxLbl.sizeToFit()
        view.addSubview(taxLbl)
        
        let taxSwitch = UISwitch(frame: CGRect(x: taxLbl.frame.maxX + 20, y: taxLbl.frame.minY + 5, width: taxLbl.frame.width, height: taxLbl.frame.width))
        taxSwitch.center.y = taxLbl.center.y
        view.addSubview(taxSwitch)
        
        let itemName = UITextField(frame: CGRect(x:navView.frame.minX + 50, y: myImageView.frame.maxY + 20, width: screenSize.width/2 - 100, height: 60))
        itemName.placeholder = "Enter Item Name"
        itemName.font = UIFont(name: itemName.font!.fontName, size: 50)
        itemName.adjustsFontSizeToFitWidth = true
        //itemName.sizeToFit()
        view.addSubview(itemName)
        
        let itemCategory = UITextField(frame: CGRect(x:navView.frame.minX + 50, y: itemName.frame.maxY + 15, width: screenSize.width/2 - 100, height: 60))
        itemCategory.placeholder = "Enter Item Category"
        itemCategory.font = UIFont(name: itemName.font!.fontName, size: 50)
        itemCategory.adjustsFontSizeToFitWidth = true
        //itemCategory.sizeToFit()
        view.addSubview(itemCategory)
        
        let costLbl = UILabel(frame: CGRect(x:navView.frame.minX + 50, y: itemCategory.frame.maxY + 15, width: screenSize.width/3, height: 60))
        costLbl.textAlignment = .center
        costLbl.text = "Cost"
        costLbl.font = UIFont(name: titleLbl.font.fontName, size: 50)
        costLbl.sizeToFit()
        view.addSubview(costLbl)
        
        let itemCost = UITextField(frame: CGRect(x:costLbl.frame.maxX + 10, y: itemCategory.frame.maxY + 15, width: 0, height: 0))
        itemCost.placeholder = "$0.00"
        //itemCost.center.y = costLbl.center.y
        itemCost.font = UIFont(name: itemName.font!.fontName, size: 50)
        itemCost.adjustsFontSizeToFitWidth = true
        itemCost.sizeToFit()
        
        itemCost.addTarget(self, action: #selector(itemPriceChanged), for: .editingChanged)
        
        view.addSubview(itemCost)
        
        let priceLbl = UILabel(frame: CGRect(x:itemCost.frame.maxX + 10, y: itemCategory.frame.maxY + 15, width: screenSize.width/3, height: 60))
        priceLbl.textAlignment = .center
        priceLbl.text = "Price"
        priceLbl.font = UIFont(name: titleLbl.font.fontName, size: 50)
        priceLbl.sizeToFit()
        
        view.addSubview(priceLbl)
        
        let itemPrice = UITextField(frame: CGRect(x:priceLbl.frame.maxX + 10, y: itemCategory.frame.maxY + 15, width: 0, height: 0))
        itemPrice.placeholder = "$0.00"
        //itemPrice.center.y = priceLbl.center.y
        itemPrice.font = UIFont(name: itemName.font!.fontName, size: 50)
        itemPrice.adjustsFontSizeToFitWidth = true
        itemPrice.sizeToFit()
        
        itemPrice.addTarget(self, action: #selector(itemPriceChanged), for: .editingChanged)
        itemPrice.translatesAutoresizingMaskIntoConstraints = false 
        itemPrice.anchor(top: nil, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        view.addSubview(itemPrice)
        

        
        let itemDescription = UITextView(frame: CGRect(x: navView.frame.minX + 50, y: itemPrice.frame.maxY + 20, width: screenSize.width/2 - 100 , height: 150))
        itemDescription.font = .systemFont(ofSize: 25)
        itemDescription.layer.borderWidth = 1
        itemDescription.layer.cornerRadius = 5
        itemDescription.layer.masksToBounds = true
        itemDescription.delegate = self
        view.addSubview(itemDescription)
        
        let cancelBtn = UIButton(frame: CGRect(x:navView.frame.minX, y: navView.frame.maxY - 70, width: 100, height: 70))
        cancelBtn.reversesTitleShadowWhenHighlighted = true
        cancelBtn.setTitleShadowColor(.black, for: .highlighted)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.red, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        view.addSubview(cancelBtn)
        
        let addItemBtn = UIButton(frame: CGRect(x:navView.frame.maxX - 105, y: navView.frame.maxY - 70, width: 100, height: 70))
        addItemBtn.reversesTitleShadowWhenHighlighted = true
        addItemBtn.setTitleShadowColor(.black, for: .highlighted)
        addItemBtn.setTitle("Add Item", for: .normal)
        addItemBtn.setTitleColor( self.view.tintColor, for: .normal)
        addItemBtn.addTarget(self, action: #selector(addItemAction), for: .touchUpInside)
        view.addSubview(addItemBtn)

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
