//
//  FluctuantView.swift
//  SportsBall
//
//  Created by Brook on 16/5/18.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//波胆
class FluctuantView: OrderView {
    var orderCellModel:OrderCellModel!//当前View对应的资料
    
    /*******************************注单控件*******************************/
    @IBOutlet var N_BDZPL10View: UIView!
    @IBOutlet var N_BDZPL10: UILabel!
    @IBOutlet var N_BDZPL20View: UIView!
    @IBOutlet var N_BDZPL20: UILabel!
    @IBOutlet var N_BDZPL21View: UIView!
    @IBOutlet var N_BDZPL21: UILabel!
    @IBOutlet var N_BDZPL30View: UIView!
    @IBOutlet var N_BDZPL30: UILabel!
    @IBOutlet var N_BDZPL31View: UIView!
    @IBOutlet var N_BDZPL31: UILabel!
    @IBOutlet var N_BDZPL32View: UIView!
    @IBOutlet var N_BDZPL32: UILabel!
    @IBOutlet var N_BDZPL40View: UIView!
    @IBOutlet var N_BDZPL40: UILabel!
    @IBOutlet var N_BDZPL41View: UIView!
    @IBOutlet var N_BDZPL41: UILabel!
    @IBOutlet var N_BDZPL42View: UIView!
    @IBOutlet var N_BDZPL42: UILabel!
    @IBOutlet var N_BDZPL43View: UIView!
    @IBOutlet var N_BDZPL43: UILabel!
    
    @IBOutlet var N_BDKPL10View: UIView!
    @IBOutlet var N_BDKPL10: UILabel!
    @IBOutlet var N_BDKPL20View: UIView!
    @IBOutlet var N_BDKPL20: UILabel!
    @IBOutlet var N_BDKPL21View: UIView!
    @IBOutlet var N_BDKPL21: UILabel!
    @IBOutlet var N_BDKPL30View: UIView!
    @IBOutlet var N_BDKPL30: UILabel!
    @IBOutlet var N_BDKPL31View: UIView!
    @IBOutlet var N_BDKPL31: UILabel!
    @IBOutlet var N_BDKPL32View: UIView!
    @IBOutlet var N_BDKPL32: UILabel!
    @IBOutlet var N_BDKPL40View: UIView!
    @IBOutlet var N_BDKPL40: UILabel!
    @IBOutlet var N_BDKPL41View: UIView!
    @IBOutlet var N_BDKPL41: UILabel!
    @IBOutlet var N_BDKPL42View: UIView!
    @IBOutlet var N_BDKPL42: UILabel!
    @IBOutlet var N_BDKPL43View: UIView!
    @IBOutlet var N_BDKPL43: UILabel!
    
    @IBOutlet var N_BDGPL00View: UIView!
    @IBOutlet var N_BDGPL00: UILabel!
    @IBOutlet var N_BDGPL11View: UIView!
    @IBOutlet var N_BDGPL11: UILabel!
    @IBOutlet var N_BDGPL22View: UIView!
    @IBOutlet var N_BDGPL22: UILabel!
    @IBOutlet var N_BDGPL33View: UIView!
    @IBOutlet var N_BDGPL33: UILabel!
    @IBOutlet var N_BDGPL44View: UIView!
    @IBOutlet var N_BDGPL44: UILabel!
    
