//
//  AddItemPopUpVC.swift
//  HuPOS
//
//  Created by Cody Husek on 4/3/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import UIKit

class AddItemPopUpVC:UIViewController {
    
    
//    var popupView:UIView = {
//        var view_ = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
//        view_.backgroundColor = .white
//        view_.layer.cornerRadius = 5
//        view_.layer.masksToBounds = true
//        view_.translatesAutoresizingMaskIntoConstraints = false
//        return view_
//    }()
//
//    var cancelButton:UIButton = {
//        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
//        btn.titleLabel?.text = "Cancel"
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    var messageView:UITextView = {
//        var textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        textView.isScrollEnabled = false
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.font = UIFont.systemFont(ofSize: 40)
//        textView.textAlignment = .center
//        textView.backgroundColor = UIColor.clear
//        return textView
//    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
  
//        view.addSubview(popupView)
//        view.addSubview(cancelButton)
//        view.addSubview(messageView)
//        popupView.center = self.view.center
//        messageView.center = self.view.center
        
        //cancelButton.anchor(top: nil, left: nil, right: nil, bottom: popupView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        self.showAnimate()
        //        popupView.centerXAnchor.constraint(equalTo: self.pare).isActive = true
        //        popupView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func onButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let navView = UIView()
        navView.frame = CGRect(x: 0, y: 0, width: screenSize.width/3, height: screenSize.height/3)
        navView.center.x = view.center.x
        navView.center.y = view.center.y
        navView.backgroundColor = UIColor.white
        navView.layer.cornerRadius = 5
        navView.layer.masksToBounds = true
        view.addSubview(navView)
        
        let navLabel = UILabel(frame: CGRect(x: 0, y: navView.frame.height - 30, width: 100, height: 30))
        navLabel.center.x = navView.center.x
     
        navLabel.text = "Welcome"
        navLabel.textColor = .black
        navLabel.textAlignment = .center
        navView.addSubview(navLabel)
        
        let myImageView = UIImageView(frame: CGRect(x: 0, y: navView.frame.maxY - 40, width: 120, height: 120))
        myImageView.center.x = view.center.x
        myImageView.image = #imageLiteral(resourceName: "default-profile")
        myImageView.contentMode = .scaleAspectFill
        view.addSubview(myImageView)
        
        let button = UIButton(frame: CGRect(x:navView.frame.minX, y: navView.frame.maxY - 70, width: 100, height: 70))
        button.reversesTitleShadowWhenHighlighted = true
        button.setTitleShadowColor(.black, for: .highlighted)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
