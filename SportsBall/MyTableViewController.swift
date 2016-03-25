//
//  MyTableViewController.swift
//  MyViewCell
//
//  Created by Brook on 16/3/22.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController,UnionTitleViewDelegate,UpViewDelegate {
    
    var tableViewCellIdentifier = "tableViewCellIdentifier"//默认的
    let unionTitleViewIdentifier = "unionTitleViewIdentifier"//联盟Identifier
    var heihtg:CGFloat = 200//赛事的注单高度
    var unionTitleInfoArray:NSMutableArray!//与UnionTitleInfo的数组对应
    var matchCells:NSArray!//与UnionTitleModel的数组对应
    var section:Int!//所在的联盟组
    var row:Int!//所在的赛事组
    
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionOpened: Int){
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[unionTitleView.section] as! UnionTitleInfo
        unionTitleInfo.unionTitleView.HeaderOpen = true
        unionTitleInfo.unionTitleModel.headerClose = false
        
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        let countOfRowsToInsert = unionTitleInfo.unionTitleModel.orderCellRollModels.count
        let indexPathsToInsert = NSMutableArray()
        
        for (var i = 0; i < countOfRowsToInsert; i++) {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        
        // 设计动画，以便让表格的打开和关闭拥有一个流畅的效果
        var insertAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Bottom
        
        // 应用单元格的更新
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(indexPathsToInsert as! [NSIndexPath], withRowAnimation: insertAnimation)
        self.tableView.endUpdates()
    }
    
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int){
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[unionTitleView.section] as! UnionTitleInfo
        unionTitleInfo.unionTitleView.HeaderOpen = false
        unionTitleInfo.unionTitleModel.headerClose = true
        
        let countOfRowsToDelete = self.tableView.numberOfRowsInSection(unionTitleView.section)
        
        if countOfRowsToDelete > 0 {
            var indexPathsToDelete = NSMutableArray()
            for (var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: unionTitleView.section))
            }
            self.tableView.deleteRowsAtIndexPaths(indexPathsToDelete as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    func upView(orderCellRollView:OrderCellRollView){
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[orderCellRollView.section] as! UnionTitleInfo
        var orderCellRollModel:OrderCellRollModel = unionTitleInfo.unionTitleModel.orderCellRollModels[orderCellRollView.row] as! OrderCellRollModel
        orderCellRollModel.close = !orderCellRollModel.close
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // 检查unionTitleInfoArray是否已被创建，如果已被创建，则检查组的数量是否匹配当前实际组的数量。通常情况下，您需要保持unionTitleInfo与组、单元格信息保持同步。如果扩展功能以让用户能够在表视图中编辑信息，那么需要在编辑操作中适当更新unionTitleInfo
        if unionTitleInfoArray == nil || unionTitleInfoArray.count != self.numberOfSectionsInTableView(self.tableView) {
            // 对于每个用户组来说，需要为每个单元格设立一个一致的unionTitleInfo对象
            var infoArray: NSMutableArray = NSMutableArray()
            
            for matchCell in matchCells {
                var unionTitleInfo:UnionTitleInfo = UnionTitleInfo()
                unionTitleInfo.unionTitleModel = matchCell as! UnionTitleModel
                unionTitleInfo.unionTitleView.HeaderOpen = true
                
                infoArray.addObject(unionTitleInfo)
            }
            unionTitleInfoArray = infoArray
        }
        
        // 联盟高度
        self.tableView.sectionHeaderHeight = CGFloat(30)
        
        //联盟xib加载
        let unionTitleViewNib: UINib = UINib(nibName: "UnionTitleView", bundle: nil)
        self.tableView.registerNib(unionTitleViewNib, forHeaderFooterViewReuseIdentifier: unionTitleViewIdentifier)
        
        //赛事标题注单xib加载
        let orderCellRollViewNib: UINib = UINib(nibName: "OrderCellRollView", bundle: nil)
        self.tableView.registerNib(orderCellRollViewNib, forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //根据关闭的注单的数量设定cell的高度，没有关闭的高度242，关闭的42
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[indexPath.section] as! UnionTitleInfo
        var orderCellRollModel:OrderCellRollModel = unionTitleInfo.unionTitleModel.orderCellRollModels[indexPath.row] as! OrderCellRollModel
        if orderCellRollModel.close == true {
            return 242 - heihtg
        }
        return 242
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的section header视图
        let unionTitleView: UnionTitleView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(unionTitleViewIdentifier) as! UnionTitleView
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[section] as! UnionTitleInfo
        
        unionTitleView.section = section
        unionTitleView.delegate = self
        unionTitleInfo.unionTitleView = unionTitleView
        unionTitleView.frame.size.width = self.tableView.frame.width
        return unionTitleView
    }
    //不是第一响应者
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Int(unionTitleInfoArray.count)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //这里决定显示否、、修改这里改成联盟和注单一起的
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[section] as! UnionTitleInfo
        var sectionOpen = unionTitleInfo.unionTitleModel.headerClose
        var count = unionTitleInfo.unionTitleModel.orderCellRollModels.count
        
        return sectionOpen ? 0 : Int(count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 返回指定的section Cell视图
        var cell:OrderCellRollView = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as! OrderCellRollView
        var unionTitleInfo:UnionTitleInfo = unionTitleInfoArray[indexPath.section] as! UnionTitleInfo
        var orderCellRollModel:OrderCellRollModel = unionTitleInfo.unionTitleModel.orderCellRollModels[indexPath.row] as! OrderCellRollModel
        
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.showView(orderCellRollModel.close)
        cell.myUpViewDelegate = self
        cell.frame.size.width = self.tableView.frame.width
        return cell
    }
}
