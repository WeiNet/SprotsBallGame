//
//  UITableViewCellRoll.swift
//  MyViewCell
//
//  Created by Brook on 16/3/22.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

// 该协议将被用户组的委托实现； 当赛事被打开/关闭时，它将通知发送给委托，来告知Xcode调用何方法
protocol UpViewDelegate: NSObjectProtocol {
    func upView(orderCellRollView:OrderCellRollView)
    func orderCliCk(orderCellRollModel:OrderCellRollModel,toolsCode: Int)
}
protocol bindDataDelegate: NSObjectProtocol {
    func bindData(orderCellRollView:OrderCellRollView,orderCellRollModel:OrderCellRollModel)
}

class OrderCellRollView: UITableViewCell {
    @IBOutlet var titleView: UIView!
    @IBOutlet var order: UIView!
    
    /*******************************title标题控件*******************************/
    @IBOutlet var N_VISIT_NAME: UILabel!
    @IBOutlet var N_VISIT_JZF: UILabel!
    @IBOutlet var N_HOME_NAME: UILabel!
    @IBOutlet var N_HOME_JZF: UILabel!
    @IBOutlet var N_GAMEDATE: UILabel!
    /*******************************title标题控件*******************************/
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
    
    var myUpViewDelegate: UpViewDelegate!
    var section: Int!//当前操作的行号
    var row:Int!
    var headerClose: Bool = false  // 标记HeaderView是否展开
    var orderCellRollModel:OrderCellRollModel!//当前View对应的资料
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userInteractionEnabled()
    }
    
    func showView(close:Bool){
        order.hidden = close
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "titleTap:")
        titleView.addGestureRecognizer(tapGesture)
        
    }
    
    func titleTap(sender: UITapGestureRecognizer) {
        self.toggleOpen(true)
    }
    func orderTap(sender: UITapGestureRecognizer) {
        let view = sender.view! as UIView
//        var ff = view.isKindOfClass(UILabel)
        let iTag = view.tag
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
        self.placeOrder(true,toolsCode: iTag)
//        var singBetView:SingBetView = SingBetView()
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
    func setLblFontBackground(lable:UILabel,selected: Bool){
        if selected {
            lable.textColor = hexStringToColor("#FFFFFF")
            lable.backgroundColor = hexStringToColor("#FF4646")
        }else{
            lable.textColor = hexStringToColor("#464646")
            lable.backgroundColor = hexStringToColor("#FAFAFA")
        }
    }
    func setLblFontBackground2(lable:UILabel,selected: Bool){
        if selected {
            lable.textColor = hexStringToColor("#FFFF00")
            lable.backgroundColor = hexStringToColor("#FF4646")
        }else{
            lable.textColor = hexStringToColor("#008C23")
            lable.backgroundColor = hexStringToColor("#FAFAFA")
        }
    }
    func toggleOpen(userAction: Bool) {
        if userAction {
            if order.hidden {
                // 单击手势识别
                myAddGestureRecognizer()
            }
            order.hidden = !order.hidden
            headerClose = order.hidden
            myUpViewDelegate.upView(self)
        }
    }
    func placeOrder(userAction: Bool,toolsCode: Int) {
        myUpViewDelegate.orderCliCk(orderCellRollModel,toolsCode: toolsCode)
        print("我是点击的按钮事件响应的！！！！！！")
    }
    
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
    func myAddGestureRecognizer(){
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
//N_LDYPL
//N_HJPL
//N_RDYPL
//L_RFView
//N_LRFBL
//N_LRFPL
//R_RFView
//N_RRFBL
//N_RRFPL
//N_LDXBLView
//N_LDXBL
//N_DXDPL
//N_RDXBLView
//N_RDXBL
//N_DXXPL
//
//N_LDYPL2
//N_HJPL2
//N_RDYPL2
//L_RFView2
//N_LRFBL2
//N_LRFPL2
//R_RFView2
//N_RRFBL2
//N_RRFPL2
//N_LDXBLView2
//N_LDXBL2
//N_DXDPL2
//N_RDXBLView2
//N_RDXBL2
//N_DXXPL2
extension UIColor {
//    public func hexStringToColor(strColor:String)->UIColor{
//        var cString: String = strColor.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        
//        if cString.characters.count < 6 {return UIColor.blackColor()}
//        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
//        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
//        if cString.characters.count != 6 {return UIColor.blackColor()}
//        
//        var range: NSRange = NSMakeRange(0, 2)
//        
//        let rString = (cString as NSString).substringWithRange(range)
//        range.location = 2
//        let gString = (cString as NSString).substringWithRange(range)
//        range.location = 4
//        let bString = (cString as NSString).substringWithRange(range)
//        
//        var r: UInt32 = 0x0
//        var g: UInt32 = 0x0
//        var b: UInt32 = 0x0
//        NSScanner.init(string: rString).scanHexInt(&r)
//        NSScanner.init(string: gString).scanHexInt(&g)
//        NSScanner.init(string: bString).scanHexInt(&b)
//        
//        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
//        
//    }
}