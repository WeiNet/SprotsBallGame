//
//  ResultViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//开奖结果
class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate,UnionDelegate,UnionTitleViewDelegate {
    
    @IBOutlet var btnBallType: UIButton!
    @IBOutlet var btnTitle: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var common = CommonParameter()//网络请求
    var infoArray:NSMutableArray!//与UnionTitleInfo的数组对应
    var unionID:String = ""
    var date:String = ""
    var ballType:String = "0"
    let unionIdentifier = "unionIdentifier"
    let getDateResult:String = "GetDateResult"
    let getMatchResultResult:String = "GetMatchResultResult"
    var alertMenu:UIAlertController!
    var dateArray:Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()
    var typeArray:Array<Dictionary<String,String>> = [["足球":"0"],["篮球":"1"]]
    var onclickFlag:String = ""
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == "WebError" || strResult == "Error"){
            let message = "网络连接异常!"
            alertMessage(message)
            return
        }
        if(strType == getDateResult){
            createMenuDate(strResult)
        }else if(strType == getMatchResultResult){
            clearAllNotice()
            print(strResult)
            tableView.reloadData()
        }
    }
    
    //球类型选择
    @IBAction func ballType(sender: UIButton) {
        onclickFlag = "ballType"
        alertMenu = createMenu("球类", message: "请选择球类", menuArray: typeArray)
        self.presentViewController(alertMenu, animated: true, completion: nil)
    }
    
    //日期选择
    @IBAction func date(sender: AnyObject) {
        onclickFlag = "date"
        alertMenu = createMenu("日期", message: "请选择日期", menuArray: dateArray)
        self.presentViewController(alertMenu, animated: true, completion: nil)
    }
    
    //联盟选择
    @IBAction func union(sender: AnyObject) {
        showUnion(self)
    }
    
    //联盟选择回调
    func unionClickDelegate(keys:String){
        unionID = keys
        getMatchResult()
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
    
    //创建日期alert
    func createMenu(title:String,message:String,menuArray: Array<Dictionary<String,String>>)->UIAlertController{
        let alertMenu:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for menu in menuArray {
            for (key,value) in menu {
                let item = UIAlertAction(title: key, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
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
        if(onclickFlag == "date"){
            date = value
            btnTitle.titleLabel?.text = key
        }else if(onclickFlag == "ballType"){
            if(value == "0"){
                btnBallType.selected = false
            }else{
                btnBallType.selected = true
            }
            ballType = value
        }
        getMatchResult()
    }
    
    //创建日期选项菜单
    func createMenuDate(strResult: String){
        let resultArray = strResult.componentsSeparatedByString(",")
        for result in resultArray {
            let dateTemp:[String] = result.componentsSeparatedByString("/")
            let dic:Dictionary<String,String> = ["\(dateTemp[0])年\(dateTemp[1])月\(dateTemp[2])日":result]
            dateArray.append(dic)
        }
        date = resultArray[0]
        let dateTemp2:[String] = resultArray[0].componentsSeparatedByString("/")
        let strTitle:String = "\(dateTemp2[0])年\(dateTemp2[1])月\(dateTemp2[2])日"
        btnTitle.titleLabel?.text = strTitle
        getMatchResult()
    }
    
    //联盟展开
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionOpened: Int){
    }
    
    //联盟关闭
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int){
    }
    
    //联盟显示多少行
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        ToolsCode.tableViewDisplayWitMsg(tableView, rowCount: infoArray.count)
//        return infoArray.count
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的section header视图
        let union: UnionTitleView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(unionIdentifier) as! UnionTitleView
//        let infos:UnionTitleInfo = infoArray[section] as! UnionTitleInfo
        
        union.unionIndex = section
        union.delegate = self
        union.frame.size.width = tableView.frame.width
//        union.name.text = "★\(infos.unionTitleModel.name!)"
//        union.count.text = "X\(infos.unionTitleModel.count!)"
//        union.headerOpen = infos.unionTitleModel.unionOpen
//        union.btnDisclosure.selected = !infos.unionTitleModel.unionOpen
//        infos.unionTitleView = union
        
        return union
    }
    
    //每个联盟下面Cell显示多少行，有联盟的打开和关闭决定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let infos:UnionTitleInfo = infoArray[section] as! UnionTitleInfo
//        let sectionOpen = infos.unionTitleModel.unionOpen
//        let count = infos.unionTitleModel.orderCellModels.count
        
//        return sectionOpen ? Int(count) : 0
        return 3
    }
    
    //tableView中的Cell视图的创建加载
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(ballType == "0"){
            let footballResultView = NSBundle.mainBundle().loadNibNamed("FootballResultView" , owner: nil, options: nil).first as! FootballResultView
            footballResultView.frame.size.width = tableView.frame.size.width
            return footballResultView
        }else{
            let basktballResultView = NSBundle.mainBundle().loadNibNamed("BasktballResultView" , owner: nil, options: nil).first as! BasktballResultView
            basktballResultView.frame.size.width = tableView.frame.size.width
            basktballResultView.selectionStyle = UITableViewCellSelectionStyle.None
            return basktballResultView
        }
    }
    
    //设定每个Cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(ballType == "0"){
            return 100
        }else{
            return 131
        }
    }
    
    //取得赛事结果时间
    func getDate(){
        common.delegate = self
        common.matchingElement = getDateResult
        var strParam:String = "<GetDate xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<inum>100</inum>")
        strParam.appendContentsOf("</GetDate>")
        common.getResult(strParam,strResultName: getDateResult)
    }
    
    //取得赛事结果
    func getMatchResult(){
        common.matchingElement = getMatchResultResult
        var strParam:String = "<GetMatchResult xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strLM>\(unionID)</strLM>")
        strParam.appendContentsOf("<strDate>\(date)</strDate>")
        strParam.appendContentsOf("<strPageindex>1</strPageindex>")
        strParam.appendContentsOf("<strPageSize>20</strPageSize>")
        strParam.appendContentsOf("<strBallType>\(ballType)</strBallType>")
        strParam.appendContentsOf("</GetMatchResult>")
        common.getResult(strParam,strResultName: getMatchResultResult)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnBallType.setImage(UIImage(named: "ball0"), forState: UIControlState.Normal)
        btnBallType.setImage(UIImage(named: "ball1"), forState: UIControlState.Selected)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat(38)// 联盟高度
        //联盟xib加载
        let unionNib: UINib = UINib(nibName: "UnionTitleView", bundle: nil)
        tableView.registerNib(unionNib, forHeaderFooterViewReuseIdentifier: unionIdentifier)
        
        getDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ios隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //ios隐藏导航栏
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
