//
//  BetList.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BetListManager: NSObject {
      var  betList:[BetInfo]=[]
    private static let instance = BetListManager()
    /// 全局统一访问入口
    public class var sharedManager: BetListManager {
        return instance
    }
    func getBetList()->[BetInfo]{
        return betList

    }



}
