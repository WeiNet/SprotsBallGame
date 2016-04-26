//
//  HeaderView.swift
//  SportsBall
//
//  Created by Brook on 16/4/15.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

@objc protocol HeaderViewDelegate: NSObjectProtocol {
    optional func backClick()
    optional func refreshClick()
    optional func titleViewClick()
    optional func unionClick()
    optional func explainClick()
}

@IBDesignable class HeaderView: UIView {
    var headerView:UIView!
    var delegate:HeaderViewDelegate!
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var title: UILabel!
    
    @IBAction func back(sender: UIButton) {
        print("点击back")
        delegate.backClick!()
    }
    
    @IBAction func refresh(sender: UIButton) {
        print("用户点击refresh")
        delegate.refreshClick!()
    }
    
    @IBAction func union(sender: UIButton) {
        print("用户点击union")
        delegate.unionClick!()
    }
    
    @IBAction func explain(sender: UIButton) {
        print("用户点击explain")
        delegate.explainClick!()
    }
    func titleTap(sender: UITapGestureRecognizer) {
        print("用户点击titleTap")
        self.toggleOpen(true)
    }
    
    func toggleOpen(userAction: Bool) {
        if userAction {
            //用户点击
            delegate.titleViewClick!()
            print("用户点击")
        }
    }
}
