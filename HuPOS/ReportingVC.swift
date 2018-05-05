//
//  ReportingVC.swift
//  HuPOS
//
//  Created by Cody Husek on 4/27/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

var REPORT_TABLE_HEIGHT:CGFloat = 0

enum ReportCategory:Int {
    case cash_sale_total = 0, credit_sale_total = 1, total_tax = 2, total_sales = 3, total_tax_sales = 4
    
    var description : String {
        switch self {
        case .cash_sale_total: return "Cash Sale Total (Check & Gift Included)"
        case .credit_sale_total: return "Credit Sale Total"
        case .total_sales: return "Total Sales (Without Tax)"
        case .total_tax: return "Total Tax"
        case .total_tax_sales: return "Total Sales & Tax"
        }
    }
    
    var array:[ReportCategory]{
        var array:[ReportCategory] = []
        switch ReportCategory.cash_sale_total {
        case .cash_sale_total: array.append(.cash_sale_total); fallthrough
        case .credit_sale_total: array.append(.credit_sale_total); fallthrough
        case .total_sales: array.append(.total_sales); fallthrough
        case .total_tax: array.append(.total_tax); fallthrough
        case .total_tax_sales:array.append(.total_tax_sales);
        }
        return array
    }
}

class Report: NSObject {

    override init(){
        cash_sale_total = 0.0
        credit_sale_total = 0.0
        tax_total = 0.0
        sale_total = 0.0
    }
    
    var categories = ReportCategory.cash_sale_total.array
    var cash_sale_total:Double?
    var credit_sale_total:Double?
    var tax_total:Double?
    var sale_total:Double?

}

class ReportingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var report = Report.init()

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return REPORT_TABLE_HEIGHT / CGFloat(Report().categories.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Report().categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Report Cell")
        cell.textLabel?.text = report.categories[indexPath.row].description + ":"
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none

        if (report.categories[indexPath.row] == .cash_sale_total) {
            cell.detailTextLabel?.text = report.cash_sale_total?.toCurrencyString()
        }else if(report.categories[indexPath.row] == .credit_sale_total){
            cell.detailTextLabel?.text = report.credit_sale_total?.toCurrencyString()
        }else if(report.categories[indexPath.row] == .total_sales){
            cell.detailTextLabel?.text = (report.credit_sale_total! + report.cash_sale_total!).toCurrencyString()
        }else if(report.categories[indexPath.row] == .total_tax){
            cell.detailTextLabel?.text = report.tax_total?.toCurrencyString()
        }else if(report.categories[indexPath.row] == .total_tax_sales){
            cell.detailTextLabel?.text = (report.sale_total!).toCurrencyString()
        }
        
        return cell
    }
    
    let startDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 35)
        lbl.textColor = UIColor.black
        lbl.text = "Start Date:"
        return lbl
    }()
    
    let startDatePicker:UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        picker.timeZone = NSTimeZone.local
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    let endDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 35)
        lbl.textColor = UIColor.black
        lbl.text = "End Date:"
        return lbl
    }()
    
    let endDatePicker:UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        picker.timeZone = NSTimeZone.local
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    let reportTable:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()
    
    let generateReportBtn:UIButton = {
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
        btn.addTarget(self, action: #selector(generateReport), for: .touchUpInside)
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds

        setupViews(screen: screenSize)
        self.generateReport()
        // Do any additional setup after loading the view.
    }

    func setupViews(screen:CGRect){
        let PAD:CGFloat = 25.0
        let NAVIGATIONBAR_HEIGHT = (navigationController?.navigationBar.layer.frame.height)!
        let TOOLBAR_HEIGHT = (navigationController?.toolbar.layer.frame.height)!

        _ = screen.width
        let SCREEN_HEIGHT = screen.height
        var SCREEN_HEIGHT_SAFE = SCREEN_HEIGHT - (startDateLbl.frame.height)*2
        SCREEN_HEIGHT_SAFE -= NAVIGATIONBAR_HEIGHT*2
        SCREEN_HEIGHT_SAFE -= TOOLBAR_HEIGHT
        SCREEN_HEIGHT_SAFE -= CGFloat(PAD)
        let GENERATE_REPORT_WIDTH = screen.width - 2*PAD//(screen.width - CGFloat(4*PAD)) * (7/10)
        let GENERATE_REPORT_HEIGHT = SCREEN_HEIGHT_SAFE * (2/10)
        _ = SCREEN_HEIGHT_SAFE * (8/10)
        let PICKER_WIDTH = (screen.width - 2*PAD) * (3/10)
        let PICKER_HEIGHT = SCREEN_HEIGHT_SAFE / 3
        let REPORT_TABLE_WIDTH = (screen.width - 2*PAD) * (7/10)
        REPORT_TABLE_HEIGHT = SCREEN_HEIGHT_SAFE * (8/10)
        startDatePicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        endDatePicker.date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!

        reportTable.delegate = self
        reportTable.dataSource = self
        
        view.addSubview(startDateLbl)
        view.addSubview(startDatePicker)
        view.addSubview(endDateLbl)
        view.addSubview(endDatePicker)
        view.addSubview(generateReportBtn)
        view.addSubview(reportTable)
        
        startDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(reportTable.snp.right).offset(PAD)
        }
        
        startDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(startDateLbl.snp.bottom)
            make.left.equalTo(reportTable.snp.right).offset(PAD)
            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        endDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker.snp.bottom)
            make.left.equalTo(reportTable.snp.right).offset(PAD)
        }
        endDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(endDateLbl.snp.bottom)
            make.left.equalTo(reportTable.snp.right).offset(PAD)
            
            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        
        reportTable.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(NAVIGATIONBAR_HEIGHT)
            make.left.equalTo(self.view)
