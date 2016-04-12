//
//  BetList.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BetList: NSObject {
    var betList: [BetInfo]?
    class var sharedInstance: BetList {
        get {
            
            struct SingletonStruct {
                static let singleton: BetList = BetList()
            }
            return SingletonStruct.singleton
        }
        
    }




}
