//
//  BreakfastViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/26.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BreakfastViewController: UIViewController,ResultDelegate,HeaderViewDelegate,BindDelegate,OrderDelegate,SwiftCustomAlertViewDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var common=CommonParameter()//网络请求
    var betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//0:早盘；1：单式；2：滚球
    let checkBetResult:String = "CheckBetResult"
    let getFootballMatchResult:String = "GetFootballMatchResult"
    let addBetResult:String = "AddBetResult"
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        clearAllNotice()
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getFootballMatchResult){//页面首次加载获取资料
            let aryUnionInfo:NSMutableArray = Ball().stringToDictionary(strResult)
            Ball().addControls(aryUnionInfo, contentView: contentView, mainView: mainView, delegate: self,orderHeight: 216)
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
        if contentView.subviews.count > 0 {
            contentView.subviews[0].removeFromSuperview()
        }
        getFootballMatch()
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
        //绑定注单标题资料
        Ball().bindMatchDelegate(cell,orderCellModel:orderCellModel)
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
        betInfo = fullBetInfo1(orderCellModel,toolsCode:toolsCode)
        checkBet(betInfo)//检验选取的赔率是不是最新的
        
        var betManger=BetListManager.sharedManager
        var objInfo = betInfo
        betManger.betList.append(objInfo)
        
        alertView.show(self)//显示即时下注popuWin
        return false
    }
    
    //即时下注付款协议
    func selectOkButtonalertView(){
        pleaseWait()
        betInfo.dMoney = alertView.myView.money.text!
        AddBet()
        print("selectOkButtonalertView")
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
        if (orderCellModel.N_DY_OPEN == nil || String(orderCellModel.N_DY_OPEN) == "0"){
            view.N_LDYPL.text = orderCellModel.N_LDYPL != nil ? String(format: "%.3f", orderCellModel.N_LDYPL.floatValue) : ""
            view.N_HJPL.text = orderCellModel.N_HJPL != nil ? String(format: "%.3f", orderCellModel.N_HJPL.floatValue) : ""
            view.N_RDYPL.text = orderCellModel.N_RDYPL != nil ? String(format: "%.3f", orderCellModel.N_RDYPL.floatValue) : ""
        }
        //全场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN == nil || String(orderCellModel.N_RF_OPEN) == "0"){
            if(orderCellModel.N_LET == nil || String(orderCellModel.N_LET) == "0"){
                view.N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }else{
                view.N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS), bl: Int(orderCellModel.N_RFBL), lx: Int(orderCellModel.N_RFLX))
            }
            view.N_LRFPL.text = orderCellModel.N_LRFPL != nil ? String(format: "%.3f", orderCellModel.N_LRFPL.floatValue) : ""
            view.N_RRFPL.text = orderCellModel.N_RRFPL != nil ? String(format: "%.3f", orderCellModel.N_RRFPL.floatValue) : ""
        }
        //全场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN == nil || String(orderCellModel.N_DX_OPEN) == "0"){
            view.N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS), bl: Int(orderCellModel.N_DXBL), lx: Int(orderCellModel.N_DXLX))
            view.N_DXDPL.text = orderCellModel.N_DXDPL != nil ? String(format: "%.3f", orderCellModel.N_DXDPL.floatValue) : ""
            view.N_DXXPL.text = orderCellModel.N_DXXPL != nil ? String(format: "%.3f", orderCellModel.N_DXXPL.floatValue) : ""
        }
        
        //半场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellModel.N_DY_OPEN2 == nil || String(orderCellModel.N_DY_OPEN2) == "0"){
            view.N_LDYPL2.text = orderCellModel.N_LDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_LDYPL2.floatValue) : ""
            view.N_HJPL2.text = orderCellModel.N_HJPL2 != nil ? String(format: "%.3f", orderCellModel.N_HJPL2.floatValue) : ""
            view.N_RDYPL2.text = orderCellModel.N_RDYPL2 != nil ? String(format: "%.3f", orderCellModel.N_RDYPL2.floatValue) : ""
        }
        //半场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_RF_OPEN2 == nil || String(orderCellModel.N_RF_OPEN2) == "0"){
            if(orderCellModel.N_LET2 == nil || String(orderCellModel.N_LET2) == "0"){
                view.N_LRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }else{
                view.N_RRFBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_RFFS2), bl: Int(orderCellModel.N_RFBL2), lx: Int(orderCellModel.N_RFLX2))
            }
            view.N_LRFPL2.text = orderCellModel.N_LRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_LRFPL2.floatValue) : ""
            view.N_RRFPL2.text = orderCellModel.N_RRFPL2 != nil ? String(format: "%.3f", orderCellModel.N_RRFPL2.floatValue) : ""
        }
        //半场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellModel.N_DX_OPEN2 == nil || String(orderCellModel.N_DX_OPEN2) == "0"){
            view.N_LDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            view.N_RDXBL2.text = ToolsCode.getBallHead(Int(orderCellModel.N_DXFS2), bl: Int(orderCellModel.N_DXBL2), lx: Int(orderCellModel.N_DXLX2))
            view.N_DXDPL2.text = orderCellModel.N_DXDPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXDPL2.floatValue) : ""
            view.N_DXXPL2.text = orderCellModel.N_DXXPL2 != nil ? String(format: "%.3f", orderCellModel.N_DXXPL2.floatValue) : ""
        }
    }
    //背景的填充
    func fillBackground(view:BreakfastView,orderCellModel:OrderCellModel){
        let ball:Ball = Ball()
        ball.setLblFontBackground(view.N_LDYPL, selected: orderCellModel.N_LDYPL_SEL)
        ball.setLblFontBackground(view.N_HJPL, selected: orderCellModel.N_HJPL_SEL)
        ball.setLblFontBackground(view.N_RDYPL, selected: orderCellModel.N_RDYPL_SEL)
        ball.setBackground(view.L_RFView,select: orderCellModel.N_LRFPL_SEL)
        ball.setBackground(view.R_RFView,select: orderCellModel.N_RRFPL_SEL)
        ball.setBackground2(view.N_LDXBLView,select: orderCellModel.N_DXDPL_SEL)
        ball.setBackground2(view.N_RDXBLView,select: orderCellModel.N_DXXPL_SEL)
        
        ball.setLblFontBackground(view.N_LDYPL2, selected: orderCellModel.N_LDYPL2_SEL)
        ball.setLblFontBackground(view.N_HJPL2, selected: orderCellModel.N_HJPL2_SEL)
        ball.setLblFontBackground(view.N_RDYPL2, selected: orderCellModel.N_RDYPL2_SEL)
        ball.setBackground(view.L_RFView2,select: orderCellModel.N_LRFPL2_SEL)
        ball.setBackground(view.R_RFView2,select: orderCellModel.N_RRFPL2_SEL)
        ball.setBackground2(view.N_LDXBLView2,select: orderCellModel.N_DXDPL2_SEL)
        ball.setBackground2(view.N_RDXBLView2,select: orderCellModel.N_DXXPL2_SEL)
    }

    //主窗体添加购物车、赛事列表、即时/复合下注
    func addControls1(showUnion:NSMutableArray){
        var startY:CGFloat = 0
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 20
        
        let cartButtonView = NSBundle.mainBundle().loadNibNamed("CartButtonView" , owner: nil, options: nil).first as? CartButtonView
        cartButtonView?.frame.size.width = width
        cartButtonView?.frame.size.height = 48
        contentView.addSubview(cartButtonView!)
        //添加购物车控件后Y轴空出
        startY = startY + 48
        
        //先创建一个数组用于设置分段控件的标题
        let appsArray:[String] = ["即时下注","复合下注"]
        let segment:UISegmentedControl = UISegmentedControl(items: appsArray)
        segment.frame = CGRect(x: (width-180)/2, y: height+45, width: 180, height: 20)
        //默认选中下标为0的
        segment.selectedSegmentIndex = 0
        //设置标题颜色
//        segment.tintColor = UIColor.redColor()
        //添加事件，当segment改变时，触发 Parent
        segment.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
        mainView.addSubview(segment)
        
        let cgr = CGRect(x: 0, y: startY, width: width, height: height - 20 - 36)
        let tableView = TableView(frame: cgr)
        tableView.initDelegate(showUnion)
        tableView.bindDelegate = self
        contentView.addSubview(tableView)
    }
    
    //即时/复合下注选择改变事件
    func segmentChange(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0 :
            print("000")
        case 1 :
            print("11111")
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
            if (tempType != "DY") && (tempType != "H") {
                hfs = String(orderCellModel.valueForKey("N_\(tempType)BL")!)
                hlx = String(orderCellModel.valueForKey("N_\(tempType)FS")!)
                hbl = String(orderCellModel.valueForKey("N_\(tempType)LX")!)
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
            if (tempType != "DY") && (tempType != "H") {
                hfs = String(orderCellModel.valueForKey("N_\(tempType)BL2")!)
                hlx = String(orderCellModel.valueForKey("N_\(tempType)FS2")!)
                hbl = String(orderCellModel.valueForKey("N_\(tempType)LX2")!)
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
        betInfo.rate = String(orderCellModel.valueForKey(tempRate)!)
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
        alertView.myView.visit.text = betInfo.homename
        alertView.myView.home.text = betInfo.visitname
        let newRate = String(betInfoJson[0].objectForKey("newRate")!) as NSString
        alertView.myView.rate.text = String(format: "%.3f", newRate.floatValue)
        alertView.myView.limits.text = dzxx + "~" + dzsx
        alertView.myView.max.text = dzsx
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
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>20</strPageSize>")
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
        //赛事注单
        getFootballMatch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ios隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        return true
    }
}
