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
        delegate.backClick!()
    }
    
    @IBAction func refresh(sender: UIButton) {
        delegate.refreshClick!()
    }
    
    @IBAction func title(sender: AnyObject) {
        delegate.titleViewClick!()
    }
    @IBAction func union(sender: UIButton) {
        delegate.unionClick!()
    }
    
    @IBAction func explain(sender: UIButton) {
        delegate.explainClick!()
    }
}
