//
//  SalesHistoryVC.swift
//  HuPOS
//
//  Created by Cody Husek on 5/3/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class SaleCell: UITableViewCell {
    
    let title:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "ID"
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
    let taxTotal:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Tax Total"
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
    let saleTotal:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Sale Total"
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
    
    let timestamp:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Timestamp"
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
    
    let employee:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Employee"
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
    
    func setup(){
        let PAD = 5.0
        
        self.addSubview(title)
        self.addSubview(saleTotal)
        self.addSubview(timestamp)
        self.addSubview(employee)
        self.addSubview(taxTotal)
        
        title.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(PAD)
            //make.width.equalTo(self.bounds.width/2)
            // make.height.equalTo(self.bounds.height/2)
        }
        
        saleTotal.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self).offset(-1*PAD)
        }
        taxTotal.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(PAD)
            make.right.equalTo(self).offset(-1*PAD)
        }
        timestamp.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(PAD)
            //make.right.equalTo(self).offset(-1*PAD)
            make.left.equalTo(title.snp.right)
        }
        employee.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-1*PAD)
            make.left.equalTo(self).offset(PAD)
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
        self.title.text = ""
        self.employee.text = ""
        self.timestamp.text = ""
        self.saleTotal.text = ""
        self.taxTotal.text = ""
    }
    
}







class SalesHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sales:[Sale] = []
    
    let saleTable:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()
    
    let generateSaleBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Generate Report", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(loadSales), for: .touchUpInside)
        return btn
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sales.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let saleCell = SaleCell()
        saleCell.title.text = "Sale ID: " + self.sales[indexPath.row].id
        saleCell.employee.text = self.sales[indexPath.row].employeeId
        saleCell.saleTotal.text = self.sales[indexPath.row].saleTotal?.toCurrencyString()
        saleCell.taxTotal.text = self.sales[indexPath.row].taxTotal?.toCurrencyString()
        saleCell.timestamp.text = "Time: " + self.sales[indexPath.row].timestamp?.description
        return saleCell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSalesForMonth()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        
        setup(screen: screenSize)
        // Do any additional setup after loading the view.
    }
    
    @objc func loadSales(){
        self.getSalesForMonth()
    }
    
    func setup(screen:CGRect){
        let PAD = 10.0
        let NAVIGATIONBAR_HEIGHT = (navigationController?.navigationBar.layer.frame.height)!
        let TOOLBAR_HEIGHT = (navigationController?.toolbar.layer.frame.height)!
        var SCREEN_HEIGHT_SAFE = screen.height
        SCREEN_HEIGHT_SAFE -= NAVIGATIONBAR_HEIGHT
        SCREEN_HEIGHT_SAFE -= TOOLBAR_HEIGHT
        SCREEN_HEIGHT_SAFE -= CGFloat(PAD)
        
        self.saleTable.delegate = self
        self.saleTable.dataSource = self
        
        self.view.addSubview(saleTable)
        self.view.addSubview(generateSaleBtn)
        
        
        saleTable.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-1*PAD)
            make.top.left.equalTo(self.view).offset(PAD)
            make.height.equalTo(SCREEN_HEIGHT_SAFE * (9/10))
            make.width.equalTo(screen.width)
        }
        generateSaleBtn.snp.makeConstraints { (make) in
            make.height.equalTo(SCREEN_HEIGHT_SAFE * (1/10))
            make.top.equalTo(saleTable.snp.bottom).offset(PAD)
            make.left.equalTo(self.view).offset(PAD)
            make.right.equalTo(self.view).offset(-1*PAD)
        }
    }
    
    
    
    func getSalesForMonth(){
        let db = Firestore.firestore()
        let originalColor = self.generateSaleBtn.backgroundColor
        self.generateSaleBtn.backgroundColor = .lightGray
        var newSaleReport:[Sale] = []
        _ = db.collection("Sales")
        var oneMonthAgo = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        oneMonthAgo = Calendar.current.date(byAdding: .day, value: -30, to: oneMonthAgo!)
        
        let myGroup = DispatchGroup()
        print("GETTING SALES FOR MONTH...")
        db.collection("Sales").whereField("Timestamp", isGreaterThanOrEqualTo: oneMonthAgo).getDocuments { (snapshot, err) in
            if let err = err {
                print("ERROR \(err.localizedDescription)")
                self.generateSaleBtn.backgroundColor = originalColor
                self.generateSaleBtn.isUserInteractionEnabled = true
            }else{
                var newSale:Sale?
                for document in snapshot!.documents {
                    myGroup.enter()
                    newSale = Sale(id: document.documentID, dictionary: document.data())
                    print("Adding Sale: \(document.documentID)")
                    
                    db.collection("Sales").document(document.documentID).collection("Events").getDocuments(completion: { (snapshot, err) in
                        if let err = err {
                            print("ERROR \(err.localizedDescription)")
                            self.generateSaleBtn.backgroundColor = originalColor
                            
                            self.generateSaleBtn.isUserInteractionEnabled = true
                        }else{
                            
                            for document_ in snapshot!.documents {
                                
                                newSale?.events?.append(Event(id: document_.documentID, dictionary: document_.data()))
                                print("Adding Event to Sale: \(document.documentID)")

                                
                            }
                        }
                    })
                    
                    db.collection("Sales").document(document.documentID).collection("Sale Items").getDocuments(completion: { (snapshot, err) in
                        if let err = err {
                            print("ERROR \(err.localizedDescription)")
                            self.generateSaleBtn.backgroundColor = originalColor
                            
                            self.generateSaleBtn.isUserInteractionEnabled = true
                        }else{
                            
                            for document_ in snapshot!.documents{
                                newSale?.saleItems?.append(SaleItem(id: document_.documentID, dictionary: document_.data()))
                                print("Adding SaleItem to Sale: \(document.documentID)")

                                print("NEW ITEM + \((newSale?.saleItems?.last?.inventoryItemId!)!)")
                                db.collection("Items").document((newSale?.saleItems?.last?.inventoryItemId)!).getDocument(completion: { (snapshot, err) in
                                    if let err = err {
                                        print("ERROR \(err.localizedDescription)")
                                        self.generateSaleBtn.backgroundColor = originalColor
                                        
                                        self.generateSaleBtn.isUserInteractionEnabled = true
                                    }else{
                                        newSale?.saleItems?.last?.inventoryItem = InventoryItem(id: (snapshot?.documentID)!, dictionary: (snapshot?.data())!)
                                        print("Adding Inventory Item to Sale: \(snapshot?.documentID)")
                                        newSaleReport.append(newSale!)
                                    }
                                    
                                })
                            }
                        }
                    })
                    myGroup.leave()
                    newSaleReport.append(newSale!)
                }
                myGroup.notify(queue: .main) {
                    print("Finished all requests.")
                    self.generateSaleBtn.backgroundColor = originalColor
                    
                    self.generateSaleBtn.isUserInteractionEnabled = true
                    self.sales = newSaleReport
                    self.saleTable.reloadData()
                    print(newSaleReport.count)
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
