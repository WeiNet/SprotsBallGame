//
//  UnionTitleView.swift
//  MyCellListTest
//
//  Created by Brook on 16/3/11.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

// 该协议将被用户组的委托实现； 当用户组被打开/关闭时，它将通知发送给委托，来告知Xcode调用何方法
protocol UnionTitleViewDelegate: NSObjectProtocol {
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionOpened: Int)
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int)
}

class UnionTitleView: UITableViewHeaderFooterView {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var icon: UIButton!
    
    var delegate: UnionTitleViewDelegate!
    var section: Int!//当前操作的行号
    var HeaderOpen: Bool = true  // 标记HeaderView是否展开
    
    override func awakeFromNib() {
        // 设置disclosure 按钮的图片（被打开）
        //self.BtnDisclosure.setImage(UIImage(named: "carat-open"), forState: UIControlState.Selected)
        
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "btnTap:")
        //        self.removeGestureRecognizer(tapGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    func btnTap(sender: UIButton) {
        self.toggleOpen(true)
    }
    
    func toggleOpen(userAction: Bool) {
        //        BtnDisclosure.selected = !BtnDisclosure.selected
        // 如果userAction传入的值为真，将给委托传递相应的消息
        if userAction {
            if HeaderOpen {
                delegate.sectionHeaderUnion(self, sectionClosed: section)
            }else{
                delegate.sectionHeaderUnion(self, sectionOpened: section)
            }
        }
    }
}
