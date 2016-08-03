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
        print(getIPAddresses()[0])
        var strParam:String = "<Login xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>\(strUserName)</strUser>")
        strParam.appendContentsOf("<strPwd>\(strPW)</strPwd>")
        strParam.appendContentsOf("<strIp>\(getIPAddresses()[0])</strIp>")
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
                UserInfoManager.sharedManager.setUrl(TestWebServiceAddress)
            }else{
                UserInfoManager.sharedManager.setUrl(TestWebServiceAddress)
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
                Tool.showMsg(NSLocalizedString("Maintain", comment: "")+strErrorMsg)
                    
                    return
                }
                else if(strErrorCode==10002){
                    
                    Tool.showMsg(NSLocalizedString("LoginError", comment: ""))
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
    
    
     func getIPAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
}

