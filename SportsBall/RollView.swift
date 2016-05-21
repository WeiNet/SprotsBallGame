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
    
    @IBOutlet var N_DSSPLView: UIView!
    @IBOutlet var N_DSSPL: UILabel!
    @IBOutlet var N_DSDPLView: UIView!
    @IBOutlet var N_DSDPL: UILabel!
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    func userInteractionEnabled(){
        N_LRFBLView.userInteractionEnabled = true
        N_RRFBLView.userInteractionEnabled = true
        N_LDXBLView.userInteractionEnabled = true
        N_RDXBLView.userInteractionEnabled = true
        N_DSSPLView.userInteractionEnabled = true
        N_DSDPLView.userInteractionEnabled = true
        
        N_LRFBLView.tag = ToolsCode.LRFView
        N_RRFBLView.tag = ToolsCode.RRFView
        N_LDXBLView.tag = ToolsCode.LDXBLView
        N_RDXBLView.tag = ToolsCode.RDXBLView
        N_DSSPLView.tag = ToolsCode.LDSBLView
        N_DSDPLView.tag = ToolsCode.RDSBLView
    }
    
    //注册点击事件
    func addGestureRecognizer(){
        N_LRFBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RRFBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_DSSPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_DSDPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
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
                ToolsCode.setBackground(view,select:!select)
            }else if((iTag>=ToolsCode.LDXBLView && iTag<=ToolsCode.RDXBLView)){
                ToolsCode.setBackground2(view,select: !select)
            }else if((iTag>=ToolsCode.LDSBLView && iTag<=ToolsCode.RDSBLView)){
                ToolsCode.setBackground(view,select: !select)
            }
        }
    }
    
    //注单赋值前清空重用控件
    func clear(){
        
        N_LRFBL.text = ""
        N_LRFPL.text = ""
        N_RRFBL.text = ""
        N_RRFPL.text = ""
        
        N_LDXBL.text = ""
        N_LDXDPL.text = ""
        N_RDXBL.text = ""
        N_RDXXPL.text = ""
        
        N_DSSPL.text = ""
        N_DSDPL.text = ""
    }
    
    //资料的显示
    func showData(){
        //让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN != nil && String(orderCellModel.N_RF_OPEN) != "1"){
            if(String(orderCellModel.N_LET) != "1"){
                N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN != nil && String(orderCellModel.N_DX_OPEN) != "1"){
            N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            N_LDXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            N_RDXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        //单双不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DS_OPEN != nil && String(orderCellModel.N_DS_OPEN) != "1"){
            N_DSSPL.text = orderCellModel.N_DSSPL != nil ? String(format: "%.3f", orderCellModel.N_DSSPL.floatValue) : ""
            N_DSDPL.text = orderCellModel.N_DSDPL != nil ? String(format: "%.3f", orderCellModel.N_DSDPL.floatValue) : ""
        }
    }
    
    //背景的填充
    func fillBackground(){
        ToolsCode.setBackground(N_LRFBLView,select: orderCellModel.N_LRFPL_SEL)
        ToolsCode.setBackground(N_RRFBLView,select: orderCellModel.N_RRFPL_SEL)
        
        ToolsCode.setBackground2(N_LDXBLView,select: orderCellModel.N_DXDPL_SEL)
        ToolsCode.setBackground2(N_RDXBLView,select: orderCellModel.N_DXXPL_SEL)
        
        ToolsCode.setBackground(N_DSSPLView,select: orderCellModel.N_DSSPL_SEL)
        ToolsCode.setBackground(N_DSDPLView,select: orderCellModel.N_DSDPL_SEL)
    }
}
