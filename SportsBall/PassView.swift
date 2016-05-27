//
//  PassView.swift
//  SportsBall
//
//  Created by Brook on 16/5/18.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//综合过关
class PassView: OrderView {
    var orderCellModel:OrderCellModel!//当前View对应的资料
    
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
    
    @IBOutlet var N_DSDPLView: UIView!
    @IBOutlet var N_DSDPL: UILabel!
    @IBOutlet var N_DSSPLView: UIView!
    @IBOutlet var N_DSSPL: UILabel!
    /*******************************注单控件*******************************/
    //启动用户交互事件，设定Tag用于区别点击时所在的控件
    override func userInteractionEnabled(){
        N_LDYPL.userInteractionEnabled = true
        N_HJPL.userInteractionEnabled = true
        N_RDYPL.userInteractionEnabled = true
        L_RFView.userInteractionEnabled = true
        R_RFView.userInteractionEnabled = true
        N_LDXBLView.userInteractionEnabled = true
        N_RDXBLView.userInteractionEnabled = true
        N_DSSPLView.userInteractionEnabled = true
        N_DSDPLView.userInteractionEnabled = true
        
        N_LDYPL.tag = ToolsCode.LDYPL
        N_HJPL.tag = ToolsCode.HJPL
        N_RDYPL.tag = ToolsCode.RDYPL
        L_RFView.tag = ToolsCode.LRFView
        R_RFView.tag = ToolsCode.RRFView
        N_LDXBLView.tag = ToolsCode.LDXBLView
        N_RDXBLView.tag = ToolsCode.RDXBLView
        N_DSSPLView.tag = ToolsCode.DSSPLView
        N_DSDPLView.tag = ToolsCode.DSDPLView
    }
    //注册点击事件
    override func addGestureRecognizer(){
        N_LDYPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_HJPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDYPL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        L_RFView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        R_RFView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_LDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_RDXBLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_DSSPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
        N_DSDPLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "orderTap:"))
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
            if ((iTag>=ToolsCode.LDYPL && iTag<=ToolsCode.RDYPL)){
                ToolsCode.setLblFontBackground(view as! UILabel,selected: !select)
            }else if((iTag>=ToolsCode.LRFView && iTag<=ToolsCode.RRFView)
                || (iTag>=ToolsCode.DSSPLView && iTag<=ToolsCode.DSDPLView)){
                ToolsCode.setBackground(view,select:!select)
            }else if((iTag>=ToolsCode.LDXBLView && iTag<=ToolsCode.RDXBLView)){
                ToolsCode.setBackground2(view,select: !select)
            }
        }
    }
    //注单赋值前清空重用控件
    override func clear(){
        N_LDYPL.text = ""
        N_HJPL.text = ""
        N_RDYPL.text = ""
        
        N_LRFBL.text = ""
        N_RRFBL.text = ""
        N_LRFPL.text = ""
        N_RRFPL.text = ""
        
        N_LDXBL.text = ""
        N_RDXBL.text = ""
        N_DXDPL.text = ""
        N_DXXPL.text = ""
        
        N_DSSPL.text = ""
        N_DSDPL.text = ""
    }
    //资料的显示
    override func showData(){
        //全场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellModel.N_DY_OPEN != nil && String(orderCellModel.N_DY_OPEN) != "1"){
            N_LDYPL.text = orderCellModel.N_LDYPL != nil ? String(format: "%.3f", orderCellModel.N_LDYPL.floatValue) : ""
            N_HJPL.text = orderCellModel.N_HJPL != nil ? String(format: "%.3f", orderCellModel.N_HJPL.floatValue) : ""
            N_RDYPL.text = orderCellModel.N_RDYPL != nil ? String(format: "%.3f", orderCellModel.N_RDYPL.floatValue) : ""
        }
        //全场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN != nil && String(orderCellModel.N_RF_OPEN) != "1"){
            if(orderCellModel.N_LET != nil && String(orderCellModel.N_LET) != "1"){
                N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //全场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN != nil && String(orderCellModel.N_DX_OPEN) != "1"){
            N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            N_DXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            N_DXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        //单双不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DS_OPEN != nil && String(orderCellModel.N_DS_OPEN) != "1"){
            N_DSSPL.text = orderCellModel.N_DSSPL != nil ? String(format: "%.3f", orderCellModel.N_DSSPL.floatValue) : ""
            N_DSDPL.text = orderCellModel.N_DSDPL != nil ? String(format: "%.3f", orderCellModel.N_DSDPL.floatValue) : ""
        }
    }
    //背景的填充
    override func fillBackground(){
        ToolsCode.setLblFontBackground(N_LDYPL, selected: orderCellModel.N_LDYPL_SEL)
        ToolsCode.setLblFontBackground(N_HJPL, selected: orderCellModel.N_HJPL_SEL)
        ToolsCode.setLblFontBackground(N_RDYPL, selected: orderCellModel.N_RDYPL_SEL)
        ToolsCode.setBackground(L_RFView,select: orderCellModel.N_LRFPL_SEL)
        ToolsCode.setBackground(R_RFView,select: orderCellModel.N_RRFPL_SEL)
        ToolsCode.setBackground2(N_LDXBLView,select: orderCellModel.N_DXDPL_SEL)
        ToolsCode.setBackground2(N_RDXBLView,select: orderCellModel.N_DXXPL_SEL)
        ToolsCode.setBackground(N_DSSPLView,select: orderCellModel.N_DSSPL_SEL)
        ToolsCode.setBackground(N_DSDPLView,select: orderCellModel.N_DSDPL_SEL)
    }
}
