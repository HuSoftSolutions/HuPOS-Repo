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
    
    func setupViews(screen:CGRect){
        
        let MAIN_VIEW_WIDTH = screen.width / 2
        view.addSubview(mainView)

        
        mainView.snp.makeConstraints { (make) in
            make.width.height.equalTo(MAIN_VIEW_WIDTH)
            make.center.equalTo(view)
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
