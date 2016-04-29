    //
    //  ShopingViewController.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/4/11.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //
    
    import UIKit
    
    class ShopingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate {
        var betManger:BetListManager?
        var betList:[BetInfo]?
        var comm=CommonParameter()
        @IBOutlet weak var tableList: UITableView!
        
        @IBAction func payChlick(sender: UIButton) {
            var jsonObject: [AnyObject] = []
            
            for objbet in betList!{
                jsonObject.append(objbet.toDict())
            }
            
            var str=toJSONString(jsonObject)
            
            addBet(str)
        }
        override func viewDidLoad() {
            self.title="购物车"
            betManger=BetListManager.sharedManager
            betList=betManger!.getBetList()
            self.tableList.dataSource=self
            self.tableList.delegate=self
            comm.delegate=self
            
        }
        override func viewWillAppear(animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: animated)    }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            
            return (betList?.count)!
        }
        
        
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {    var cell=tableView.dequeueReusableCellWithIdentifier("shopingcell")
            if(cell==nil){
                cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "shopingcell")
            }
            var lableV=cell?.viewWithTag(5) as! UILabel
            var lableH=cell?.viewWithTag(6) as! UILabel
            var lableBetTeam=cell?.viewWithTag(7) as! UILabel
            var lableRate=cell?.viewWithTag(10) as! UILabel
            var lableKY=cell?.viewWithTag(11) as! UILabel
            var lableDC=cell?.viewWithTag(12) as! UILabel
            var lableDZ=cell?.viewWithTag(13) as! UILabel
            lableV.text=betList![indexPath.row].visitname
            lableH.text=betList![indexPath.row].homename
            lableBetTeam.text=betList![indexPath.row].betteamName
            lableRate.text=betList![indexPath.row].visitname
            lableDC.text=betList![indexPath.row].dcsx
            lableDZ.text=betList![indexPath.row].dzxx+"-"+betList![indexPath.row].dzsx
            
            
            return cell!
        }
        
        
        func toJSONString(jsonObject: [AnyObject])->NSString{
            
            let data = try!NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
            var strJson=NSString(data: data, encoding: NSUTF8StringEncoding)
            return strJson!
        }
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
            return 190.0
        }
        
        func setResult(strResult: String, strType: String) {
            NSLog(strResult)
            
        }
        func addBet(strParam:NSString){
            var strParam:String = "<BatchAddBet xmlns=\"http://tempuri.org/\">";
            strParam.appendContentsOf("<strpara>\(strParam)</strpara>")
            strParam.appendContentsOf("<isBeting>false</iPageindex>")
            strParam.appendContentsOf("</BatchAddBet>")
            comm.getResult(strParam,strResultName: "BatchAddBetResult")        }
    }