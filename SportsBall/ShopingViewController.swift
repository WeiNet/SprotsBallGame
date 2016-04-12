//
//  ShopingViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class ShopingViewController: UIViewController {
    
    override func viewDidLoad() {
        self.title="购物车"
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)    }
}
