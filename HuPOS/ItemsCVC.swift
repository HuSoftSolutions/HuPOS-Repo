//
//  ItemsCVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

enum Tax:Int {
    case no_tax = 0, tax_inc = 1, tax_added = 2
    
    var description : String {
        switch self {
        case .no_tax: return "No Tax"
        case .tax_inc: return "Tax Included"
        case .tax_added: return "Tax Added"
        }
    }
    
    var array:[Tax] {
        var array:[Tax] = []
        switch Tax.no_tax {
        case .no_tax: array.append(.no_tax); fallthrough
        case .tax_inc: array.append(.tax_inc); fallthrough
        case .tax_added: array.append(.tax_added);
        }
        return array
    }
}

let CELL_COUNT = 40
let CELL_BACKGROUND_COLOR = UIColor(red: 240/255, green: 240/255, blue: 255/255, alpha: 1.0)
let CUSTOM_COLOR1 = UIColor(red: 0/255, green: 0/255, blue: 200/255, alpha: 1)
let CUSTOM_COLOR2 = UIColor(red: 255/255, green: 255/255, blue: 10/255, alpha: 1)

let CELL_COLORS:[UIColor] = [CELL_BACKGROUND_COLOR,
                             CUSTOM_COLOR1.lighter(by: 5)!,
                             CUSTOM_COLOR1.lighter(by: 10)!,
                             CUSTOM_COLOR1.lighter(by: 15)!,
                             CUSTOM_COLOR1.lighter(by: 20)!,
                             CUSTOM_COLOR2.lighter(by: 5)!,
                             CUSTOM_COLOR2.lighter(by: 10)!,
                             CUSTOM_COLOR2.lighter(by: 15)!,
                             CUSTOM_COLOR2.lighter(by: 20)!,
                             UIColor.green.withAlphaComponent(0.5)]

public class InventoryItem {
    var id:String?
    var image:String?
    var title:String?
    var category:String?
    var desc:String?
    var price:Double?
    var cost:Double?
    var taxIndex = 0
    var miscPrice:Bool?
    var index:Int?
    var cellColorIndex:Int = 0
    
    init(id:String, dictionary:[String:Any]){
        self.id = id
        self.image = dictionary["Image"] as? String
        self.title = dictionary["Title"] as? String
        self.category = dictionary["Category"] as? String
        self.desc = dictionary["Desc"] as? String
        self.price = dictionary["Price"] as? Double
        self.cost = dictionary["Cost"] as? Double
        self.taxIndex = (dictionary["Tax"] as? Int)!
        self.miscPrice = dictionary["MiscPrice"] as? Bool
        self.index = dictionary["Index"] as? Int
        self.cellColorIndex = (dictionary["CellColorIndex"] as? Int)!
    }
    
    init(img:String, title:String, category:String, price:Double, cost:Double, tax:Int, miscPrice:Bool, description:String, index:Int, id:String, cellColorIndex:Int){
        self.image = img
        self.title = title
        self.category = category
        self.desc = description
        self.price = price
        self.cost = cost
        self.taxIndex = tax
        self.miscPrice = miscPrice
        self.index = index
        self.id = id
        self.cellColorIndex = cellColorIndex
    }
    
    public func dictionary() -> [String : Any]{
        var data:[String:Any] = ["Id":String(), "Image":String(), "Title":String(), "Category":String(), "Index":String(), "Description":String(), "Price":Double(), "Cost":Double(), "Tax":Int(), "MiscPrice":Bool(), "CellColorIndex":Int() ]
        
        data["Id"] = self.id
        data["Title"] = self.title
        data["Category"] = self.category
        data["Price"] = self.price
        data["Cost"] = self.cost
        data["Tax"] = self.taxIndex
        data["MiscPrice"] = self.miscPrice
        data["Image"] = self.image
        data["Index"] = self.index
        data["Description"] = self.desc
        data["CellColorIndex"] = self.cellColorIndex
        
        return data
    }
} 

public class Item_ {
    
    var image = #imageLiteral(resourceName: "plusicon")
    var title:String?
    var index:Int?
    var inventoryItemCell:InventoryItem?
    
    init(index:Int){
        self.index = index
    }
    
}

class ItemCell:UICollectionViewCell{
    var item :Item_? {
        didSet{
            titleLabel.text = ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    
    func setCellShadow(){
        //self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width:0, height:1)
//        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 3
    }
    
    func setup(){
        //self.backgroundColor = .white
        
        self.addSubview(imageView_)
        self.addSubview(titleLabel)

        self.layer.borderWidth = 0.5
        
        imageView_.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        titleLabel.anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
    }
    
    let imageView_: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let button:UIButton = {
        
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    let titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    override func prepareForReuse() {
        self.backgroundColor = .white
        self.titleLabel.text = ""
        self.imageView_.image = nil
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}











































extension ItemsCVC:UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
          //  if let _ = loadingOper
        }
    }
    
    
}









class ItemsCVC:UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate{
    
