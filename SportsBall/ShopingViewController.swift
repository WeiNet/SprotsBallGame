    //
    //  ShopingViewController.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/4/11.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //
    
    import UIKit
    
    class ShopingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
        var betManger:BetListManager?
        var betList:[BetInfo]?
        @IBOutlet weak var tableList: UITableView!
        override func viewDidLoad() {
            self.title="购物车"
            betManger=BetListManager.sharedManager
            betList=betManger!.getBetList()
            self.tableList.dataSource=self
            self.tableList.delegate=self
            
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
            
                       return cell!
        }
        
        
        func toJSONString()->NSString{
            var dict=[BetInfo]()
            var objInfo1=BetInfo()
            objInfo1.dMoney="10"
            objInfo1.dzsx="11"
            objInfo1.dzxx="45"
            objInfo1.homename="dfdf"
            dict.append(objInfo1)
            
            //        let dict = ["name":"Jobs","friends":["Ive","Cook"]]
            let data = try!NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            var strJson=NSString(data: data, encoding: NSUTF8StringEncoding)
            return strJson!
        }
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
            return 190.0
        }
        
    }