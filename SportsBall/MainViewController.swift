//
//  MainViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/4.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,CirCleViewDelegate,UITableViewDataSource,UITableViewDelegate{
     var circleView: CirCleView!
    
 
    @IBOutlet weak var tableData: UITableView!
    
    var gameName=["足球竞赛","篮球竞赛","棒球竞赛","排球竞赛"]
    var gameImage=["football","baseketball","baseball","vallyball"]
    //当前屏幕对象
    var screenObject=UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        self.tableData.dataSource=self
        self.tableData.delegate=self
    
        self.view.backgroundColor=UIColor.whiteColor()
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=true
//        self.title = "CirCle"
        self.automaticallyAdjustsScrollViewInsets = false
        let imageArray: [UIImage!] = [UIImage(named: "ad2"), UIImage(named: "loop2"), UIImage(named: "loop3")]
        
        self.circleView = CirCleView(frame: CGRectMake(0, 20, self.view.frame.size.width, 200), imageArray: imageArray)
        circleView.backgroundColor = UIColor.orangeColor()
        circleView.delegate = self
               self.view.addSubview(circleView)
        
        
        
//        let tempButton = UIButton(frame: CGRectMake(0, 300, self.view.frame.size.width, 20))
//        tempButton.backgroundColor = UIColor.redColor()
//        tempButton.setTitle("appendImage", forState: UIControlState.Normal)
//        tempButton.addTarget(self, action: Selector("setImage:"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(tempButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /********************************** Privite Methods ***************************************/
     //MARK:- Privite Methods
    func setImage(sender: UIButton) {
        //        circleView.imageArray = [UIImage(named: "first.jpg"), UIImage(named: "third.jpg")]
        circleView.urlImageArray = ["http://pic1.nipic.com/2008-09-08/200898163242920_2.jpg"]
    }
    
    
    
    
    /********************************** Delegate Methods ***************************************/
     //MARK:- Delegate Methods
     //MARK: CirCleViewDelegate Methods
    
    func clickCurrentImage(currentIndxe: Int) {
        print(currentIndxe, terminator: "");
    }
    

    

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gameName.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
   
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cellName="sportCell"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellName)
        if(cell==nil){
        cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellName)
        }
        var image=cell!.viewWithTag(1) as! UIImageView
        image.image=UIImage(named: gameImage[indexPath.row])
        var labText=cell!.viewWithTag(2)as! UILabel
        labText.text=gameName[indexPath.row]
        var labTextDetail=cell!.viewWithTag(3)as! UILabel
        labTextDetail.text="赢的千万大奖"
    var labTextBottom=cell?.viewWithTag(4)as! UILabel
        labTextBottom.text="有态度看实时"
        
//        cell!.imageView?.image=UIImage(named: gameImage[indexPath.row])
//        cell!.textLabel?.text=gameName[indexPath.row]
//   
//        cell!.detailTextLabel?.text="有态度，实时比赛"
//        cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
//        var view11=UIView(frame:CGRect(x: 0, y: 0, width: 320, height: 20))
//        view11.backgroundColor=UIColor.greenColor()
//        cell?.contentView.addSubview(view11)
        return cell!
    
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 90;
    }
    
}
