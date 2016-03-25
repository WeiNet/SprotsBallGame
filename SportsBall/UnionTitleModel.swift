//
//  UnionTitleModel.swift
//  MyCellListTest
//
//  Created by Brook on 16/3/11.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

class UnionTitleModel: NSObject {
    var name: String!
    var count: String!
    var icon: String!
    var headerClose: Bool = false
    
    var orderCellRollModels:NSArray = NSArray()//包含赛事标题与注单数据
}
