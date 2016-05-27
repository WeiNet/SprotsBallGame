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
        var dics:Dictionary<String,String>=["Index":"\(Index)","strUser":"\(strUser)","dMoney":"\(dMoney)","yssj":"\(yssj)","playType":"\(playType)","lr":"\(lr)","ballType":"\(ballType)","id":"\(id)","courtType":"\(courtType)","tid":"\(tid)","rate":"\(rate)","vh":"\(vh)","let":"\(strlet)","hfs":"\(hfs)","hlx":"\(hlx)","hbl":"\(hbl)","strbet":"\(strbet)","visitname":"\(visitname)","homename":"\(homename)","jzf":"\(jzf)","isLive":"\(isLive)","allianceName":"\(allianceName)","date":"\(date)","isjzf":"\(isjzf)","score":"\(score)","dzxx":"\(dzxx)","dzsx":"\(dzsx)","dcsx":"\(dcsx)","kyje":"\(kyje)","ballhead":"\(ballhead)","betteamName":"\(betteamName)"]
        return dics
    }
    
    func toString()->String{
        var strBetInfoModel:String = "{"
        strBetInfoModel.appendContentsOf("\"allianceName\":\"\(allianceName)\",")
        strBetInfoModel.appendContentsOf("\"ballType\":\"\(ballType)\",")
        strBetInfoModel.appendContentsOf("\"betteamName\":\"\(betteamName)\",")
        strBetInfoModel.appendContentsOf("\"courtType\":\"\(courtType)\",")
        strBetInfoModel.appendContentsOf("\"dMoney\":\"\(dMoney)\",")
        strBetInfoModel.appendContentsOf("\"date\":\"\(date)\",")
        strBetInfoModel.appendContentsOf("\"dcsx\":\"\(dcsx)\",")
        strBetInfoModel.appendContentsOf("\"dzsx\":\"\(dzsx)\",")
        strBetInfoModel.appendContentsOf("\"dzxx\":\"\(dzxx)\",")
        strBetInfoModel.appendContentsOf("\"hbl\":\"\(hbl)\",")
        strBetInfoModel.appendContentsOf("\"hfs\":\"\(hfs)\",")
        strBetInfoModel.appendContentsOf("\"hlx\":\"\(hlx)\",")
        strBetInfoModel.appendContentsOf("\"kyje\":\"\(kyje)\",")
        strBetInfoModel.appendContentsOf("\"homename\":\"\(homename)\",")
        strBetInfoModel.appendContentsOf("\"id\":\"\(id)\",")
        strBetInfoModel.appendContentsOf("\"isLive\":\"\(isLive)\",")
        strBetInfoModel.appendContentsOf("\"isjzf\":\"\(isjzf)\",")
        strBetInfoModel.appendContentsOf("\"jzf\":\"\(jzf)\",")
        strBetInfoModel.appendContentsOf("\"let\":\"\(strlet)\",")
        strBetInfoModel.appendContentsOf("\"lr\":\"\(lr)\",")
        strBetInfoModel.appendContentsOf("\"playType\":\"\(playType)\",")
        strBetInfoModel.appendContentsOf("\"rate\":\"\(rate)\",")
        strBetInfoModel.appendContentsOf("\"strUser\":\"\(strUser)\",")
        strBetInfoModel.appendContentsOf("\"tid\":\"\(tid)\",")
        strBetInfoModel.appendContentsOf("\"vh\":\"\(vh)\",")
        strBetInfoModel.appendContentsOf("\"visitname\":\"\(visitname)\",")
        strBetInfoModel.appendContentsOf("\"Index\":\"\(Index)\",")
        strBetInfoModel.appendContentsOf("\"yssj\":\"\(yssj)\",")
        strBetInfoModel.appendContentsOf("\"strbet\":\"\(strbet)\",")
        strBetInfoModel.appendContentsOf("\"score\":\"\(score)\",")
        strBetInfoModel.appendContentsOf("\"ballhead\":\"\(ballhead)\"")
        strBetInfoModel.appendContentsOf("}")
        return strBetInfoModel
    }
    
}
