//
//  UnionVO.swift
//  SportsBall
//
//  Created by Brook on 16/5/13.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class allUnionVO: NSObject {
    var test:String!
    var arrayUnionVO:Array<UnionTitleVO> = Array()
    
    private static let allUnionVOInstance = AllUnionVO()
    
    class func getAllUnionVOInstance() -> AllUnionVO {
        return allUnionVOInstance
    }
    
    private override init() {} // 私有化init方法
}
