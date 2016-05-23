//
//  RollViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewController: BallViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate,CartButtonDelegate,UnionDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var common=CommonParameter()//网络请求
    var betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//2：滚球；3：让球、综合过关
    var mUnionID = ""
    var isMultiselect = false//即时下注
    let checkBetResult:String = "CheckBetResult"
    let getOtherMatchResult:String = "GetOtherMatchResult"
    let addBetResult:String = "AddBetResult"
    var alertMenu:UIAlertController!
    var alertCart:UIAlertController!
    var menuArray: Array<Dictionary<String,String>> = [["2":"滚球"],["3":"让球"],["3":"综合过关"]]
    var orderHeight:CGFloat = 109

    //玩法菜单选项响应事件
    override func clickMenuItem(key:String,value:String){
        mPlayType = key
        mUnionID = ""
        isMultiselect = false
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
            let basketInfo:NSMutableArray = stringToDictionary(strResult)
            addControls(basketInfo, contentView: contentView, mainView: mainView, delegate: self,cartDelegate:self,orderHeight: orderHeight,playType:mPlayType)
        }else if(strType == checkBetResult){
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
        getOtherMatch()
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
        tabBar.selectedIndex = 3
        let helpVC:HelpController = tabBar.viewControllers![3] as! HelpController
        helpVC.loadWebView("rule_lq")
        self.navigationController?.popViewControllerAnimated(true)
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
        getOtherMatch()
    }
    //绑定队伍标题
    func bindMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        bindCommonMatchDelegate(cell,orderCellModel:orderCellModel)
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
        viewTemp.orderCellModel = orderCellModel
        viewTemp.clear()
        viewTemp.showData()
        viewTemp.fillBackground()
    }
    
    //点击赔率点击事件的协议
    func orderClickDelegate(orderCellModel:OrderCellModel,toolsCode: Int)->Bool{
        let tempRate = ToolsCode.codeBy(toolsCode)
        let rate = orderCellModel.valueForKey(tempRate)?.floatValue
        if (rate == 0){
            return false
        }
        
        betInfo = fullBetInfo(orderCellModel,toolsCode:toolsCode)
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
    override func fullBetInfo(orderCellModel:OrderCellModel,toolsCode:Int)->BetInfoModel{
        let betInfo:BetInfoModel = super.fullBetInfo(orderCellModel, toolsCode: toolsCode)
        
        if ((betInfo.playType == "RF") || (betInfo.playType == "DX")) {
            let tempType:String = ToolsCode.codeByPlayType(toolsCode)
            betInfo.score = ToolsCode.getBallHead((orderCellModel.valueForKey("N_\(tempType)FS")?.integerValue)!, bl: (orderCellModel.valueForKey("N_\(tempType)BL")?.integerValue)!, lx: (orderCellModel.valueForKey("N_\(tempType)LX")?.integerValue)!)
        }else{
            betInfo.score = "0"
        }
        return betInfo
    }
    
    func getOtherMatch(){
        pleaseWait()
        common.delegate = self
        common.matchingElement = getOtherMatchResult
        var strParam:String = "<GetOtherMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM>\(mUnionID)</strLM>")
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
        
        alertMenu = createMenu("篮球玩法", message: "请选择玩法", menuArray: menuArray)
        alertCart = initCartClear()
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
