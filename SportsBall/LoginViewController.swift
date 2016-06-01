//
//  LoginViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/2.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,NSXMLParserDelegate,ResultDelegate,UITextFieldDelegate{
    var tmpString: String = String()
    var common=CommonParameter()//网络请求
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLog: UIButton!
    
    @IBOutlet weak var textUserNumber: UITextField!
    
    @IBOutlet weak var textUserPW: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        common.delegate=self
        self.textUserNumber.delegate=self
        self.textUserPW.delegate=self
//        self.activityView.
        self.navigationController?.navigationBarHidden=true
        self.activityView.hidesWhenStopped=true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loginClick(sender: UIButton) {
        if(self.textUserNumber.text==""){
        
            Tool.showMsg("帐号不能为空")
         return
        }
        if(self.textUserPW.text==""){
            
            Tool.showMsg("密码不能为空")
            return
        }
        self.activityView.startAnimating()
        loginMoney()
        

        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func loginMoney(){
        var strAccount=self.textUserNumber.text?.uppercaseString
        var strArry=strAccount!.componentsSeparatedByString("@")
        var strNew=strArry[0]+(self.textUserPW.text?.uppercaseString)!+"QWEQAZ"
        
       print(strNew.md5)
        var strParam:String = "<GetDQUser xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUserName>\(self.textUserNumber.text!)</strUserName>")
        strParam.appendContentsOf("<strPassword>\(self.textUserPW.text!)</strPassword>")
        strParam.appendContentsOf("<strMd5>\(strNew.md5)</strMd5>")
        strParam.appendContentsOf("</GetDQUser>")
        common.getMoneyAddressResult(strParam,strResultName: "GetDQUserResult")
    
    }
    func login(strUserName:String,strPW:String){
        var strParam:String = "<Login xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>\(strUserName)</strUser>")
        strParam.appendContentsOf("<strPwd>\(strPW)</strPwd>")
        strParam.appendContentsOf("<strIp>192.160.30.34</strIp>")
        strParam.appendContentsOf("</Login>")
        common.getResult(strParam,strResultName: "LoginResult")
        
    }
    
    func getLoginData(){
        if(tmpString != ""){
            
            NSLog("")
            
        }
        
    }
    func setResult(strResult: String,strType:String) {
        
        self.activityView.stopAnimating()
        if(strType=="Error" && strResult=="WebError"){
            Tool.showMsg("网络错误，请检查网络")
           
            return
        }
        if(strResult==""){
             Tool.showMsg("系统错误")
           
            return
        }
        if(strType=="GetDQUserResult"){
            print(strResult)
            if(strResult=="2"||strResult=="1"){
             Tool.showMsg("用户名或密码错误")
            return
            }
             var strArry=strResult.componentsSeparatedByString("@")
            if(strArry.count<2){
            Tool.showMsg("用户名或密码错误")
                return
            }
            login(strArry[0], strPW: strArry[1])
            
            return
        }
        if(strType=="LoginResult"){
            print(strResult)
            var jsonResult:NSMutableDictionary=Tool.toJson(strResult)
            
            var strFlag=jsonResult["bSucceed"] as! NSNumber
            var strUserName=jsonResult["UserName"]as! String
            var strUserID=jsonResult["UserID"]as! String
            var strCredit=jsonResult["Credit"]as! Double
            if(strFlag==0){
                Tool.showMsg("用户名或密码错误")
                return
            }
            
            UserInfoManager.sharedManager.setUserID(strUserID)
            UserInfoManager.sharedManager.setUserName(strUserName)
            UserInfoManager.sharedManager.setCredit(strCredit)
           jumpPage()
                        
            return
        }
       
        
        
        
    }
    func jumpPage(){
        var sb = UIStoryboard(name: "Main", bundle:nil)
        var vc = sb.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

