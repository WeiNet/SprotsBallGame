//
//  ProblemController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/30.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit


class ProblemController: UIViewController,UITableViewDataSource,UITableViewDelegate ,ResultDelegate{

    @IBOutlet weak var tableViewList: UITableView!
    var refresh=UIRefreshControl()
    var connection=CommonParameter()
    var jsonResult:NSMutableArray=[]
    var intPage=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewList.dataSource=self
        self.tableViewList.delegate=self
        refresh.attributedTitle=NSAttributedString(string: "下拉刷新")
        refresh.addTarget(self, action: "refreshResult", forControlEvents: UIControlEvents.ValueChanged)
        self.title="问题反馈"
        self.tableViewList.addSubview(refresh)
    navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "我要反馈", style: UIBarButtonItemStyle.Bordered, target: self, action: "back"), animated: true)
        self.connection.delegate=self
        getResult()
       
    }
    func refreshResult(){
        refresh.beginRefreshing()
        getResult()
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)    }
    func back(){
        var sb = UIStoryboard(name: "Main", bundle:nil)
        var vc = sb.instantiateViewControllerWithIdentifier("ProblemFeedbackViewController") as! ProblemFeedbackViewController
        self.navigationController?.pushViewController(vc, animated: true)    }
    
   
    
    func getResult(){
        var body = "sData=gt001@FUNTEST*\(intPage)"
        intPage++
        connection.getHttpResult("GetQuestionServlet", strBody: body)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonResult.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentify="sportCell"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellIdentify)
        if(cell==nil){
        cell=UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: cellIdentify)}
        var lableTitle=cell?.viewWithTag(2) as! UILabel
        var lableDetil=cell?.viewWithTag(3)as! UILabel
        var lableTime=cell?.viewWithTag(4)as! UILabel
        var lableNumber=cell?.viewWithTag(5)as! UILabel
        var lableStatus=cell?.viewWithTag(6) as! UILabel
        var title=jsonResult[indexPath.row].objectForKey("title")as! String
        var content=jsonResult[indexPath.row].objectForKey("content")as! String
        var status=jsonResult[indexPath.row].objectForKey("status")as! Int
        var id=jsonResult[indexPath.row].objectForKey("id")as! Int
         var strTime=try!jsonResult[indexPath.row].objectForKey("createTime") as! String
               // 方式2：自定义日期格式进行转换
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"        // String 转 Date
    var nowString = try!dateFormatter2.dateFromString(strTime)
        lableTitle.text=title
        
        lableDetil.text=content
        
        if(status==0){
        lableStatus.text="未回复"
        }else{
        lableStatus.text="已回复"
            lableStatus.textColor=UIColor.redColor()
        }
        lableNumber.text="问题编号：\(id)"
      lableTime.text="\(nowString)"
        return cell!
    }
    func setResult(strResult: String,strType:String) {
       NSLog(strResult)
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
}
