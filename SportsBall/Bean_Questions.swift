//
//  Bean_Questions.swift
//  SportsBall
//
//  Created by abel jing on 16/4/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class Bean_Questions:NSObject{

//    var id :Int?
    var account:String?
//    var createTime:String?
    var title:String?
    var content:String?
    var telNum:String?
    var status:String?
    var lang:String?
    init(_account:String,_title:String,_content:String,_telNum:String,_status:String,_lang:String){
       
        self.account=_account
       
        self.title=_title
        self.telNum=_telNum
        self.status=_status
        self.lang=_lang
        self.content=_content
    
    
    }
}