    @IBOutlet var N_BDZPL5View: UIView!
    @IBOutlet var N_BDZPL5: UILabel!
    /*******************************注单控件*******************************/
    
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    override func userInteractionEnabled(){
        
        N_BDZPL10View.userInteractionEnabled = true
        N_BDZPL20View.userInteractionEnabled = true
        N_BDZPL21View.userInteractionEnabled = true
        N_BDZPL30View.userInteractionEnabled = true
        N_BDZPL31View.userInteractionEnabled = true
        N_BDZPL32View.userInteractionEnabled = true
        N_BDZPL40View.userInteractionEnabled = true
        N_BDZPL41View.userInteractionEnabled = true
        N_BDZPL42View.userInteractionEnabled = true
        N_BDZPL43View.userInteractionEnabled = true
        
        N_BDZPL10View.tag = ToolsCode.BDZPL10View
        N_BDZPL20View.tag = ToolsCode.BDZPL20View
        N_BDZPL21View.tag = ToolsCode.BDZPL21View
        N_BDZPL30View.tag = ToolsCode.BDZPL30View
        N_BDZPL31View.tag = ToolsCode.BDZPL31View
        N_BDZPL32View.tag = ToolsCode.BDZPL32View
        N_BDZPL40View.tag = ToolsCode.BDZPL40View
        N_BDZPL41View.tag = ToolsCode.BDZPL41View
        N_BDZPL42View.tag = ToolsCode.BDZPL42View
        N_BDZPL43View.tag = ToolsCode.BDZPL43View
        
        N_BDKPL10View.userInteractionEnabled = true
        N_BDKPL20View.userInteractionEnabled = true
        N_BDKPL21View.userInteractionEnabled = true
        N_BDKPL30View.userInteractionEnabled = true
        N_BDKPL31View.userInteractionEnabled = true
        N_BDKPL32View.userInteractionEnabled = true
        N_BDKPL40View.userInteractionEnabled = true
        N_BDKPL41View.userInteractionEnabled = true
        N_BDKPL42View.userInteractionEnabled = true
        N_BDKPL43View.userInteractionEnabled = true
        
        N_BDKPL10View.tag = ToolsCode.BDKPL10View
        N_BDKPL20View.tag = ToolsCode.BDKPL20View
        N_BDKPL21View.tag = ToolsCode.BDKPL21View
        N_BDKPL30View.tag = ToolsCode.BDKPL30View
        N_BDKPL31View.tag = ToolsCode.BDKPL31View
        N_BDKPL32View.tag = ToolsCode.BDKPL32View
        N_BDKPL40View.tag = ToolsCode.BDKPL40View
        N_BDKPL41View.tag = ToolsCode.BDKPL41View
        N_BDKPL42View.tag = ToolsCode.BDKPL42View
        N_BDKPL43View.tag = ToolsCode.BDKPL43View
        
        N_BDGPL00View.userInteractionEnabled = true
        N_BDGPL11View.userInteractionEnabled = true
        N_BDGPL22View.userInteractionEnabled = true
        N_BDGPL33View.userInteractionEnabled = true
        N_BDGPL44View.userInteractionEnabled = true
        
        N_BDGPL00View.tag = ToolsCode.BDGPL00View
        N_BDGPL11View.tag = ToolsCode.BDGPL11View
        N_BDGPL22View.tag = ToolsCode.BDGPL22View
        N_BDGPL33View.tag = ToolsCode.BDGPL33View
        N_BDGPL44View.tag = ToolsCode.BDGPL44View
        
        N_BDZPL5View.userInteractionEnabled = true
        
        N_BDZPL5View.tag = ToolsCode.BDZPL5View
    }
    //注册点击事件
    override func addGestureRecognizer(){
        N_BDZPL10View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL20View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL21View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL30View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL31View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL32View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL40View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL41View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL42View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDZPL43View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        
        N_BDKPL10View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL20View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL21View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL30View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL31View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL32View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL40View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL41View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL42View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDKPL43View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        
        N_BDGPL00View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDGPL11View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDGPL22View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDGPL33View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BDGPL44View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        
        N_BDZPL5View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
    }
    override func orderTap(sender: UITapGestureRecognizer) {
        let view = sender.view! as UIView
        let iTag = view.tag
        //赔率点击回调方法
        let isMore:Bool = delegate.orderClickDelegate(orderCellModel, toolsCode: iTag)
        if isMore {
            let name = ToolsCode.codeBy(iTag)
            let select = orderCellModel.valueForKey("\(name)_SEL") as! Bool
            orderCellModel.setValue(!select, forKey: "\(name)_SEL")
            ToolsCode.setBackground(view,select:!select)
        }
    }
    //注单赋值前清空重用控件
    override func clear(){
        N_BDZPL10.text = ""
        N_BDZPL20.text = ""
        N_BDZPL21.text = ""
        N_BDZPL30.text = ""
        N_BDZPL31.text = ""
        N_BDZPL32.text = ""
        N_BDZPL40.text = ""
        N_BDZPL41.text = ""
        N_BDZPL42.text = ""
        N_BDZPL43.text = ""
        
        N_BDKPL10.text = ""
        N_BDKPL20.text = ""
        N_BDKPL21.text = ""
        N_BDKPL30.text = ""
        N_BDKPL31.text = ""
        N_BDKPL32.text = ""
        N_BDKPL40.text = ""
        N_BDKPL41.text = ""
        N_BDKPL42.text = ""
        N_BDKPL43.text = ""
        
        N_BDGPL00.text = ""
        N_BDGPL11.text = ""
        N_BDGPL22.text = ""
        N_BDGPL33.text = ""
        N_BDGPL44.text = ""
        
        N_BDZPL5.text = ""
    }
    //资料的显示
    override func showData(){
        N_BDZPL10.text = orderCellModel.N_BDZPL10 != nil ? String(orderCellModel.N_BDZPL10.floatValue) : ""
        N_BDZPL20.text = orderCellModel.N_BDZPL20 != nil ? String(orderCellModel.N_BDZPL20.floatValue) : ""
        N_BDZPL21.text = orderCellModel.N_BDZPL21 != nil ? String(orderCellModel.N_BDZPL21.floatValue) : ""
        N_BDZPL30.text = orderCellModel.N_BDZPL30 != nil ? String(orderCellModel.N_BDZPL30.floatValue) : ""
        N_BDZPL31.text = orderCellModel.N_BDZPL31 != nil ? String(orderCellModel.N_BDZPL31.floatValue) : ""
        N_BDZPL32.text = orderCellModel.N_BDZPL32 != nil ? String(orderCellModel.N_BDZPL32.floatValue) : ""
        N_BDZPL40.text = orderCellModel.N_BDZPL40 != nil ? String(orderCellModel.N_BDZPL40.floatValue) : ""
        N_BDZPL41.text = orderCellModel.N_BDZPL41 != nil ? String(orderCellModel.N_BDZPL41.floatValue) : ""
        N_BDZPL42.text = orderCellModel.N_BDZPL42 != nil ? String(orderCellModel.N_BDZPL42.floatValue) : ""
        N_BDZPL43.text = orderCellModel.N_BDZPL43 != nil ? String(orderCellModel.N_BDZPL43.floatValue) : ""
        
        N_BDKPL10.text = orderCellModel.N_BDKPL10 != nil ? String(orderCellModel.N_BDKPL10.floatValue) : ""
        N_BDKPL20.text = orderCellModel.N_BDKPL20 != nil ? String(orderCellModel.N_BDKPL20.floatValue) : ""
        N_BDKPL21.text = orderCellModel.N_BDKPL21 != nil ? String(orderCellModel.N_BDKPL21.floatValue) : ""
        N_BDKPL30.text = orderCellModel.N_BDKPL30 != nil ? String(orderCellModel.N_BDKPL30.floatValue) : ""
        N_BDKPL31.text = orderCellModel.N_BDKPL31 != nil ? String(orderCellModel.N_BDKPL31.floatValue) : ""
        N_BDKPL32.text = orderCellModel.N_BDKPL32 != nil ? String(orderCellModel.N_BDKPL32.floatValue) : ""
        N_BDKPL40.text = orderCellModel.N_BDKPL40 != nil ? String(orderCellModel.N_BDKPL40.floatValue) : ""
        N_BDKPL41.text = orderCellModel.N_BDKPL41 != nil ? String(orderCellModel.N_BDKPL41.floatValue) : ""
        N_BDKPL42.text = orderCellModel.N_BDKPL42 != nil ? String(orderCellModel.N_BDKPL42.floatValue) : ""
        N_BDKPL43.text = orderCellModel.N_BDKPL43 != nil ? String(orderCellModel.N_BDKPL43.floatValue) : ""
        
        N_BDGPL00.text = orderCellModel.N_BDGPL00 != nil ? String(orderCellModel.N_BDGPL00.floatValue) : ""
        N_BDGPL11.text = orderCellModel.N_BDGPL11 != nil ? String(orderCellModel.N_BDGPL11.floatValue) : ""
        N_BDGPL22.text = orderCellModel.N_BDGPL22 != nil ? String(orderCellModel.N_BDGPL22.floatValue) : ""
        N_BDGPL33.text = orderCellModel.N_BDGPL33 != nil ? String(orderCellModel.N_BDGPL33.floatValue) : ""
        N_BDGPL44.text = orderCellModel.N_BDGPL44 != nil ? String(orderCellModel.N_BDGPL44.floatValue) : ""
        
        N_BDZPL5.text = orderCellModel.N_BDKPL5 != nil ? String(orderCellModel.N_BDKPL5.floatValue) : ""
    }
    //背景的填充
    override func fillBackground(){
        ToolsCode.setBackground(N_BDZPL10View,select: orderCellModel.N_BDZPL10_SEL)
        ToolsCode.setBackground(N_BDZPL20View,select: orderCellModel.N_BDZPL20_SEL)
        ToolsCode.setBackground(N_BDZPL21View,select: orderCellModel.N_BDZPL21_SEL)
        ToolsCode.setBackground(N_BDZPL30View,select: orderCellModel.N_BDZPL30_SEL)
        ToolsCode.setBackground(N_BDZPL31View,select: orderCellModel.N_BDZPL31_SEL)
        ToolsCode.setBackground(N_BDZPL32View,select: orderCellModel.N_BDZPL32_SEL)
        ToolsCode.setBackground(N_BDZPL40View,select: orderCellModel.N_BDZPL40_SEL)
        ToolsCode.setBackground(N_BDZPL41View,select: orderCellModel.N_BDZPL41_SEL)
        ToolsCode.setBackground(N_BDZPL42View,select: orderCellModel.N_BDZPL42_SEL)
        ToolsCode.setBackground(N_BDZPL43View,select: orderCellModel.N_BDZPL43_SEL)
        
        ToolsCode.setBackground(N_BDKPL10View,select: orderCellModel.N_BDKPL10_SEL)
        ToolsCode.setBackground(N_BDKPL20View,select: orderCellModel.N_BDKPL20_SEL)
        ToolsCode.setBackground(N_BDKPL21View,select: orderCellModel.N_BDKPL21_SEL)
        ToolsCode.setBackground(N_BDKPL30View,select: orderCellModel.N_BDKPL30_SEL)
        ToolsCode.setBackground(N_BDKPL31View,select: orderCellModel.N_BDKPL31_SEL)
        ToolsCode.setBackground(N_BDKPL32View,select: orderCellModel.N_BDKPL32_SEL)
        ToolsCode.setBackground(N_BDKPL40View,select: orderCellModel.N_BDKPL40_SEL)
        ToolsCode.setBackground(N_BDKPL41View,select: orderCellModel.N_BDKPL41_SEL)
        ToolsCode.setBackground(N_BDKPL42View,select: orderCellModel.N_BDKPL42_SEL)
        ToolsCode.setBackground(N_BDKPL43View,select: orderCellModel.N_BDKPL43_SEL)
        
        ToolsCode.setBackground(N_BDGPL00View,select: orderCellModel.N_BDGPL00_SEL)
        ToolsCode.setBackground(N_BDGPL11View,select: orderCellModel.N_BDGPL11_SEL)
        ToolsCode.setBackground(N_BDGPL22View,select: orderCellModel.N_BDGPL22_SEL)
        ToolsCode.setBackground(N_BDGPL33View,select: orderCellModel.N_BDGPL33_SEL)
        ToolsCode.setBackground(N_BDGPL44View,select: orderCellModel.N_BDGPL44_SEL)
        
        ToolsCode.setBackground(N_BDZPL5View,select: orderCellModel.N_BDKPL5_SEL)
    }
}
