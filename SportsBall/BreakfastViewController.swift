//
//  BreakfastViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/26.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BreakfastViewController: BallViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate,CartButtonDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var common=CommonParameter()//网络请求
    var betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//0:早盘；1：单式；2：滚球
    var isMultiselect = false//即时下注
    let checkBetResult:String = "CheckBetResult"
    let getFootballMatchResult:String = "GetFootballMatchResult"
    let addBetResult:String = "AddBetResult"
    var alertMenu:UIAlertController!
    var alertCart:UIAlertController!
    var menuArray: Array<Dictionary<String,String>> = [["0":"早盘"],["2":"滚球"],["1":"单式"],["3":"波胆"],["4":"入球数"],["5":"半全场"],["6":"综合过关"]]
    
    //创建玩法菜单
    func createMenu(menuArray: Array<Dictionary<String,String>>){
        if(menuArray.count <= 0){
            return
        }
        alertMenu = UIAlertController(title: "足球玩法", message: "请选取玩法", preferredStyle: UIAlertControllerStyle.Alert)
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
        getFootballMatch()
    }
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        clearAllNotice()
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getFootballMatchResult){//页面首次加载获取资料
            let aryUnionInfo:NSMutableArray = stringToDictionary(strResult)
            addControls(aryUnionInfo, contentView: contentView, mainView: mainView, delegate: self,cartDelegate:self,orderHeight: 216)
        }else if(strType == checkBetResult){//检验选中的赔率是不是最新的
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
        getFootballMatch()
    }
    //标题点击，玩法选取
    func titleViewClick(){
        self.presentViewController(alertMenu, animated: true, completion: nil)
    }
    //联盟打开
    func unionClick(){
        //在XIB的后面加入一个透明的View
        let bottom:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        bottom.backgroundColor = UIColor.blackColor()
        bottom.alpha = 0.8
        
        let myView = NSBundle.mainBundle().loadNibNamed("UnionCustomAlertView", owner: self, options: nil).first as? UnionCustomAlertView
        myView?.frame = CGRect(x: 0, y: 0, width: 350, height: 600)
        myView?.center = self.view.center
        
        if myView != nil {
            self.view.addSubview(bottom)
            myView?.backgroundView = bottom
            self.view.addSubview(myView!)
            self.view.bringSubviewToFront(myView!)
        }
    }
    //规则说明
    func explainClick(){
        
    }
    //清空购物清单
    func cartClear(){
        self.presentViewController(alertCart, animated: true, completion: nil)
    }
    //初始化购物车清空Alert
    func initCartClear(){
        alertCart = UIAlertController(title: "清空提示", message: "是否清除购物车注单？", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "清除", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            let betManger = BetListManager.sharedManager
            betManger.betList.removeAll(keepCapacity: false)
        }
        let ok = UIAlertAction(title: "保存", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertCart.addAction(ok)
        alertCart.addAction(cancel)
    }
    //显示购物车
    func cartShow(){
        if(isMultiselect){
            let betManger = BetListManager.sharedManager
            if(betManger.betList.count > 0){
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewControllerWithIdentifier("ShopingViewController") as! ShopingViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                alertMessage("至少选择一场比赛", carrier: self)
            }
        }
    }
    
    //绑定队伍标题
    func bindMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        bindCommonMatchDelegate(cell,orderCellModel:orderCellModel)
    }
    //添加注单赔率View
    func addOrderDelegate(cell:Cell,orderCellModel:OrderCellModel)->UIView{
        let breakfastView = NSBundle.mainBundle().loadNibNamed("BreakfastView" , owner: nil, options: nil).first as? BreakfastView
        breakfastView!.userInteractionEnabled()
        //加载时赔率是打开的就要立即添加手势事件
        breakfastView!.addGestureRecognizer()
        breakfastView!.delegate = self
        cell.gestureDelegate = breakfastView
        return breakfastView!
    }
    //绑定注单赔率
    func bindorderDelegate(view:UIView,orderCellModel:OrderCellModel){
        let viewTemp:BreakfastView = view as! BreakfastView
        clear(viewTemp)
        showData(viewTemp,orderCellModel:orderCellModel)
        fillBackground(viewTemp,orderCellModel:orderCellModel)
        viewTemp.orderCellModel = orderCellModel
    }
    
    //点击赔率点击事件的协议
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int)->Bool{
        let tempRate = ToolsCode.codeBy(toolsCode)
        let rate = orderCellModel.valueForKey(tempRate)?.floatValue
        if (rate == 0){
            return false
        }
        
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
    
    //注单赋值前清空重用控件
    func clear(view:BreakfastView){
        view.N_LDYPL.text = ""
        view.N_HJPL.text = ""
        view.N_RDYPL.text = ""
        
        view.N_LRFBL.text = ""
        view.N_RRFBL.text = ""
        view.N_LRFPL.text = ""
        view.N_RRFPL.text = ""
        
        view.N_LDXBL.text = ""
        view.N_RDXBL.text = ""
        view.N_DXDPL.text = ""
        view.N_DXXPL.text = ""
        
        
        view.N_LDYPL2.text = ""
        view.N_HJPL2.text = ""
        view.N_RDYPL2.text = ""
        
        view.N_LRFBL2.text = ""
        view.N_RRFBL2.text = ""
        view.N_LRFPL2.text = ""
        view.N_RRFPL2.text = ""
        
        view.N_LDXBL2.text = ""
        view.N_RDXBL2.text = ""
        view.N_DXDPL2.text = ""
        view.N_DXXPL2.text = ""
    }
    //资料的显示
    func showData(view:BreakfastView,orderCellModel:OrderCellModel){
        //全场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellModel.N_DY_OPEN != nil && String(orderCellModel.N_DY_OPEN) != "1"){
            view.N_LDYPL.text = orderCellModel.N_LDYPL != nil ? String(format: "%.3f", orderCellModel.N_LDYPL.floatValue) : ""
            view.N_HJPL.text = orderCellModel.N_HJPL != nil ? String(format: "%.3f", orderCellModel.N_HJPL.floatValue) : ""
            view.N_RDYPL.text = orderCellModel.N_RDYPL != nil ? String(format: "%.3f", orderCellModel.N_RDYPL.floatValue) : ""
        }
        //全场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN != nil && String(orderCellModel.N_RF_OPEN) != "1"){
            if(orderCellModel.N_LET != nil && String(orderCellModel.N_LET) != "1"){
                view.N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                view.N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            view.N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            view.N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //全场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN != nil && String(orderCellModel.N_DX_OPEN) != "1"){
            view.N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_DXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            view.N_DXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        
        
        //半场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellModel.N_DY_OPEN2 != nil && String(orderCellModel.N_DY_OPEN2) != "1"){
            view.N_LDYPL2.text = orderCellModel.N_LDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_LDYPL2.floatValue) : ""
            view.N_HJPL2.text = orderCellModel.N_HJPL2 != nil ? String(format: "%.3f", orderCellModel.N_HJPL2.floatValue) : ""
            view.N_RDYPL2.text = orderCellModel.N_RDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_RDYPL2.floatValue) : ""
        }
        //半场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN2 != nil && String(orderCellModel.N_RF_OPEN2) != "1"){
            if(orderCellModel.N_LET2 != nil && String(orderCellModel.N_LET2) != "1"){
                view.N_LRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }else{
                view.N_RRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }
            view.N_LRFPL2.text = orderCellModel.N_LRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_LRFPL2.floatValue) : ""
            view.N_RRFPL2.text = orderCellModel.N_RRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_RRFPL2.floatValue) : ""
        }
        //半场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN2 != nil && String(orderCellModel.N_DX_OPEN2) != "1"){
            view.N_LDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            view.N_RDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            view.N_DXDPL2.text = orderCellModel.N_DXDPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXDPL2.floatValue) : ""
            view.N_DXXPL2.text = orderCellModel.N_DXXPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXXPL2.floatValue) : ""
        }
    }
    //背景的填充
    func fillBackground(view:BreakfastView,orderCellModel:OrderCellModel){
        ToolsCode.setLblFontBackground(view.N_LDYPL, selected: orderCellModel.N_LDYPL_SEL)
        ToolsCode.setLblFontBackground(view.N_HJPL, selected: orderCellModel.N_HJPL_SEL)
        ToolsCode.setLblFontBackground(view.N_RDYPL, selected: orderCellModel.N_RDYPL_SEL)
        ToolsCode.setBackground(view.L_RFView,select: orderCellModel.N_LRFPL_SEL)
        ToolsCode.setBackground(view.R_RFView,select: orderCellModel.N_RRFPL_SEL)
        ToolsCode.setBackground2(view.N_LDXBLView,select: orderCellModel.N_DXDPL_SEL)
        ToolsCode.setBackground2(view.N_RDXBLView,select: orderCellModel.N_DXXPL_SEL)
        
        ToolsCode.setLblFontBackground(view.N_LDYPL2, selected: orderCellModel.N_LDYPL2_SEL)
        ToolsCode.setLblFontBackground(view.N_HJPL2, selected: orderCellModel.N_HJPL2_SEL)
        ToolsCode.setLblFontBackground(view.N_RDYPL2, selected: orderCellModel.N_RDYPL2_SEL)
        ToolsCode.setBackground(view.L_RFView2,select: orderCellModel.N_LRFPL2_SEL)
        ToolsCode.setBackground(view.R_RFView2,select: orderCellModel.N_RRFPL2_SEL)
        ToolsCode.setBackground2(view.N_LDXBLView2,select: orderCellModel.N_DXDPL2_SEL)
        ToolsCode.setBackground2(view.N_RDXBLView2,select: orderCellModel.N_DXXPL2_SEL)
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
        if(toolsCode>=56661 && toolsCode<=56667){//全场控件
            id = String(orderCellModel.N_ID)
            let1 = String(orderCellModel.N_LET)
            let tempType = ToolsCode.codeByPlayType(toolsCode)
            if (tempType != "DY") && (tempType != "HJ") {
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
        }else if(toolsCode>=56668 && toolsCode<=56674){//半场控件
            id = String(orderCellModel.N_ID2)
            let1 = String(orderCellModel.N_LET2)
            let tempType = ToolsCode.codeByPlayType(toolsCode)
            if (tempType != "DY") && (tempType != "HJ") {
                hfs = String(orderCellModel.valueForKey("N_\(tempType)FS2")!)
                hlx = String(orderCellModel.valueForKey("N_\(tempType)LX2")!)
                hbl = String(orderCellModel.valueForKey("N_\(tempType)BL2")!)
            }
            let tempLRH = ToolsCode.codeByLRH(toolsCode)
            if tempLRH == "L" {
                tid = String(orderCellModel.N_VISIT2)
            }else if tempLRH == "R" {
                tid = String(orderCellModel.N_HOME2)
            }else{
                tid = "0"
            }
            courtType = "2"
        }
        let tempRate = ToolsCode.codeBy(toolsCode)
        
        let betInfo:BetInfoModel = BetInfoModel()//下注model
        betInfo.strUser = "DEMOFZ-0P0P00"//USER??????????????????????????????????????????????????????????????
        betInfo.playType = mPlayType == "2" ? "ZD"+playType : playType
        betInfo.lr = ToolsCode.codeByLRH(toolsCode)
        betInfo.ballType = orderCellModel.N_LX
        betInfo.courtType = courtType
        betInfo.id = id
        betInfo.tid = tid
        betInfo.rate = String(format: "%.3f", (orderCellModel.valueForKey(tempRate)?.floatValue)!)
        //        betInfo.rate = String(orderCellModel.valueForKey(tempRate)!)
        betInfo.vh = String(orderCellModel.N_VH)
        betInfo.strlet = let1
        betInfo.hbl = hbl
        betInfo.hfs = hfs
        betInfo.hlx = hlx
        betInfo.homename = String(orderCellModel.N_HOME_NAME)
        betInfo.visitname = String(orderCellModel.N_VISIT_NAME)
        betInfo.betteamName = betteamName
        betInfo.date = gameDate
        betInfo.dzxx = "10"//USER??????????????????????????????????????????????????????????????
        betInfo.dMoney = "10"
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
            alertView.myView.visit.text = betInfo.visitname + "[主]"
            let isScore = String(betInfoJson[0].objectForKey("isjzf")!)
            if isScore == "1" {
                let score = String(betInfoJson[0].objectForKey("jzf")!)
                let ayrScore = score.componentsSeparatedByString(":")
                alertView.myView.N_VISIT_JZF.text = ayrScore[0]
                alertView.myView.N_HOME_JZF.text = ayrScore[1]
            } else {
                alertView.myView.N_VISIT_JZF.text = ""
                alertView.myView.N_HOME_JZF.text = ""
            }
            alertView.myView.home.text = betInfo.homename
            let newRate = String(betInfoJson[0].objectForKey("newRate")!) as NSString
            let betteamName = String(betInfoJson[0].objectForKey("betteamName")!)
            alertView.myView.betText.text =  betteamName+"  @ "+String(format: "%.3f", newRate.floatValue)
            alertView.myView.rate.text = String(format: "%.3f", newRate.floatValue)
            alertView.myView.limits.text = dzxx + "~" + dzsx
            alertView.myView.max.text = dzsx
        }
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
    
    //取得赛事注单赔率
    func getFootballMatch(){
        if contentView.subviews.count > 0 {
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
//            contentView.subviews[0].removeFromSuperview()
        }
        pleaseWait()
        common.delegate = self
        common.matchingElement = getFootballMatchResult
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>20000</strPageSize>")
        strParam.appendContentsOf("<strUser></strUser>")
        //0:早盘；1：单式；2：滚球
        //        strParam.appendContentsOf("<strType>2</strType>")
        strParam.appendContentsOf("<strType>\(mPlayType)</strType>")
        strParam.appendContentsOf("</GetFootballMatch>")
        common.getResult(strParam,strResultName: getFootballMatchResult)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头部
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView" , owner: nil, options: nil).first as? HeaderView
        headerView?.frame.size.height = 48
        headerView?.delegate = self
        self.headerView.addSubview(headerView!)
        
        createMenu(menuArray)
        initCartClear()
        //赛事资料
        getFootballMatch()
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
