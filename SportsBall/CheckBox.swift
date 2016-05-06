//
//  CheckBox.swift
//  SportsBall
//
//  Created by Brook on 16/5/6.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

@IBDesignable class CheckBox: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Selected)
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "checkboxClick:")
        self.addGestureRecognizer(tapGesture)
    }
    
    func checkboxClick(sender: UITapGestureRecognizer) {
        self.selected = !self.selected
    }
}
