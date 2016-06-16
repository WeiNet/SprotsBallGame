//
//  HelpController.swift
//  SportsBall
//
//  Created by abel jing on 16/5/4.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class HelpController: UIViewController {
    
    var alertMenu:UIAlertController!
    @IBOutlet weak var webView: UIWebView!
   var menuArray: Array<Dictionary<String,String>> = [["0":NSLocalizedString("SportsComment", comment: "")],["2":NSLocalizedString("Foot", comment: "")],["1":NSLocalizedString("Baseket", comment: "")]]
    override func viewDidLoad() {
        view.backgroundColor=UIColor.whiteColor()
        loadWebView("QA_sport");
        createMenu(menuArray)
    }
    func loadWebView(htmlName:String){
        let path = NSBundle.mainBundle().pathForResource(htmlName, ofType: ".html",
            inDirectory: "HTML")
        let url = NSURL(fileURLWithPath:path!)
        let request = NSURLRequest(URL:url)
        
        //将浏览器视图全屏(在内容区域全屏,不占用顶端时间条)
        webView.scalesPageToFit=true
        //let theWebView:WKWebView = WKWebView(frame:UIScreen.mainScreen().applicationFrame)
        //禁用页面在最顶端时下拉拖动效果
        webView.scrollView.bounces = false
        
        //加载页面
        webView.loadRequest(request)

    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //创建玩法菜单
    func createMenu(menuArray: Array<Dictionary<String,String>>){
        if(menuArray.count <= 0){
            return
        }
        alertMenu = UIAlertController(title: NSLocalizedString("GameType", comment: ""), message: NSLocalizedString("PleaseSelect", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        for menu in menuArray {
            for (key,value) in menu {
                let item = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    self.clickMenuItem(key)
                })
                alertMenu.addAction(item)
            }
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alertMenu.addAction(cancel)
    }
    //玩法菜单选项响应事件
    func clickMenuItem(key:String){
        switch(key){
        case "0":
             loadWebView("QA_sport");
            break
        case "1":
             loadWebView("rule_lq");
            break
        default:
             loadWebView("rule_zq");
            break
        
        }
        print(key)
    }

    @IBAction func showAlert(sender: AnyObject) {
        self.presentViewController(alertMenu, animated: true, completion: nil)
    }

}
