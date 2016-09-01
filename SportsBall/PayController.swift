//
//  PayController.swift
//  SportsBall
//
//  Created by abel jing on 16/5/17.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class PayController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate {
    @IBOutlet weak var viewOne: UIView!
    
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var viewTwo: UIView!
    var conn=CommonParameter();
    
    @IBOutlet weak var betMoney: UILabel!
    
    @IBOutlet weak var payMoney: UILabel!
    var  dateArry=[""]
    var refresh=UIRefreshControl()
    var jsonResult=NSMutableArray()
    var jsonDetail=NSMutableArray()
    var mdate:String=""
    var intIndexPage:Int=0
    @IBAction func dateTimeClick(sender: AnyObject) {
        //配置零：内容配置
        
        if(dateArry.isEmpty){
            return}
        
       
        let menuArray = [KxMenuItem.init("\(dateArry[0])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[1])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[2])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[3])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[4])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[5])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[6])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[7])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[8])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[9])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[10])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[11])",image: UIImage(named: ""), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("\(dateArry[12])",image: UIImage(named: ""), target: self, action: "respondOfMenu:")
        ]
       
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 12,  //指示箭头大小
            marginXSpacing: 20,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 20,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: true,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        
        
        //菜单展示
        KxMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: menuArray, withOptions: options)
        
        
        
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func viewDidLoad() {
        setViewBackground()
        self.tableList.dataSource=self
        self.tableList.delegate=self
        conn.delegate=self
        refresh.attributedTitle=NSAttributedString(string: NSLocalizedString("DownRefresh", comment: ""))
        refresh.addTarget(self, action: "funcRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableList.addSubview(refresh)
        getDate()
        
    }
    func setViewBackground(){
        
        self.viewOne.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
        self.viewOne.layer.borderWidth = 1
        self.viewTwo.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
        self.viewTwo.layer.borderWidth = 1
    }
    func respondOfMenu(sender: AnyObject) {
        self.intIndexPage=0
        self.btnTitle.setTitle(sender.title!, forState: UIControlState.Normal)
        mdate=sender.title!!
        print(mdate)
        funcRefresh()
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonDetail.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identify="sportBall"
        var cell=tableView.dequeueReusableCellWithIdentifier(identify)
        if(cell==nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
        }
        if(jsonDetail.count>0){
        var image=cell?.viewWithTag(2) as! UIImageView
        var labelDetail=cell?.viewWithTag(3) as! UILabel
        var labelYT=cell?.viewWithTag(4)as! UILabel
        var labelTime=cell?.viewWithTag(5) as! UILabel
        var labelNumber=cell?.viewWithTag(6) as! UILabel
        var labelResult=cell?.viewWithTag(7) as! UILabel
        var xznr=jsonDetail[indexPath.row].objectForKey("N_XZNR")as! String
        var zdh=jsonDetail[indexPath.row].objectForKey("N_XZDH")as! String
        var xzje=jsonDetail[indexPath.row].objectForKey("N_XZJE")
        var hyjg=jsonDetail[indexPath.row].objectForKey("N_HYJG")
        var time=jsonDetail[indexPath.row].objectForKey("N_XZRQ")as! String
        if(xznr.containsString("足球")){
            image.image=UIImage(named: "football")
        }else{
            image.image=UIImage(named: "baseketball")
        }
        var attrStr = try! NSAttributedString(
            data: xznr.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        labelDetail.attributedText = attrStr
        labelNumber.text=zdh
        labelYT.text="\(Double(xzje! as! NSNumber))"
        labelResult.text="\(Double(hyjg! as! NSNumber))"
        labelTime.text=ToolsCode.formatterDate(time,format: "MM/dd HH:mm")
       
        print(xzje)
        print(hyjg)
        }
        return cell!
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150.0
    }
    
    func getDate(){
        
        var strParam:String = "<GetDate xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<inum>13</inum>")
        strParam.appendContentsOf("</GetDate>")
        conn.getResult(strParam,strResultName: "GetDateResult")
    }
    func setResult(strResult: String, strType: String) {
        //       print(strResult)
        if(strType=="Error"){
            return
        }
        if(strResult==""){
            return
        }
        if(strType=="GetDateResult"){
            
            dateArry=strResult.componentsSeparatedByString(",")
            btnTitle.setTitle(dateArry[0], forState: UIControlState.Normal)
            mdate=dateArry[0]
            funcRefresh()
            
            return
        }
        if(strType=="GetBetsDetailResult"){
            print(strResult)
            
            jsonResult = ToolsCode.toJsonArray(strResult) as! NSMutableArray
            refresh.endRefreshing()
            if(jsonResult[0] as! NSObject==[]){
                
                jsonDetail=[]
                self.tableList.reloadData()
                self.betMoney.text="0.0"
                self.payMoney.text="0.0"
//                var alert = UIAlertView()
//                alert.title = NSLocalizedString("SystemPrompt", comment: "")
//                alert.message = NSLocalizedString("FinishedLoading", comment: "")
//                alert.addButtonWithTitle("Cancel")
//               
//                alert.show()
                return
            }
           
   var arryDetail = jsonResult[0]as! NSMutableArray
            var betmoney1=jsonResult[1] as! NSNumber
            var paymoney1=jsonResult[2] as! NSNumber
            var payCount=Double(betmoney1)+Double(paymoney1)
//            jsonDetail.addObjectsFromArray(arryDetail as [AnyObject])
            jsonDetail=arryDetail
             self.betMoney.text="\(jsonResult[1])"
            self.payMoney.text="\(payCount)"
            print(jsonResult[1].classForCoder)
            self.tableList.reloadData()
            
        }
        
    }
    func funcRefresh(){
        
        intIndexPage++
        var strParam:String = "<GetBetsDetail xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strUser>\(UserInfoManager.sharedManager.getUserID())</strUser>")
        strParam.appendContentsOf("<strBallType>all</strBallType>")
        strParam.appendContentsOf("<strDate>\(mdate)</strDate>")
        strParam.appendContentsOf("<iPageindex>\(intIndexPage)</iPageindex>")
        strParam.appendContentsOf("<iPageSize>100000</iPageSize>")
        strParam.appendContentsOf("</GetBetsDetail>")
        conn.getResult(strParam,strResultName: "GetBetsDetailResult")
        
        
        
    }
    
}
