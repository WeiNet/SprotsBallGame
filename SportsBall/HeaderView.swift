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
    
    @IBOutlet var btnTitle: UIButton!
    @IBAction func back(sender: UIButton) {
        print("点击back")
        delegate.backClick!()
    }
    
    @IBAction func refresh(sender: UIButton) {
        print("用户点击refresh")
        delegate.refreshClick!()
    }
    
    @IBAction func title(sender: AnyObject) {
        print("用户点击title")
        delegate.titleViewClick!()
    }
    @IBAction func union(sender: UIButton) {
        print("用户点击union")
        delegate.unionClick!()
    }
    
    @IBAction func explain(sender: UIButton) {
        print("用户点击explain")
        delegate.explainClick!()
    }
}
