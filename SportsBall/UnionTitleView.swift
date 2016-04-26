//
//  UnionTitleView.swift
//  MyCellListTest
//
//  Created by Brook on 16/3/11.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

// 该协议将被TableVoiew实现； 当联盟组被打开/关闭时，它将通知发送给委托，来告知Xcode调用何方法
protocol UnionTitleViewDelegate: NSObjectProtocol {
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionOpened: Int)
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int)
}

class UnionTitleView: UITableViewHeaderFooterView {
    
    @IBOutlet var btnDisclosure: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var icon: UIButton!
    
    var delegate: UnionTitleViewDelegate!
    var unionIndex: Int!//当前操作的行号
    var headerOpen: Bool = true  // 标记联盟是否展开
    
    override func awakeFromNib() {
        // 设置disclosure 按钮的图片（被关闭）down
        self.btnDisclosure.setImage(UIImage(named: "up"), forState: UIControlState.Selected)
        
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "btnTap:")
        self.addGestureRecognizer(tapGesture)
    }
    
    func btnTap(sender: UITapGestureRecognizer) {
        self.toggleOpen(true)
    }
    
    func toggleOpen(userAction: Bool) {
        btnDisclosure.selected = !btnDisclosure.selected
        // 如果userAction传入的值为真，将给委托传递相应的消息
        if userAction {
            if headerOpen {
                delegate.sectionHeaderUnion(self, sectionClosed: unionIndex)
            }else{
                delegate.sectionHeaderUnion(self, sectionOpened: unionIndex)
            }
        }
    }
}
