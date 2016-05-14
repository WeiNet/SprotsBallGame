//
//  RollViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewController: UIViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate,CartButtonDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var common=CommonParameter()//网络请求
    var betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//2：滚球；3：让球、综合过关
    let checkBetResult:String = "CheckBetResult"
    let getOtherMatchResult = "GetOtherMatchResult"
    let addBetResult:String = "AddBetResult"
    var isMultiselect = false//即时下注
    var orderHeight:CGFloat = 109
    var alertMenu:UIAlertController!
    var menuArray: Array<Dictionary<String,String>> = [["2":"滚球"],["3":"让球"],["3":"综合过关"]]
    
    //创建玩法菜单
    func createMenu(menuArray: Array<Dictionary<String,String>>){
        if(menuArray.count <= 0){
            return
        }
        alertMenu = UIAlertController(title: "蓝球玩法", message: "请选取玩法", preferredStyle: UIAlertControllerStyle.Alert)
        for menu in menuArray {
            for (key,value) in menu {
                let item = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    self.clickMenuItem(key, value: value)
                })
                alertMenu.addAction(item)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertMenu.addAction(cancel)
    }
    //玩法菜单选项响应事件
    func clickMenuItem(key:String,value:String){
        mPlayType = key
        let view:HeaderView = headerView.subviews[0] as! HeaderView
        view.btnTitle.setTitle(value, forState: UIControlState.Normal)
        getOtherMatch()
    }
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        clearAllNotice()
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getOtherMatchResult){
            if(mPlayType == "2"){
                orderHeight = 72
            }else{
                orderHeight = 109
            }
            let basketInfo:NSMutableArray = Ball().stringToDictionary(strResult)
            Ball().addControls(basketInfo, contentView: contentView, mainView: mainView, delegate: self,cartDelegate:self,orderHeight: orderHeight)
        }else if(strType == checkBetResult){
            let betInfoJson = ToolsCode.toJsonArray("[\(strResult)]")
            fullBetInfo2(betInfoJson)
        }else if(strType == addBetResult){
            let resultJson = ToolsCode.toJsonArray("[\(strResult)]")
            let message = String(resultJson[0].objectForKey("sErroMessage")!)
            alertMessage(message, carrier: self)
        }
    }
    
    //返回
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //刷新
    func refreshClick(){
        getOtherMatch()
    }
    //标题点击，玩法选取
    func titleViewClick(){
        self.presentViewController(alertMenu, animated: true, completion: nil)
    }
    //联盟打开
    func unionClick(){
        let myView = NSBundle.mainBundle().loadNibNamed("UnionCustomAlertView", owner: self, options: nil).first as? UnionCustomAlertView
        myView?.frame = CGRect(x: 0, y: 0, width: 350, height: 600)
        myView?.center = self.view.center
        
        if myView != nil {
            self.view.addSubview(myView!)
            self.view.bringSubviewToFront(myView!)
        }
    }
    //规则说明
    func explainClick(){
        
    }
    
    //绑定队伍标题
    func bindMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        Ball().bindMatchDelegate(cell,orderCellModel:orderCellModel)
        if(mPlayType == "2"){
            let gameDate = orderCellModel.N_ZDUPTIME
            cell.N_GAMEDATE.text = ToolsCode.formatterDate(gameDate,format: "MM/dd HH:mm")
            cell.N_VISIT_JZF.text = ""
            cell.N_HOME_JZF.text = ""
        }
    }
    //添加注单赔率View
    func addOrderDelegate(cell:Cell,orderCellModel:OrderCellModel)->UIView{
        let rollView = NSBundle.mainBundle().loadNibNamed("RollView" , owner: nil, options: nil).first as? RollView
        rollView!.userInteractionEnabled()
        //加载时赔率是打开的就要立即添加手势事件
        rollView!.addGestureRecognizer()
        rollView!.delegate = self
        rollView!.orderCellModel = orderCellModel
        rollView?.frame.size.width = contentView.frame.size.width
        cell.gestureDelegate = rollView
        if(mPlayType == "2"){
            rollView?.belowView.removeFromSuperview()
        }
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
        if(orderCellModel.N_RF_OPEN != nil && String(orderCellModel.N_RF_OPEN) != "1"){
            if(String(orderCellModel.N_LET) != "1"){
                view.N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                view.N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            view.N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            view.N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN != nil && String(orderCellModel.N_DX_OPEN) != "1"){
            view.N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_LDXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            view.N_RDXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        //单双不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DS_OPEN != nil && String(orderCellModel.N_DS_OPEN) != "1"){
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
    
    //即时/复合下注选择改变事件
    func segmentChange(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0 :
            isMultiselect = false
        case 1 :
            isMultiselect = true
        default:
            print("default")
        }
    }
    
    //第一次填入BetInfoModel属性用于检验最新赔率，检验完成才有其他属性
    func fullBetInfo1(orderCellModel:OrderCellModel,toolsCode:Int)->BetInfoModel{
        let playType:String = ToolsCode.codeByPlayType(toolsCode)
        var tid:String!
        var hfs:String = "0"//赌赢为0
        var hlx:String = "0"
        var hbl:String = "0"
        let tempRate = ToolsCode.codeBy(toolsCode)
        
        let tempLRH = ToolsCode.codeByLRH(toolsCode)
        if tempLRH == "L" {
            tid = String(orderCellModel.N_VISIT)
        }else if tempLRH == "R" {
            tid = String(orderCellModel.N_HOME)
        }
        let tempType = ToolsCode.codeByPlayType(toolsCode)
        if (tempType != "DY") && (tempType != "H") {
            hfs = String(orderCellModel.valueForKey("N_\(tempType)FS")!)
            hlx = String(orderCellModel.valueForKey("N_\(tempType)LX")!)
            hbl = String(orderCellModel.valueForKey("N_\(tempType)BL")!)
        }
        var gameDate:String = orderCellModel.N_GAMEDATE
        gameDate = ToolsCode.formatterDate(gameDate, format: "yyyy/MM/dd")
        var betteamName:String!
        let tempBetName = ToolsCode.codeByLRH(toolsCode)
        if tempBetName == "L" {
            betteamName = String(orderCellModel.N_VISIT_NAME)
        }else if tempBetName == "R" {
            betteamName = String(orderCellModel.N_HOME_NAME)
        }
        if playType == "DX"{
            betteamName = tempBetName == "L" ? "大" : "小"
        }
        
        let betInfo:BetInfoModel = BetInfoModel()//下注model
        betInfo.strUser = "DEMOFZ-0P0P00"//USER??????????????????????????????????????????????????????????????
        betInfo.playType = mPlayType == "2" ? "ZD"+playType : playType
        betInfo.lr = ToolsCode.codeByLRH(toolsCode)
        betInfo.ballType = orderCellModel.N_LX
        betInfo.courtType = "1"
        betInfo.id = String(orderCellModel.N_ID)
        betInfo.tid = tid
        betInfo.rate = String(format: "%.3f", (orderCellModel.valueForKey(tempRate)?.floatValue)!)
        betInfo.vh = String(orderCellModel.N_VH)
        betInfo.strlet = String(orderCellModel.N_LET)
        betInfo.hbl = hbl
        betInfo.hfs = hfs
        betInfo.hlx = hlx
        betInfo.homename = String(orderCellModel.N_HOME_NAME)
        betInfo.visitname = String(orderCellModel.N_VISIT_NAME)
        betInfo.betteamName = betteamName
        betInfo.date = gameDate
        betInfo.dzxx = "10"//USER??????????????????????????????????????????????????????????????
        betInfo.dMoney = "10"
        betInfo.score = ToolsCode.getBallHead((orderCellModel.valueForKey("N_\(tempType)FS")?.integerValue)!, bl: (orderCellModel.valueForKey("N_\(tempType)BL")?.integerValue)!, lx: (orderCellModel.valueForKey("N_\(tempType)LX")?.integerValue)!)
        return betInfo
    }
    
    
    //第二次设定BetInfo属性，主要填入限额等
    func fullBetInfo2(betInfoJson:AnyObject){
        betInfo.isLive = String(betInfoJson[0].objectForKey("isLive")!)
        betInfo.yssj = String(betInfoJson[0].objectForKey("yssj")!)
        betInfo.isjzf = String(betInfoJson[0].objectForKey("isjzf")!)
        betInfo.jzf = String(betInfoJson[0].objectForKey("jzf")!)
        betInfo.allianceName = String(betInfoJson[0].objectForKey("allianceName")!)
        let dzxx = String(betInfoJson[0].objectForKey("dzxx")!)
        betInfo.dzxx = dzxx
        let dzsx = String(betInfoJson[0].objectForKey("dzsx")!)
        betInfo.dzsx = dzsx
        betInfo.dcsx = String(betInfoJson[0].objectForKey("dcsx")!)
        //        betInfo.courtType = String(betInfoJson[0].objectForKey("courtType")!)
        if(!isMultiselect){
            alertView.myView.visit.text = betInfo.visitname
            alertView.myView.home.text = betInfo.homename
            let newRate = String(betInfoJson[0].objectForKey("newRate")!) as NSString
            alertView.myView.rate.text = String(format: "%.3f", newRate.floatValue)
            alertView.myView.limits.text = dzxx + "~" + dzsx
            alertView.myView.max.text = dzsx
        }
    }
    
    //即时下注付款协议
    func selectOkButtonalertView(){
        pleaseWait()
        betInfo.dMoney = alertView.myView.money.text!
        AddBet()
    }
    //即时下注付款取消协议
    func  selecttCancelButtonAlertView(){
        print("selecttCancelButtonAlertView")
    }
    
    //点击赔率点击事件的协议
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int)->Bool{
        betInfo = fullBetInfo1(orderCellModel,toolsCode:toolsCode)
        checkBet(betInfo)//检验选取的赔率是不是最新的
        if(isMultiselect){
            let betManger = BetListManager.sharedManager
            let objInfo = betInfo
            betManger.betList.append(objInfo)
        }else{
            alertView.show(self)//显示即时下注popuWin
        }
        return isMultiselect
    }
    
    func getOtherMatch(){
        if contentView.subviews.count > 0 {
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
//            contentView.subviews[0].removeFromSuperview()
        }
        pleaseWait()
        common.delegate = self
        common.matchingElement = getOtherMatchResult
        var strParam:String = "<GetOtherMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>1000</strPageSize>")
        strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
        strParam.appendContentsOf("<strType>\(mPlayType)</strType>")
        strParam.appendContentsOf("<strCourtType>1</strCourtType>")
        strParam.appendContentsOf("<strBall>b_bk</strBall>")
        strParam.appendContentsOf("</GetOtherMatch>")
        common.getResult(strParam,strResultName: getOtherMatchResult)
    }
    
    //检验赔率是不是最新的
    func checkBet(betInfo:BetInfoModel){
        common.matchingElement = checkBetResult
        var strParam:String = "<CheckBet xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
        strParam.appendContentsOf("<lr>\(betInfo.lr)</lr>")
        strParam.appendContentsOf("<ballType>\(betInfo.ballType)</ballType>")
        strParam.appendContentsOf("<playType>\(betInfo.playType)</playType>")
        strParam.appendContentsOf("<id>\(betInfo.id)</id>")
        strParam.appendContentsOf("<tid>\(betInfo.tid)</tid>")
        strParam.appendContentsOf("<rate>\(betInfo.rate)</rate>")
        strParam.appendContentsOf("<vh>\(betInfo.vh)</vh>")
        strParam.appendContentsOf("<let>\(betInfo.strlet)</let>")
        strParam.appendContentsOf("<hfs>\(betInfo.hfs)</hfs>")
        strParam.appendContentsOf("<hlx>\(betInfo.hlx)</hlx>")
        strParam.appendContentsOf("<hbl>\(betInfo.hbl)</hbl>")
        strParam.appendContentsOf("</CheckBet>")
        common.getResult(strParam,strResultName: checkBetResult)
    }
    
    //向远端添加注单
    func AddBet(){
        common.matchingElement = addBetResult
        var strParam:String = "<AddBet xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strpara>\(betInfo.toString())</strpara>")
        print(betInfo.toString())
        strParam.appendContentsOf("</AddBet>")
        common.getResult(strParam,strResultName: addBetResult)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头部
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView" , owner: nil, options: nil).first as? HeaderView
        headerView?.frame.size.height = 48
        headerView?.delegate = self
        self.headerView.addSubview(headerView!)
        
        createMenu(menuArray)
        //赛事资料
        getOtherMatch()
    }
    
    //ios隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        return true
    }
    //ios隐藏导航栏
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}
