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
    var betInfo:BetInfo = BetInfo()//下注model
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
    var isPass:Bool = false

    //玩法菜单选项响应事件
    override func clickMenuItem(key:String,value:String){
        isPass = false
        isMultiselect = false
        let dics:Dictionary<String,String> = menuArray[3]
        for (keyTemp,valueTemp) in dics {
            if valueTemp == value{
                isPass = true
                isMultiselect = true
            }
        }
        
        mPlayType = key
        mUnionID = ""
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
        if(strType=="Error" && strResult=="WebError"){
            alertMessage("网络错误，请检查网络")
            return
        }
        if(strResult==""){
            alertMessage("系统错误")
            return
        }
//        if(strType == "Error" || strResult == ""){
//            let message = "系统错误！"
//            alertMessage(message)
//            return
//        }
//        if(strType == "WebError" || strResult == "Error"){
//            let message = "网络连接异常!"
//            alertMessage(message)
//            return
//        }
        if(strType == getFootballMatchResult){//页面首次加载获取资料
            let aryUnionInfo:NSMutableArray = stringToDictionary(strResult)
            addControls(aryUnionInfo, contentView: contentView, mainView: mainView, delegate: self,cartDelegate:self,orderHeight: orderHeight,playType:mPlayType,isPass: isPass)
        }else if(strType == checkBetResult){//检验选中的赔率是不是最新的
            let betInfoJson = ToolsCode.toJsonArray("[\(strResult)]")
            fullBetInfo2(betInfoJson, betInfo: betInfo, alertView: alertView, isMultiselect: isMultiselect)
        }else if(strType == addBetResult){
            let resultJson = ToolsCode.toJsonArray("[\(strResult)]")
            let message = String(resultJson[0].objectForKey("sErroMessage")!)
            alertMessage(message)
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
        let navigationViews = self.navigationController!.viewControllers
        let tabBar:UITabBarController = navigationViews[navigationViews.count - 2] as! UITabBarController
        tabBar.selectedIndex = 4
        let helpVC:HelpController = tabBar.viewControllers![4] as! HelpController
        helpVC.loadWebView("rule_zq")
        self.navigationController?.popViewControllerAnimated(true)
    }
    //清空购物清单
    func cartClear(){
        self.presentViewController(alertCart, animated: true, completion: nil)
    }
    //显示购物车
    func cartShow(){
        if(isMultiselect && isPass == false){
            showCart()
        } else if(isMultiselect && isPass == true){
            showPassCart()
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
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int,isSel: Bool)->Bool{
        let tempRate = ToolsCode.codeBy(toolsCode)
        let rate = orderCellModel.valueForKey(tempRate)?.floatValue
        if (rate == 0){
            return false
        }
        if isSel {
            cleanOdds(orderCellModel,toolsCode: toolsCode)
            return isMultiselect
        }
        
        betInfo = fullBetInfo(orderCellModel,toolsCode:toolsCode)
        if(isMultiselect){
            if isPass {
                onlySelect(betInfo)
            }
            checkBet(betInfo)//检验选取的赔率是不是最新的
        }else{
            checkBet(betInfo)//检验选取的赔率是不是最新的
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
    }
    
    //即时/复合下注选择改变事件
    func segmentChange(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0 :
            isMultiselect = false
            clearAllOdds()
        case 1 :
            isMultiselect = true
        default:
            print("defaul")
        }
    }
    
    func setLr(betInfo:BetInfo,lr:String,playType:String,ballhead:String){
        betInfo.ballhead = ballhead
        betInfo.playType = playType
        betInfo.lr = lr
    }
    //第一次填入BetInfoModel属性用于检验最新赔率，检验完成才有其他属性
    override func fullBetInfo(orderCellModel:OrderCellModel,toolsCode:Int)->BetInfo{
        var betInfo:BetInfo = super.fullBetInfo(orderCellModel, toolsCode: toolsCode)
        if (mPlayType == "0" || mPlayType == "1") {//早盘/单式
            
        } else if (mPlayType == "2") {//滚球
            betInfo.playType = "ZD" + betInfo.playType
        } else if (mPlayType == "3") {//综合过关
            if (betInfo.playType == "DS") {
                let tempBetName = ToolsCode.codeByLRH(toolsCode)
                if (tempBetName == "L") {
                    betInfo.betteamName = "单"
                } else {
                    betInfo.betteamName = "双"
                }
            }
        } else if (mPlayType == "4") {//波胆
            switch(toolsCode){
            case ToolsCode.BDZPL10View:
                setLr(betInfo,lr:"Z",playType:"BD10",ballhead:"1:0")
            case ToolsCode.BDZPL20View:
                setLr(betInfo,lr:"Z",playType:"BD20",ballhead:"2:0")
            case ToolsCode.BDZPL21View:
                setLr(betInfo,lr:"Z",playType:"BD21",ballhead:"2:1")
            case ToolsCode.BDZPL30View:
                setLr(betInfo,lr:"Z",playType:"BD30",ballhead:"3:0")
            case ToolsCode.BDZPL31View:
                setLr(betInfo,lr:"Z",playType:"BD31",ballhead:"3:1")
            case ToolsCode.BDZPL32View:
                setLr(betInfo,lr:"Z",playType:"BD32",ballhead:"3:2")
            case ToolsCode.BDZPL40View:
                setLr(betInfo,lr:"Z",playType:"BD40",ballhead:"4:0")
            case ToolsCode.BDZPL41View:
                setLr(betInfo,lr:"Z",playType:"BD41",ballhead:"4:1")
            case ToolsCode.BDZPL42View:
                setLr(betInfo,lr:"Z",playType:"BD42",ballhead:"4:2")
            case ToolsCode.BDZPL43View:
                setLr(betInfo,lr:"Z",playType:"BD43",ballhead:"4:3")
                
            case ToolsCode.BDKPL10View:
                setLr(betInfo,lr:"K",playType:"BD01",ballhead:"0:1")
            case ToolsCode.BDKPL20View:
                setLr(betInfo,lr:"K",playType:"BD02",ballhead:"0:2")
            case ToolsCode.BDKPL21View:
                setLr(betInfo,lr:"K",playType:"BD12",ballhead:"1:2")
            case ToolsCode.BDKPL30View:
                setLr(betInfo,lr:"K",playType:"BD03",ballhead:"0:3")
            case ToolsCode.BDKPL31View:
                setLr(betInfo,lr:"K",playType:"BD13",ballhead:"1:3")
            case ToolsCode.BDKPL32View:
                setLr(betInfo,lr:"K",playType:"BD23",ballhead:"2:3")
            case ToolsCode.BDKPL40View:
                setLr(betInfo,lr:"K",playType:"BD04",ballhead:"0:4")
            case ToolsCode.BDKPL41View:
                setLr(betInfo,lr:"K",playType:"BD14",ballhead:"1:4")
            case ToolsCode.BDKPL42View:
                setLr(betInfo,lr:"K",playType:"BD24",ballhead:"2:4")
            case ToolsCode.BDKPL43View:
                setLr(betInfo,lr:"K",playType:"BD34",ballhead:"3:4")
                
            case ToolsCode.BDGPL00View:
                setLr(betInfo,lr:"G",playType:"BD00",ballhead:"0:0")
            case ToolsCode.BDGPL11View:
                setLr(betInfo,lr:"G",playType:"BD11",ballhead:"1:1")
            case ToolsCode.BDGPL22View:
                setLr(betInfo,lr:"G",playType:"BD22",ballhead:"2:2")
            case ToolsCode.BDGPL33View:
                setLr(betInfo,lr:"G",playType:"BD33",ballhead:"3:3")
            case ToolsCode.BDGPL44View:
                setLr(betInfo,lr:"G",playType:"BD44",ballhead:"4:4")
                
            case ToolsCode.BDZPL5View:
                setLr(betInfo,lr:"Z",playType:"BD5",ballhead:"5:")
            default:
                setLr(betInfo,lr:"",playType:"",ballhead:"")
            }
            if betInfo.lr == "Z" {
                betInfo.tid = String(orderCellModel.N_VISIT)
                betInfo.betteamName = orderCellModel.N_VISIT_NAME
            }else if betInfo.lr == "K" {
                betInfo.tid = String(orderCellModel.N_HOME)
                betInfo.betteamName = orderCellModel.N_HOME_NAME
            }else if betInfo.lr == "G" {
                betInfo.tid = String(orderCellModel.N_VISIT)
            }
            if betInfo.playType == "5" {
                betInfo.tid = String(orderCellModel.N_VISIT)
                betInfo.betteamName = orderCellModel.N_VISIT_NAME
            }
        } else if (mPlayType == "5") {//半全场
            switch(toolsCode){
            case ToolsCode.BQCZZView:
                setLr(betInfo,lr:"ZZ",playType:"BQCZZ",ballhead:"主/主")
            case ToolsCode.BQCZHView:
                setLr(betInfo,lr:"ZH",playType:"BQCZH",ballhead:"主/和")
            case ToolsCode.BQCZKView:
                setLr(betInfo,lr:"ZK",playType:"BQCZK",ballhead:"主/客")
            case ToolsCode.BQCHZView:
                setLr(betInfo,lr:"HZ",playType:"BQCHZ",ballhead:"和/主")
            case ToolsCode.BQCHHView:
                setLr(betInfo,lr:"HH",playType:"BQCHH",ballhead:"和/和")
            case ToolsCode.BQCHKView:
                setLr(betInfo,lr:"HK",playType:"BQCHK",ballhead:"和/客")
            case ToolsCode.BQCKZView:
                setLr(betInfo,lr:"KZ",playType:"BQCKZ",ballhead:"客/主")
            case ToolsCode.BQCKHView:
                setLr(betInfo,lr:"KH",playType:"BQCKH",ballhead:"客/和")
            case ToolsCode.BQCKKView:
                setLr(betInfo,lr:"KK",playType:"BQCKK",ballhead:"客/客")
            default:
                setLr(betInfo,lr:"",playType:"",ballhead:"")
            }
            betInfo.betteamName = orderCellModel.N_VISIT_NAME
        } else{//入球数
            betInfo.tid = "0"
            betInfo.betteamName = orderCellModel.N_VISIT_NAME
            switch(toolsCode){
            case ToolsCode.DSSPLView:
                setLr(betInfo,lr:"S",playType:"RQSS",ballhead:"s")
            case ToolsCode.DSDPLView:
                setLr(betInfo,lr:"D",playType:"RQSD",ballhead:"d")
            case ToolsCode.RQSPL01View:
                setLr(betInfo,lr:"0-1",playType:"RQS01",ballhead:"0-1")
            case ToolsCode.RQSPL23View:
                setLr(betInfo,lr:"2-3",playType:"RQS23",ballhead:"2-3")
            case ToolsCode.RQSPL46View:
                setLr(betInfo,lr:"4-6",playType:"RQS46",ballhead:"4-6")
            case ToolsCode.RQSPL7View:
                setLr(betInfo,lr:"7",playType:"RQS7",ballhead:">=7")
            default:
                setLr(betInfo,lr:"",playType:"",ballhead:"")
            }
        }
        return betInfo
    }
    
    //向远端添加注单
    func AddBet(){
        common.matchingElement = addBetResult
        var strParam:String = "<AddBet xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strpara>\(betInfo.toString())</strpara>")
        strParam.appendContentsOf("</AddBet>")
        common.getResult(strParam,strResultName: addBetResult)
    }
    
    //检验赔率是不是最新的
    func checkBet(betInfo:BetInfo){
        let user:UserInfoManager = UserInfoManager.sharedManager
        common.matchingElement = checkBetResult
        var strParam:String = "<CheckBet xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strUser>\(user.getUserID())</strUser>")
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
        if !isMultiselect {
            common.getResult(strParam,strResultName: checkBetResult)
        }else {
            common.getSynchronousRequest(strParam,strResultName: checkBetResult)
        }
    }
    
    //取得赛事注单赔率
    func getFootballMatch(){
        pleaseWait()
        let user:UserInfoManager = UserInfoManager.sharedManager
        common.delegate = self
        common.matchingElement = getFootballMatchResult
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM>\(mUnionID)</strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>20000</strPageSize>")
        strParam.appendContentsOf("<strUser>\(user.getUserID())</strUser>")
        strParam.appendContentsOf("<strType>\(mPlayType)</strType>")
        strParam.appendContentsOf("</GetFootballMatch>")
        common.getResult(strParam,strResultName: getFootballMatchResult)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头部
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView" , owner: nil, options: nil).first as? HeaderView
        headerView?.frame.size.height = 42
        headerView?.delegate = self
        self.headerView.addSubview(headerView!)
        
        initView(mPlayType)
        
        alertMenu = createMenu("足球玩法", message: "请选择玩法", menuArray: menuArray)
        alertCart = initCartClear()
        //赛事资料
        getFootballMatch()
    }
    
    func initView(playType:String){
        let view:HeaderView = headerView.subviews[0] as! HeaderView
        for array in menuArray{
            let dics:Dictionary<String,String> = array
            for (keyTemp,valueTemp) in dics{
                if playType == keyTemp{
                    view.btnTitle.setTitle(valueTemp, forState: UIControlState.Normal)
                }
            }
        }
    }
    
    //刷新tableView
    override func viewDidAppear(animated: Bool) {
        if contentView.subviews.count == 2 {
            let tableView:TableView = self.mContentView.subviews[1] as! TableView
            tableView.reloadData()
        }
    }
}
