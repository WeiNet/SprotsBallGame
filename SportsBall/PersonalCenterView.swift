//
//  PersonalCenterView.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class PersonalCenterView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableViewList: UITableView!
    
    var setNameArry=["问题反馈","关于"]
    var setImge=["feedback_log","about_log"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人中心"
        self.navigationController?.navigationBarHidden=true
        self.tableViewList.dataSource=self
        self.tableViewList.delegate=self
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return setNameArry.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCellWithIdentifier("SportCell")
        if(cell==nil){
             cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "SportCell")
        }
        var image=cell?.viewWithTag(1)as! UIImageView
        var name=cell?.viewWithTag(2)as! UILabel
        image.image=UIImage(named: setImge[indexPath.row])
        name.text=setNameArry[indexPath.row]
        cell?.separatorInset.bottom
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
    return 80.0
    }
    
    
    
    
}
