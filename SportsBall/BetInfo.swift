//
//  BetInfo.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BetInfo: NSObject {
    var  Index:String = ""
    var  strUser:String=""
    var  dMoney:String=""
    var  yssj:String=""
    var  playType:String=""
    var  lr:String=""
    var  ballType:String=""
    var  id:String=""
    var  courtType:String=""
    var  tid:String=""
    var  rate:String=""
    var  vh:String=""
    var  strlet:String=""
    var  hfs:String=""
    var  hlx:String=""
    var  hbl:String=""
    var  strbet:String=""
    var  visitname:String=""
    var  homename:String=""
    var  jzf:String=""
    var  isLive:String=""
    var  allianceName:String=""
    var  date:String=""
    var  isjzf:String=""
    var  score:String=""
    var  dzxx:String=""
    var  dzsx:String=""
    var  dcsx:String=""
    var  kyje:String=""
    var  ballhead:String=""
    var betteamName:String=""
    func toDict() -> [String : String] {
        var dics:Dictionary<String,String>=["Index":"\(Index)","strUser":"\(strUser)","dMoney":"\(dMoney)","yssj":"\(yssj)","playType":"\(playType)","lr":"\(lr)","ballType":"\(ballType)","id":"\(id)","courtType":"\(courtType)","tid":"\(tid)","rate":"\(rate)","vh":"\(vh)","strlet":"\(strlet)","hfs":"\(hfs)","hlx":"\(hlx)","hbl":"\(hbl)","strbet":"\(strbet)","visitname":"\(visitname)","homename":"\(homename)","jzf":"\(jzf)","isLive":"\(isLive)","allianceName":"\(allianceName)","date":"\(date)","isjzf":"\(isjzf)","score":"\(score)","dzxx":"\(dzxx)","dzsx":"\(dzsx)","dcsx":"\(dcsx)","kyje":"\(kyje)","ballhead":"\(ballhead)","betteamName":"\(betteamName)"]
        return dics
    }
    
    func toString()->String{
        var strBetInfoModel:String = "{"
        strBetInfoModel.appendContentsOf("\"Index\":\"\(Index)\",")
        strBetInfoModel.appendContentsOf("\"strUser\":\"\(strUser)\",")
        strBetInfoModel.appendContentsOf("\"dMoney\":\"\(dMoney)\",")
        strBetInfoModel.appendContentsOf("\"yssj\":\"\(yssj)\",")
        strBetInfoModel.appendContentsOf("\"playType\":\"\(playType)\",")
        
        strBetInfoModel.appendContentsOf("\"lr\":\"\(lr)\",")
        strBetInfoModel.appendContentsOf("\"ballType\":\"\(ballType)\",")
        strBetInfoModel.appendContentsOf("\"id\":\"\(id)\",")
        strBetInfoModel.appendContentsOf("\"courtType\":\"\(courtType)\",")
        strBetInfoModel.appendContentsOf("\"tid\":\"\(tid)\",")
        
        strBetInfoModel.appendContentsOf("\"rate\":\"\(rate)\",")
        strBetInfoModel.appendContentsOf("\"vh\":\"\(vh)\",")
        strBetInfoModel.appendContentsOf("\"let\":\"\(strlet)\",")
        strBetInfoModel.appendContentsOf("\"hfs\":\"\(hfs)\",")
        strBetInfoModel.appendContentsOf("\"hlx\":\"\(hlx)\",")
        
        strBetInfoModel.appendContentsOf("\"hbl\":\"\(hbl)\",")
        strBetInfoModel.appendContentsOf("\"strbet\":\"\(strbet)\",")
        strBetInfoModel.appendContentsOf("\"visitname\":\"\(visitname)\",")
        strBetInfoModel.appendContentsOf("\"homename\":\"\(homename)\",")
        strBetInfoModel.appendContentsOf("\"jzf\":\"\(jzf)\",")
        
        strBetInfoModel.appendContentsOf("\"isLive\":\"\(isLive)\",")
        strBetInfoModel.appendContentsOf("\"allianceName\":\"\(allianceName)\",")
        strBetInfoModel.appendContentsOf("\"date\":\"\(date)\",")
        strBetInfoModel.appendContentsOf("\"isjzf\":\"\(isjzf)\",")
        strBetInfoModel.appendContentsOf("\"score\":\"\(score)\",")
        
        strBetInfoModel.appendContentsOf("\"dzxx\":\"\(dzxx)\",")
        strBetInfoModel.appendContentsOf("\"dzsx\":\"\(dzsx)\",")
        strBetInfoModel.appendContentsOf("\"dcsx\":\"\(dcsx)\",")
        strBetInfoModel.appendContentsOf("\"kyje\":\"\(kyje)\",")
        strBetInfoModel.appendContentsOf("\"ballhead\":\"\(ballhead)\",")
        
        strBetInfoModel.appendContentsOf("\"betteamName\":\"\(betteamName)\"")
        strBetInfoModel.appendContentsOf("}")
        return strBetInfoModel
    }
    
}
