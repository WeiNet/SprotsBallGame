//
//  BallViewController.swift
//  SportsBall
//
//  Created by Brook on 16/5/16.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BallViewController: UIViewController {

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
//        if(menuArray.count <= 0){
//            return nil
//        }
        let alertMenu:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
        let info = ToolsCode.toJsonArray(strResult)
        let unionJson = info[1]
        if unionJson.count == 0 {//没有资料
            print("没有资料")
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
        
        let matchJson = info[0]
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
    func addControls(showUnion:NSMutableArray,contentView:UIView,mainView:UIView,delegate:BindDelegate,cartDelegate:CartButtonDelegate,orderHeight:CGFloat,playType:String){
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
        var height = contentView.frame.size.height + 20
        
        if (playType != "2") {
            let cartButtonView = NSBundle.mainBundle().loadNibNamed("CartButtonView" , owner: nil, options: nil).first as? CartButtonView
//            cartButtonView?.frame.size.width = width
//            cartButtonView?.frame.size.height = 48
            cartButtonView?.frame = CGRect(x: 0, y: 0, width: width, height: 48)
            cartButtonView?.delegate = cartDelegate
            contentView.addSubview(cartButtonView!)
            //添加购物车控件后Y轴空出
            startY = startY + 48
            height = height - 48
        }
        
        if (playType != "2") {
            //先创建一个数组用于设置分段控件的标题
            let appsArray:[String] = ["即时下注","复合下注"]
            let segment:UISegmentedControl = UISegmentedControl(items: appsArray)
            segment.frame = CGRect(x: (width-180)/2, y: height + 75, width: 180, height: 20)
            //默认选中下标为0的
            segment.selectedSegmentIndex = 0
            //设置标题颜色
            //segment.tintColor = UIColor.redColor()
            //添加事件，当segment改变时，触发 Parent
            segment.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
            mainView.addSubview(segment)
            height = height - 26
        }
        
        let cgr = CGRect(x: 0, y: startY, width: width, height: height)// - 20 - 36)
        let tableView = TableView(frame: cgr)
        tableView.initDelegate(showUnion)
        tableView.orderHeight = orderHeight
        tableView.bindDelegate = delegate
        contentView.addSubview(tableView)
        var tttt:String = "ttt"
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
    func showUnion(){
        //在XIB的后面加入一个透明的View
        let bottom:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        bottom.backgroundColor = UIColor.blackColor()
        bottom.alpha = 0.8
        
        let myView = NSBundle.mainBundle().loadNibNamed("UnionCustomAlertView", owner: self, options: nil).first as? UnionCustomAlertView
        myView?.frame = CGRect(x: 0, y: 0, width: 350, height: 600)
        myView?.center = self.view.center
        
        if myView != nil {
            let window: UIWindow = UIApplication.sharedApplication().keyWindow!
            window.addSubview(bottom)
            myView?.backgroundView = bottom
            window.addSubview(myView!)
            window.bringSubviewToFront(myView!)
        }
    }
    
    //初始化购物车清空Alert
    func initCartClear()->UIAlertController{
        let alertCart:UIAlertController = UIAlertController(title: "清空提示", message: "是否清除购物车注单？", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "清除", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            let betManger = BetListManager.sharedManager
            betManger.betList.removeAll(keepCapacity: false)
        }
        let ok = UIAlertAction(title: "保存", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertCart.addAction(ok)
        alertCart.addAction(cancel)
        return alertCart
    }
    
    //显示购物车
    func showCart(){
        let betManger = BetListManager.sharedManager
        if(betManger.betList.count > 0){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("ShopingViewController") as! ShopingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            alertMessage("至少选择一场比赛", carrier: self)
        }
    }
    
    //第二次设定BetInfo属性，主要填入限额等
    func fullBetInfo2(betInfoJson:AnyObject,betInfo:BetInfoModel,alertView:SwiftCustomAlertView,isMultiselect:Bool){
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
}
