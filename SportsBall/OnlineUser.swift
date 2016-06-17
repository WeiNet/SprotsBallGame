//
//  OnlineUser.swift
//  SportsBall
//
//  Created by Brook on 16/6/3.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

////退出系统
//protocol ExitDelegate: NSObjectProtocol {
//    func systemExit()//退出系统
//}

//修改在线会员状态
class OnlineUser: NSObject,ResultDelegate {
    private static let onlineUserInstance = OnlineUser()
    private override init() {} // 私有化init方法
    var common=CommonParameter()//网络请求
    let modifyOnlineUserResponse:String = "ModifyOnlineUserResponse"
    var isStart:Bool = true
    
//    var exitDelegate:ExitDelegate!
    
    class func getOnlineUserInstance() -> OnlineUser {
        return onlineUserInstance
    }
    
    //远端回传资料响应协议
    internal func setResult(strResult: String,strType:String)  {
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == "WebError" || strResult == "Error"){
            print("网络连接异常!")
            return
        }
        if(strType == modifyOnlineUserResponse){
            isStart = (strResult == "true" ? true : false)
        }
    }
    
    //修改在线会员状态
    private func ModifyOnlineUser(){
        let user:UserInfoManager = UserInfoManager.sharedManager
        var strParam:String = "<ModifyOnlineUser xmlns=\"http://tempuri.org/\">"
        strParam.appendContentsOf("<strUser>\(user.getUserID())</strUser>")
        strParam.appendContentsOf("</ModifyOnlineUser>")
        common.getResult(strParam,strResultName: modifyOnlineUserResponse)
    }
    
    //启动线程
    func ThreadStart(){
        common.matchingElement = modifyOnlineUserResponse
        common.delegate = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{()->Void in
            //耗时代码块
            while(self.isStart){
                self.ModifyOnlineUser()
                NSThread.sleepForTimeInterval(600)
            }
            //执行完  调用主线程刷新界面
            dispatch_async(dispatch_get_main_queue(),{()->Void in
                //通知主线程退出系统
                exit(0)
//                self.exitDelegate.systemExit()
            })
        })
    }
}
