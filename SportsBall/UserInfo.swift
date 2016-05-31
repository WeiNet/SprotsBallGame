//
//  BetList.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class UserInfoManager: NSObject {
    var strUserName=""
    var strUserID=""
    var strCredit=0.0
    private static let instance = UserInfoManager()
    /// 全局统一访问入口
    public class var sharedManager: UserInfoManager {
        return instance
    }
    func getUserName()->String{
        return strUserName
        
    }
    func setUserName(strName:String){
    strUserName=strName
    }
    func getUserID()->String{
        return strUserID
        
    }
    func setUserID(strID:String){
        strUserID=strID
    }
    func getCredit()->Double{
        return strCredit
        
    }
    func setCredit(strUserCredit:Double){
        strCredit=strUserCredit
    }
    
    
}
