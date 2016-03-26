//
//  LoginViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/2.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,NSXMLParserDelegate,ResultDelegate{
    var tmpString: String = String()
    var common=CommonParameter()//网络请求
  
    
    @IBOutlet weak var btnLog: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        common.delegate=self
       
        self.navigationController?.navigationBarHidden=true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loginClick(sender: UIButton) {
        login()
        
                var sb = UIStoryboard(name: "Main", bundle:nil)
                var vc = sb.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        
        
                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func login(){
        
        var strParam:String = "<Login xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>rerer</strUser>")
        strParam.appendContentsOf("<strPwd>fgfg</strPwd>")
        strParam.appendContentsOf("<strIp>192.160.30.34</strIp>")
        strParam.appendContentsOf("</Login>")
        common.getResult(strParam,strResultName: "LoginResult")
        
    }
    
    func getLoginData(){
        if(tmpString != ""){
            
           NSLog("")
            
        }
        
    }
    func setResult(strResult: String)  {
//         NSLog(strResult)
        btnLog.titleLabel?.text=""
    }
    
    
    
}

