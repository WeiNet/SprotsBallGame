//
//  Cell.swift
//  SportsBall
//
//  Created by Brook on 16/4/23.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//TableView 实例化
protocol ShowDelegate: NSObjectProtocol {
    func upOrderViewShow(cell:Cell)//显示与隐藏下注赔率View
}
//各自的orderView 实例化
protocol GestureDelegate: NSObjectProtocol {
    func addGestureRecognizer()//为每个赔率添加点击响应事件
}
class Cell: UITableViewCell {
    
    var unionIndex: Int!//当前操作联盟
    var matchIndex: Int!//当前操作联盟下面的赛事
    var showDelegate:ShowDelegate!
    var gestureDelegate:GestureDelegate!
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var orderView: UIView!
    /*******************************title标题控件*******************************/
    @IBOutlet var N_VISIT_NAME: UILabel!
    @IBOutlet var N_VISIT_JZF: UILabel!
    @IBOutlet var N_HOME_JZF: UILabel!
    @IBOutlet var N_HOME_NAME: UILabel!
    @IBOutlet var N_GAMEDATE: UILabel!
    /*******************************title标题控件*******************************/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        // 添加赛事标题单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "titleTap:")
        titleView.addGestureRecognizer(tapGesture)
    }
    
    func titleTap(sender: UITapGestureRecognizer) {
        self.toggleOpen(true)
    }
    func toggleOpen(userAction: Bool) {
        if userAction {
            if orderView.hidden {
                // 每次显示是都要注册单击手势识别事件
                gestureDelegate.addGestureRecognizer()
            }
            orderView.hidden = !orderView.hidden
            showDelegate.upOrderViewShow(self)
        }
    }
}
