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
    /*******************************注单控件*******************************/
    @IBOutlet var N_LDYPL: UILabel!
    @IBOutlet var N_HJPL: UILabel!
    @IBOutlet var N_RDYPL: UILabel!
    @IBOutlet var L_RFView: UIView!
    @IBOutlet var N_LRFBL: UILabel!
    @IBOutlet var N_LRFPL: UILabel!
    @IBOutlet var R_RFView: UIView!
    @IBOutlet var N_RRFBL: UILabel!
    @IBOutlet var N_RRFPL: UILabel!
    @IBOutlet var N_LDXBLView: UIView!
    @IBOutlet var N_LDXBL: UILabel!
    @IBOutlet var N_DXDPL: UILabel!
    @IBOutlet var N_RDXBLView: UIView!
    @IBOutlet var N_RDXBL: UILabel!
    @IBOutlet var N_DXXPL: UILabel!
    
    @IBOutlet var N_LDYPL2: UILabel!
    @IBOutlet var N_HJPL2: UILabel!
    @IBOutlet var N_RDYPL2: UILabel!
    @IBOutlet var L_RFView2: UIView!
    @IBOutlet var N_LRFBL2: UILabel!
    @IBOutlet var N_LRFPL2: UILabel!
    @IBOutlet var R_RFView2: UIView!
    @IBOutlet var N_RRFBL2: UILabel!
    @IBOutlet var N_RRFPL2: UILabel!
    @IBOutlet var N_LDXBLView2: UIView!
    @IBOutlet var N_LDXBL2: UILabel!
    @IBOutlet var N_DXDPL2: UILabel!
    @IBOutlet var N_RDXBLView2: UIView!
    @IBOutlet var N_RDXBL2: UILabel!
    @IBOutlet var N_DXXPL2: UILabel!
    /*******************************注单控件*******************************/
    
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
        
        // 单击手势识别
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "btnTap2:")
        N_LDYPL.addGestureRecognizer(tapGesture2)
        N_HJPL.addGestureRecognizer(tapGesture2)
        N_RDYPL.addGestureRecognizer(tapGesture2)
        L_RFView.addGestureRecognizer(tapGesture2)
        N_LRFBL.addGestureRecognizer(tapGesture2)
        
        order.canBecomeFirstResponder()
    }
    
    func btnTap(sender: UIButton) {
        self.toggleOpen(true)
    }
    func btnTap2(sender: UIButton) {
        self.toggleOpen2(true)
    }
    //不是第一响应者
    override func canResignFirstResponder() -> Bool {
        return false
    }
    func toggleOpen(userAction: Bool) {
        if userAction {
            order.hidden = !order.hidden
            headerClose = order.hidden
            myUpViewDelegate.upView(self)
        }
    }
    func toggleOpen2(userAction: Bool) {
        if userAction {
            print("我是点击的按钮事件响应的！！！！！！")
        }
    }
}
