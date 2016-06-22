//
//  BallViewController.swift
//  SportsBall
//
//  Created by Brook on 16/5/16.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BallViewController: UIViewController {
    var mContentView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //创建玩法菜单
    func createMenu(title:String,message:String,menuArray: Array<Dictionary<String,String>>)->UIAlertController{
        let alertMenu:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for menu in menuArray {
            for (key,value) in menu {
                let item = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    BetListManager.sharedManager.clearBetList()
                    self.clickMenuItem(key, value: value)
                })
                alertMenu.addAction(item)
            }
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alertMenu.addAction(cancel)
        return alertMenu
        
    }
    
    //玩法菜单选项响应事件
    func clickMenuItem(key:String,value:String){
//        mPlayType = key
//        let view:HeaderView = headerView.subviews[0] as! HeaderView
//        view.btnTitle.setTitle(value, forState: UIControlState.Normal)
//        getFootballMatch()
    }
    
    //显示赛事（联盟、赛事队伍）
    func stringToDictionary(strResult: String)->NSMutableArray{
        let aryUnionInfo:NSMutableArray = NSMutableArray()
        
        let allUnionVO:AllUnionVO = AllUnionVO.getAllUnionVOInstance()
        allUnionVO.arrayUnionVO.removeAll(keepCapacity: false)
        var aryUnionVO:Array<UnionTitleVO> = Array()
        let info:NSArray = ToolsCode.toJsonArray(strResult)
        let unionJson = info[1]
        if unionJson.count == 0 {//没有资料
            return aryUnionInfo
        }
        let objCount:Int = unionJson.count - 1
        for index in 0...objCount {
            let unionVO:UnionTitleVO = UnionTitleVO()
            unionVO.N_NO = String(unionJson[index].objectForKey("N_NO")!)
            unionVO.N_LMMC = String(unionJson[index].objectForKey("N_LMMC")!)
            aryUnionVO.append(unionVO)
        }
        allUnionVO.arrayUnionVO = aryUnionVO
        
        let matchJson:NSArray = info[0] as! NSArray
        let matchCount:Int = matchJson.count - 1
        for union in aryUnionVO {
            let unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.id = String(union.N_NO)
            unionTitleModel.name = String(union.N_LMMC)
            
            var aryOrderCellModel:Array<OrderCellModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchJson[index].objectForKey("N_LMNO")!) {
                    
                    let orderCellModel:OrderCellModel = OrderCellModel()
                    //给注单属性赋值
                    orderCellModel.setValuesForKeysWithDictionary(matchJson[index] as! [String : AnyObject])
                    aryOrderCellModel.append(orderCellModel)
                }
            }
            unionTitleModel.count = String(aryOrderCellModel.count)
            unionTitleModel.orderCellModels = aryOrderCellModel
            if aryOrderCellModel.count > 0 {
                aryUnionInfo.addObject(unionTitleModel)
            }
        }
        return aryUnionInfo
    }
    
    //主窗体添加购物车、赛事列表、即时/复合下注
    func addControls(showUnion:NSMutableArray,contentView:UIView,mainView:UIView,delegate:BindDelegate,cartDelegate:CartButtonDelegate,orderHeight:CGFloat,playType:String,isPass:Bool){
        mContentView = contentView
        if contentView.subviews.count > 0 {
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
        }
        if mainView.subviews.count == 5 {
            let view:UIView = mainView.subviews[4]
            view.removeFromSuperview()
        }
        
        var startY:CGFloat = 0
        let width = contentView.frame.size.width
        var height = contentView.frame.size.height
        
        if (playType != "2") {
            let cartButtonView = NSBundle.mainBundle().loadNibNamed("CartButtonView" , owner: nil, options: nil).first as? CartButtonView
            if isPass {
                cartButtonView?.segment.hidden = true
            }
            cartButtonView?.frame = CGRect(x: 0, y: 0, width: width, height: 40)
            cartButtonView?.delegate = cartDelegate
            cartButtonView?.segment.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
            contentView.addSubview(cartButtonView!)
            //添加购物车控件后Y轴空出
            startY = startY + 40
            height = height - 40
        }
        
        let cgr = CGRect(x: 0, y: startY, width: width, height: height)
        let tableView = TableView(frame: cgr)
        tableView.initDelegate(showUnion)
        tableView.orderHeight = orderHeight
        tableView.bindDelegate = delegate
        contentView.addSubview(tableView)
    }
    
    //绑定队伍标题
    func bindCommonMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        cell.N_VISIT_NAME.text = orderCellModel.N_VISIT_NAME + "[主]"
        cell.N_HOME_NAME.text = orderCellModel.N_HOME_NAME
        if (orderCellModel.N_ZDFLAG != "Y") {
            let gameDate = orderCellModel.N_GAMEDATE
            cell.N_GAMEDATE.text = ToolsCode.formatterDate(gameDate,format: "MM/dd HH:mm")
            cell.N_VISIT_JZF.text = ""
            cell.N_HOME_JZF.text = ""
        }else{
            cell.N_GAMEDATE.text = orderCellModel.N_ZDTIME
            cell.N_VISIT_JZF.text = String(orderCellModel.N_VISIT_JZF)
            cell.N_HOME_JZF.text = String(orderCellModel.N_HOME_JZF)
        }
    }
    
    //显示联盟选择页面
    func showUnion(delegate:UnionDelegate){
        //在XIB的后面加入一个透明的View
        let bottom:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        bottom.backgroundColor = UIColor.blackColor()
        bottom.alpha = 0.5
        
        let viewWidth:Double = Double(view.frame.size.width) - 50
        let viewHeight:Double = Double(view.frame.size.height) - 60
        let myView = NSBundle.mainBundle().loadNibNamed("UnionCustomAlertView", owner: self, options: nil).first as? UnionCustomAlertView
        myView?.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        myView?.center = self.view.center
        ToolsCode.setCornerRadius(myView!)
        
        if myView != nil {
            let window: UIWindow = UIApplication.sharedApplication().keyWindow!
            window.addSubview(bottom)
            myView?.backgroundView = bottom
            myView?.delegate = delegate
            window.addSubview(myView!)
            window.bringSubviewToFront(myView!)
        }
    }
    
    
    
    //购物车删除资料同步下注页面
    func synchronizationData(betinfo:BetInfo){
        if mContentView.subviews.count == 2 {
            let tableView:TableView = mContentView.subviews[1] as! TableView
            let infoArray:NSMutableArray = tableView.infoArray
            if infoArray.count > 0 {
                for info in infoArray {
                    let infoTemp:UnionTitleInfo = info as! UnionTitleInfo
                    let unionTitleModel:UnionTitleModel = infoTemp.unionTitleModel
                    for order in unionTitleModel.orderCellModels {
                        //开始比较
                        let orderCellModel:OrderCellModel = order as! OrderCellModel
                        if(orderCellModel.N_VISIT_NAME == betinfo.visitname
                            && orderCellModel.N_HOME_NAME == betinfo.homename){
                            let sel = ToolsCode.codeBy(Int(betinfo.Index)!)
                            let selName:String = sel + "_SEL"
                            let select = orderCellModel.valueForKey(selName) as! Bool
                            if select {
                                orderCellModel.setValue(false, forKey: selName)
                                return //匹配一个就可以结束
                            }
                        }
                    }
                }
            }
        }
    }
    
    //清除已经选中的赔率
    func cleanOdds(orderCellModel:OrderCellModel,toolsCode: Int){
        let betManger:BetListManager = BetListManager.sharedManager
        let betList:[BetInfo] = betManger.betList
        let count:Int = betList.count - 1
        for(var i = count;i > 0;i-- ){
            if(betList[i].visitname == orderCellModel.N_VISIT_NAME
                && betList[i].homename == orderCellModel.N_HOME_NAME
                && betList[i].Index == String(toolsCode)){
                betManger.betList.removeAtIndex(i)
            }
        }
    }
    
    //过关下注，删除同一场赛事前面选中的赔率
    func onlySelect(betinfo:BetInfo){
        
        let betManger:BetListManager = BetListManager.sharedManager
        let betList:[BetInfo] = betManger.betList
        let count:Int = betList.count - 1
        for(var i = count;i > 0;i-- ){
            if(betList[i].visitname == betinfo.visitname
                && betList[i].homename == betinfo.homename){
                betManger.betList.removeAtIndex(i)
            }
        }
        
        if mContentView.subviews.count == 2 {
            let tableView:TableView = mContentView.subviews[1] as! TableView
            let infoArray:NSMutableArray = tableView.infoArray
            if infoArray.count > 0 {
                for info in infoArray {
                    let infoTemp:UnionTitleInfo = info as! UnionTitleInfo
                    let unionTitleModel:UnionTitleModel = infoTemp.unionTitleModel
                    for order in unionTitleModel.orderCellModels {
                        //开始比较
                        let orderCellModel:OrderCellModel = order as! OrderCellModel
                        if(orderCellModel.N_VISIT_NAME == betinfo.visitname
                            && orderCellModel.N_HOME_NAME == betinfo.homename){
                            
                            orderCellModel.N_LDYPL_SEL = false
                            orderCellModel.N_HJPL_SEL = false
                            orderCellModel.N_RDYPL_SEL = false
                            
                            orderCellModel.N_LRFPL_SEL = false
                            orderCellModel.N_RRFPL_SEL = false
                            
                            orderCellModel.N_DXDPL_SEL = false
                            orderCellModel.N_DXXPL_SEL = false
                            
                            orderCellModel.N_DSSPL_SEL = false
                            orderCellModel.N_DSDPL_SEL = false
                        }
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    //清除已经选中的所有赔率
    func clearAllOdds(){
        let betManger = BetListManager.sharedManager
        for bet in betManger.betList {
            self.synchronizationData(bet)
        }
        if self.mContentView.subviews.count == 2 {
            let tableView:TableView = self.mContentView.subviews[1] as! TableView
            tableView.reloadData()
        }
        betManger.betList.removeAll(keepCapacity: false)
    }
    
    //初始化购物车清空Alert
    func initCartClear()->UIAlertController{
        let alertCart:UIAlertController = UIAlertController(title: NSLocalizedString("SystemPrompt", comment: ""), message: NSLocalizedString("ClearCart", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.clearAllOdds()
        }
        let ok = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertCart.addAction(ok)
        alertCart.addAction(cancel)
        return alertCart
    }
    
    //显示多笔下注购物车
    func showCart(){
        let betManger = BetListManager.sharedManager
        if(betManger.betList.count > 0){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("ShopingViewController") as! ShopingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            alertMessage(NSLocalizedString("LeastOne", comment: ""))
        }
    }
    
    //显示过关下注购物车
    func showPassCart(){
        let betManger = BetListManager.sharedManager
        if(betManger.betList.count > 1){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("PassShopingViewController") as! PassShopingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            alertMessage(NSLocalizedString("LeastTwo", comment: ""))
        }
    }
    
    //第一次填入BetInfoModel属性用于检验最新赔率，检验完成才有其他属性
    func fullBetInfo(orderCellModel:OrderCellModel,toolsCode:Int)->BetInfo{
        var id:String = String(orderCellModel.N_ID)
        var let1:String = String(orderCellModel.N_LET)
        var courtType:String = "1"
        var gameDate:String = orderCellModel.N_GAMEDATE
        gameDate = ToolsCode.formatterDate(gameDate, format: "yyyy/MM/dd")
        let playType:String = ToolsCode.codeByPlayType(toolsCode)
        var betteamName:String!
        var tid:String!
        let tempBetName = ToolsCode.codeByLRH(toolsCode)
        if tempBetName == "L" {
            betteamName = String(orderCellModel.N_VISIT_NAME)
            tid = String(orderCellModel.N_VISIT)
        }else if tempBetName == "R" {
            betteamName = String(orderCellModel.N_HOME_NAME)
            tid = String(orderCellModel.N_HOME)
        }else{
            betteamName = "和局"
            tid = "0"
        }
        if playType == "DX"{
            betteamName = (tempBetName == "L") ? "大" : "小"
        }
        var hfs:String = "0"//赌赢为0
        var hlx:String = "0"
        var hbl:String = "0"
        let tempType = ToolsCode.codeByPlayType(toolsCode)
        if (tempType == "RF") || (tempType == "DX") {
            hfs = String(orderCellModel.valueForKey("N_\(tempType)FS")!)
            hlx = String(orderCellModel.valueForKey("N_\(tempType)LX")!)
            hbl = String(orderCellModel.valueForKey("N_\(tempType)BL")!)
        }
        if(toolsCode>=ToolsCode.LDYPL2 && toolsCode<=ToolsCode.RDXBLView2){//半场控件
            id = String(orderCellModel.N_ID2)
            let1 = String(orderCellModel.N_LET2)
            let tempType2 = ToolsCode.codeByPlayType(toolsCode)
            if (tempType == "RF") || (tempType == "DX") {
                hfs = String(orderCellModel.valueForKey("N_\(tempType2)FS2")!)
                hlx = String(orderCellModel.valueForKey("N_\(tempType2)LX2")!)
                hbl = String(orderCellModel.valueForKey("N_\(tempType2)BL2")!)
            }
            if tempBetName == "L" {
                tid = String(orderCellModel.N_VISIT2)
            }else if tempBetName == "R" {
                tid = String(orderCellModel.N_HOME2)
            }
            courtType = "2"
        }
        let tempRate = ToolsCode.codeBy(toolsCode)
        
        let betInfo:BetInfo = BetInfo()//下注model
        betInfo.Index = String(toolsCode)
        let user:UserInfoManager = UserInfoManager.sharedManager
        betInfo.strUser = user.getUserID()
        betInfo.playType = playType
        betInfo.lr = (tempBetName == "H" ? "R" : tempBetName)
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
    
    //第二次设定BetInfo属性，主要填入限额等
    func fullBetInfo2(betInfoJson:AnyObject,betInfo:BetInfo,alertView:SwiftCustomAlertView,isMultiselect:Bool){
        betInfo.hbl = String(betInfoJson[0].objectForKey("newBl")!)
        betInfo.hfs = String(betInfoJson[0].objectForKey("newFs")!)
        betInfo.isjzf = String(betInfoJson[0].objectForKey("newjzf") == nil ?betInfoJson[0].objectForKey("isjzf")! : betInfoJson[0].objectForKey("newjzf")!)
        betInfo.strlet = String(betInfoJson[0].objectForKey("newLet")!)
        betInfo.hlx = String(betInfoJson[0].objectForKey("newLx")!)
        betInfo.vh = String(betInfoJson[0].objectForKey("newVh")!)
        betInfo.isLive = String(betInfoJson[0].objectForKey("isLive")!)
        
        betInfo.yssj = String(betInfoJson[0].objectForKey("yssj")!)
        betInfo.jzf = String(betInfoJson[0].objectForKey("jzf")!)
        betInfo.allianceName = String(betInfoJson[0].objectForKey("allianceName")!)
        let dzxx = String(betInfoJson[0].objectForKey("dzxx")!)
        betInfo.dzxx = dzxx
        let dzsx = String(betInfoJson[0].objectForKey("dzsx")!)
        betInfo.dzsx = dzsx
        betInfo.dcsx = String(betInfoJson[0].objectForKey("dcsx")!)
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
            let newRateTemp = String(format: "%.3f", newRate.floatValue)
            alertView.myView.betText.text = ToolsCode.orderText(betInfo)
            alertView.myView.rate.text = String(format: "%.3f", newRate.floatValue)
            alertView.myView.max.text = dzsx
            alertView.myView.limits.text = dzxx + "~" + dzsx
            alertView.myView.iMin = Int(dzxx)!
            alertView.myView.iMax = Int(dzsx)!
            alertView.myView.gain.text = ToolsCode.calculateWinMoney(betInfo.playType,intBet: 10,dRale: Double(newRateTemp)!)
            alertView.myView.strPlayType = betInfo.playType
        } else {
            let betManger = BetListManager.sharedManager
            betManger.betList.append(betInfo)
        }
    }
    
    //ios隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        return true
    }

    //ios隐藏导航栏
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
