//
//  BreakfastView.swift
//  SportsBall
//
//  Created by Brook on 16/4/23.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

//页面 实例化
protocol OrderDelegate: NSObjectProtocol {
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int)->Bool//赔率点击事件,返回true为多选
}

class BreakfastView: UIView ,GestureDelegate{
    var orderCellModel:OrderCellModel!//当前View对应的资料
    var delegate:OrderDelegate!
//    let unionIndex:Int = 0
//    let matchIndex:Int = 0
    var ball:Ball = Ball()
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
    
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
        N_LDYPL.userInteractionEnabled = true
        N_HJPL.userInteractionEnabled = true
        N_RDYPL.userInteractionEnabled = true
        L_RFView.userInteractionEnabled = true
        R_RFView.userInteractionEnabled = true
        N_LDXBLView.userInteractionEnabled = true
        N_RDXBLView.userInteractionEnabled = true
        
        N_LDYPL.tag = ToolsCode.LDYPL
        N_HJPL.tag = ToolsCode.HJPL
        N_RDYPL.tag = ToolsCode.RDYPL
        L_RFView.tag = ToolsCode.LRFView
        R_RFView.tag = ToolsCode.RRFView
        N_LDXBLView.tag = ToolsCode.LDXBLView
        N_RDXBLView.tag = ToolsCode.RDXBLView
        
        N_LDYPL2.userInteractionEnabled = true
        N_HJPL2.userInteractionEnabled = true
        N_RDYPL2.userInteractionEnabled = true
        L_RFView2.userInteractionEnabled = true
        R_RFView2.userInteractionEnabled = true
        N_LDXBLView2.userInteractionEnabled = true
        N_RDXBLView2.userInteractionEnabled = true
        
        N_LDYPL2.tag = ToolsCode.LDYPL2
        N_HJPL2.tag = ToolsCode.HJPL2
        N_RDYPL2.tag = ToolsCode.RDYPL2
        L_RFView2.tag = ToolsCode.LRFView2
        R_RFView2.tag = ToolsCode.RRFView2
        N_LDXBLView2.tag = ToolsCode.LDXBLView2
        N_RDXBLView2.tag = ToolsCode.RDXBLView2
    }
    //注册点击事件
    func addGestureRecognizer(){
        N_LDYPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_HJPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDYPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        L_RFView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        R_RFView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        
        
        N_LDYPL2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_HJPL2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDYPL2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        L_RFView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        R_RFView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDXBLView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDXBLView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
    }
    func orderTap(sender: UITapGestureRecognizer) {
        let view = sender.view! as UIView
        let iTag = view.tag
        //赔率点击回调方法
        let isMore:Bool = delegate.orderClickDelegate(orderCellModel, toolsCode: iTag)
        if isMore {
            let name = ToolsCode.codeBy(iTag)
            let select = orderCellModel.valueForKey("\(name)_SEL") as! Bool
            orderCellModel.setValue(!select, forKey: "\(name)_SEL")
            if ((iTag>=ToolsCode.LDYPL && iTag<=ToolsCode.RDYPL)
                || (iTag>=ToolsCode.LDYPL2 && iTag<=ToolsCode.RDYPL2)){
                ball.setLblFontBackground(view as! UILabel,selected: !select)
            }else if((iTag>=ToolsCode.LRFView && iTag<=ToolsCode.RRFView)
                || (iTag>=ToolsCode.LRFView2 && iTag<=ToolsCode.RRFView2)){
                ball.setBackground(view,select:!select)
            }else if((iTag>=ToolsCode.LDXBLView && iTag<=ToolsCode.RDXBLView)
                || (iTag>=ToolsCode.LDXBLView2 && iTag<=ToolsCode.RDXBLView2)){
                ball.setBackground2(view,select: !select)
            }
        }
    }
}
