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
    var flag=false
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLog: UIButton!
    
    @IBOutlet weak var textUserNumber: UITextField!
    
    @IBOutlet weak var btnRememberPW: UIButton!
    @IBOutlet weak var textUserPW: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        common.delegate=self
        self.textUserNumber.delegate=self
        self.textUserPW.delegate=self
        self.navigationController?.navigationBarHidden=true
        self.activityView.hidesWhenStopped=true
        self.btnRememberPW.setImage(UIImage(named:"check_false"),forState: UIControlState.Normal)
         self.btnRememberPW.setImage(UIImage(named:"check_ok"),forState: UIControlState.Selected)
        self.btnRememberPW.addTarget(self, action:"rememberClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let flag = NSUserDefaults.standardUserDefaults().stringForKey("flag")
        if(flag=="true"){
    var userName = NSUserDefaults.standardUserDefaults().stringForKey("userName")
    var userPW = NSUserDefaults.standardUserDefaults().stringForKey("userPW")
            textUserNumber.text=userName
            textUserPW.text=userPW
            self.btnRememberPW.selected=true
        }else{
        self.btnRememberPW.selected=false
            
        }
        
        
    }
    
    func rememberClick(btn:UIButton){
    
     btn.selected = !btn.selected
        if(btn.selected){
       
            flag=true
        
        }else{
            setUserInfo("", strPW: "", strFlag: "false")
            flag=false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loginClick(sender: UIButton) {
        if(self.textUserNumber.text==""){
            Tool.showMsg(NSLocalizedString("EmptyAccount", comment: ""))
         return
        }
        if(self.textUserPW.text==""){
            Tool.showMsg(NSLocalizedString("EmptyPassword", comment: ""))
            return
        }
        self.activityView.startAnimating()
        loginMoney()
//        jumpPage()
        

        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func loginMoney(){
        var strAccount=self.textUserNumber.text?.uppercaseString
        var strArry=strAccount!.componentsSeparatedByString("@")
        var strNew=strArry[0]+(self.textUserPW.text?.uppercaseString)!+"QWEQAZ"
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
            Tool.showMsg(NSLocalizedString("NetworkError", comment: ""))
            return
        }
        if(strResult==""){
            Tool.showMsg(NSLocalizedString("SystemError", comment: ""))
            return
        }
        if(strType=="GetDQUserResult"){
            
            if(strResult=="2"||strResult=="1"){
                Tool.showMsg(NSLocalizedString("UserPasswordError", comment: ""))
                return
            }
            var strArry=strResult.componentsSeparatedByString("@")
            if(strArry.count<3){
                Tool.showMsg(NSLocalizedString("UserPasswordError", comment: ""))
                return
            }
            if(strArry[2]=="1"){
                UserInfoManager.sharedManager.setUrl(XMWebServiceAddress)
            }else{
                UserInfoManager.sharedManager.setUrl(TWWebServiceAddress)
            }
            login(strArry[0], strPW: strArry[1])
            
            return
        }
        if(strType=="LoginResult"){
            print(strResult)
            var jsonResult:NSMutableDictionary=Tool.toJson(strResult)
                var strFlag=jsonResult["bSucceed"] as! NSNumber
            if(strFlag==0){
                 var strErrorCode=jsonResult["iErroCode"] as! NSNumber
                 var strErrorMsg=jsonResult["sErroMessage"] as!String
                if(strErrorCode==10001){
                
                    Tool.showMsg("系统正在维护，如有不便之处请见谅！维护时间为:\n"+strErrorMsg)
                    return
                }
                else if(strErrorCode==10002){
                    
                    Tool.showMsg("你的账号在异地登陆，请及时修改密码")
                    return
                }else{
                    Tool.showMsg(NSLocalizedString("UserPasswordError", comment: ""))
                    return
                }
            }
            var strUserName=jsonResult["UserName"]as! String
            var strUserID=jsonResult["UserID"]as! String
            var strCredit=jsonResult["Credit"]as! Double

            if(flag){
             setUserInfo(textUserNumber.text!, strPW: textUserPW.text!, strFlag: "true")
            }
            UserInfoManager.sharedManager.setUserID(strUserID)
            UserInfoManager.sharedManager.setUserName(strUserName)
            UserInfoManager.sharedManager.setCredit(strCredit)
           jumpPage()
                        
            return
        }
    }
    func jumpPage(){
        let onlineUser:OnlineUser = OnlineUser.getOnlineUserInstance()
        onlineUser.ThreadStart()
        var sb = UIStoryboard(name: "Main", bundle:nil)
        var vc = sb.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func setUserInfo(strUserName:String,strPW:String,strFlag:String){
    NSUserDefaults.standardUserDefaults().setValue(strUserName, forKey: "userName")
    NSUserDefaults.standardUserDefaults().setValue(strPW, forKey: "userPW")
    NSUserDefaults.standardUserDefaults().setValue(strFlag, forKey: "flag")
    }
    
}

