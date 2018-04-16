//
//  NumberPadPopUpVC.swift
//  BoringSSL
//
//  Created by Cody Husek on 4/14/18.
//

import Foundation
import SnapKit
import Firebase
import UIKit

class NumberPadPopUpVC:UIViewController {
    
    
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let miscPriceTotal:UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 80)
        txt.minimumFontSize = 10
        txt.placeholder = "0.00".currencyInputFormatting()
        txt.adjustsFontSizeToFitWidth = true
        txt.autocapitalizationType = .words
        txt.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        txt.textColor = UIColor.black
        txt.textAlignment = .center
        txt.sizeToFit()
        return txt
    }()
    
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleShadowColor(.black, for: .highlighted)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews(screen:CGRect){
        
        let MAIN_VIEW_WIDTH = screen.width / 2
        view.addSubview(mainView)
        view.addSubview(cancelBtn)
        view.addSubview(miscPriceTotal)
        
        mainView.snp.makeConstraints { (make) in
            make.width.height.equalTo(MAIN_VIEW_WIDTH)
            make.center.equalTo(view)
        }
        
        miscPriceTotal.snp.makeConstraints { (make) in
            make.width.equalTo(MAIN_VIEW_WIDTH)
            make.height.equalTo(MAIN_VIEW_WIDTH / 6)
            make.top.equalTo(mainView)
            make.left.equalTo(mainView)
            make.right.equalTo(mainView)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.height.equalTo(MAIN_VIEW_WIDTH / 6)
            make.width.equalTo(MAIN_VIEW_WIDTH)
            make.bottom.equalTo(mainView)
            make.left.equalTo(mainView)
            make.right.equalTo(mainView)
        }
        
    }
    
    override func viewDidLoad() {
        let screenSize = UIScreen.main.bounds
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        setupViews(screen: screenSize)
    }
}
