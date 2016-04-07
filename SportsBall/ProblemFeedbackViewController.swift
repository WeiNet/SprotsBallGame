//
//  ProblemFeedbackViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/4/5.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit


class ProblemFeedbackViewController: UIViewController {
    
    @IBOutlet weak var viewcontent: UIView!
    
    override func viewDidLoad() {
        self.title="我要反馈"
         navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Bordered, target: self, action: "commit"), animated: true)
       
       
    }
    func commit(){
    print("。。。。。")
    
    }

}
