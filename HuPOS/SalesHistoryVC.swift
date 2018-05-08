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
    let dateFormatter = DateFormatter()
    
    
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sales.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(dateFormatter.stringFromDate(date)) // Jan 2, 2001
        
        let saleCell = SaleCell()
        saleCell.selectionStyle = .none
        saleCell.title.text = self.sales[indexPath.row].id!
        saleCell.employee.text = self.sales[indexPath.row].employeeId
        saleCell.saleTotal.text = self.sales[indexPath.row].saleTotal?.toCurrencyString()
        saleCell.taxTotal.text = self.sales[indexPath.row].taxTotal?.toCurrencyString()
        saleCell.timestamp.text = (dateFormatter.string(from: (self.sales[indexPath.row].timestamp)!))
        
        if(indexPath.row % 2 == 1){
            saleCell.backgroundColor = UIColor.lightGray.lighter(by: 25)
        }
        
        if(self.sales[indexPath.row].saleTotal! < 0.0){
            saleCell.saleTotal.textColor = UIColor.blue.darker(by: 10)
        }
        
        return saleCell
        
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
        self.getSalesForMonth()
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
        self.setDateRangeBtn(range: self.dateRange)
        self.rangeIndex += 1
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
        
        self.getSalesForMonth()
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
        let PICKER_WIDTH = (screen.width - 2*PAD) * (3/10)
        let REPORT_TABLE_WIDTH = (screen.width - 2*PAD) * (3/10)
        _ = (PICKER_WIDTH / 2) - 2*PAD
        _ = REPORT_TABLE_HEIGHT = SCREEN_HEIGHT_SAFE * (8/10)
        let RANGE_BTN_WIDTH = ((screen.width - 2*PAD) - 4*S_PAD) / 5
        let RANGE_BTN_HEIGHT = SCREEN_HEIGHT_SAFE * (1/10)
        let PICKER_HEIGHT = (REPORT_TABLE_HEIGHT - 4*PAD) / 2

        self.saleTable.separatorStyle = .none

        
        // Setup DateRange
        self.setDateRangeBtn(range: self.dateRange)


        
        self.saleTable.delegate = self
        self.saleTable.dataSource = self
        
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
            //            make.right.equalTo(view).offset(-1*PAD)
            make.width.equalTo(REPORT_TABLE_WIDTH)
            //make.height.equalTo(REPORT_TABLE_HEIGHT)
            make.bottom.equalTo(generateSaleBtn.snp.top).offset(-1*PAD)
        }
        
     
        
        startDateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            make.left.equalTo(startDatePicker)//.offset(PAD/2)
            make.width.equalTo(PICKER_WIDTH)
            
        }
        
        startDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(incrementRangeBtn.snp.bottom).offset(PAD)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
           //make.left.equalTo(saleTable.snp.right).offset(PAD/2)
            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
            make.right.equalTo(view).offset(-1*PAD)
        }
        endDateLbl.snp.makeConstraints { (make) in
            make.width.equalTo(PICKER_WIDTH)
            make.top.equalTo(startDatePicker.snp.bottom)
            make.left.equalTo(endDatePicker).offset(PAD/2)
        }
        endDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(startDatePicker.snp.bottom)//.offset(NAVIGATIONBAR_HEIGHT + TOOLBAR_HEIGHT)
            //make.left.equalTo(endDateLbl)//.offset(PAD/2)
            make.right.equalTo(view).offset(-1*PAD)

            make.width.equalTo(PICKER_WIDTH)
            make.height.equalTo(PICKER_HEIGHT)
        }
        
        
    }
    
    
    
    func getSalesForMonth(){
        let db = Firestore.firestore()
        let originalColor = self.generateSaleBtn.backgroundColor
        self.generateSaleBtn.backgroundColor = .lightGray
        var newSaleReport:[Sale] = []
        _ = db.collection("Sales")
        
        let myGroup = DispatchGroup()
        print("GETTING SALES FOR MONTH...")
        db.collection("Sales").whereField("Timestamp", isGreaterThanOrEqualTo: self.startDatePicker.date).whereField("Timestamp", isLessThanOrEqualTo: self.endDatePicker.date).order(by: "Timestamp", descending: true).getDocuments { (snapshot, err) in
            
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
                                        self.generateSaleBtn.backgroundColor = originalColor
                                        
                                        self.generateSaleBtn.isUserInteractionEnabled = true
                                        //                                        print(snapshot?.data())
                                        //                                        newSale?.saleItems?.last?.inventoryItem = InventoryItem(id: (snapshot?.documentID)!, dictionary: (snapshot?.data())!)
                                        //                                        print("Adding Inventory Item to Sale: \(snapshot?.documentID)")
                                        //                                        newSaleReport.append(newSale!)
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