    var editModeOn = false
    var editModeObserver:NSObjectProtocol?
    var inventoryItemObserver:NSObjectProtocol?
    var reloadCollectionView:NSObjectProtocol?
    
    
    
    var itemCells = [Item_]()
    
    func initItemCells(){
        self.itemCells.removeAll()
        for i in 0..<CELL_COUNT {
            self.itemCells.append(Item_(index:i))
        }
        // self.collectionView?.reloadData()
    }

    // WARNING !! -- May be an issue to reload each time the view will appear (line 151) in poor internet connection environment
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let group = DispatchGroup()
        print("Starting item retrieval .....")
        group.enter()
        initItemCells()
        let db = Firestore.firestore()
        
        //db.collection("Items").addDocument(data: ["Test":Tax.no_tax])
        _ = db.collection("Items").order(by: "Index", descending: false).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else{

                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let inventoryItem = InventoryItem(id: document.documentID, dictionary: document.data())
                    self.itemCells[inventoryItem.index!].inventoryItemCell = inventoryItem
                }
            }
            group.leave()
        }
        group.notify(queue: .main){
            print("Finshed!")
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })
        }
      
        let defaults = UserDefaults.standard
        self.editModeOn = defaults.bool(forKey: "EditModeOn")
        
        if(editModeObserver == nil){
        editModeObserver = NotificationCenter.default.addObserver(forName: .editModeChanged, object: nil, queue: OperationQueue.main, using: { (notification) in
            
            let editModeOn = notification.object as! Bool
            if (editModeOn){
                // Edit mode was turned on
                self.editModeOn = true
                
            }else{
                // Edit mode was turned off
                self.editModeOn = false
                
            }
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })
        })
        }
        
        if(inventoryItemObserver == nil){
        inventoryItemObserver =
            NotificationCenter.default.addObserver(forName: .inventoryItemAdded, object: nil, queue: OperationQueue.main, using: { (notification) in
                let item = notification.object as! InventoryItem
                self.itemCells[item.index!].inventoryItemCell = item
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
                
            })
        }
        if(reloadCollectionView == nil){
        reloadCollectionView = NotificationCenter.default.addObserver(forName: .reloadCollectionView, object: nil, queue: OperationQueue.main, using: { (notification) in
            let itemToDelete = notification.object as! InventoryItem
            self.itemCells[itemToDelete.index!].inventoryItemCell = nil
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })        })
    }
    }
    
    
    
    
    
    // Prevent memory leak
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let editModeObserver = editModeObserver {
            NotificationCenter.default.removeObserver(editModeObserver)
        }
        if let inventoryItemObserver = inventoryItemObserver {
            NotificationCenter.default.removeObserver(inventoryItemObserver)
        }
        if let reloadCollectionView = reloadCollectionView {
            NotificationCenter.default.removeObserver(reloadCollectionView)
        }
    }
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    
    private func loadCells(){
        
        
    }
    

    
    
    var cellId = "itemCell"
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        if(self.editModeOn){
            switch(gesture.state) {
                
            case .began:
                print("Began edit mode")
                self.editModeOn = true
                guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                    break
                }
                self.collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
                
            case .changed:
                self.collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            case .ended:
                self.collectionView?.endInteractiveMovement()
            default:
                self.collectionView?.cancelInteractiveMovement()
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.prefetchDataSource = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ItemsCVC.handleLongGesture(_:)))
        longPressGesture.cancelsTouchesInView = false
        self.collectionView?.isUserInteractionEnabled = true
        self.collectionView?.allowsSelection = true
        self.collectionView?.addGestureRecognizer(longPressGesture)
        self.collectionView?.alwaysBounceVertical = false
        
        collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.itemCells.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.itemCells[indexPath.row].inventoryItemCell == nil){   // Inventory item not present, 'Blank Cell'
            if(self.editModeOn){
                // Show add item view controller
                let alertController = UIAlertController(title: "Add New Item/Collection", message: "Please choose a cell style below", preferredStyle: .alert)
                let addItemAction = UIAlertAction(title: "New Item", style: .default) { (action) in
                    print("User pressed add item!")
                    
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let addItemPopUpVC = AddItemPopUpVC()
                    addItemPopUpVC.modalPresentationStyle = .overCurrentContext
                    addItemPopUpVC.modalTransitionStyle = .crossDissolve
                    let addItemController = addItemPopUpVC.presentationController
                    addItemController?.delegate = self
                    addItemPopUpVC.cellIndex = indexPath.row
                    self.present(addItemPopUpVC, animated: true, completion: {
                        print("Finished!")
                    })
                    
                }
                
                let addCollectionAction = UIAlertAction(title: "New Collection", style: .default) { (action) in
                    print("User pressed add collection!")
                    
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(addItemAction)
                alertController.addAction(addCollectionAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                
            }
        }else{                                                       // Iventory item present
            if(self.editModeOn){                                     // inventory item as editable cell
                // Send item to popup for editing
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let addItemPopUpVC = AddItemPopUpVC()
                addItemPopUpVC.modalPresentationStyle = .overCurrentContext
                addItemPopUpVC.modalTransitionStyle = .crossDissolve
                let addItemController = addItemPopUpVC.presentationController
                addItemController?.delegate = self
                addItemPopUpVC.cellIndex = indexPath.row
                addItemPopUpVC.inventoryItem = self.itemCells[indexPath.row].inventoryItemCell
                self.present(addItemPopUpVC, animated: true, completion: {
                    print("Finished presenting Edit View for Inventory Item !")
                })
            }else{
                // Populate sale
                if(self.itemCells[indexPath.row].inventoryItemCell?.miscPrice)!{
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let numberPadPopUp = NumberPadPopUpVC()
                    numberPadPopUp.modalPresentationStyle = .overCurrentContext
                    numberPadPopUp.modalTransitionStyle = .crossDissolve
                    let numberPadPopUpController = numberPadPopUp.presentationController
                    numberPadPopUpController?.delegate = self
                    numberPadPopUp.cellIndex = indexPath.row
                    numberPadPopUp.item = self.itemCells[indexPath.row]
                    
                    self.present(numberPadPopUp, animated: true, completion: {
                        print("Finished presenting Misc Item Number Pad View!")
                    })
                }else{
                    // Test
//                    let item = InventoryItem(id: (self.itemCells[indexPath.row].inventoryItemCell?.id)!, dictionary: (self.itemCells[indexPath.row].inventoryItemCell?.dictionary())!)
//                    NotificationCenter.default.post(name: .saleItemAdded, object: item)
                    NotificationCenter.default.post(name: .saleItemAdded, object: self.itemCells[indexPath.row])
                    
                }
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = self.itemCells.remove(at: sourceIndexPath.item)
        self.itemCells.insert(temp, at: destinationIndexPath.item)
        let group = DispatchGroup()
        
        for (i, item) in self.itemCells.enumerated() {
            group.enter()
            if item.inventoryItemCell != nil{
                item.inventoryItemCell?.index = i
                let db = Firestore.firestore()
                let itemRef = db.collection("Items").document((item.inventoryItemCell?.id!)!)
                itemRef.updateData(["Index": item.inventoryItemCell?.index]) { (err) in
                    if(err != nil){
                        print(err)
                        return
                    }else{
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main){
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:ItemCell?

        cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ItemCell
        cell?.isUserInteractionEnabled = true
        cell?.isMultipleTouchEnabled = true
        cell?.layer.borderWidth = 0.5
        cell?.layer.cornerRadius = 5
        cell?.layer.masksToBounds = true
        
        
        if(self.itemCells[indexPath.row].inventoryItemCell == nil){   // Inventory item not present, 'Blank Cell'
            if(self.editModeOn){
                cell?.titleLabel.text = ""
                cell?.imageView_.image = #imageLiteral(resourceName: "plusicon")
            }else{
                cell?.imageView_.image = nil
                cell?.backgroundColor = .white
            }
        }else{                                                        // Iventory item present
            cell?.titleLabel.text = itemCells[indexPath.row].inventoryItemCell?.title
            cell?.imageView_.image = nil
            cell?.backgroundColor = CELL_COLORS[(self.itemCells[indexPath.row].inventoryItemCell?.cellColorIndex)!]
        }
        
        return cell!

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 4) - 5, height: (self.collectionView!.frame.height / 5) - 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//    }
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
  
}
extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}
extension UIView {
    
    func pinToEdges(view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
}

////MARK: one little trick
//extension CHTCollectionViewWaterfallLayout {
//
//    internal override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
//
//        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
//
//        self.delegate?.collectionView!(self.collectionView!, moveItemAt: previousIndexPaths[0], to: targetIndexPaths[0])
//
//        return context
//    }
//}

