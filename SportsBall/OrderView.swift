//
//  OrderView.swift
//  SportsBall
//
//  Created by Brook on 16/5/19.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

//页面 实例化
protocol OrderDelegate: NSObjectProtocol {
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int,isSel:Bool)->Bool//赔率点击事件,返回true为多选
}

class OrderView: UIView ,GestureDelegate {
    var delegate:OrderDelegate!
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
    }
    //注册点击事件
    func addGestureRecognizer(){
    }
    func orderTap(sender: UITapGestureRecognizer) {
    }
    //注单赋值前清空重用控件
    func clear(){
    }
    //资料的显示
    func showData(){
    }
    //背景的填充
    func fillBackground(){
    }
}
