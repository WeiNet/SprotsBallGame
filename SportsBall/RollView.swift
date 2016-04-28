//
//  RollView.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollView: UIView,GestureDelegate {
    var orderCellModel:OrderCellModel!//当前View对应的资料
    var delegate:OrderDelegate!
    var ball:Ball = Ball()
    
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
    
    @IBOutlet var N_LDSBLView: UIView!
    @IBOutlet var N_RDSSPL: UILabel!
    @IBOutlet var N_RDSBLView: UIView!
    @IBOutlet var N_RDSDPL: UILabel!
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
        N_LRFBLView.userInteractionEnabled = true
        N_RRFBLView.userInteractionEnabled = true
        N_LDXBLView.userInteractionEnabled = true
        N_RDXBLView.userInteractionEnabled = true
        N_LDSBLView.userInteractionEnabled = true
        N_RDSBLView.userInteractionEnabled = true
        
        N_LRFBLView.tag = ToolsCode.LRFView
        N_RRFBLView.tag = ToolsCode.RRFView
        N_LDXBLView.tag = ToolsCode.LDXBLView
        N_RDXBLView.tag = ToolsCode.RDXBLView
        N_LDSBLView.tag = ToolsCode.LDSBLView
        N_RDSBLView.tag = ToolsCode.RDSBLView
    }
    
    //注册点击事件
    func addGestureRecognizer(){
        N_LRFBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RRFBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDSBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDSBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
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
            if((iTag>=ToolsCode.LRFView && iTag<=ToolsCode.RRFView)){
                ball.setBackground(view,select:!select)
            }else if((iTag>=ToolsCode.LDXBLView && iTag<=ToolsCode.RDXBLView)){
                ball.setBackground2(view,select: !select)
            }else if((iTag>=ToolsCode.LDSBLView && iTag<=ToolsCode.RDSBLView)){
                ball.setBackground2(view,select: !select)
            }
        }
    }
}
