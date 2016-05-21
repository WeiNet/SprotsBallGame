//
//  CartButtonView.swift
//  SportsBall
//
//  Created by Brook on 16/4/19.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

@objc protocol CartButtonDelegate: NSObjectProtocol {
    optional func cartClear()
    optional func cartShow()
}

class CartButtonView: UIView {
    var delegate:CartButtonDelegate!
    @IBOutlet var segment: UISegmentedControl!
    
    @IBAction func clear(sender: UIButton) {
        delegate.cartClear!()
    }
    
    @IBAction func show(sender: UIButton) {
        delegate.cartShow!()
    }
}
