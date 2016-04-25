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
        strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
        strParam.appendContentsOf("</GetCredit>")
        conn.getResult(strParam,strResultName: "GetCreditResult")
        
    }
    func setResult(strResult: String,strType:String) {
        if(strType=="Error"){
            return
        }
        if(strResult==""){
            return
        }
        var result = ( strResult as NSString ).floatValue;
        resultText.text="\(result*10000)"
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var objInfo1=BetInfo()
        objInfo1.dMoney="10"
        objInfo1.dzsx="11"
        objInfo1.dzxx="45"
        objInfo1.homename="dfdf"
        var jsonObject: [AnyObject] = []
        jsonObject.append(objInfo1)
        let jsonString = JSONStringify(jsonObject)
        print(jsonString)
        
        var sb = UIStoryboard(name: "Main", bundle:nil)
        if(indexPath.row==0){
            var vc = sb.instantiateViewControllerWithIdentifier("ShopingViewController") as! ShopingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row==1){
            
            
            var vcAbout = sb.instantiateViewControllerWithIdentifier("AboutController") as! AboutController
            self.navigationController?.pushViewController(vcAbout, animated: true)
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
        return strJson!}
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
            
            let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
            
            
            if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return string as String
            }
        }catch {
            
            print("error")
            //Access error here
            }
            
            }
            return ""
            
    }
}
