//
//  RollViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewController: UIViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!

    var common=CommonParameter()//网络请求
    var mPlayType = "2"//2：滚球；3：让球、综合过关
    let getOtherMatchResult = "GetOtherMatchResult"
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        clearAllNotice()
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getOtherMatchResult){
            print(strResult)
            let basketInfo:NSMutableArray = Ball().stringToDictionary(strResult)
            Ball().addControls(basketInfo, contentView: contentView, mainView: mainView, delegate: self,orderHeight: 109)
        }
    }
    
    //返回
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //刷新
    func refreshClick(){
        if contentView.subviews.count > 0 {
            contentView.subviews[0].removeFromSuperview()
        }
    }
    //标题点击，玩法选取
    func titleViewClick(){
        
    }
    //联盟打开
    func unionClick(){
        
    }
    //规则说明
    func explainClick(){
        
    }
    
    //绑定队伍标题
    func bindMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        
    }
    //添加注单赔率View
    func addOrderDelegate(cell:Cell,orderCellModel:OrderCellModel)->UIView{
        let rollView = NSBundle.mainBundle().loadNibNamed("RollView" , owner: nil, options: nil).first as? RollView
        rollView!.userInteractionEnabled()
        //加载时赔率是打开的就要立即添加手势事件
        rollView!.addGestureRecognizer()
        rollView!.delegate = self
        rollView!.orderCellModel = orderCellModel
        cell.gestureDelegate = rollView
        return rollView!
    }
    //绑定注单赔率
    func bindorderDelegate(view:UIView,orderCellModel:OrderCellModel){
        let viewTemp:RollView = view as! RollView
        clear(viewTemp)
        showData(viewTemp,orderCellModel:orderCellModel)
        fillBackground(viewTemp,orderCellModel:orderCellModel)
        viewTemp.orderCellModel = orderCellModel
    }
    
    //注单赋值前清空重用控件
    func clear(view:RollView){
        
        view.N_LRFBL.text = ""
        view.N_LRFPL.text = ""
        view.N_RRFBL.text = ""
        view.N_RRFPL.text = ""
        
        view.N_LDXBL.text = ""
        view.N_LDXDPL.text = ""
        view.N_RDXBL.text = ""
        view.N_RDXXPL.text = ""
        
        view.N_RDSSPL.text = ""
        view.N_RDSDPL.text = ""
    }
    
    //资料的显示
    func showData(view:RollView,orderCellModel:OrderCellModel){
        //让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN == nil || String(orderCellModel.N_RF_OPEN) == "0"){
            if(orderCellModel.N_LET == nil || String(orderCellModel.N_LET) == "0"){
                view.N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                view.N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            view.N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            view.N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN == nil || String(orderCellModel.N_DX_OPEN) == "0"){
            view.N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_LDXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            view.N_RDXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        //单双不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DS_OPEN == nil || String(orderCellModel.N_DS_OPEN) == "0"){
            view.N_RDSSPL.text = orderCellModel.N_DSSPL != nil ? String(format: "%.3f", orderCellModel.N_DSSPL.floatValue) : ""
            view.N_RDSDPL.text = orderCellModel.N_DSDPL != nil ? String(format: "%.3f", orderCellModel.N_DSDPL.floatValue) : ""
        }
    }
    
    //背景的填充
    func fillBackground(view:RollView,orderCellModel:OrderCellModel){
        let ball:Ball = Ball()
        ball.setBackground(view.N_LRFBLView,select: orderCellModel.N_LRFPL_SEL)
        ball.setBackground(view.N_RRFBLView,select: orderCellModel.N_RRFPL_SEL)
        
        ball.setBackground2(view.N_LDXBLView,select: orderCellModel.N_DXDPL_SEL)
        ball.setBackground2(view.N_RDXBLView,select: orderCellModel.N_DXXPL_SEL)
        
        ball.setBackground(view.N_LDSBLView,select: orderCellModel.N_RDSSPL_SEL)
        ball.setBackground(view.N_RDSBLView,select: orderCellModel.N_RDSDPL_SEL)
    }
    
    //即时下注付款协议
    func selectOkButtonalertView(){
        pleaseWait()
        print("selectOkButtonalertView")
    }
    //即时下注付款取消协议
    func  selecttCancelButtonAlertView(){
        print("selecttCancelButtonAlertView")
    }
    
    //点击赔率点击事件的协议
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int)->Bool{
        return true
    }
    
    func getOtherMatch(){
        pleaseWait()
        common.delegate = self
        common.matchingElement = getOtherMatchResult
        var strParam:String = "<GetOtherMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>1000</strPageSize>")
        strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
        strParam.appendContentsOf("<strType>3</strType>")
        strParam.appendContentsOf("<strCourtType>1</strCourtType>")
        strParam.appendContentsOf("<strBall>b_bk</strBall>")
        strParam.appendContentsOf("</GetOtherMatch>")
        common.getResult(strParam,strResultName: getOtherMatchResult)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头部
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView" , owner: nil, options: nil).first as? HeaderView
        headerView?.frame.size.height = 48
        headerView?.delegate = self
        self.headerView.addSubview(headerView!)
        
        getOtherMatch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
