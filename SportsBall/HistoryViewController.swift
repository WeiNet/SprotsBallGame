//
//  HistoryViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,ResultDelegate{
    var refresh=UIRefreshControl()
    var conn=CommonParameter()
    var jsonResult:NSMutableArray=[]
    var intIndexPage=0
    
    @IBAction func backClick(sender: AnyObject) {
        
        var sb = UIStoryboard(name: "Main", bundle:nil)
       
            var vc = sb.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var tableViewList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        activityView.hidesWhenStopped=true
        self.navigationItem.leftBarButtonItem = nil
        tableViewList.delegate=self
        tableViewList.dataSource=self
        conn.delegate=self
        
        refresh.attributedTitle=NSAttributedString(string: "下拉刷新")
        refresh.addTarget(self, action: "funcRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableViewList.addSubview(refresh)
        funcRefresh()
    }
    func funcRefresh(){
        intIndexPage++
        var strParam:String = "<GetUncountBet xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>\(UserInfoManager.sharedManager.getUserID())</strUser>")
        strParam.appendContentsOf("<iPageindex>\(intIndexPage)</iPageindex>")
        strParam.appendContentsOf("<iPageSize>100</iPageSize>")
        strParam.appendContentsOf("</GetUncountBet>")
        conn.getResult(strParam,strResultName: "GetUncountBetResult")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonResult.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identify="sportBall"
        var cell=tableViewList.dequeueReusableCellWithIdentifier(identify)
        if(cell==nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
        }
        var image=cell!.viewWithTag(7)as!UIImageView
        var labTime=cell!.viewWithTag(2)as! UILabel
        var labDetil=cell!.viewWithTag(3)as! UILabel
        var labType=cell!.viewWithTag(4)as! UILabel
        var labOut=cell!.viewWithTag(5)as! UILabel
        var labin=cell!.viewWithTag(6)as! UILabel
        var time=jsonResult[indexPath.row].objectForKey("N_XZRQ")as! String
        var xzdh=jsonResult[indexPath.row].objectForKey("N_XZDH")as! String
        var lx=jsonResult[indexPath.row].objectForKey("N_BSLX")as! String
        var xzje=jsonResult[indexPath.row].objectForKey("N_XZJE")as! Float
        var kyje=jsonResult[indexPath.row].objectForKey("N_KYJE")as! Float
        var xznr=jsonResult[indexPath.row].objectForKey("N_XZNR")as! String
        if(lx=="b_bk"){
            image.image=UIImage(named: "baseketball")
        }else{
            image.image=UIImage(named: "football")
        }
        labDetil.attributedText=NSAttributedString(string:xznr as! String)
        //        labin.text=xzje as! String
        //        labOut.text=kyje as! String
        
        var attrStr = try! NSAttributedString(
            data: xznr.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        labDetil.attributedText = attrStr
        labType.text=xzdh
        labOut.text="已投"+String(stringInterpolationSegment: xzje)
        labin.text="可赢"+String(stringInterpolationSegment: kyje)
        labTime.text=ToolsCode.formatterDate(time,format: "MM/dd HH:mm")
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func setResult(strResult: String,strType:String) {
        if(strType=="Error"){
        return
        }
        if(strResult==""){
        return
        }
       
        activityView.stopAnimating()
        refresh.endRefreshing()
        NSLog(strResult)
        let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
            options: NSJSONReadingOptions.MutableContainers) as! NSArray
        if(jsonArr.count==0){
            var alert = UIAlertView()
            alert.title = "系统信息"
            alert.message = "已加载完成"
            alert.addButtonWithTitle("Cancel")
            //            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        
        print("记录数：\(jsonArr.count)")
        
        for json in jsonArr {
            
            jsonResult.addObject(json)
            
        }
        self.tableViewList.reloadData()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
}
