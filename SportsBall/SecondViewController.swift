//
//  SecondViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/2.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var b:String = "BBBBB1111"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: nil, action: "showMain")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

