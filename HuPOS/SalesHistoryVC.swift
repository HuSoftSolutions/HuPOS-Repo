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
    
    var sales:[Sale] = []
    var startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    var endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
    var dateRange = DateRange.Day
    var rangeIndex = 0
    var selectedSaleIndex = 0
    let dateFormatter = DateFormatter()
    let dispatchGroup = DispatchGroup()
    let progressHUD = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(incrementRange), for: .touchUpInside)
        return btn
    }()
    
    let saleItemsTbl:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()
    let eventsTbl:UITableView = {
        let tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tbl.backgroundColor = .clear
        tbl.alwaysBounceVertical = false
        return tbl
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case saleTable:
            return self.sales.count
        case saleItemsTbl:
            if(self.sales.count == 0){
                return 0
            }else{
                return self.sales[selectedSaleIndex].saleItems!.count
            }
        case eventsTbl:
            if(self.sales.count == 0){
                return 0
            }else{
                return self.sales[selectedSaleIndex].events!.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case saleTable:
            return 100
        case saleItemsTbl:
            return 50
        case eventsTbl:
            return 50
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case saleTable:
            self.selectedSaleIndex = indexPath.row
            
            self.saleItemsTbl.reloadData()
            self.eventsTbl.reloadData()
        case saleItemsTbl:
            return
        case eventsTbl:
            return
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case eventsTbl:
            return "Sale Events"
        case saleItemsTbl:
            return "Sale Items"
        default:
            return ""
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
        case saleItemsTbl:
            let saleItemCell = UITableViewCell(style: .value1, reuseIdentifier: "saleItemCell")
            let saleItem:SaleItem = self.sales[self.selectedSaleIndex].saleItems![indexPath.row]
            if saleItem.inventoryItem != nil {
                saleItemCell.textLabel?.text = saleItem.inventoryItem!.title
            }else{
                saleItemCell.textLabel?.text = saleItem.inventoryItemId
            }
            saleItemCell.detailTextLabel?.text = saleItem.subtotal.toCurrencyString()
            saleItemCell.detailTextLabel?.textAlignment = .right
            if(indexPath.row % 2 == 0){
                saleItemCell.backgroundColor = UIColor.lightGray.lighter(by: 25)
            }
            return saleItemCell
        case eventsTbl:
            let eventCell = UITableViewCell(style: .value1, reuseIdentifier: "eventCell")
            let event:Event = self.sales[self.selectedSaleIndex].events![indexPath.row]
            eventCell.textLabel?.text = event.type!
            eventCell.detailTextLabel?.text = event.amount!.toCurrencyString()
            if(indexPath.row % 2 == 0){
                eventCell.backgroundColor = UIColor.lightGray.lighter(by: 25)
            }
            return eventCell
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
        _ = REPORT_TABLE_HEIGHT = SCREEN_HEIGHT_SAFE * (8/10)
        let RANGE_BTN_WIDTH = ((screen.width - 2*PAD) - 4*S_PAD) / 5
        let RANGE_BTN_HEIGHT = SCREEN_HEIGHT_SAFE * (1/10)
        let PICKER_HEIGHT = (REPORT_TABLE_HEIGHT - 4*PAD) / 2
        let DETAIL_TABLE_HEIGHT = (REPORT_TABLE_HEIGHT - 4*PAD) / 2
        
        self.saleTable.separatorStyle = .singleLine
        self.saleItemsTbl.separatorStyle = .none
        self.eventsTbl.separatorStyle = .none
        
        // Setup DateRange
        self.setDateRangeBtn(range: self.dateRange)
        
        
        
        self.saleTable.delegate = self
        self.saleTable.dataSource = self
        self.saleItemsTbl.delegate = self
        self.saleItemsTbl.dataSource = self
        self.eventsTbl.delegate = self
        self.eventsTbl.dataSource = self
        
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
        self.view.addSubview(saleItemsTbl)
        self.view.addSubview(eventsTbl)
        self.view.addSubview(progressHUD)
        progressHUD.center = self.view.center
        progressHUD.hidesWhenStopped = true
        
        
        generateSaleBtn.snp.makeConstraints { (make) in
            make.height.equalTo(GENERATE_REPORT_HEIGHT)
            make.bottom.equalTo(self.view).offset(-1*TOOLBAR_HEIGHT - PAD)
            make.left.equalTo(self.view).offset(PAD)
            make.right.equalTo(self.view).offset(-1*PAD)
        }
        
        decrementRangeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(saleTable)
            make.width.equalTo(RANGE_BTN_WIDTH/2)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byDayBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(decrementRangeBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byWeekBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(byDayBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        byMonthBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(byWeekBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
        }
        byYearBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(byMonthBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        incrementRangeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(byYearBtn.snp.right).offset(S_PAD)
            make.width.equalTo(RANGE_BTN_WIDTH/2)
            make.height.equalTo(RANGE_BTN_HEIGHT)
            
        }
        saleTable.snp.makeConstraints { (make) in
            make.top.equalTo(decrementRangeBtn.snp.bottom).offset(PAD)
            make.left.equalTo(self.view).offset(PAD)
            //make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            //            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(REPORT_TABLE_WIDTH)
            //make.height.equalTo(REPORT_TABLE_HEIGHT)
            make.bottom.equalTo(generateSaleBtn.snp.top).offset(-1*PAD)
        }
        
        
        
        startDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(startDatePicker)//.offset(PAD/2)
            //make.width.equalTo(PICKER_WIDTH)
            make.right.equalTo(startDatePicker).offset(-1*PAD/2)
            
        }
        
        startDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(incrementRangeBtn.snp.bottom).offset(PAD)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
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
            
            // make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        
        
        saleItemsTbl.snp.makeConstraints { (make) in
            make.top.equalTo(saleTable)
            make.left.equalTo(saleTable.snp.right).offset(PAD)
            make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            make.height.equalTo(DETAIL_TABLE_HEIGHT)
        }
        
        eventsTbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(generateSaleBtn.snp.top)
            make.left.equalTo(saleTable.snp.right).offset(PAD)
            make.right.equalTo(startDatePicker.snp.left).offset(-1*PAD)
            make.height.equalTo(DETAIL_TABLE_HEIGHT)
        }
        
    }
    
    func startFirebaseCalls(){
        
        getSaleHistoryForDateRange()
        self.dispatchGroup.notify(queue: .main){
            print("Finished adding \(self.sales.count) new sales")
            self.saleTable.reloadData()
            if(self.sales.count > 0){
                self.saleTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                self.getSaleEventsForDateRange()
                self.getSaleItemsForDateRange()
                self.dispatchGroup.notify(queue: .main){
                    print("Finished adding events")
                    print("Finished adding sale items")

                    self.eventsTbl.reloadData()
                    
                    self.getSaleItemInfoForDateRange()
                    self.dispatchGroup.notify(queue: .main){
                        
                        print("Finished getting all sale item info")
                        self.saleItemsTbl.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func getSaleItemInfoForDateRange(){
        self.setInteractionTo(state: false)
        let db = Firestore.firestore()
        
        for sale in self.sales {
            for saleItem in sale.saleItems! {
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
        self.setInteractionTo(state: false)
        let db = Firestore.firestore()
        
        for sale in self.sales {
            self.dispatchGroup.enter()
            db.collection("Sales").document(sale.id!).collection("Sale Items").getDocuments(completion: { (snapshot, err) in
                if let err = err {
                    print("ERROR \(err.localizedDescription)")
                    self.setInteractionTo(state: true)
                    self.dispatchGroup.leave()
                }else{
                    if(snapshot!.count > 0){
                        for document in snapshot!.documents {
                            print("Adding sale item to sale \(document.documentID)")
                            sale.saleItems?.append(SaleItem(id: document.documentID, dictionary: document.data()))
                        }
                    }
                }
                self.dispatchGroup.leave()
            })
        }
        self.setInteractionTo(state: true)
    }
    func getSaleEventsForDateRange(){
        self.setInteractionTo(state: false)
        let db = Firestore.firestore()
        
        for sale in self.sales {
            self.dispatchGroup.enter()
            db.collection("Sales").document(sale.id!).collection("Events").getDocuments(completion: { (snapshot, err) in
                if let err = err {
                    print("ERROR \(err.localizedDescription)")
                    self.setInteractionTo(state: true)
                    self.dispatchGroup.leave()
                }else{
                    if(snapshot!.count > 0){
                        for document in snapshot!.documents {
                            print("Adding event to sale \(document.documentID)")
                            sale.events?.append(Event(id: document.documentID, dictionary: document.data()))
                        }
                    }
                }
                self.dispatchGroup.leave()
            })
        }
        self.setInteractionTo(state: true)
    }
    
    
    func getSaleHistoryForDateRange(){
        self.sales.removeAll()
        self.saleTable.reloadData()
        self.setInteractionTo(state: false)
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
                        self.sales.append(Sale(id: document.documentID, dictionary: document.data()))
                        
                    }
                }
            }
            self.dispatchGroup.leave()
        }
        self.setInteractionTo(state: true)
    }
    
    
    //    func getSalesForMonth(){
    //        let db = Firestore.firestore()
    //        let originalColor = self.generateSaleBtn.backgroundColor
    //        var newSaleReport:[Sale] = []
    //        _ = db.collection("Sales")
    //        setInteractionTo(state: false)
    //        self.generateSaleBtn.backgroundColor = .lightGray
    //
    //        let myGroup = DispatchGroup()
    //        print("GETTING SALES FOR MONTH...")
    //        db.collection("Sales").whereField("Timestamp", isGreaterThanOrEqualTo: self.startDatePicker.date).whereField("Timestamp", isLessThanOrEqualTo: self.endDatePicker.date).order(by: "Timestamp", descending: true).getDocuments { (snapshot, err) in
    //
    //            if let err = err {
    //                print("ERROR \(err.localizedDescription)")
    //                self.generateSaleBtn.backgroundColor = originalColor
    //                self.setInteractionTo(state: true)
    //
    //            }else{
    //                if(snapshot!.documents.count > 0){
    //                    for document in snapshot!.documents {
    //                        myGroup.enter()
    //                        let newSale = Sale(id: document.documentID, dictionary: document.data());                         print("Adding Sale: \(document.documentID)")
    //
    //                        db.collection("Sales").document(document.documentID).collection("Events").getDocuments(completion: { (snapshot, err) in
    //                            if let err = err {
    //                                print("ERROR \(err.localizedDescription)")
    //                                self.generateSaleBtn.backgroundColor = originalColor
    //
    //                                self.setInteractionTo(state: true)
    //
    //                            }else{
    //
    //                                for document_ in snapshot!.documents {
    //
    //                                    newSale.events!.append(Event(id: document_.documentID, dictionary: document_.data()))
    //                                    print("Adding Event to Sale: \(document.documentID)")
    //                                }
    //                            }
    //                        })
    //                        myGroup.leave()
    //                        newSaleReport.append(newSale)
    //                    }
    //                    myGroup.notify(queue: .main) {
    //
    //                        print("Finished all requests.")
    //                        //                    self.generateSaleBtn.backgroundColor = originalColor
    //                        //
    //                        //                    self.generateSaleBtn.isUserInteractionEnabled = true
    //
    //                        let myGroup2 = DispatchGroup()
    //                        for sale in newSaleReport {
    //                            db.collection("Sales").document(sale.id!).collection("Sale Items").getDocuments(completion: { (snapshot, err) in
    //                                if let err = err {
    //                                    print("ERROR \(err.localizedDescription)")
    //                                    self.generateSaleBtn.backgroundColor = originalColor
    //                                    self.setInteractionTo(state: true)
    //
    //                                }else{
    //
    //                                    for document_ in snapshot!.documents{
    //                                        myGroup2.enter()
    //                                        sale.saleItems?.append(SaleItem(id: document_.documentID, dictionary: document_.data()))
    //                                        print("Adding SaleItem to Sale: \(sale.id!)")
    //
    //                                        print("NEW ITEM + \((sale.saleItems!.last!.inventoryItemId!))")
    //                                        db.collection("Items").document((sale.saleItems!.last!.inventoryItemId!)).getDocument(completion: { (snapshot, err) in
    //                                            if let err = err {
    //                                                print("ERROR \(err.localizedDescription)")
    //                                                self.generateSaleBtn.backgroundColor = originalColor
    //                                                self.setInteractionTo(state: true)
    //
    //                                            }else{
    //                                                print(snapshot!.data()!)
    //                                                sale.saleItems?.last?.inventoryItem = InventoryItem(id: (snapshot!.documentID), dictionary: (snapshot!.data())!)
    //                                                print("Adding Inventory Item to Sale: \(snapshot!.documentID)")
    //                                                // newSaleReport.append(newSale)
    //                                            }
    //                                            myGroup2.leave()
    //                                        })
    //                                    }
    //                                    myGroup2.notify(queue: .main){
    //                                        self.setInteractionTo(state: true)
    //                                        self.generateSaleBtn.backgroundColor = originalColor
    //                                        self.sales = newSaleReport
    //                                        self.saleTable.reloadData()
    //                                        self.saleItemsTbl.reloadData()
    //                                        self.eventsTbl.reloadData()
    //                                    }
    //                                }
    //                            })
    //                        }
    //                    }
    //                }else{
    //                    self.setInteractionTo(state: true)
    //                    self.generateSaleBtn.backgroundColor = originalColor
    //                    self.sales = newSaleReport
    //                    self.saleTable.reloadData()
    //                    self.saleItemsTbl.reloadData()
    //                    self.eventsTbl.reloadData()
    //                }
    //            }
    //        }
    //    }
    
    func setInteractionTo(state:Bool){
        self.generateSaleBtn.isUserInteractionEnabled = state
        self.decrementRangeBtn.isUserInteractionEnabled = state
        self.incrementRangeBtn.isUserInteractionEnabled = state
        self.byDayBtn.isUserInteractionEnabled = state
        self.byWeekBtn.isUserInteractionEnabled = state
        self.byMonthBtn.isUserInteractionEnabled = state
        self.byYearBtn.isUserInteractionEnabled = state
        if(state){
            self.progressHUD.startAnimating()
        }else{
            self.progressHUD.stopAnimating()
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
