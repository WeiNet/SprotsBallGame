//
//  UITableViewCellRoll.swift
//  MyViewCell
//
//  Created by Brook on 16/3/22.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

// 该协议将被用户组的委托实现； 当赛事被打开/关闭时，它将通知发送给委托，来告知Xcode调用何方法
protocol UpViewDelegate: NSObjectProtocol {
    func upView(orderCellRollView:OrderCellRollView)
}
protocol bindDataDelegate: NSObjectProtocol {
    func bindData(orderCellRollView:OrderCellRollView,orderCellRollModel:OrderCellRollModel)
}

class OrderCellRollView: UITableViewCell {
    @IBOutlet var titleView: UIView!
    @IBOutlet var order: UIView!
    
    /*******************************title标题控件*******************************/
    @IBOutlet var N_VISIT_NAME: UILabel!
    @IBOutlet var N_HOME_NAME: UILabel!
    @IBOutlet var N_GAMEDATE: UILabel!
    /*******************************title标题控件*******************************/
    
    var myUpViewDelegate: UpViewDelegate!
    var section: Int!//当前操作的行号
    var row:Int!
    var headerClose: Bool = false  // 标记HeaderView是否展开
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showView(close:Bool){
        order.hidden = close
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "btnTap:")
        //self.removeGestureRecognizer(tapGesture)
        titleView.addGestureRecognizer(tapGesture)
    }
    
    func btnTap(sender: UIButton) {
        self.toggleOpen(true)
    }
    
    func toggleOpen(userAction: Bool) {
        if userAction {
            order.hidden = !order.hidden
            headerClose = order.hidden
            myUpViewDelegate.upView(self)
        }
    }
}
