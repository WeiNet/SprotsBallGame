//
//  AllUnionVO.swift
//  SportsBall
//
//  Created by Brook on 16/5/14.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class AllUnionVO: NSObject {
    var arrayUnionVO:Array<UnionTitleVO> = Array()
    var selNO = ""
    
    private static let allUnionVOInstance = AllUnionVO()
    
    class func getAllUnionVOInstance() -> AllUnionVO {
        return allUnionVOInstance
    }
    
    private override init() {} // 私有化init方法
}
