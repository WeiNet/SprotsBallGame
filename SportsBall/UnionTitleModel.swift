//
//  UnionTitleModel.swift
//  MyCellListTest
//
//  Created by Brook on 16/3/11.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

class UnionTitleModel: NSObject {
    var id: String?
    var name: String?
    var count: String?
    var icon: String?
    var unionOpen: Bool = true
    
    //注单数据
    var orderCellModels:NSArray = NSArray()
}
