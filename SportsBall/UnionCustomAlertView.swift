//
//  UnionCustomAlertView.swift
//  SportsBall
//
//  Created by Brook on 16/5/6.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class UnionCustomAlertView: UIView {

    private var viewX:Double!
    private var viewY:Double!
    private var viewWidth: Double = 350.0
    private var viewHeight: Double = 600.0
    
    @IBOutlet var unionTable: UITableView!
    @IBOutlet var selAllView: UIView!
    @IBOutlet var selAllButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
    
    var cornerRadius: Double = 40.0
    var bottom:UIView!
    var myView:UnionCustomAlertView!
    
    @IBAction func canel(sender: UIButton) {
        print("canel")
    }
    @IBAction func ok(sender: UIButton) {
      print("ok")
    }
    
    func checkboxClick(sender: UITapGestureRecognizer) {
        selAllButton.selected = !selAllButton.selected
    }

    override func awakeFromNib() {
        selAllButton.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Normal)
        selAllButton.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Selected)
        selAllView.userInteractionEnabled = true
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "checkboxClick:")
        selAllView.addGestureRecognizer(tapGesture)
    }
}
