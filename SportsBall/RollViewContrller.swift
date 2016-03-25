//
//  RollViewContrller.swift
//  SportsBall
//
//  Created by Brook on 16/3/24.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewContrller:MyTableViewController,ResultDelegate {
    var common=CommonParameter()//网络请求
    
    func setResult(strResult: String)  {
        NSLog(strResult)
    }
    
    override func viewDidLoad() {
        common.delegate = self
        common.matchingElement = "GetFootballMatchResult"
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>3</strPageSize>")
        strParam.appendContentsOf("<strUser></strUser>")
        strParam.appendContentsOf("<strType>0</strType>")
        strParam.appendContentsOf("</GetFootballMatch>")
        common.getResult(strParam,strResultName: "LoginResult")
        
        self.matchCells = loadUnionAndMatchInfo()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //加载资料
    func loadUnionAndMatchInfo() -> NSArray {
        var unionTitleModels: NSMutableArray?
        
        // 定位到plist文件并将文件拷贝到数组中存放
        var fileUrl = NSBundle.mainBundle().URLForResource("PropertyList", withExtension: "plist")
        var GroupDictionariesArray = NSArray(contentsOfURL: fileUrl!)
        unionTitleModels = NSMutableArray(capacity: GroupDictionariesArray!.count)
        
        
        // 遍历数组，组合出UnionTitleModel
        for GroupDictionary in GroupDictionariesArray! {
            var unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.name = GroupDictionary["name"] as! String
            unionTitleModel.count = GroupDictionary["count"] as! String
            unionTitleModel.icon = GroupDictionary["icon"] as! String
            
            var cellDictionaries: NSMutableArray = GroupDictionary["matchs"] as! NSMutableArray
            var orderCellRollModels = NSMutableArray(capacity: cellDictionaries.count)
            //组合出OrderCellRollModel
            for cellDictionarie in cellDictionaries {
                var orderCellRollModel:OrderCellRollModel = OrderCellRollModel()
                //                orderCellRollModel.setValuesForKeysWithDictionary(cellDictionarie as! [String : AnyObject])
                orderCellRollModels.addObject(orderCellRollModel)
            }
            unionTitleModel.orderCellRollModels = orderCellRollModels
            unionTitleModels!.addObject(unionTitleModel)
        }
        return unionTitleModels!
    }

}
