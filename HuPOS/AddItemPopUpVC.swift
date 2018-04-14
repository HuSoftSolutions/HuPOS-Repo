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
import Firebase


class AddItemPopUpVC:UIViewController {
    
    var inventoryItem:InventoryItem?
    var cellIndex = 0
    var taxOn:Bool = true
    
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let itemImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = #imageLiteral(resourceName: "noimg")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 5
        img.layer.masksToBounds = true
        return img
    }()
    
    let itemName:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Item Name"
        txt.adjustsFontSizeToFitWidth = true
        txt.font = UIFont.systemFont(ofSize: 30)
        txt.sizeToFit()
        txt.autocapitalizationType = .words
        return txt
    }()
    
    let itemCategory:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 30)
        txt.minimumFontSize = 10
        txt.placeholder = "Item Category"
        txt.adjustsFontSizeToFitWidth = true
        txt.autocapitalizationType = .words
        return txt
    }()
    
    let taxBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
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
    
    let costLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = UIColor.lightGray
        lbl.text = "Cost"
        return lbl
    }()
    
    let priceLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = UIColor.lightGray
        lbl.text = "Price"
        return lbl
    }()
    
    let cost:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 30)
        txt.minimumFontSize = 10
        txt.placeholder = "$0.00"
        txt.adjustsFontSizeToFitWidth = true
        txt.addTarget(self, action: #selector(AddItemPopUpVC.itemPriceChanged), for: .editingChanged)
        txt.keyboardType = .numberPad
        return txt
    }()
    
    let price:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 30)
        txt.minimumFontSize = 10
        txt.placeholder = "$0.00"
        txt.adjustsFontSizeToFitWidth = true
        txt.addTarget(self, action: #selector(AddItemPopUpVC.itemPriceChanged), for: .editingChanged)
        txt.keyboardType = .numberPad
        return txt
    }()
    
    let desc:UITextView = {
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.toolbarPlaceholder = "Description"
        txt.font = UIFont.systemFont(ofSize: 20)
        txt.layer.borderWidth = 0.5
        txt.layer.cornerRadius = 5
        txt.layer.masksToBounds = true
        return txt
    }()
    
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    let addItemBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Add Item", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(addItemAction), for: .touchUpInside)
        return btn
    }()
    
    let removeItemBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(deleteItemAction), for: .touchUpInside)
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
    
    @objc func deleteItemAction(){
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to permanently delete this item?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            let db = Firestore.firestore()
            db.collection("Items").document((self.inventoryItem?.id)!).delete()
            NotificationCenter.default.post(name: .reloadCollectionView, object: self.inventoryItem)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (alert) in
            //self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    @objc func addItemAction(){
        
        //        let confirmationAlert = UIAlertController(title: "Alert", message: "Are you sure you want to add this item?", preferredStyle: .alert)
        //        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
        
        let cost_ = self.cost.text!.dropFirst()
        let price_ = self.price.text!.dropFirst()
        
        guard let cost_d = Double(cost_) else { return }
        guard let price_d = Double(price_) else { return }
        
        var id = ""
        
        if(self.inventoryItem != nil){
            id = (inventoryItem?.id!)!
        }
        
        let newItem = InventoryItem(img: "", title: self.itemName.text!, category: self.itemCategory.text!, price: price_d, cost: cost_d, tax: self.taxOn, description: self.desc.text, index: self.cellIndex, id:id)
        
        print(newItem.dictionary())
        let db = Firestore.firestore()
        
        if(self.inventoryItem != nil){
            print("Inventory Item To Edit Present.\n Old: \(String(describing: self.inventoryItem?.dictionary())) \nNew: \(newItem.dictionary())")
            db.collection("Items").document((self.inventoryItem?.id)!).updateData([
                "Category":newItem.category!,
                "Title":newItem.title!,
                "Image":newItem.image!,
                "Price":newItem.price!,
                "Cost":newItem.cost!,
                "Tax":newItem.tax!,
                "Description":newItem.desc!]) { err in
                    if let err = err {
                        print(err)
                        //                            let errorAlert = UIAlertController(title: "Error", message: "'\(String(describing: newItem.title) )' was not updated.", preferredStyle: .alert)
                        //                            let cancel = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
                        //                            errorAlert.addAction(cancel)
                        //                            self.present(errorAlert, animated: true, completion: nil)
                    }else{
                        //                            let successAlert = UIAlertController(title: "Success", message: "'\(newItem.title!)' was updated successfully.", preferredStyle: .alert)
                        //                            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                        //                            successAlert.addAction(cancel)
                        //                            self.present(successAlert, animated: true, completion: nil)
                        
                    }
            }
            
        }else{
            
            let ref = db.collection("Items").addDocument(data: newItem.dictionary(), completion: { (err) in
                if err != nil {
                    print(err.debugDescription)
                    //                        let errorAlert = UIAlertController(title: "Error", message: "'\(String(describing: newItem.title) )' was not added.", preferredStyle: .alert)
                    //                        let cancel = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
                    //                        errorAlert.addAction(cancel)
                    //                        self.present(errorAlert, animated: true, completion: nil)
                    //                        return
                }else{
                    //                        let successAlert = UIAlertController(title: "Success", message: "'\(newItem.title!)' was added successfully.", preferredStyle: .alert)
                    //                        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    //                        successAlert.addAction(cancel)
                    //
                    //                        self.present(successAlert, animated: true, completion: nil)
                }
                
            })
            newItem.id = ref.documentID
            db.collection("Items").document(ref.documentID).updateData(["Id":ref.documentID])
            
        }
        
        self.dismiss(animated: true, completion: {
            //broadcast
            NotificationCenter.default.post(name: .inventoryItemAdded, object: newItem )
        })
    }
    //        confirmationAlert.addAction(yesAction)
    //        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        self.present(confirmationAlert, animated: true, completion: nil)
    // }
    
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
    
    func addItemToEdit(){
        if(self.inventoryItem != nil){
            self.itemName.text = self.inventoryItem?.title
            self.itemCategory.text = self.inventoryItem?.category
            self.price.text = String(format: "%.02f", (self.inventoryItem?.price)!).currencyInputFormatting()
            self.cost.text = String(format: "%.02f", (self.inventoryItem?.cost)!).currencyInputFormatting()
            self.taxOn = !(self.inventoryItem?.tax)!
            self.taxChangedAction()
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
        view.addSubview(costLbl)
        view.addSubview(priceLbl)
        view.addSubview(cost)
        view.addSubview(price)
        view.addSubview(desc)
        
        
        
        addItemBtn.setTitleColor(self.view.tintColor, for: .normal)
        
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
        
        costLbl.snp.makeConstraints { (make) in
            make.top.equalTo(itemImage.snp.bottom).offset(15)
            make.left.equalTo(mainView.snp.left).offset(15)
            make.width.equalTo(MAIN_VIEW_WIDTH/2)
        }
        
        priceLbl.snp.makeConstraints { (make) in
            make.top.equalTo(itemImage.snp.bottom).offset(15)
            make.left.equalTo(costLbl.snp.right).offset(15)
            make.width.equalTo(MAIN_VIEW_WIDTH/2)
        }
        
        cost.snp.makeConstraints { (make) in
            make.top.equalTo(costLbl.snp.bottom)
            make.left.equalTo(mainView.snp.left).offset(15)
            make.right.equalTo(mainView.snp.right).offset(-1*MAIN_VIEW_WIDTH / 2)
            make.height.equalTo(IMG_WIDTH / 3)
        }
        price.snp.makeConstraints { (make) in
            make.top.equalTo(priceLbl.snp.bottom)
            make.left.equalTo(priceLbl.snp.left)
            make.right.equalTo(mainView.snp.right).offset(-15)
            make.height.equalTo(IMG_WIDTH / 3)
        }
        
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(cost.snp.bottom).offset(15)
            make.left.equalTo(mainView.snp.left).offset(15)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-15)
            make.right.equalTo(mainView.snp.right).offset(-15)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(mainView).offset(15)
            make.bottom.equalTo(mainView).offset(-15)
        }
        
        addItemBtn.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(mainView).offset(-15)
        }
        
        if(self.inventoryItem != nil){
            view.addSubview(removeItemBtn)
            removeItemBtn.snp.makeConstraints { (make) in
                make.bottom.equalTo(mainView).offset(-15)
                make.centerX.equalTo(mainView.snp.centerX)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Add New Item"
        
        self.addItemToEdit()
        
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
        
        //        // if first number is 0 or all numbers were deleted
        //        guard number != 0 as NSNumber else {
        //            return ""
        //        }
        
        return formatter.string(from: number)!
    }
}
