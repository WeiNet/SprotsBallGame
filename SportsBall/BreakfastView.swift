//
//  BreakfastView.swift
//  SportsBall
//
//  Created by Brook on 16/4/23.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

//页面 实例化
protocol OrderMainDelegate: NSObjectProtocol {
    func orderMainDelegate(orderCellRollModel:OrderCellRollModel,unionIndex:Int,matchIndex:Int)->Bool//赔率点击事件,返回true为多选
}

class BreakfastView: UIView ,GestureDelegate{
    var orderCellRollModel:OrderCellRollModel!//当前View对应的资料
    var delegate:OrderMainDelegate!
    let unionIndex:Int = 0
    let matchIndex:Int = 0
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
        let isMore:Bool = delegate.orderMainDelegate(orderCellRollModel,unionIndex:unionIndex,matchIndex:matchIndex)
        if isMore {
            let name = ToolsCode.codeBy(iTag)
            let select = orderCellRollModel.valueForKey("\(name)_SEL") as! Bool
            orderCellRollModel.setValue(!select, forKey: "\(name)_SEL")
            if ((iTag>=56661 && iTag<56664) || (iTag>=56668 && iTag<56671)){
                setLblFontBackground(view as! UILabel,selected: !select)
            }else if((iTag>=56664 && iTag<56666) || (iTag>=56671 && iTag<56673)){
                setBackground(view,select:!select)
            }else if((iTag>=56666 && iTag<56668) || (iTag>=56673 && iTag<56675)){
                setBackground2(view,select: !select)
            }
        }
    }
    //让分的背景设定
    func setBackground(view:UIView,select: Bool){
        let lbl0 = view.subviews[0] as! UILabel
        let lbl1 = view.subviews[1] as! UILabel
        setLblFontBackground2(lbl0,selected: select)
        setLblFontBackground(lbl1,selected: select)
    }
    //大小球的背景设定
    func setBackground2(view:UIView,select: Bool){
        let lbl0 = view.subviews[0] as! UILabel
        let lbl1 = view.subviews[1] as! UILabel
        let lbl2 = view.subviews[2] as! UILabel
        setLblFontBackground(lbl0,selected: select)
        setLblFontBackground2(lbl1,selected: select)
        setLblFontBackground(lbl2,selected: select)
    }
    //白色红底
    func setLblFontBackground(lable:UILabel,selected: Bool){
        if selected {
            lable.textColor = hexStringToColor("#FFFFFF")
            lable.backgroundColor = hexStringToColor("#FF4646")
        }else{
            lable.textColor = hexStringToColor("#464646")
            lable.backgroundColor = hexStringToColor("#FAFAFA")
        }
    }
    //金色红底
    func setLblFontBackground2(lable:UILabel,selected: Bool){
        if selected {
            lable.textColor = hexStringToColor("#FFFF00")
            lable.backgroundColor = hexStringToColor("#FF4646")
        }else{
            lable.textColor = hexStringToColor("#008C23")
            lable.backgroundColor = hexStringToColor("#FAFAFA")
        }
    }
    //16进制转UIColor
    func hexStringToColor(strColor:String)->UIColor{
        var cString: String = strColor.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
}
