//
//  PersonalCenterView.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class PersonalCenterView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var setTable: UITableView!
var setNameArry=["dfdf","dfdf","ddd","df"]
    var setImge=["m1","m2","m3","m4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable.dataSource=self
        self.setTable.delegate=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return setNameArry.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cellName="setCell"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellName)
        if(cell==nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellName)
        }
        var image=cell!.viewWithTag(1) as! UIImageView
        image.image=UIImage(named: setImge[indexPath.row])
        var labText=cell!.viewWithTag(2)as! UILabel
       
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
