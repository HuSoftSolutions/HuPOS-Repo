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
    
    @IBOutlet weak var addImage: UIImageView!
}

class ItemsCVC: UICollectionViewController {
    
    
    var itemCells:[String] = ["addCell","testCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell","addCell"]
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        }else if(self.itemCells[indexPath.row] == "testCell"){
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as! blankCell

        }
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
   
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: self.collectionView)
        var indexPath = self.collectionView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath as IndexPath?
                let cell = self.tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot = snapshopOfCell(inputView: cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                self.collectionView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25,
                               animations: { () -> Void in
                                center?.y = locationInView.y
                                My.cellSnapshot!.center = center!
                                My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                                My.cellSnapshot!.alpha = 0.98
                                cell?.alpha = 0.0
                                
                }, completion: { (finished) -> Void in
                    if finished {
                        cell?.isHidden = true
                    }
                }
                )
            }
        case UIGestureRecognizerState.changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                swap(&self.itemCells[indexPath!.row], &self.itemCells[Path.initialIndexPath!.row])
                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            let cell = self.collectionView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = (cell?.center)!
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapshot!.removeFromSuperview()
                    My.cellSnapshot = nil
                }
            })
        }
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
