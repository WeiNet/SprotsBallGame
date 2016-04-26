//
//  TableView.swift
//  SportsBall
//
//  Created by Brook on 16/4/25.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class TableView: UITableView,UITableViewDataSource,UITableViewDelegate,ShowDelegate,UnionTitleViewDelegate {
    
    var infoArray:NSMutableArray!//与UnionTitleInfo的数组对应
    let cellIdentifier = "cellIdentifier"
    let unionIdentifier = "unionIdentifier"
    let matchHeight:CGFloat = 40
    let orderHeight:CGFloat = 216
    
    //初始化TableView
    func initDelegate(matchArray:NSArray){
        self.dataSource = self
        self.delegate = self
        
        // 检查infoArray是否已被创建，如果已被创建，则检查组的数量是否匹配当前实际组的数量。通常情况下，您需要保持infoArray与组、单元格信息保持同步。如果扩展功能以让用户能够在表视图中编辑信息，那么需要在编辑操作中适当更新infoArray
        if infoArray == nil || infoArray.count != self.numberOfSectionsInTableView(self) {
            // 对于每个用户组来说，需要为每个单元格设立一个一致的infoArray对象
            var infos: NSMutableArray = NSMutableArray()
            
            for match in matchArray {
                var info:UnionTitleInfo = UnionTitleInfo()
                info.unionTitleModel = match as! UnionTitleModel
                info.unionTitleView.HeaderOpen = true
                
                infos.addObject(info)
            }
            infoArray = infos
        }
        
        // 联盟高度
        self.sectionHeaderHeight = CGFloat(38)
        
        //联盟xib加载
        let unionNib: UINib = UINib(nibName: "UnionTitleView", bundle: nil)
        self.registerNib(unionNib, forHeaderFooterViewReuseIdentifier: unionIdentifier)
        
        //赛事标题注单xib加载
        let orderNib: UINib = UINib(nibName: "Cell", bundle: nil)
        self.registerNib(orderNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    //抛出运行时异常
    func throwError(){
        if infoArray == nil{
            fatalError("infoArray 对象没有初始化")
        }
    }
    
    //关闭打开赔率View，显示的高度由 heightForRowAtIndexPath决定
    func upOrderViewShow(cellView:Cell){
        if(cellView.section == nil || cellView.row == nil){
            fatalError("section或row 没有初始化")
        }
        let infos:UnionTitleInfo = infoArray[cellView.section] as! UnionTitleInfo
        let cellModel:OrderCellModel = infos.unionTitleModel.orderCellModels[cellView.row] as! OrderCellModel
        cellModel.orderClose = !cellModel.orderClose
        
        self.beginUpdates()
        self.endUpdates()
    }
    
    //联盟展开
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionOpened: Int){
        let infos:UnionTitleInfo = infoArray[unionTitleView.section] as! UnionTitleInfo
        infos.unionTitleView.HeaderOpen = true
        infos.unionTitleModel.unionOpen = false
        
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        let countOfRowsToInsert = infos.unionTitleModel.orderCellModels.count
        let indexPathsToInsert = NSMutableArray()
        
        for(var i = 0; i < countOfRowsToInsert; i++) {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        
        // 设计动画，以便让表格的打开和关闭拥有一个流畅的效果
        let animation: UITableViewRowAnimation = UITableViewRowAnimation.Bottom
        
        // 应用单元格的更新
        self.beginUpdates()
        self.insertRowsAtIndexPaths(indexPathsToInsert as! [NSIndexPath], withRowAnimation: animation)
        self.endUpdates()
    }
    
    //联盟关闭
    func sectionHeaderUnion(unionTitleView: UnionTitleView, sectionClosed: Int){
        let infos:UnionTitleInfo = infoArray[unionTitleView.section] as! UnionTitleInfo
        infos.unionTitleView.HeaderOpen = false
        infos.unionTitleModel.unionOpen = true
        
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        let countOfRowsToDelete = self.numberOfRowsInSection(unionTitleView.section)
        
        if countOfRowsToDelete > 0 {
            let indexPathsToDelete = NSMutableArray()
            for(var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: unionTitleView.section))
            }
            self.deleteRowsAtIndexPaths(indexPathsToDelete as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    //联盟显示多少行
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        throwError()
        return Int(infoArray.count)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的section header视图
        let union: UnionTitleView = self.dequeueReusableHeaderFooterViewWithIdentifier(unionIdentifier) as! UnionTitleView
        let infos:UnionTitleInfo = infoArray[section] as! UnionTitleInfo
        
        union.section = section
        union.delegate = self
        infos.unionTitleView = union
        union.frame.size.width = self.frame.width
        
        union.name.text = "★\(infos.unionTitleModel.name!)"
        union.count.text = "X\(infos.unionTitleModel.count!)"
        union.HeaderOpen = !infos.unionTitleModel.unionOpen
        
        return union
    }
    
    //每个联盟下面Cell显示多少行，有联盟的打开和关闭决定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let infos:UnionTitleInfo = infoArray[section] as! UnionTitleInfo
        let sectionOpen = infos.unionTitleModel.unionOpen
        let count = infos.unionTitleModel.orderCellModels.count
        
        return sectionOpen ? 0 : Int(count)
    }
    
    //设定每个Cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //赛事标题View的高度是40，下注赔率View的高度是216
        let infos:UnionTitleInfo = infoArray[indexPath.section] as! UnionTitleInfo
        let cellModel:OrderCellModel = infos.unionTitleModel.orderCellModels[indexPath.row] as! OrderCellModel
        if cellModel.orderClose {
            return (matchHeight + 1)
        }else{
            return (matchHeight + orderHeight + 2)
        }
    }
    
    //tableView中的Cell视图的创建加载--------由页面自己写
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 返回指定的section Cell视图
        var cell:Cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! Cell
        
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.showDelegate = self
        var breakfastView = NSBundle.mainBundle().loadNibNamed("BreakfastView" , owner: nil, options: nil).first as? BreakfastView
        breakfastView?.frame.size.height = orderHeight
        breakfastView!.userInteractionEnabled()
        //加载时赔率是打开的就要立即添加手势事件
        breakfastView!.addGestureRecognizer()
        cell.gestureDelegate = breakfastView!
        cell.orderView.addSubview(breakfastView!)
        //点击不改变整行Cell的颜色
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}