//            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(REPORT_TABLE_WIDTH)
            make.height.equalTo(REPORT_TABLE_HEIGHT)
        }
        
        generateReportBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-1*NAVIGATIONBAR_HEIGHT - PAD)
            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(GENERATE_REPORT_WIDTH)
            make.height.equalTo(GENERATE_REPORT_HEIGHT)
        }
        
    }
    
    private func getReportData(){
        _ = Firestore.firestore()
        
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        
    }
    
    private func clearTable(){
        
    }
    
    private func clearReport(){
        self.report.cash_sale_total = 0.0
        self.report.credit_sale_total = 0.0
        self.report.tax_total = 0.0
        self.report.sale_total = 0.0
    }
    
    @objc func generateReport(){
        let newReport = Report()
      //  self.generateReportBtn.backgroundColor = UIColor.orange
        
        self.generateReportBtn.isUserInteractionEnabled = false
        let originalColor = self.generateReportBtn.backgroundColor
        self.generateReportBtn.backgroundColor = .lightGray
        //self.clearReport()

        //self.reportTable.reloadData()
        let myGroup = DispatchGroup()
        let db = Firestore.firestore()
        print("Start date: \(self.startDatePicker.date)\nEnd date: \(self.endDatePicker.date)")
        db.collection("Sales").whereField("Timestamp", isGreaterThanOrEqualTo: self.startDatePicker.date).whereField("Timestamp", isLessThanOrEqualTo: self.endDatePicker.date).getDocuments { (snapshot, err) in
            if let err = err {
                print("ERROR \(err.localizedDescription)")
                self.generateReportBtn.backgroundColor = originalColor

                self.generateReportBtn.isUserInteractionEnabled = true
            }else{
                
                for document in snapshot!.documents {
                    myGroup.enter()
                    var taxTotal = 0.0
                    var saleTotal = 0.0
                    taxTotal = (document["Tax Total"] as? Double)!
                    saleTotal = (document["Sale Total"] as? Double)!
                    newReport.tax_total! += taxTotal
                    newReport.sale_total! += saleTotal
                    
                    let myGroup2 = DispatchGroup()
                    
                    db.collection("Sales").document(document.documentID).collection("Events").getDocuments(completion: { (snapshot, err) in
                        if let err = err {
                            print("ERROR \(err.localizedDescription)")
                            self.generateReportBtn.backgroundColor = originalColor

                            self.generateReportBtn.isUserInteractionEnabled = true
                        }else{
                            var cashTotal = 0.0
                            var creditTotal = 0.0
                            for document in snapshot!.documents {
                                let eventCount:Double = Double(snapshot!.documents.count)
                                let type = document["Type"] as! String
                                let amount = document["Amount"] as! Double
                                print("Event type: \(type) Amt: \(amount.toCurrencyString())")
                                if(type.trimmingCharacters(in: .whitespaces) == "Cash" || type == "Gift" || type == "Check"){
                                    cashTotal += (amount - taxTotal/eventCount)
                                }else{
                                    creditTotal += (amount - taxTotal/eventCount)
                                }
                                
                            }
                            newReport.cash_sale_total! += cashTotal
                            newReport.credit_sale_total! += creditTotal
                        }
                        myGroup.leave()

                    })
                }
                myGroup.notify(queue: .main) {
                    print("Finished all requests.")
                    self.generateReportBtn.backgroundColor = originalColor

                    self.generateReportBtn.isUserInteractionEnabled = true
                    //self.clearReport()
                    self.report = newReport
                    self.reportTable.reloadData()

                }
                
            }
            
        }

        
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
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
