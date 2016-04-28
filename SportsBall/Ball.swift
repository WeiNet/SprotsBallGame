//
//  Ball.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class Ball: NSObject {
    
    //显示赛事（联盟、赛事队伍）
    func stringToDictionary(strResult: String)->NSMutableArray{
        let aryUnionInfo:NSMutableArray = NSMutableArray()
        
        var aryUnionVO:Array<UnionTitleVO> = Array()
        let info = ToolsCode.toJsonArray(strResult)
        let unionJson = info[1]
        if unionJson.count == 0 {//没有资料
            print("没有资料")
            return aryUnionInfo
        }
        let objCount:Int = unionJson.count - 1
        for index in 0...objCount {
            let unionVO:UnionTitleVO = UnionTitleVO()
            unionVO.N_NO = String(unionJson[index].objectForKey("N_NO")!)
            unionVO.N_LMMC = String(unionJson[index].objectForKey("N_LMMC")!)
            aryUnionVO.append(unionVO)
        }
        
        let matchJson = info[0]
        let matchCount:Int = matchJson.count - 1
        for union in aryUnionVO {
            let unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.id = String(union.N_NO)
            unionTitleModel.name = String(union.N_LMMC)
            
            var aryOrderCellModel:Array<OrderCellModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchJson[index].objectForKey("N_LMNO")!) {
                    let orderCellModel:OrderCellModel = OrderCellModel()
                    //给注单属性赋值
                    orderCellModel.setValuesForKeysWithDictionary(matchJson[index] as! [String : AnyObject])
                    aryOrderCellModel.append(orderCellModel)
                }
            }
            unionTitleModel.count = String(aryOrderCellModel.count)
            unionTitleModel.orderCellModels = aryOrderCellModel
            if aryOrderCellModel.count > 0 {
                aryUnionInfo.addObject(unionTitleModel)
            }
        }
        return aryUnionInfo
    }
}
