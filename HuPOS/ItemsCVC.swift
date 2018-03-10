//
//  ItemsCVC.swift
//  HuPOS
//
//  Created by Cody Husek on 3/7/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class blankCell:UICollectionViewCell{
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var itemName: UILabel!
    
}

class ItemsCVC: UICollectionViewController {
    
    var editModeOn = false
    
    @IBOutlet var itemCollectionView: UICollectionView!
    
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    @IBAction func longPressRecognized(_ sender: UILongPressGestureRecognizer) {
        switch(sender.state) {
            
        case .began:
            print("Began edit mode")
            self.editModeOn = true
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
    
    var itemCells:[String] = ["addCell","itemCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell"]
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    func beginEditingCells(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.longPressRecognizer.minimumPressDuration = 2.0
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
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
        var cell:blankCell?
        if(self.itemCells[indexPath.row] == "addCell"){
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! blankCell

            if(!self.editModeOn){
                cell?.addItemButton.alpha = 0
            }else{
                cell?.addItemButton.alpha = 1
            }

        }else if(self.itemCells[indexPath.row] == "itemCell"){
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! blankCell
            cell?.itemName.addGestureRecognizer(self.longPressRecognizer)

        }
                    let longPressRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(ItemsCVC.longPressRecognized(_:)))
        cell?.addGestureRecognizer(longPressRecognizer)
        cell?.layoutIfNeeded()
        return cell!
        
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
