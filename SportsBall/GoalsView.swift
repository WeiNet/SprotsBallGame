//
//  GoalsView.swift
//  SportsBall
//
//  Created by Brook on 16/5/18.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//入球数
class GoalsView: OrderView {
    var orderCellModel:OrderCellModel!//当前View对应的资料
    
    /*******************************注单控件*******************************/
    @IBOutlet var N_DSDPLView: UIView!
    @IBOutlet var N_DSDPL: UILabel!
    @IBOutlet var N_DSSPLView: UIView!
    @IBOutlet var N_DSSPL: UILabel!
    @IBOutlet var N_RQSPL01View: UIView!
    @IBOutlet var N_RQSPL01: UILabel!
    @IBOutlet var N_RQSPL23View: UIView!
    @IBOutlet var N_RQSPL23: UILabel!
    @IBOutlet var N_RQSPL46View: UIView!
    @IBOutlet var N_RQSPL46: UILabel!
    @IBOutlet var N_RQSPL7View: UIView!
    @IBOutlet var N_RQSPL7: UILabel!
    /*******************************注单控件*******************************/
    
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    override func userInteractionEnabled(){
        N_DSSPLView.userInteractionEnabled = true
        N_DSDPLView.userInteractionEnabled = true
        N_RQSPL01View.userInteractionEnabled = true
        N_RQSPL23View.userInteractionEnabled = true
        N_RQSPL46View.userInteractionEnabled = true
        N_RQSPL7View.userInteractionEnabled = true
        
        N_DSSPLView.tag = ToolsCode.DSSPLView
        N_DSDPLView.tag = ToolsCode.DSDPLView
        N_RQSPL01View.tag = ToolsCode.RQSPL01View
        N_RQSPL23View.tag = ToolsCode.RQSPL23View
        N_RQSPL46View.tag = ToolsCode.RQSPL46View
        N_RQSPL7View.tag = ToolsCode.RQSPL7View
        
    }
    
    //注册点击事件
    override func addGestureRecognizer(){
        N_DSSPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_DSDPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RQSPL01View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RQSPL23View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RQSPL46View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RQSPL7View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
    }
    
    override func orderTap(sender: UITapGestureRecognizer) {
        let view = sender.view! as UIView
        let iTag = view.tag
        let name = ToolsCode.codeBy(iTag)
        let select = orderCellModel.valueForKey("\(name)_SEL") as! Bool
        //赔率点击回调方法
        let isMore:Bool = delegate.orderClickDelegate(orderCellModel, toolsCode: iTag,isSel: select)
        if isMore {
            orderCellModel.setValue(!select, forKey: "\(name)_SEL")
            ToolsCode.setBackground(view,select:!select)
        }
    }
    
    //注单赋值前清空重用控件
    override func clear(){
        N_DSSPL.text = ""
        N_DSDPL.text = ""
        N_RQSPL01.text = ""
        N_RQSPL23.text = ""
        N_RQSPL46.text = ""
        N_RQSPL7.text = ""
    }
    
    //资料的显示
    override func showData(){
        N_DSSPL.text = orderCellModel.N_DSSPL != nil ? String(orderCellModel.N_DSSPL.floatValue) : ""
        N_DSDPL.text = orderCellModel.N_DSDPL != nil ? String(orderCellModel.N_DSDPL.floatValue) : ""
        N_RQSPL01.text = orderCellModel.N_RQSPL01 != nil ? String(orderCellModel.N_RQSPL01.floatValue) : ""
        N_RQSPL23.text = orderCellModel.N_RQSPL23 != nil ? String(orderCellModel.N_RQSPL23.floatValue) : ""
        N_RQSPL46.text = orderCellModel.N_RQSPL46 != nil ? String(orderCellModel.N_RQSPL46.floatValue) : ""
        N_RQSPL7.text = orderCellModel.N_RQSPL7 != nil ? String(orderCellModel.N_RQSPL7.floatValue) : ""
    }
    
    //背景的填充
    override func fillBackground(){
        ToolsCode.setBackground(N_DSSPLView,select: orderCellModel.N_DSDPL_SEL)
        ToolsCode.setBackground(N_DSDPLView,select: orderCellModel.N_DSSPL_SEL)
        ToolsCode.setBackground(N_RQSPL01View,select: orderCellModel.N_RQSPL01_SEL)
        ToolsCode.setBackground(N_RQSPL23View,select: orderCellModel.N_RQSPL23_SEL)
        ToolsCode.setBackground(N_RQSPL46View,select: orderCellModel.N_RQSPL46_SEL)
        ToolsCode.setBackground(N_RQSPL7View,select: orderCellModel.N_RQSPL7_SEL)
    }
}
