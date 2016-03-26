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
    @IBOutlet weak var tableViewList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewList.delegate=self
        tableViewList.dataSource=self
        conn.delegate=self
        refresh.attributedTitle=NSAttributedString(string: "下拉刷新")
        refresh.addTarget(self, action: "funcRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableViewList.addSubview(refresh)
    }
    func funcRefresh(){
     
        var strParam:String = "<GetUncountBet xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>FUNTESTFZ-GT006</strUser>")
        strParam.appendContentsOf("<iPageindex>1</iPageindex>")
        strParam.appendContentsOf("<iPageSize>1</iPageSize>")
        strParam.appendContentsOf("</GetUncountBet>")
        conn.getResult(strParam,strResultName: "GetUncountBetResult")
refresh.endRefreshing()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func setResult(strResult: String) {
        NSLog(strResult)
    }

}
