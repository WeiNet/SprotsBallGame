//
//  BreakfastView.swift
//  SportsBall
//
//  Created by Brook on 16/4/23.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//早盘、单式、滚球
class BreakfastView: OrderView {
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
    override func userInteractionEnabled(){
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
    override func addGestureRecognizer(){
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
    override func orderTap(sender: UITapGestureRecognizer) {
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
                ToolsCode.setLblFontBackground(view as! UILabel,selected: !select)
            }else if((iTag>=ToolsCode.LRFView && iTag<=ToolsCode.RRFView)
                || (iTag>=ToolsCode.LRFView2 && iTag<=ToolsCode.RRFView2)){
                ToolsCode.setBackground(view,select:!select)
            }else if((iTag>=ToolsCode.LDXBLView && iTag<=ToolsCode.RDXBLView)
                || (iTag>=ToolsCode.LDXBLView2 && iTag<=ToolsCode.RDXBLView2)){
                ToolsCode.setBackground2(view,select: !select)
            }
        }
    }
    //第一次填入BetInfoModel属性用于检验最新赔率，检验完成才有其他属性
    func fullBetInfo(toolsCode:Int)->BetInfoModel{
        var id:String!
        var tid:String!
        var let1:String!
        var hfs:String = "0"//赌赢为0
        var hlx:String = "0"
        var hbl:String = "0"
        var courtType:String = "1"
        var gameDate:String = orderCellModel.N_GAMEDATE
        gameDate = ToolsCode.formatterDate(gameDate, format: "yyyy/MM/dd")
        let playType:String = ToolsCode.codeByPlayType(toolsCode)
        var betteamName:String!
        let tempBetName = ToolsCode.codeByLRH(toolsCode)
        if tempBetName == "L" {
            betteamName = String(orderCellModel.N_VISIT_NAME)
        }else if tempBetName == "R" {
            betteamName = String(orderCellModel.N_HOME_NAME)
        }else{
            betteamName = "和局"
        }
        if playType == "DX"{
            betteamName = tempBetName == "L" ? "大" : "小"
        }
        //全场控件
        id = String(orderCellModel.N_ID)
        let1 = String(orderCellModel.N_LET)
        let tempType = ToolsCode.codeByPlayType(toolsCode)
        if (tempType == "RF") && (tempType == "DX") {
            hfs = String(orderCellModel.valueForKey("N_\(tempType)FS")!)
            hlx = String(orderCellModel.valueForKey("N_\(tempType)LX")!)
            hbl = String(orderCellModel.valueForKey("N_\(tempType)BL")!)
        }
        let tempLRH = ToolsCode.codeByLRH(toolsCode)
        if tempLRH == "L" {
            tid = String(orderCellModel.N_VISIT)
        }else if tempLRH == "R" {
            tid = String(orderCellModel.N_HOME)
        }else{
            tid = "0"
        }
        if(toolsCode>=ToolsCode.LDYPL2 && toolsCode<=ToolsCode.RDXBLView2){//半场控件
            id = String(orderCellModel.N_ID2)
            let1 = String(orderCellModel.N_LET2)
            let tempType2 = ToolsCode.codeByPlayType(toolsCode)
            if (tempType == "RF") && (tempType == "DX") {
                hfs = String(orderCellModel.valueForKey("N_\(tempType2)FS2")!)
                hlx = String(orderCellModel.valueForKey("N_\(tempType2)LX2")!)
                hbl = String(orderCellModel.valueForKey("N_\(tempType2)BL2")!)
            }
            let tempLRH2 = ToolsCode.codeByLRH(toolsCode)
            if tempLRH2 == "L" {
                tid = String(orderCellModel.N_VISIT2)
            }else if tempLRH2 == "R" {
                tid = String(orderCellModel.N_HOME2)
            }else{
                tid = "0"
            }
            courtType = "2"
        }
        let tempRate = ToolsCode.codeBy(toolsCode)
        
        let betInfo:BetInfoModel = BetInfoModel()//下注model
        betInfo.strUser = "DEMOFZ-0P0P00"//USER??????????????????????????????????????????????????????????????
        betInfo.playType = playType
        betInfo.lr = ToolsCode.codeByLRH(toolsCode)
        betInfo.ballType = orderCellModel.N_LX
        betInfo.courtType = courtType
        betInfo.id = id
        betInfo.tid = tid
        betInfo.rate = String(format: "%.3f", (orderCellModel.valueForKey(tempRate)?.floatValue)!)
        betInfo.vh = String(orderCellModel.N_VH)
        betInfo.strlet = let1
        betInfo.hbl = hbl
        betInfo.hfs = hfs
        betInfo.hlx = hlx
        betInfo.homename = String(orderCellModel.N_HOME_NAME)
        betInfo.visitname = String(orderCellModel.N_VISIT_NAME)
        betInfo.betteamName = betteamName
        betInfo.date = gameDate
        betInfo.dMoney = "10"
        return betInfo
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
        
        
        N_LDYPL2.text = ""
        N_HJPL2.text = ""
        N_RDYPL2.text = ""
        
        N_LRFBL2.text = ""
        N_RRFBL2.text = ""
        N_LRFPL2.text = ""
        N_RRFPL2.text = ""
        
        N_LDXBL2.text = ""
        N_RDXBL2.text = ""
        N_DXDPL2.text = ""
        N_DXXPL2.text = ""
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
        
        
        //半场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellModel.N_DY_OPEN2 != nil && String(orderCellModel.N_DY_OPEN2) != "1"){
            N_LDYPL2.text = orderCellModel.N_LDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_LDYPL2.floatValue) : ""
            N_HJPL2.text = orderCellModel.N_HJPL2 != nil ? String(format: "%.3f", orderCellModel.N_HJPL2.floatValue) : ""
            N_RDYPL2.text = orderCellModel.N_RDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_RDYPL2.floatValue) : ""
        }
        //半场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN2 != nil && String(orderCellModel.N_RF_OPEN2) != "1"){
            if(orderCellModel.N_LET2 != nil && String(orderCellModel.N_LET2) != "1"){
                N_LRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }else{
                N_RRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }
            N_LRFPL2.text = orderCellModel.N_LRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_LRFPL2.floatValue) : ""
            N_RRFPL2.text = orderCellModel.N_RRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_RRFPL2.floatValue) : ""
        }
        //半场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN2 != nil && String(orderCellModel.N_DX_OPEN2) != "1"){
            N_LDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            N_RDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            N_DXDPL2.text = orderCellModel.N_DXDPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXDPL2.floatValue) : ""
            N_DXXPL2.text = orderCellModel.N_DXXPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXXPL2.floatValue) : ""
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
        
        ToolsCode.setLblFontBackground(N_LDYPL2, selected: orderCellModel.N_LDYPL2_SEL)
        ToolsCode.setLblFontBackground(N_HJPL2, selected: orderCellModel.N_HJPL2_SEL)
        ToolsCode.setLblFontBackground(N_RDYPL2, selected: orderCellModel.N_RDYPL2_SEL)
        ToolsCode.setBackground(L_RFView2,select: orderCellModel.N_LRFPL2_SEL)
        ToolsCode.setBackground(R_RFView2,select: orderCellModel.N_RRFPL2_SEL)
        ToolsCode.setBackground2(N_LDXBLView2,select: orderCellModel.N_DXDPL2_SEL)
        ToolsCode.setBackground2(N_RDXBLView2,select: orderCellModel.N_DXXPL2_SEL)
    }
}
