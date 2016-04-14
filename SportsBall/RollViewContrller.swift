//
//  RollViewContrller.swift
//  SportsBall
//
//  Created by Brook on 16/3/24.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewContrller:UIViewController,ResultDelegate,bindDataDelegate,MyTableViewDelegate,SwiftCustomAlertViewDelegate {
    @IBOutlet var myContent: UIView!
    var common=CommonParameter()//网络请求
    var myTable:MyTableView!
    let betInfo:BetInfoModel = BetInfoModel()//下注model
    let alertView = SwiftCustomAlertView()//即时下注popu页面
    var mPlayType = "2"//0早餐2滚球
    let checkBetResult:String = "CheckBetResult"
    let getFootballMatchResult:String = "GetFootballMatchResult"
    let addBetResult:String = "AddBetResult"
    //即时下注付款协议
    func selectOkButtonalertView(){
        betInfo.dMoney = alertView.myView.money.text
        AddBet()
        print("selectOkButtonalertView")
    }
    //即时下注付款取消协议
    func  selecttCancelButtonAlertView(){
        print("selecttCancelButtonAlertView")
    }
    //点击赔率点击事件的协议
    func orderCliCk(orderCellRollModel:OrderCellRollModel,toolsCode: Int)->Bool{
        alertView.show(self)//显示即时下注popuWin
        let betInfoVO = fullBetInfo1(orderCellRollModel,toolsCode:toolsCode)
        checkBet(betInfoVO)//检验选取的赔率是不是最新的
        return false
    }
    //注单的资料绑定协议（Cell的显示）
    func bindData(orderCellRollView:OrderCellRollView,orderCellRollModel:OrderCellRollModel){
        clear(orderCellRollView)
        showData(orderCellRollView,orderCellRollModel:orderCellRollModel)
        fillBackground(orderCellRollView,orderCellRollModel:orderCellRollModel)
    }
    //注单赋值前清空重用控件
    func clear(orderCellRollView:OrderCellRollView){
        orderCellRollView.N_LDYPL.text = ""
        orderCellRollView.N_HJPL.text = ""
        orderCellRollView.N_RDYPL.text = ""
        
        orderCellRollView.N_LRFBL.text = ""
        orderCellRollView.N_RRFBL.text = ""
        orderCellRollView.N_LRFPL.text = ""
        orderCellRollView.N_RRFPL.text = ""
        
        orderCellRollView.N_LDXBL.text = ""
        orderCellRollView.N_RDXBL.text = ""
        orderCellRollView.N_DXDPL.text = ""
        orderCellRollView.N_DXXPL.text = ""
        
        
        orderCellRollView.N_LDYPL2.text = ""
        orderCellRollView.N_HJPL2.text = ""
        orderCellRollView.N_RDYPL2.text = ""
        
        orderCellRollView.N_LRFBL2.text = ""
        orderCellRollView.N_RRFBL2.text = ""
        orderCellRollView.N_LRFPL2.text = ""
        orderCellRollView.N_RRFPL2.text = ""
        
        orderCellRollView.N_LDXBL2.text = ""
        orderCellRollView.N_RDXBL2.text = ""
        orderCellRollView.N_DXDPL2.text = ""
        orderCellRollView.N_DXXPL2.text = ""
    }
    //资料的显示
    func showData(orderCellRollView:OrderCellRollView,orderCellRollModel:OrderCellRollModel){
        //全场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellRollModel.N_DY_OPEN == nil || String(orderCellRollModel.N_DY_OPEN) == "0"){
            orderCellRollView.N_LDYPL.text = orderCellRollModel.N_LDYPL != nil ? String(format: "%.3f", orderCellRollModel.N_LDYPL.floatValue) : ""
            orderCellRollView.N_HJPL.text = orderCellRollModel.N_HJPL != nil ? String(format: "%.3f", orderCellRollModel.N_HJPL.floatValue) : ""
            orderCellRollView.N_RDYPL.text = orderCellRollModel.N_RDYPL != nil ? String(format: "%.3f", orderCellRollModel.N_RDYPL.floatValue) : ""
        }
        //全场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellRollModel.N_RF_OPEN == nil || String(orderCellRollModel.N_RF_OPEN) == "0"){
            if(orderCellRollModel.N_LET == nil || String(orderCellRollModel.N_LET) == "0"){
                orderCellRollView.N_LRFBL.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_RFFS), bl: Int(orderCellRollModel.N_RFBL), lx: Int(orderCellRollModel.N_RFLX))
            }else{
                orderCellRollView.N_RRFBL.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_RFFS), bl: Int(orderCellRollModel.N_RFBL), lx: Int(orderCellRollModel.N_RFLX))
            }
            orderCellRollView.N_LRFPL.text = orderCellRollModel.N_LRFPL != nil ? String(format: "%.3f", orderCellRollModel.N_LRFPL.floatValue) : ""
            orderCellRollView.N_RRFPL.text = orderCellRollModel.N_RRFPL != nil ? String(format: "%.3f", orderCellRollModel.N_RRFPL.floatValue) : ""
        }
        //全场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellRollModel.N_DX_OPEN == nil || String(orderCellRollModel.N_DX_OPEN) == "0"){
            orderCellRollView.N_LDXBL.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_DXFS), bl: Int(orderCellRollModel.N_DXBL), lx: Int(orderCellRollModel.N_DXLX))
            orderCellRollView.N_RDXBL.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_DXFS), bl: Int(orderCellRollModel.N_DXBL), lx: Int(orderCellRollModel.N_DXLX))
            orderCellRollView.N_DXDPL.text = orderCellRollModel.N_DXDPL != nil ? String(format: "%.3f", orderCellRollModel.N_DXDPL.floatValue) : ""
            orderCellRollView.N_DXXPL.text = orderCellRollModel.N_DXXPL != nil ? String(format: "%.3f", orderCellRollModel.N_DXXPL.floatValue) : ""
        }
        
        //半场赌赢不允许下注-->OPEN 该盘口不锁定
        if (orderCellRollModel.N_DY_OPEN2 == nil || String(orderCellRollModel.N_DY_OPEN2) == "0"){
            orderCellRollView.N_LDYPL2.text = orderCellRollModel.N_LDYPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_LDYPL2.floatValue) : ""
            orderCellRollView.N_HJPL2.text = orderCellRollModel.N_HJPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_HJPL2.floatValue) : ""
            orderCellRollView.N_RDYPL2.text = orderCellRollModel.N_RDYPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_RDYPL2.floatValue) : ""
        }
        //半场让分不允许下注-->OPEN 该盘口不锁定
        if(orderCellRollModel.N_RF_OPEN2 == nil || String(orderCellRollModel.N_RF_OPEN2) == "0"){
            if(orderCellRollModel.N_LET2 == nil || String(orderCellRollModel.N_LET2) == "0"){
                orderCellRollView.N_LRFBL2.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_RFFS2), bl: Int(orderCellRollModel.N_RFBL2), lx: Int(orderCellRollModel.N_RFLX2))
            }else{
                orderCellRollView.N_RRFBL2.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_RFFS2), bl: Int(orderCellRollModel.N_RFBL2), lx: Int(orderCellRollModel.N_RFLX2))
            }
            orderCellRollView.N_LRFPL2.text = orderCellRollModel.N_LRFPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_LRFPL2.floatValue) : ""
            orderCellRollView.N_RRFPL2.text = orderCellRollModel.N_RRFPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_RRFPL2.floatValue) : ""
        }
        //半场大小不允许下注-->OPEN 该盘口不锁定
        if(orderCellRollModel.N_DX_OPEN2 == nil || String(orderCellRollModel.N_DX_OPEN2) == "0"){
            orderCellRollView.N_LDXBL2.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_DXFS2), bl: Int(orderCellRollModel.N_DXBL2), lx: Int(orderCellRollModel.N_DXLX2))
            orderCellRollView.N_RDXBL2.text = ToolsCode.getBallHead(Int(orderCellRollModel.N_DXFS2), bl: Int(orderCellRollModel.N_DXBL2), lx: Int(orderCellRollModel.N_DXLX2))
            orderCellRollView.N_DXDPL2.text = orderCellRollModel.N_DXDPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_DXDPL2.floatValue) : ""
            orderCellRollView.N_DXXPL2.text = orderCellRollModel.N_DXXPL2 != nil ? String(format: "%.3f", orderCellRollModel.N_DXXPL2.floatValue) : ""
        }
    }
    //背景的填充
    func fillBackground(orderCellRollView:OrderCellRollView,orderCellRollModel:OrderCellRollModel){
        orderCellRollView.setLblFontBackground(orderCellRollView.N_LDYPL, selected: orderCellRollModel.N_LDYPL_SEL)
        orderCellRollView.setLblFontBackground(orderCellRollView.N_HJPL, selected: orderCellRollModel.N_HJPL_SEL)
        orderCellRollView.setLblFontBackground(orderCellRollView.N_RDYPL, selected: orderCellRollModel.N_RDYPL_SEL)
        orderCellRollView.setBackground(orderCellRollView.L_RFView,select: orderCellRollModel.N_LRFPL_SEL)
        orderCellRollView.setBackground(orderCellRollView.R_RFView,select: orderCellRollModel.N_RRFPL_SEL)
        orderCellRollView.setBackground2(orderCellRollView.N_LDXBLView,select: orderCellRollModel.N_DXDPL_SEL)
        orderCellRollView.setBackground2(orderCellRollView.N_RDXBLView,select: orderCellRollModel.N_DXXPL_SEL)
        
        orderCellRollView.setLblFontBackground(orderCellRollView.N_LDYPL2, selected: orderCellRollModel.N_LDYPL2_SEL)
        orderCellRollView.setLblFontBackground(orderCellRollView.N_HJPL2, selected: orderCellRollModel.N_HJPL2_SEL)
        orderCellRollView.setLblFontBackground(orderCellRollView.N_RDYPL2, selected: orderCellRollModel.N_RDYPL2_SEL)
        orderCellRollView.setBackground(orderCellRollView.L_RFView2,select: orderCellRollModel.N_LRFPL2_SEL)
        orderCellRollView.setBackground(orderCellRollView.R_RFView2,select: orderCellRollModel.N_RRFPL2_SEL)
        orderCellRollView.setBackground2(orderCellRollView.N_LDXBLView2,select: orderCellRollModel.N_DXDPL2_SEL)
        orderCellRollView.setBackground2(orderCellRollView.N_RDXBLView2,select: orderCellRollModel.N_DXXPL2_SEL)
    }
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getFootballMatchResult){//页面首次加载获取资料
            showTableView(strResult)
        }else if(strType == checkBetResult){//检验选中的赔率是不是最新的
            let betInfoJson = ToolsCode.toJsonArray("[\(strResult)]")
            fullBetInfo2(betInfoJson)
        }else if(strType == addBetResult){
            
        }
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
    //显示赛事（联盟、赛事队伍）
    func showTableView(strResult: String){
        var allUnionArr:Array<UnionTitleVO> = Array()
        let info = ToolsCode.toJsonArray(strResult)
        let unionAllJson = info[1]
        if unionAllJson.count == 0 {//没有资料
            print("没有资料")
            return
        }
        let objCount:Int = unionAllJson.count - 1
        for index in 0...objCount {
            let model:UnionTitleVO = UnionTitleVO()
            model.N_NO = String(unionAllJson[index].objectForKey("N_NO")!)
            model.N_LMMC = String(unionAllJson[index].objectForKey("N_LMMC")!)
            allUnionArr.append(model)
        }
        
        let showUnion:NSMutableArray = NSMutableArray()
        let matchAllJson = info[0]
        let matchCount:Int = matchAllJson.count - 1
        for union in allUnionArr {
            let unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.id = String(union.N_NO)
            unionTitleModel.name = String(union.N_LMMC)
            
            var order:Array<OrderCellRollModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchAllJson[index].objectForKey("N_LMNO")!) {
                    let orderCellRollModel:OrderCellRollModel = OrderCellRollModel()
                    //给注单属性赋值
                    orderCellRollModel.setValuesForKeysWithDictionary(matchAllJson[index] as! [String : AnyObject])
                    order.append(orderCellRollModel)
                }
            }
            unionTitleModel.count = String(order.count)
            unionTitleModel.orderCellRollModels = order
            if order.count > 0 {
                showUnion.addObject(unionTitleModel)
            }
        }
        
        let width = self.myContent.frame.size.width
        let height = self.myContent.frame.size.height - 20
        myTable = MyTableView(frame: CGRect(x: 0, y: 25, width: width, height: height))
        myTable.matchCells = showUnion
        myTable.bindDataTable = self
        myTable.tableDelegate = self
        myTable.setDelegate()
        myContent.addSubview(myTable)
    }
    //第一次填入BetInfoModel属性用于检验最新赔率，检验完成才有其他属性
    func fullBetInfo1(orderCellRollModel:OrderCellRollModel,toolsCode:Int)->BetInfoModel{
        var id:String!
        var tid:String!
        var let1:String!
        var hfs:String = "0"//赌赢为0
        var hlx:String = "0"
        var hbl:String = "0"
        var courtType:String = "1"
        var gameDate:String = orderCellRollModel.N_GAMEDATE
        gameDate = ToolsCode.formatterDate(gameDate, format: "yyyy/MM/dd")
        let playType:String = ToolsCode.codeByPlayType(toolsCode)
        var betteamName:String!
        let tempBetName = ToolsCode.codeByLRH(toolsCode)
        if tempBetName == "L" {
            betteamName = String(orderCellRollModel.N_VISIT_NAME)
        }else if tempBetName == "R" {
            betteamName = String(orderCellRollModel.N_HOME_NAME)
        }else{
            betteamName = "和局"
        }
        if playType == "DX"{
            betteamName = tempBetName == "L" ? "大" : "小"
        }
        if(toolsCode>=56661 && toolsCode<=56667){//全场控件
            id = String(orderCellRollModel.N_ID)
            let1 = String(orderCellRollModel.N_LET)
            let tempType = ToolsCode.codeByPlayType(toolsCode)
            if (tempType != "DY") && (tempType != "H") {
                hfs = String(orderCellRollModel.valueForKey("N_\(tempType)BL")!)
                hlx = String(orderCellRollModel.valueForKey("N_\(tempType)FS")!)
                hbl = String(orderCellRollModel.valueForKey("N_\(tempType)LX")!)
            }
            let tempLRH = ToolsCode.codeByLRH(toolsCode)
            if tempLRH == "L" {
                tid = String(orderCellRollModel.N_VISIT)
            }else if tempLRH == "R" {
                tid = String(orderCellRollModel.N_HOME)
            }else{
                tid = "0"
            }
        }else if(toolsCode>=56668 && toolsCode<=56674){//半场控件
            id = String(orderCellRollModel.N_ID2)
            let1 = String(orderCellRollModel.N_LET2)
            let tempType = ToolsCode.codeByPlayType(toolsCode)
            if (tempType != "DY") && (tempType != "H") {
                hfs = String(orderCellRollModel.valueForKey("N_\(tempType)BL2")!)
                hlx = String(orderCellRollModel.valueForKey("N_\(tempType)FS2")!)
                hbl = String(orderCellRollModel.valueForKey("N_\(tempType)LX2")!)
            }
            let tempLRH = ToolsCode.codeByLRH(toolsCode)
            if tempLRH == "L" {
                tid = String(orderCellRollModel.N_VISIT2)
            }else if tempLRH == "R" {
                tid = String(orderCellRollModel.N_HOME2)
            }else{
                tid = "0"
            }
            courtType = "2"
        }
        let tempRate = ToolsCode.codeBy(toolsCode)
        
        betInfo.strUser = "DEMOFZ-0P0P00"//USER??????????????????????????????????????????????????????????????
        betInfo.playType = mPlayType == "2" ? "ZD"+playType : playType
        betInfo.lr = ToolsCode.codeByLRH(toolsCode)
        betInfo.ballType = orderCellRollModel.N_LX
        betInfo.courtType = courtType
        betInfo.id = id
        betInfo.tid = tid
        betInfo.rate = String(orderCellRollModel.valueForKey(tempRate)!)
        betInfo.vh = String(orderCellRollModel.N_VH)
        betInfo.let1 = let1
        betInfo.hbl = hbl
        betInfo.hfs = hfs
        betInfo.hlx = hlx
        betInfo.homename = String(orderCellRollModel.N_HOME_NAME)
        betInfo.visitname = String(orderCellRollModel.N_VISIT_NAME)
        betInfo.betteamName = betteamName
        betInfo.date = gameDate
        betInfo.dzxx = "10"//USER??????????????????????????????????????????????????????????????
        betInfo.dMoney = "10"
        return betInfo
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
        strParam.appendContentsOf("<let>\(betInfo.let1)</let>")
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
        // Do any additional setup after loading the view.
        common.delegate = self
        common.matchingElement = getFootballMatchResult
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>20</strPageSize>")
        strParam.appendContentsOf("<strUser></strUser>")
        strParam.appendContentsOf("<strType>\(mPlayType)</strType>")//0早2滚
        strParam.appendContentsOf("</GetFootballMatch>")
        common.getResult(strParam,strResultName: getFootballMatchResult)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
