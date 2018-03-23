//
//  ItemsCVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

//protocol

struct Item_ {
    let image:String?
    let title:String?
    let type:String?
}

class ItemCell:UICollectionViewCell{
    
    
    var item :Item_? {
        didSet{
            guard let image_ = item?.image else { return }
            guard let title_ = item?.title else { return }
            guard let type_ = item?.type else { return }
            
            imageView_.image = UIImage(named: image_)
            titleLabel.text = title_
            
            
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
        
        imageView_.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 0, width: 0, height: 50)
        
        titleLabel.anchor(top: imageView_.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
    }
    
    let imageView_: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func prepareForReuse() {
        self.backgroundColor = .white
        self.titleLabel.text = "Test"
    }
    
    @IBAction func editItemAction(_ sender: Any) {
        
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol ItemsCVC_Home_Protocol{
    func setEditModeOn()
}
protocol ItemsCVC_SaleItemsTVC_Protocol {
    func displayEditModeCell()
}

class ItemsCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, Home_ItemsCVC_Protocol {
    
    var itemCells = [Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "addCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell"),
                     Item_(image: "", title: "Test", type: "itemCell")]
    var cellId = "itemCell"
    public var itemsToHome:ItemsCVC_Home_Protocol?
    var editModeOn = false
    
    @IBOutlet var itemCollectionView: UICollectionView!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    @IBAction func longPressRecognized(_ sender: UILongPressGestureRecognizer) {
        switch(sender.state) {
            
        case .began:
            print("Began edit mode")
            self.editModeOn = true
            self.itemsToHome?.setEditModeOn()
            self.collectionView?.reloadData()
            guard let selectedIndexPath = itemCollectionView.indexPathForItem(at: sender.location(in: itemCollectionView)) else {
                break
            }
            itemCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            itemCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
        case .ended:
            itemCollectionView.endInteractiveMovement()
        default:
            itemCollectionView.cancelInteractiveMovement()
        }
    }
    
    
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    func beginEditingCells(){
        
    }
    
    func setEditModeOff(){
        self.editModeOn = false
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.longPressRecognizer.minimumPressDuration = 2.0
        collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.itemCells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:ItemCell?
        if(self.itemCells[indexPath.row].type == "addCell"){
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell
            cell?.titleLabel.text = ""
            if(!self.editModeOn){
                cell?.backgroundColor = .white
            }else{
                cell?.backgroundColor = .red

            }

        }else if(self.itemCells[indexPath.row].type == "itemCell"){
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell
            cell?.item = itemCells[indexPath.row]
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(ItemsCVC.longPressRecognized(_:)))
        cell?.addGestureRecognizer(longPressRecognizer)
        cell?.layoutIfNeeded()
        cell?.layer.cornerRadius = 5
        cell?.layer.masksToBounds = true
        
        return cell!
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 4) - 16, height: (view.frame.height / 5) - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
        
        print("Ending Index: \(destinationIndexPath.item)")
        
        let temp = self.itemCells[sourceIndexPath.row]
        self.itemCells[sourceIndexPath.row] = self.itemCells[destinationIndexPath.row]
        self.itemCells[destinationIndexPath.row] = temp
    }
    
   override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
