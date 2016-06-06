//
//  ResultViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit
//开奖结果
class ResultViewController: UIViewController,ResultDelegate {
    
    @IBOutlet var btnBallType: UIButton!
    var common = CommonParameter()//网络请求
    var unionID:String = ""
    var date:String = ""
    var ballType:String = "0"
    let getDateResult:String = "GetDateResult"
    let getMatchResultResult:String = "GetMatchResultResult"
    var alertMenu:UIAlertController!
    var dateArray: Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()
    var typeArray: Array<Dictionary<String,String>> = [["足球":"0"],["篮球":"1"]]
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
            GetMatchResult()
        }else if(onclickFlag == "ballType"){
            ballType = value
            GetMatchResult()
        }
    }
    
    //创建日期选项菜单
    func createMenuDate(strResult: String){
        let resultArray = strResult.componentsSeparatedByString(",")
        for result in resultArray {
            let dateTemp:[String] = result.componentsSeparatedByString("/")
            let dic:Dictionary<String,String> = ["\(dateTemp[0])年\(dateTemp[1])月\(dateTemp[2])日":result]
            dateArray.append(dic)
        }
        alertMenu = createMenu("足球玩法", message: "请选择玩法", menuArray: dateArray)
        date = resultArray[0]
        GetMatchResult()
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
    func GetMatchResult(){
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
