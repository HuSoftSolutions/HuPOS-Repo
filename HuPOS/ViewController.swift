//
//  ViewController.swift
//  HuPOS
//
//  Created by Cody Husek on 1/29/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("test", forKey:"Test")
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

