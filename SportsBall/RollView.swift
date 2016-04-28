//
//  RollView.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollView: UIView,GestureDelegate {
    @IBOutlet var upperView: UIView!
    @IBOutlet var belowView: UIView!
    
    @IBOutlet var N_LRFBLView: UIView!
    @IBOutlet var N_LRFBL: UILabel!
    @IBOutlet var N_LRFPL: UILabel!
    @IBOutlet var N_RRFBLView: UIView!
    @IBOutlet var N_RRFBL: UILabel!
    @IBOutlet var N_RRFPL: UILabel!
    
    @IBOutlet var N_LDXBLView: UIView!
    @IBOutlet var N_LDXBL: UILabel!
    @IBOutlet var N_LDXDPL: UILabel!
    @IBOutlet var N_RDXBLView: UIView!
    @IBOutlet var N_RDXBL: UILabel!
    @IBOutlet var N_RDXXPL: UILabel!
    
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
    }
    
    //注册点击事件
    func addGestureRecognizer(){
    }
}
