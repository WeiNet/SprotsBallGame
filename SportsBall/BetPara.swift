//
//  BetPara.swift
//  SportsBall
//
//  Created by abel jing on 16/6/4.
//  Copyright © 2016年 abel jing. All rights reserved.
//

class BetPara {
    var  BetContent:[BetInfo]=[]
    var money:String=""
    var moneySum:String=""
    var inum:String=""
    var USER:String=""
    
    func setBetContent(betArry:[BetInfo]){
    
        BetContent=betArry
    
    }
    
    func toString(strBetContent:NSString)->String{
    
    var strBetInfoModel:String = "{"
        strBetInfoModel.appendContentsOf("\"BetContent\":\(strBetContent),")
        strBetInfoModel.appendContentsOf("\"USER\":\"\(USER)\",")
        strBetInfoModel.appendContentsOf("\"inum\":\"\(inum)\",")
        strBetInfoModel.appendContentsOf("\"money\":\"\(money)\",")
        strBetInfoModel.appendContentsOf("\"moneySum\":\"\(moneySum)\"")
        strBetInfoModel.appendContentsOf("}")
        return strBetInfoModel
    
    }
    
    
    
}
