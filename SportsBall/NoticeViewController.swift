//
//  NoticeViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/7/4.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,ResultDelegate{
    
    @IBAction func backClick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    var conn=CommonParameter()
    var jsonResult:NSMutableArray=[]
    var intIndexPage=0
 var refresh=UIRefreshControl()
    @IBOutlet weak var noticeTableView: UITableView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.noticeTableView.delegate=self
        self.noticeTableView.dataSource=self
        conn.delegate=self
        
        refresh.attributedTitle=NSAttributedString(string: NSLocalizedString("DownRefresh", comment: ""))
        refresh.addTarget(self, action: "funcRefresh", forControlEvents: UIControlEvents.ValueChanged)
        noticeTableView.estimatedRowHeight = 100.0
        noticeTableView.rowHeight==UITableViewAutomaticDimension
        noticeTableView.addSubview(refresh)
        activityView.startAnimating()
        funcRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func funcRefresh(){
        intIndexPage += 1
        var strParam:String = "<GetAnnouncement xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<status>0</status>")
        strParam.appendContentsOf("<iPageindex>\(intIndexPage)</iPageindex>")
        strParam.appendContentsOf("<iPerPageSize>100</iPerPageSize>")
        strParam.appendContentsOf("</GetAnnouncement>")
        conn.getResult(strParam,strResultName: "GetAnnouncementResponse")
        
        
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonResult.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell: NoticeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? NoticeTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? NoticeTableViewCell
            
        }
//        cell.lableContent.sizeToFit()
         var strContent=jsonResult[indexPath.row].objectForKey("N_NR_CN")as! String
        var strTime=jsonResult[indexPath.row].objectForKey("N_FBSJ")as! String
        cell.lableContent.text=strContent
        cell.lableTime.text=ToolsCode.formatterDate(strTime,format: "YYYY/MM/dd HH:mm")
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
       
        return 230
    }
    func setResult(strResult: String, strType: String) {
        if(strType=="Error"){
            return
        }
        if(strResult==""){
            return
        }
        if(strType == "WebError" || strResult == "Error"){
            alertMessage(NSLocalizedString("NetworkError", comment: ""))
            return
        }
        activityView.stopAnimating()
        refresh.endRefreshing()
        NSLog(strResult)
        let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
                                                                  options: NSJSONReadingOptions.MutableContainers) as! NSArray
        if(jsonArr.count==0){
            //            var alert = UIAlertView()
            //            alert.title = NSLocalizedString("SystemPrompt", comment: "")
            //            alert.message = NSLocalizedString("FinishedLoading", comment: "")
            //            alert.addButtonWithTitle("Cancel")
            //            //            alert.addButtonWithTitle("OK")
            //            alert.show()
            return
        }
        
        print("记录数：\(jsonArr.count)")
        
        for json in jsonArr {
            
            jsonResult.addObject(json)
            
        }
        self.noticeTableView.reloadData()
    
    }

}
