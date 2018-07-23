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

// SALE_TABLE_HEIGHT:CGFloat = 0.0 //(REPORT_TABLE_HEIGHT - 4*PAD) / 2
var REPORT_TABLE_HEIGHT:CGFloat = 0.0
enum ReportCategory:Int {
    case cash_sale_total = 0, credit_sale_total = 1, total_tax = 2, total_sales = 3, total_tax_sales = 4

    var description : String {
        switch self {
        case .cash_sale_total: return "Cash"
        case .credit_sale_total: return "Credit"
        case .total_sales: return "Total Sales"
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
enum DateRange:Int {
    case Day = 0, Week = 1, Month = 2, Year = 3
    
    var description : String {
        switch self {
        case .Day: return "Day"
        case .Week: return "Week"
        case .Month: return "Month"
        case .Year: return "Year"
        }
    }}

class SaleCell: UITableViewCell {
    let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.text = "Sale ID:"
        return lbl
    }()
    
    let title:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "ID"
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        lbl.lineBreakMode = .byCharWrapping
        lbl.baselineAdjustment = .alignCenters
        return lbl
    }()
    let taxLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.black
        lbl.text = "Tax:"
        return lbl
    }()
    let taxTotal:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Tax Total"
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        lbl.lineBreakMode = .byCharWrapping
        lbl.baselineAdjustment = .alignCenters
        return lbl
    }()
    let saleTotalLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.green
        lbl.text = "Sale Total:"
        return lbl
    }()
    let saleTotal:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Sale Total"
        lbl.textColor = UIColor.green.darker(by: 20)
        lbl.font = UIFont.systemFont(ofSize: 25)
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
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont.systemFont(ofSize: 18)
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
        lbl.textColor = UIColor.blue
        lbl.font = UIFont.systemFont(ofSize: 18)
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
        let PAD = 10.0
        //self.addSubview(titleLbl)
        self.addSubview(title)
        //self.addSubview(saleTotalLbl)
        self.addSubview(saleTotal)
        self.addSubview(timestamp)
        self.addSubview(employee)
        
        
        //        self.addSubview(taxLbl)
        //        self.addSubview(taxTotal)
        
        //        titleLbl.snp.makeConstraints { (make) in
        //            make.top.equalTo(self).offset(PAD/2.0)
        //        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(PAD)
            make.left.equalTo(self).offset(PAD)
            //make.width.equalTo(self.bounds.width/2)
            // make.height.equalTo(self.bounds.height/2)
        }
        
        saleTotal.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(PAD)
            make.right.bottom.equalTo(self).offset(-1*PAD)
            
        }
        //        saleTotalLbl.snp.makeConstraints { (make) in
        //            make.right.bottom.equalTo(saleTotal).offset(-1*PAD)
        //        }
        
        //        taxTotal.snp.makeConstraints { (make) in
        //            make.top.equalTo(taxLbl.snp.bottom).offset(PAD)
        //            make.right.equalTo(self).offset(-1*PAD)
        //        }
        //        taxLbl.snp.makeConstraints { (make) in
        //            make.top.equalTo(self).offset(PAD)
        //            make.right.equalTo(taxTotal.snp.left)
        //        }
        
        
        timestamp.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-1*PAD)
            //make.right.equalTo(self).offset(-1*PAD)
            make.left.equalTo(self).offset(PAD)
        }
        employee.snp.makeConstraints { (make) in
            make.bottom.equalTo(timestamp.snp.top)//.offset(-1*PAD)
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
        self.backgroundColor = .white
    }
}







class SalesHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var report = Report.init()
    var newReport = Report.init()

    var sales:[Sale] = []
    var startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    var endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
    var dateRange = DateRange.Day
    var rangeIndex = 0
    var selectedSaleIndex = 0
    let dateFormatter = DateFormatter()
    let dispatchGroup = DispatchGroup()
    let progressHUD = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var saleTableSpinner = UIView()
    var saleItemTableSpinner = UIView()
    var reportTableSpinner = UIView()
    var reportViewSpinner = UIView()
    var report = Report.init()

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
        btn.setTitle("Get Sales", for: .normal)
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
    
    let startDateLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.darkGray.darker(by: 20)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        lbl.text = "Start Date"
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
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = UIColor.white
        lbl.text = "End Date"
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = UIColor.darkGray.darker(by: 20)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let endDatePicker:UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        picker.timeZone = NSTimeZone.local
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    let byDayBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Day", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(setRangeType), for: .touchUpInside)
        return btn
    }()
    let byWeekBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Week", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(setRangeType), for: .touchUpInside)
        return btn
    }()
    
    let byMonthBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Month", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(setRangeType), for: .touchUpInside)
        return btn
    }()
    
    let byYearBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Year", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(setRangeType), for: .touchUpInside)
        return btn
    }()
    
    let decrementRangeBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(decrementRange), for: .touchUpInside)
        return btn
    }()
    
    let incrementRangeBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle(">", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(incrementRange), for: .touchUpInside)
        return btn
    }()
    
    let saleDetailTable:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()
    
    let reportTable:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()

    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case self.saleTable:
            return 1
        case self.saleDetailTable:
            return 2
        default:
            return 1

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case saleTable:
            return self.sales.count
        case saleDetailTable:
            if(self.sales.count > 0){
                switch section {
                case 0:
                    return self.sales[selectedSaleIndex].saleItems.count
                case 1:
                    return self.sales[selectedSaleIndex].events.count
                default:
                    return 0
                }
            }else { return 0 }
        case reportTable:
            return Report().categories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case saleTable:
            return 100
        case saleDetailTable:
            return 50
        case reportTable:
            return CGFloat((REPORT_TABLE_HEIGHT - 30) / CGFloat(Report().categories.count))
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case saleTable:
            self.selectedSaleIndex = indexPath.row
            
            self.saleDetailTable.reloadData()
        case saleDetailTable:
            return

        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case saleTable:
            return "Sales History"
        case saleDetailTable:
            switch section {
            case 0:
                return "Sale Items"
            case 1:
                return "Sale Events"
            default:
                return "Error"
            }
        case reportTable:
            return "Report"
        default:
            return "Error"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(dateFormatter.stringFromDate(date)) // Jan 2, 2001
        switch tableView {
        case saleTable:
            
            let saleCell = SaleCell()
            saleCell.selectionStyle = .default
            saleCell.title.text = self.sales[indexPath.row].id!
            saleCell.employee.text = self.sales[indexPath.row].employeeId
            saleCell.saleTotal.text = self.sales[indexPath.row].saleTotal?.toCurrencyString()
            saleCell.taxTotal.text = self.sales[indexPath.row].taxTotal?.toCurrencyString()
            saleCell.timestamp.text = (dateFormatter.string(from: (self.sales[indexPath.row].timestamp)!))
            
            if(self.sales[indexPath.row].saleTotal! < 0.0){
                saleCell.saleTotal.textColor = UIColor.blue.darker(by: 10)
            }
            
            return saleCell
        case saleDetailTable:
            
            switch indexPath.section {
            case 0:
                let saleItemCell = UITableViewCell(style: .value1, reuseIdentifier: "saleItemCell")
                let saleItem:SaleItem = self.sales[self.selectedSaleIndex].saleItems[indexPath.row]
                if saleItem.inventoryItem != nil {
                    saleItemCell.textLabel?.text = saleItem.inventoryItem!.title
                }else{
                    saleItemCell.textLabel?.text = saleItem.inventoryItemId
                }
                saleItemCell.detailTextLabel?.text = saleItem.subtotal.toCurrencyString()
                saleItemCell.detailTextLabel?.textAlignment = .right

                return saleItemCell
            case 1:
                let eventCell = UITableViewCell(style: .value1, reuseIdentifier: "eventCell")
                let event:Event = self.sales[self.selectedSaleIndex].events[indexPath.row]
                eventCell.textLabel?.text = event.type!
                eventCell.detailTextLabel?.text = event.amount!.toCurrencyString()

                return eventCell

            default:
                return UITableViewCell()
            }
            
            
        case reportTable:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Report Cell")
            cell.textLabel?.text = report.categories[indexPath.row].description + ":"
            cell.textLabel?.textColor = .black
            //cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.numberOfLines = 2
            //cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.selectionStyle = .none
            
            if (report.categories[indexPath.row] == .cash_sale_total) {
                cell.detailTextLabel?.text = self.newReport.cash_sale_total?.toCurrencyString()
            }else if(report.categories[indexPath.row] == .credit_sale_total){
                cell.detailTextLabel?.text = self.newReport.credit_sale_total?.toCurrencyString()
            }else if(report.categories[indexPath.row] == .total_sales){
                cell.detailTextLabel?.text = (self.newReport.credit_sale_total! + self.newReport.cash_sale_total!).toCurrencyString()
            }else if(report.categories[indexPath.row] == .total_tax){
                cell.detailTextLabel?.text = self.newReport.tax_total?.toCurrencyString()
            }else if(report.categories[indexPath.row] == .total_tax_sales){
                cell.detailTextLabel?.text = (self.newReport.sale_total!).toCurrencyString()
            }
            
            return cell
        default:
            let saleItemCell = UITableViewCell(style: .value1, reuseIdentifier: "saleItemCell")
            
            return saleItemCell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.getSalesForMonth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        setup(screen: screenSize)
        // Do any additional setup after loading the view.
    }
    
    @objc func loadSales(){
        self.startFirebaseCalls()
        //self.getSalesForMonth()
        
    }
    
    @objc func setRangeType(_ sender: UIButton){
        print(sender.titleLabel!.text!)
        // self.rangeIndex = 0
        switch sender.titleLabel!.text! {
        case DateRange.Day.description:
            self.dateRange = .Day
        case DateRange.Week.description:
            self.dateRange = .Week
        case DateRange.Month.description:
            self.dateRange = .Month
        case DateRange.Year.description:
            self.dateRange = .Year
        default:
            return
        }
        self.setDateRangeBtn(range: self.dateRange)
    }
    
    @objc func decrementRange(){
        self.rangeIndex -= 1
        self.setDateRangeBtn(range: self.dateRange)
        
        
    }
    
    @objc func incrementRange(){
        self.rangeIndex += 1
        self.setDateRangeBtn(range: self.dateRange)
        
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
    }
    
    func setDateRangeBtn(range:DateRange) {
        
        self.byDayBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        self.byWeekBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        self.byMonthBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        self.byYearBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        
        //            startDate = Calendar.current.date(byAdding: .day, value: 0, to: startDate!)
        
        
        startDate = Date()
        endDate = Date()
        
        switch range.rawValue {
        case 0:
            self.byDayBtn.backgroundColor = .lightGray
            startDate = Calendar.current.date(byAdding: .day, value: rangeIndex, to: startDate!)
            endDate = Calendar.current.date(byAdding: .day, value: rangeIndex, to: endDate!)
        case 1:
            self.byWeekBtn.backgroundColor = .lightGray
            startDate = Calendar.current.date(byAdding: .weekOfMonth, value: rangeIndex, to: (startDate?.startOfWeek)!)
            endDate = Calendar.current.date(byAdding: .weekOfMonth, value: rangeIndex, to: (endDate?.endOfWeek)!)
        case 2:
            self.byMonthBtn.backgroundColor = .lightGray
            startDate = Calendar.current.date(byAdding: .month, value: rangeIndex, to: (startDate?.startOfMonth)!)
            endDate = Calendar.current.date(byAdding: .month, value: rangeIndex, to: (endDate?.endOfMonth)!)
            
        case 3:
            self.byYearBtn.backgroundColor = .lightGray
            startDate = Calendar.current.date(byAdding: .year, value: rangeIndex, to: (startDate?.startOfYear)!)
            endDate = Calendar.current.date(byAdding: .year, value: rangeIndex, to: (endDate?.endOfYear)!)
        default:
            return
        }
        
        startDatePicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate!)!
        endDatePicker.date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate!)!
        
        self.startFirebaseCalls()
        //self.getSalesForMonth()
    }
    
    func setup(screen:CGRect){
        let PAD:CGFloat = 15.0
        let S_PAD:CGFloat = 2
        let NAVIGATIONBAR_HEIGHT = (navigationController?.navigationBar.layer.frame.height)!
        let TOOLBAR_HEIGHT = (navigationController?.toolbar.layer.frame.height)!
        var SCREEN_HEIGHT_SAFE = screen.height
        SCREEN_HEIGHT_SAFE -= NAVIGATIONBAR_HEIGHT
        SCREEN_HEIGHT_SAFE -= TOOLBAR_HEIGHT
        SCREEN_HEIGHT_SAFE -= CGFloat(3*PAD)
        _ = screen.width - 2*PAD//(screen.width - CGFloat(4*PAD)) * (7/10)
        let GENERATE_REPORT_HEIGHT = SCREEN_HEIGHT_SAFE * (1/10)
        _ = SCREEN_HEIGHT_SAFE * (8/10)
        let PICKER_WIDTH = self.startDatePicker.frame.width//(screen.width - 2*PAD) * (3/10)
        let REPORT_TABLE_WIDTH = (screen.width - 2*PAD) * (3/10)
        _ = (PICKER_WIDTH / 2) - 2*PAD
        let RANGE_BTN_WIDTH = ((screen.width - 2*PAD) - 4*S_PAD) / 5
        let RANGE_BTN_HEIGHT = TOOLBAR_HEIGHT//SCREEN_HEIGHT_SAFE * (1/10)
        var SALE_TABLE_HEIGHT = SCREEN_HEIGHT_SAFE - RANGE_BTN_HEIGHT - 3*PAD - GENERATE_REPORT_HEIGHT

        let PICKER_HEIGHT = (SALE_TABLE_HEIGHT - 4*PAD) / 2
        
        
        REPORT_TABLE_HEIGHT = SALE_TABLE_HEIGHT * (1/2) - PAD
        
        self.saleTable.separatorStyle = .singleLine
        self.saleDetailTable.separatorStyle = .singleLine
        self.saleDetailTable.allowsSelection = false
        // Setup DateRange
        self.setDateRangeBtn(range: self.dateRange)
        
        
        
        self.saleTable.delegate = self
        self.saleTable.dataSource = self
        self.saleDetailTable.delegate = self
        self.saleDetailTable.dataSource = self
        self.reportTable.delegate = self
        self.reportTable.dataSource = self

        
        self.view.addSubview(saleTable)
        self.view.addSubview(generateSaleBtn)
        self.view.addSubview(startDateLbl)
        self.view.addSubview(startDatePicker)
        self.view.addSubview(endDateLbl)
        self.view.addSubview(endDatePicker)
        self.view.addSubview(byDayBtn)
        self.view.addSubview(byWeekBtn)
        self.view.addSubview(byMonthBtn)
        self.view.addSubview(byYearBtn)
        self.view.addSubview(decrementRangeBtn)
        self.view.addSubview(incrementRangeBtn)
        self.view.addSubview(saleDetailTable)
        self.view.addSubview(reportTable)
        //self.view.addSubview(progressHUD)
        

        
        
        generateSaleBtn.snp.makeConstraints { (make) in
            make.height.equalTo(GENERATE_REPORT_HEIGHT)
            make.bottom.equalTo(self.view).offset(-1*TOOLBAR_HEIGHT - PAD)
            make.left.equalTo(self.view).offset(PAD)
            make.right.equalTo(self.view).offset(-1*PAD)
        }
        
        decrementRangeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(saleTable)
            make.width.equalTo(RANGE_BTN_WIDTH/2)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byDayBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(decrementRangeBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byWeekBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(byDayBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byMonthBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(byWeekBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
        }
        byYearBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(byMonthBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        incrementRangeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT/2)
            make.left.equalTo(byYearBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH/2)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }

        
        startDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(startDatePicker)//.offset(PAD/2)
            //make.width.equalTo(PICKER_WIDTH)
            make.right.equalTo(startDatePicker).offset(-1*PAD/2)
            
        }
        
        startDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(decrementRangeBtn.snp.bottom).offset(PAD)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            //make.left.equalTo(saleTable.snp.right).offset(PAD/2)
            //make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
            make.right.equalTo(view).offset(-1*PAD)
        }
        endDateLbl.snp.makeConstraints { (make) in
            //make.width.equalTo(PICKER_WIDTH)
            make.top.equalTo(startDatePicker.snp.bottom)
            make.left.equalTo(endDatePicker).offset(PAD/2)
            make.right.equalTo(endDatePicker).offset(-1*PAD/2)
        }
        endDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker.snp.bottom)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            //make.left.equalTo(endDateLbl)//.offset(PAD/2)
            make.right.equalTo(view).offset(-1*PAD)
            
             //make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        
        
        // sale history
        saleTable.snp.makeConstraints { (make) in
            make.top.equalTo(decrementRangeBtn.snp.bottom).offset(PAD)
            make.left.equalTo(self.view).offset(PAD)
            //make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            //            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(REPORT_TABLE_WIDTH)
            make.height.equalTo(SALE_TABLE_HEIGHT / 2)
            //make.bottom.equalTo(generateSaleBtn.snp.top).offset(-1*PAD)
        }
        
        saleDetailTable.snp.makeConstraints { (make) in
            make.top.equalTo(saleTable.snp.bottom)
            make.left.equalTo(saleTable.snp.right)
            make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            make.height.equalTo(REPORT_TABLE_HEIGHT)
        }
        reportTable.snp.makeConstraints { (make) in
            make.top.equalTo(saleTable.snp.bottom).offset(PAD)
            make.left.equalTo(saleTable).offset(PAD)
            make.width.equalTo(REPORT_TABLE_WIDTH)
            //make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            make.height.equalTo(REPORT_TABLE_HEIGHT)
        }

        
    }
    
    func startFirebaseCalls(){
        saleTableSpinner = UIViewController.displaySpinner(onView: self.saleTable)
        saleItemTableSpinner = UIViewController.displaySpinner(onView: self.saleDetailTable)
        reportTableSpinner = UIViewController.displaySpinner(onView: self.reportTable)

        self.setInteractionTo(state: false)
        getSaleHistoryForDateRange()
        self.dispatchGroup.notify(queue: .main){
            print("Finished adding \(self.sales.count) new sales")
            UIViewController.removeSpinner(spinner: self.saleTableSpinner)
            self.saleTable.reloadData()
            
            if(self.sales.count > 0){
                self.saleTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                self.getSaleEventsForDateRange()
                self.getSaleItemsForDateRange()
                self.dispatchGroup.notify(queue: .main){
                    print("Finished adding events")
                    print("Finished adding sale items")
                    print("Finished calculating report totals")
                    
                    self.reportTable.reloadData()
                    UIViewController.removeSpinner(spinner: self.reportTableSpinner)

                    
                    self.getSaleItemInfoForDateRange()
                    self.dispatchGroup.notify(queue: .main){
                        
                        print("Finished getting all sale item info")
                        
                        
                        self.saleDetailTable.reloadData()
                        UIViewController.removeSpinner(spinner: self.saleItemTableSpinner)
                        
                        self.setInteractionTo(state: true)
                    }
                    
                }
            }else{
                if(self.saleItemTableSpinner != nil){
                    UIViewController.removeSpinner(spinner: self.saleItemTableSpinner)
                }
                if(self.reportTableSpinner != nil){
                    UIViewController.removeSpinner(spinner: self.reportTableSpinner)
                }
            }
            self.setInteractionTo(state: true)
            
        }
    }
    
    func getReportTotals(){
        
    }
    
    func getSaleItemInfoForDateRange(){
        let db = Firestore.firestore()
        
        for sale in self.sales {
            for saleItem in sale.saleItems {
                self.dispatchGroup.enter()
                db.collection("Items").document(saleItem.inventoryItemId!).getDocument(completion: { (snapshot, err) in
                    if let err = err {
                        print("ERROR \(err.localizedDescription)")
                        self.setInteractionTo(state: true)
                        self.dispatchGroup.leave()
                    }else{
                        if(snapshot!.exists){
                            print("Adding sale item information to sale \(sale.id!)")

                            saleItem.inventoryItem = InventoryItem(id: snapshot!.documentID, dictionary: snapshot!.data()!)
                        }else{
                            print("ERROR: Inventory Item \(saleItem.inventoryItemId!) may no longer exist")

                        }
                    }
                    self.dispatchGroup.leave()
                })
            }
        }
        self.setInteractionTo(state: true)
    }
    
    func getSaleItemsForDateRange(){
        let db = Firestore.firestore()
        
        for sale in self.sales {
            self.dispatchGroup.enter()
            db.collection("Sales").document(sale.id!).collection("Sale Items").getDocuments(completion: { (snapshot, err) in
                if let err = err {
                    print("ERROR \(err.localizedDescription)")
                    self.dispatchGroup.leave()
                }else{
                    if(snapshot!.count > 0){
                        for document in snapshot!.documents {
                            print("Adding sale item to sale \(document.documentID)")
                            sale.saleItems.append(SaleItem(id: document.documentID, dictionary: document.data()))
                        }
                    }
                }
                self.dispatchGroup.leave()
            })
        }
    }
    func getSaleEventsForDateRange(){
        let db = Firestore.firestore()
        
        for sale in self.sales {
            self.dispatchGroup.enter()
            db.collection("Sales").document(sale.id!).collection("Events").getDocuments(completion: { (snapshot, err) in
                if let err = err {
                    print("ERROR \(err.localizedDescription)")
                    self.dispatchGroup.leave()
                }else{
                    var cashTotal = 0.0
                    var creditTotal = 0.0
                    //if(snapshot!.count > 0){
                        for document in snapshot!.documents {
                            let eventCount:Double = Double(snapshot!.documents.count)
                            let type = document["Type"] as! String
                            let amount = document["Amount"] as! Double
                            print("Event type: \(type) Amt: \(amount.toCurrencyString())")
                            if(type.trimmingCharacters(in: .whitespaces) == "Cash" || type == "Gift" || type == "Check"){
                                cashTotal += (amount - sale.taxTotal!/eventCount)
                            }else{
                                creditTotal += (amount - sale.taxTotal!/eventCount)
                            }
                            sale.events.append(Event(id: document.documentID, dictionary: document.data()))
                            
                        }
                        self.newReport.cash_sale_total! += cashTotal
                        self.newReport.credit_sale_total! += creditTotal
                        
                        
                   // }
                }
                self.dispatchGroup.leave()
            })
        }
    }
    
    
    func getSaleHistoryForDateRange(){
        self.newReport = Report()
        self.reportTable.reloadData()
        self.sales.removeAll()
        self.saleTable.reloadData()
        self.saleDetailTable.reloadData()
        self.selectedSaleIndex = 0
        let db = Firestore.firestore()
        self.dispatchGroup.enter()
        db.collection("Sales").whereField("Timestamp", isGreaterThanOrEqualTo: self.startDatePicker.date).whereField("Timestamp", isLessThanOrEqualTo: self.endDatePicker.date).order(by: "Timestamp", descending: true).getDocuments { (snapshot, err) in
            
            if let err = err {
                print("ERROR \(err.localizedDescription)")
                self.setInteractionTo(state: true)
                self.dispatchGroup.leave()
            }else{
                if(snapshot!.documents.count > 0){
                    for document in snapshot!.documents {
                        print("Adding snapshot document \(document.documentID)")
                        var taxTotal = 0.0
                        var saleTotal = 0.0
                        taxTotal = (document["Tax Total"] as? Double)!
                        saleTotal = (document["Sale Total"] as? Double)!
                        self.newReport.tax_total! += taxTotal
                        self.newReport.sale_total! += saleTotal
                        self.sales.append(Sale(id: document.documentID, dictionary: document.data()))
                        
                    }
                }
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    
    func setInteractionTo(state:Bool){
        self.generateSaleBtn.isUserInteractionEnabled = state
        self.decrementRangeBtn.isUserInteractionEnabled = state
        self.incrementRangeBtn.isUserInteractionEnabled = state
        self.byDayBtn.isUserInteractionEnabled = state
        self.byWeekBtn.isUserInteractionEnabled = state
        self.byMonthBtn.isUserInteractionEnabled = state
        self.byYearBtn.isUserInteractionEnabled = state
//        if(state){
//            self.progressHUD.startAnimating()
//        }else{
//            self.progressHUD.stopAnimating()
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var startOfMonth: Date? {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        return calendar.date(from: components)!
    }
    
    var startOfYear: Date? {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        components.setValue(1, for: .month)
        return calendar.date(from: components)!
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var endOfMonth: Date? {
        let calendar = Calendar.current
        let components = DateComponents(day:1)
        let startOfNextMonth = calendar.nextDate(after:Date(), matching: components, matchingPolicy: .nextTime)!
        return calendar.date(byAdding:.day, value: -1, to: startOfNextMonth)!
    }
    
    var endOfYear: Date? {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        components.setValue(1, for: .month)
        let firstDayThisYear = calendar.date(from: components)!
        let firstDayNextYear = calendar.date(byAdding: .year, value: 1, to: firstDayThisYear)!
        let lastDayThisYear = calendar.date(byAdding: .day, value: -1, to: firstDayNextYear)!
        return lastDayThisYear
    }
}
