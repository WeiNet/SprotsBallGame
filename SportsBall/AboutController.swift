//
//  AboutController.swift
//  SportsBall
//
//  Created by abel jing on 16/4/9.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    
    override func viewDidLoad() {
        self.title="关于"
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)    }
}
