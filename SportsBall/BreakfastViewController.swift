//
//  BreakfastViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/26.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BreakfastViewController: BallViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate,CartButtonDelegate,UnionDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var common=CommonParameter()//网络请求
    var betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//0:早盘；1：单式；2：滚球
    var mUnionID = ""
    var isMultiselect = false//即时下注
    let checkBetResult:String = "CheckBetResult"
    let getFootballMatchResult:String = "GetFootballMatchResult"
    let addBetResult:String = "AddBetResult"
    var alertMenu:UIAlertController!
    var alertCart:UIAlertController!
    var menuArray: Array<Dictionary<String,String>> = [["0":"早盘"],["1":"单式"],["2":"滚球"],["3":"综合过关"],["4":"波胆"],["5":"半全场"],["6":"入球数"]]
    var orderHeight:CGFloat = 216

    //玩法菜单选项响应事件
    override func clickMenuItem(key:String,value:String){
        mPlayType = key
        mUnionID = ""
        isMultiselect = false
        let view:HeaderView = headerView.subviews[0] as! HeaderView
        view.btnTitle.setTitle(value, forState: UIControlState.Normal)
        if (mPlayType == "0" || mPlayType == "1" || mPlayType == "2") {//早盘/单式/滚球
            orderHeight = 216
        } else if (mPlayType == "3") {//综合过关
            orderHeight = 131
        } else if (mPlayType == "4") {//波胆
            orderHeight = 192
        } else if (mPlayType == "5") {//半全场
            orderHeight = 101
        } else{//入球数
            orderHeight = 60
        }
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
            addControls(aryUnionInfo, contentView: contentView, mainView: mainView, delegate: self,cartDelegate:self,orderHeight: orderHeight,playType:mPlayType)
        }else if(strType == checkBetResult){//检验选中的赔率是不是最新的
            let betInfoJson = ToolsCode.toJsonArray("[\(strResult)]")
            fullBetInfo2(betInfoJson, betInfo: betInfo, alertView: alertView, isMultiselect: isMultiselect)
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
        showUnion(self)
    }
    //规则说明
    func explainClick(){
        
    }
    //清空购物清单
    func cartClear(){
        self.presentViewController(alertCart, animated: true, completion: nil)
    }
    //显示购物车
    func cartShow(){
        if(isMultiselect){
            showCart()
        }
    }
    //联盟选择
    func unionClickDelegate(keys:String){
        mUnionID = keys
        getFootballMatch()
    }
    //绑定队伍标题
    func bindMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        bindCommonMatchDelegate(cell,orderCellModel:orderCellModel)
    }
    //添加注单赔率View
    func addOrderDelegate(cell:Cell,orderCellModel:OrderCellModel)->UIView{
        var orderView:OrderView
        if (mPlayType == "0" || mPlayType == "1" || mPlayType == "2") {//早盘/单式/滚球
            orderView = (NSBundle.mainBundle().loadNibNamed("BreakfastView" , owner: nil, options: nil).first as? BreakfastView)!
        } else if (mPlayType == "3") {//综合过关
            orderView = (NSBundle.mainBundle().loadNibNamed("PassView" , owner: nil, options: nil).first as? PassView)!
        } else if (mPlayType == "4") {//波胆
            orderView = (NSBundle.mainBundle().loadNibNamed("FluctuantView" , owner: nil, options: nil).first as? FluctuantView)!
        } else if (mPlayType == "5") {//半全场
            orderView = (NSBundle.mainBundle().loadNibNamed("FieldView" , owner: nil, options: nil).first as? FieldView)!
        } else{//入球数
            orderView = (NSBundle.mainBundle().loadNibNamed("GoalsView" , owner: nil, options: nil).first as? GoalsView)!
        }
        orderView.userInteractionEnabled()
        //加载时赔率是打开的就要立即添加手势事件
        orderView.addGestureRecognizer()
        orderView.delegate = self
        cell.gestureDelegate = orderView
        return orderView
    }
    //绑定注单赔率
    func bindorderDelegate(view:UIView,orderCellModel:OrderCellModel){
        var orderView:OrderView
        if (mPlayType == "0" || mPlayType == "1" || mPlayType == "2") {//早盘/单式/滚球
            let orderViewTemp = view as! BreakfastView
            orderViewTemp.orderCellModel = orderCellModel
            orderView = orderViewTemp
        } else if (mPlayType == "3") {//综合过关
            let orderViewTemp = view as! PassView
            orderViewTemp.orderCellModel = orderCellModel
            orderView = orderViewTemp
        } else if (mPlayType == "4") {//波胆
            let orderViewTemp = view as! FluctuantView
            orderViewTemp.orderCellModel = orderCellModel
            orderView = orderViewTemp
        } else if (mPlayType == "5") {//半全场
            let orderViewTemp = view as! FieldView
            orderViewTemp.orderCellModel = orderCellModel
            orderView = orderViewTemp
        } else{//入球数
            let orderViewTemp = view as! GoalsView
            orderViewTemp.orderCellModel = orderCellModel
            orderView = orderViewTemp
        }
        orderView.clear()
        orderView.showData()
        orderView.fillBackground()
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
        if(toolsCode>=56668 && toolsCode<=56674){//半场控件
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
        betInfo.playType = mPlayType == "2" ? "ZD"+playType : playType
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
        pleaseWait()
        common.delegate = self
        common.matchingElement = getFootballMatchResult
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM>\(mUnionID)</strLM>")
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
        
        alertMenu = createMenu("足球玩法", message: "请选择玩法", menuArray: menuArray)
        alertCart = initCartClear()
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
