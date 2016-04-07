//
//  PersonalCenterView.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class PersonalCenterView: UIViewController,UITableViewDelegate,UITableViewDataSource,ResultDelegate {
  	var conn=CommonParameter()
    
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
   
  		@IBAction func btnRefresh(sender: UIButton) {
            
            getResult()
    }
    
    var setNameArry=["问题反馈","关于"]
    var setImge=["feedback_log","about_log"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人中心"
        self.navigationController?.navigationBarHidden=true
        self.tableViewList.dataSource=self
        self.tableViewList.delegate=self
        self.conn.delegate=self
      	getResult()
        

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
    func getResult(){
        
        var strParam:String = "<GetCredit xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>FUNTESTFZ-GT006</strUser>")
        strParam.appendContentsOf("</GetCredit>")
        conn.getResult(strParam,strResultName: "GetCreditResult")
        
    }
    func setResult(strResult: String,strType:String) {
        resultText.text=strResult
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sb = UIStoryboard(name: "Main", bundle:nil)
        var vc = sb.instantiateViewControllerWithIdentifier("ProblemController") as! ProblemController
        self.navigationController?.pushViewController(vc, animated: true)    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

    
    
    
}
