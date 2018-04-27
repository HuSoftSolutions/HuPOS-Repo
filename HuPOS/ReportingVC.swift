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

enum ReportCategory:Int {
    case cash_sale_total = 0, credit_sale_total = 1, cash_tax_total = 2, credit_tax_total = 3, total_tax = 4, total_sales = 5, total_tax_sales = 6
    
    var description : String {
        switch self {
        case .cash_sale_total: return "Cash Sale Total (Check & Gift)"
        case .credit_sale_total: return "Credit Sale Total"
        case .cash_tax_total: return "Cash Tax Total"
        case .credit_tax_total: return "Credit Tax Total"
        case .total_sales: return "Total Sales"
        case .total_tax: return "Total Tax (Cash & Credit)"
        case .total_tax_sales: return "Total Tax & Sales"
        }
    }
    
    var array:[ReportCategory]{
        var array:[ReportCategory] = []
        switch ReportCategory.cash_sale_total {
        case .cash_sale_total: array.append(.cash_sale_total); fallthrough
        case .cash_tax_total: array.append(.cash_tax_total); fallthrough
        case .credit_sale_total: array.append(.credit_sale_total); fallthrough
        case .credit_tax_total: array.append(.credit_tax_total); fallthrough
        case .total_sales: array.append(.total_sales); fallthrough
        case .total_tax: array.append(.total_tax); fallthrough
        case .total_tax_sales:array.append(.total_tax_sales);
        }
        return array
    }
}

class Report {

    var categories = ReportCategory.cash_tax_total.array
    var cash_sale_total:Double = 0.0
    var credit_sale_total:Double = 0.0
    var cash_tax_total:Double = 0.0
    var credit_tax_total:Double = 0.0
    
    
}

class ReportingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var report = Report()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "Report Cell")
        cell.textLabel?.text = report.categories[indexPath.row].description + ":"
        return cell
    }
    
    let startDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
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
        lbl.font = UIFont.systemFont(ofSize: 20)
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
        return tbl
    }()
    
    let generateReportBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Generate Report", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 75)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(generateReport), for: .touchUpInside)
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds

        setupViews(screen: screenSize)
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
        let GENERATE_REPORT_WIDTH = (screen.width - CGFloat(4*PAD)) * (7/10)
        let GENERATE_REPORT_HEIGHT = SCREEN_HEIGHT_SAFE * (1/10)
        _ = SCREEN_HEIGHT_SAFE * (8/10)
        let PICKER_WIDTH = (screen.width) * (3/10)
        let PICKER_HEIGHT = SCREEN_HEIGHT_SAFE / 2
        let REPORT_TABLE_HEIGHT = SCREEN_HEIGHT_SAFE * (7/10)
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
            make.left.equalTo(view).offset(PAD)
        }
        
        startDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(startDateLbl.snp.bottom)
            make.left.equalTo(view).offset(PAD)
            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        endDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker.snp.bottom)
            make.left.equalTo(view).offset(PAD)
        }
        endDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(endDateLbl.snp.bottom)
            make.left.equalTo(view).offset(PAD)

            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        
        reportTable.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker.snp.top)
            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(GENERATE_REPORT_WIDTH)
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
    @objc func generateReport(){
        
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
