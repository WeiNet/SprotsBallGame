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
            let message = "系统错误！"
            alertMessage(message)
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
            infoArray = stringToDictionary(strResult)
//            print(strResult)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
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
            let info:ResultTitleInfo = ResultTitleInfo()
            let resultTitleModel:ResultTitleModel = ResultTitleModel()
            resultTitleModel.id = String(union.N_NO)
            resultTitleModel.name = String(union.N_LMMC)
            
            var aryResultCellModel:Array<ResultCellModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchJson[index].objectForKey("N_LMNO")!) {
                    
                    let resultCellModel:ResultCellModel = ResultCellModel()
                    //给注单属性赋值
                    resultCellModel.setValuesForKeysWithDictionary(matchJson[index] as! [String : AnyObject])
                    aryResultCellModel.append(resultCellModel)
                }
            }
            resultTitleModel.count = String(aryResultCellModel.count)
            resultTitleModel.resultCellModel = aryResultCellModel
            
            if aryResultCellModel.count > 0 {
                info.resultTitleModel = resultTitleModel
                info.unionTitleView.headerOpen = true
                aryUnionInfo.addObject(info)
            }
        }
        return aryUnionInfo
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
        let infos:ResultTitleInfo = infoArray[unionTitleView.unionIndex] as! ResultTitleInfo
        infos.unionTitleView.headerOpen = true
        infos.resultTitleModel.unionOpen = true
        
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        let countOfRowsToInsert = infos.resultTitleModel.resultCellModel.count
        let indexPathsToInsert = NSMutableArray()
        
        for(var i = 0; i < countOfRowsToInsert; i++) {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        
        // 设计动画，以便让表格的打开和关闭拥有一个流畅的效果
        let animation: UITableViewRowAnimation = UITableViewRowAnimation.Bottom
        
        // 应用单元格的更新
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPathsToInsert as! [NSIndexPath], withRowAnimation: animation)
        tableView.endUpdates()
    }
    
    //联盟关闭
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int){
        let infos:ResultTitleInfo = infoArray[unionTitleView.unionIndex] as! ResultTitleInfo
        infos.unionTitleView.headerOpen = false
        infos.resultTitleModel.unionOpen = false
        
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        let countOfRowsToDelete = tableView.numberOfRowsInSection(unionTitleView.unionIndex)
        
        if countOfRowsToDelete > 0 {
            let indexPathsToDelete = NSMutableArray()
            for(var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: unionTitleView.unionIndex))
            }
            tableView.deleteRowsAtIndexPaths(indexPathsToDelete as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    //联盟显示多少行
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        ToolsCode.tableViewDisplayWitMsg(tableView, rowCount: infoArray.count)
        return infoArray.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的section header视图
        let union: UnionTitleView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(unionIdentifier) as! UnionTitleView
        let infos:ResultTitleInfo = infoArray[section] as! ResultTitleInfo
        
        union.unionIndex = section
        union.delegate = self
        union.frame.size.width = tableView.frame.width
        union.name.text = "★\(infos.resultTitleModel.name!)"
        union.count.text = "X\(infos.resultTitleModel.count!)"
        union.headerOpen = infos.resultTitleModel.unionOpen
        union.btnDisclosure.selected = !infos.resultTitleModel.unionOpen
        infos.unionTitleView = union
        
        return union
    }
    
    //每个联盟下面Cell显示多少行，有联盟的打开和关闭决定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let infos:ResultTitleInfo = infoArray[section] as! ResultTitleInfo
        let sectionOpen = infos.resultTitleModel.unionOpen
        let count = infos.resultTitleModel.resultCellModel.count
        
        return sectionOpen ? Int(count) : 0
    }
    
    //tableView中的Cell视图的创建加载
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let infos:ResultTitleInfo = infoArray[indexPath.section] as! ResultTitleInfo
        let resultCellModel:ResultCellModel = infos.resultTitleModel.resultCellModel[indexPath.row] as! ResultCellModel
        if(ballType == "0"){
            let football = NSBundle.mainBundle().loadNibNamed("FootballResultView" , owner: nil, options: nil).first as! FootballResultView
            football.frame.size.width = tableView.frame.size.width
            football.selectionStyle = UITableViewCellSelectionStyle.None
            
            football.N_VISIT_NAME.text = resultCellModel.N_VISIT_NAME + "[主]"
            football.N_HOME_NAME.text = resultCellModel.N_HOME_NAME
            let gameDate = resultCellModel.N_GAMEDATE
            football.N_GAMEDATE.text = ToolsCode.formatterDate(gameDate,format: "MM/dd HH:mm")
            football.N_UP_VISIT_RESULT.text = resultCellModel.N_UP_VISIT_RESULT.stringValue
            football.N_UP_HOME_RESULT.text = resultCellModel.N_UP_HOME_RESULT.stringValue
            football.N_VISIT_RESULT.text = resultCellModel.N_VISIT_RESULT.stringValue
            football.N_HOME_RESULT.text = resultCellModel.N_HOME_RESULT.stringValue
            
            return football
        }else{
            let basktball = NSBundle.mainBundle().loadNibNamed("BasktballResultView" , owner: nil, options: nil).first as! BasktballResultView
            basktball.frame.size.width = tableView.frame.size.width
            basktball.selectionStyle = UITableViewCellSelectionStyle.None
            
            basktball.N_VISIT_NAME.text = resultCellModel.N_VISIT_NAME + "[主]"
            basktball.N_HOME_NAME.text = resultCellModel.N_HOME_NAME
            let gameDate = resultCellModel.N_GAMEDATE
            basktball.N_GAMEDATE.text = ToolsCode.formatterDate(gameDate,format: "MM/dd HH:mm")
            let upVisitResult = resultCellModel.N_UP_VISIT_RESULT.intValue
            let upHomeResult = resultCellModel.N_UP_HOME_RESULT.intValue
            let visitResult = resultCellModel.N_VISIT_RESULT.intValue
            let homeResult = resultCellModel.N_HOME_RESULT.intValue
            basktball.N_UP_VISIT_RESULT.text = String(upVisitResult)
            basktball.N_UP_HOME_RESULT.text = String(upHomeResult)
            basktball.N_DO_VISIT_RESULT.text = String(visitResult - upVisitResult)
            basktball.N_DO_HOME_RESULT.text = String(homeResult - upHomeResult)
            basktball.N_VISIT_RESULT.text = String(visitResult)
            basktball.N_HOME_RESULT.text = String(homeResult)
            
            return basktball
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
        pleaseWait()
        common.delegate = self
        common.matchingElement = getDateResult
        var strParam:String = "<GetDate xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<inum>10</inum>")
        strParam.appendContentsOf("</GetDate>")
        common.getResult(strParam,strResultName: getDateResult)
    }
    
    //取得赛事结果
    func getMatchResult(){
        pleaseWait()
        common.matchingElement = getMatchResultResult
        var strParam:String = "<GetMatchResult xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strLM>\(unionID)</strLM>")
        strParam.appendContentsOf("<strDate>\(date)</strDate>")
        strParam.appendContentsOf("<strPageindex>1</strPageindex>")
        strParam.appendContentsOf("<strPageSize>2000</strPageSize>")
        strParam.appendContentsOf("<strBallType>\(ballType)</strBallType>")
        strParam.appendContentsOf("</GetMatchResult>")
        common.getResult(strParam,strResultName: getMatchResultResult)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnBallType.setImage(UIImage(named: "ball0"), forState: UIControlState.Normal)
        btnBallType.setImage(UIImage(named: "ball1"), forState: UIControlState.Selected)
        
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
