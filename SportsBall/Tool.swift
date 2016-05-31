    //
    //  ToJSON.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/5/31.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //

    import Foundation

    class Tool: NSObject {
      //将返回结果转化为字典
        static func toJson(strResult:NSString)->NSMutableDictionary {
        
        let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
        
        let json = try! NSJSONSerialization.JSONObjectWithData(data!,
        options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
        return json
        
        }
       
        static func showMsg(strMsg:String){
            let alertView = UIAlertView()
            alertView.title = "系统提示"
            alertView.message = strMsg 
            alertView.addButtonWithTitle("确定")
            alertView.show()}
        
    }
     