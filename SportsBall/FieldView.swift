//
//  FieldView.swift
//  SportsBall
//
//  Created by Brook on 16/5/18.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class FieldView: UIView {
    var orderCellModel:OrderCellModel!//当前View对应的资料
    var delegate:OrderDelegate!
    
    /*******************************注单控件*******************************/
    @IBOutlet var N_BQCZZView: UIView!
    @IBOutlet var N_BQCZZ: UILabel!
    @IBOutlet var N_BQCZHView: UIView!
    @IBOutlet var N_BQCZH: UILabel!
    @IBOutlet var N_BQCZKView: UIView!
    @IBOutlet var N_BQCZK: UILabel!
    @IBOutlet var N_BQCHZView: UIView!
    @IBOutlet var N_BQCHZ: UILabel!
    @IBOutlet var N_BQCHHView: UIView!
    @IBOutlet var N_BQCHH: UILabel!
    @IBOutlet var N_BQCHKView: UIView!
    @IBOutlet var N_BQCHK: UILabel!
    @IBOutlet var N_BQCKZView: UIView!
    @IBOutlet var N_BQCKZ: UILabel!
    @IBOutlet var N_BQCKHView: UIView!
    @IBOutlet var N_BQCKH: UILabel!
    @IBOutlet var N_BQCKKView: UIView!
    @IBOutlet var N_BQCKK: UILabel!
    /*******************************注单控件*******************************/
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
        N_BQCZZView.userInteractionEnabled = true
        N_BQCZHView.userInteractionEnabled = true
        N_BQCZKView.userInteractionEnabled = true
        N_BQCHZView.userInteractionEnabled = true
        N_BQCHHView.userInteractionEnabled = true
        N_BQCHKView.userInteractionEnabled = true
        N_BQCKZView.userInteractionEnabled = true
        N_BQCKHView.userInteractionEnabled = true
        N_BQCKKView.userInteractionEnabled = true
        
        N_BQCZZView.tag = ToolsCode.BQCZZView
        N_BQCZHView.tag = ToolsCode.BQCZHView
        N_BQCZKView.tag = ToolsCode.BQCZKView
        N_BQCHZView.tag = ToolsCode.BQCHZView
        N_BQCHHView.tag = ToolsCode.BQCHHView
        N_BQCHKView.tag = ToolsCode.BQCHKView
        N_BQCKZView.tag = ToolsCode.BQCKZView
        N_BQCKHView.tag = ToolsCode.BQCKHView
        N_BQCKKView.tag = ToolsCode.BQCKKView
    }
    //注册点击事件
    func addGestureRecognizer(){
        N_BQCZZView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCZHView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCZKView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCHZView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCHHView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCHKView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCKZView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCKHView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_BQCKKView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
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
            ToolsCode.setBackground(view,select:!select)
        }
    }
    //注单赋值前清空重用控件
    func clear(){
        N_BQCZZ.text = ""
        N_BQCZH.text = ""
        N_BQCZK.text = ""
        N_BQCHZ.text = ""
        N_BQCHH.text = ""
        N_BQCHK.text = ""
        N_BQCKZ.text = ""
        N_BQCKH.text = ""
        N_BQCKK.text = ""
    }
    //资料的显示
    func showData(){
        N_BQCZZ.text = orderCellModel.N_BQCZZ != nil ? String(orderCellModel.N_BQCZZ.floatValue) : ""
        N_BQCZH.text = orderCellModel.N_BQCZH != nil ? String(orderCellModel.N_BQCZH.floatValue) : ""
        N_BQCZK.text = orderCellModel.N_BQCZK != nil ? String(orderCellModel.N_BQCZK.floatValue) : ""
        N_BQCHZ.text = orderCellModel.N_BQCHZ != nil ? String(orderCellModel.N_BQCHZ.floatValue) : ""
        N_BQCHH.text = orderCellModel.N_BQCHH != nil ? String(orderCellModel.N_BQCHH.floatValue) : ""
        N_BQCHK.text = orderCellModel.N_BQCHK != nil ? String(orderCellModel.N_BQCHK.floatValue) : ""
        N_BQCKZ.text = orderCellModel.N_BQCKZ != nil ? String(orderCellModel.N_BQCKZ.floatValue) : ""
        N_BQCKH.text = orderCellModel.N_BQCKH != nil ? String(orderCellModel.N_BQCKH.floatValue) : ""
        N_BQCKK.text = orderCellModel.N_BQCKK != nil ? String(orderCellModel.N_BQCKK.floatValue) : ""
    }
    //背景的填充
    func fillBackground(){
        ToolsCode.setBackground(N_BQCZZView,select: orderCellModel.N_BQCZZ_SEL)
        ToolsCode.setBackground(N_BQCZHView,select: orderCellModel.N_BQCZH_SEL)
        ToolsCode.setBackground(N_BQCZKView,select: orderCellModel.N_BQCZK_SEL)
        ToolsCode.setBackground(N_BQCHZView,select: orderCellModel.N_BQCHZ_SEL)
        ToolsCode.setBackground(N_BQCHHView,select: orderCellModel.N_BQCHH_SEL)
        ToolsCode.setBackground(N_BQCHKView,select: orderCellModel.N_BQCHK_SEL)
        ToolsCode.setBackground(N_BQCKZView,select: orderCellModel.N_BQCKZ_SEL)
        ToolsCode.setBackground(N_BQCKHView,select: orderCellModel.N_BQCKH_SEL)
        ToolsCode.setBackground(N_BQCKKView,select: orderCellModel.N_BQCKK_SEL)
    }
}
