//
//  ItemsCVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit
import Firebase



// public class CollectionItem { }

public class InventoryItem {
    var id:String?
    var image:String?
    var title:String?
    var category:String?
    var desc:String?
    var price:Double?
    var cost:Double?
    var tax:Bool?
    var index:Int?
    
    init(id:String, dictionary:[String:Any]){
        self.id = id
        self.image = dictionary["Image"] as? String
        self.title = dictionary["Title"] as? String
        self.category = dictionary["Category"] as? String
        self.desc = dictionary["Desc"] as? String
        self.price = dictionary["Price"] as? Double
        self.cost = dictionary["Cost"] as? Double
        self.tax = dictionary["Tax"] as? Bool
        self.index = dictionary["Index"] as? Int
    }
    
    init(img:String, title:String, type:String, category:String, price:Double, cost:Double, tax:Bool, description:String, index:Int){
        self.image = img
        self.title = title
        self.category = category
        self.desc = description
        self.price = price
        self.cost = cost
        self.tax = tax
        self.index = index
    }
    
    public func dictionary() -> [String : Any]{
        var data:[String:Any] = ["Id":String(), "Image":String(), "Title":String(), "Type":String(), "Category":String(), "Price":Double(), "Cost":Double(), "Tax":Bool()]
        
        data["Id"] = self.id
        data["Title"] = self.title
        data["Category"] = self.category
        data["Price"] = self.price
        data["Cost"] = self.cost
        data["Tax"] = self.tax
        data["Image"] = self.image
        
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
            // if inventoryItemCell is nil
            
            // else fill in blank cell traits
            
            // guard let title_ = item?.title else { return }
            
            titleLabel.text = ""
            
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    func setCellShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 3
    }
    
    func setup(){
        self.backgroundColor = .white
        
        self.addSubview(imageView_)
        self.addSubview(titleLabel)

        self.layer.borderWidth = 0.5
        
        imageView_.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        
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
       // btn.backgroundColor = .green
        return btn
    }()
    
    let titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    
    override func prepareForReuse() {
        self.backgroundColor = .white
        self.titleLabel.text = ""
    }

    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ItemsCVC:UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate{
    
    let CELL_COUNT = 20
    
    var editModeOn = false
    var editModeObserver:NSObjectProtocol?
    
    var itemCells = [Item_]()
    
    func initItemCells(){
        self.itemCells.removeAll()
        for i in 0..<CELL_COUNT {
            self.itemCells.append(Item_(index:i))
        }
        self.collectionView?.reloadData()
    }

    // WARNING !! -- May be an issue to reload each time the view will appear (line 151) in poor internet connection environment
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initItemCells()
        
        let group = DispatchGroup()
        print("Starting item retrieval .....")
        group.enter()
        let db = Firestore.firestore()
        
        _ = db.collection("Items").order(by: "Index", descending: false).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else{
                //self.itemCells.removeAll()
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                }
            }
            group.leave()
        }

        group.notify(queue: .main){
            print("Finshed!")
            self.collectionView?.reloadData()
        }
      
        
        
        
        let defaults = UserDefaults.standard
        self.editModeOn = defaults.bool(forKey: "EditModeOn")
        
        editModeObserver = NotificationCenter.default.addObserver(forName: .editModeChanged, object: nil, queue: OperationQueue.main, using: { (notification) in
            
            let editModeOn = notification.object as! Bool
            if (editModeOn){
                // Edit mode was turned on
                self.editModeOn = true
                
            }else{
                // Edit mode was turned off
                self.editModeOn = false
                
            }
            self.collectionView?.reloadData()
            
            
        })
        self.collectionView?.reloadData()
    }
    
    
    
    
    
    // Prevent memory leak
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let editModeObserver = editModeObserver {
            NotificationCenter.default.removeObserver(editModeObserver)
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
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ItemsCVC.handleLongGesture(_:)))
        longPressGesture.cancelsTouchesInView = false
        self.collectionView?.isUserInteractionEnabled = true
        self.collectionView?.allowsSelection = true
        self.collectionView?.addGestureRecognizer(longPressGesture)

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
                
            }else{
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = self.itemCells.remove(at: sourceIndexPath.item)
        self.itemCells.insert(temp, at: destinationIndexPath.item)
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
        }else{                                                       // Iventory item present
            if(self.editModeOn){                                     // Load inventory item as editable cell
                
            }else{
                
            }
        }
        
        return cell!

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 4) - 16, height: (view.frame.height / 5) - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
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

