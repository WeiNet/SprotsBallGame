//
//  ToolsCode.swift
//  SportsBall
//
//  Created by Brook on 16/4/1.
//  Copyright © 2016年 abel jing. All rights reserved.
//
import UIKit

struct ToolsCode {
    //***************************用于区分点击那个赔率***************************//
    static var LDYPL:Int = 56661//全场、左队、赌赢
    static var HJPL:Int = 56662//全场、和局
    static var RDYPL:Int = 56663//全场、右队、赌赢
    static var LRFView:Int = 56664//全场、左队、让分
    static var RRFView:Int = 56665//全场、右队、让分
    static var LDXBLView:Int = 56666//全场、左队、大小
    static var RDXBLView:Int = 56667//全场、右队、大小
    
    static var LDYPL2:Int = 56668//半场、左队、赌赢
    static var HJPL2:Int = 56669//半场、和局
    static var RDYPL2:Int = 56670//半场、右队、赌赢
    static var LRFView2:Int = 56671//半场、左队、让分
    static var RRFView2:Int = 56672//半场、右队、让分
    static var LDXBLView2:Int = 56673//半场、左队、大小
    static var RDXBLView2:Int = 56674//半场、右队、大小
    
    static var LDSBLView:Int = 56675//单双、左队、双
    static var RDSBLView:Int = 56676//单双、右队、单
    //***************************用于区分点击那个赔率***************************//
    
    static func codeBy(code : Int) -> String {
        var controlName:String = ""
        switch(code){
        case LDYPL:
            controlName = "N_LDYPL"
        case HJPL:
            controlName = "N_HJPL"
        case RDYPL:
            controlName = "N_RDYPL"
        case LRFView:
            controlName = "N_LRFPL"
        case RRFView:
            controlName = "N_RRFPL"
        case LDXBLView:
            controlName = "N_DXDPL"
        case RDXBLView:
            controlName = "N_DXXPL"
            
        case LDYPL2:
            controlName = "N_LDYPL2"
        case HJPL2:
            controlName = "N_HJPL2"
        case RDYPL2:
            controlName = "N_RDYPL2"
        case LRFView2:
            controlName = "N_LRFPL2"
        case RRFView2:
            controlName = "N_RRFPL2"
        case LDXBLView2:
            controlName = "N_DXDPL2"
        case RDXBLView2:
            controlName = "N_DXXPL2"
            
        case LDSBLView:
            controlName = "N_RDSSPL"
        case RDSBLView:
            controlName = "N_RDSDPL"
        default:
            controlName = ""
        }
        return controlName
    }
    
    //根据code得到是在左右和局
    static func codeByLRH(code : Int) -> String {
        var controlLRH:String = ""
        switch(code){
        case LDYPL,LRFView,LDXBLView,LDYPL2,LRFView2,LDXBLView2,LDSBLView:
            controlLRH = "L"
        case HJPL,HJPL2:
            controlLRH = "H"
        case RDYPL,RRFView,RDXBLView,RDYPL2,RRFView2,RDXBLView2,RDSBLView:
            controlLRH = "R"
        default:
            controlLRH = ""
        }
        return controlLRH
    }
    
    //根据code得到是玩法
    static func codeByPlayType(code : Int) -> String {
        var controlPlayType:String = ""
        switch(code){
        case LDYPL,RDYPL,LDYPL2,RDYPL2:
            controlPlayType = "DY"
        case HJPL,HJPL2:
            controlPlayType = "HJ"
        case LRFView,RRFView,LRFView2,RRFView2:
            controlPlayType = "RF"
        case LDXBLView,RDXBLView,LDXBLView2,RDXBLView2:
            controlPlayType = "DX"
        case LDSBLView,RDSBLView:
            controlPlayType = "DS"
        default:
            controlPlayType = ""
        }
        return controlPlayType
    }
    //转成json格式
    //格式：{"uname":"张三","tel":{"home":"010","mobile":"138"}}
    static func toJson(strResult:String)->AnyObject{
        let error:AnyObject = "is not a valid json object"
        //首先判断能不能转换
        if (!NSJSONSerialization.isValidJSONObject(strResult)) {
            print("is not a valid json object")
            return error
        }
        //利用OC的json库转换成OC的NSData，
        //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
        let data : NSData! = try? NSJSONSerialization.dataWithJSONObject(strResult, options: [])
        
        //把NSData对象转换回JSON对象
        let json : AnyObject! = try? NSJSONSerialization
            .JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)
        return json
    }
    
    //转成json数组格式
    //格式：[{"ID":1,"Name":"元台禅寺","LineID":1},{"ID":2,"Name":"田坞里山塘","LineID":1},{"ID":3,"Name":"滴水石","LineID":1}]
    static func toJsonArray(strResult:String)->AnyObject{
        
        if strResult == ""{
            return ""
        }
        let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
        
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
                                                                  options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        return jsonArr
    }
    //格式化赛事时间
    static func formatterDate(game:String,format:String)->String{
        var gameDate:String!
        gameDate = game.stringByReplacingOccurrencesOfString("/Date(", withString: "")
        gameDate = gameDate.stringByReplacingOccurrencesOfString(")/", withString: "")
        let double = (gameDate as NSString).doubleValue
        let date:NSDate = NSDate(timeIntervalSince1970: double/1000.0)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    //让球的赔率头部
    static func getBallHead(fs:Int,bl:Int,lx:Int)->String{
        var strResule:String = ""
        switch(lx){
        case 1:
            if(bl < 100 && bl > 0){
                let str1 = fs - 1
                let str2 = Double(bl)/100.0
                let str3 = Double(str1)+str2
                strResule = "\(str3)/\(fs)"
            }else if(bl == 100){
                let str1 = Double(fs) - 0.5
                strResule = String(str1)
            }else if(bl == 0){
                strResule = String(fs)
            }else{
                strResule = "\(fs)+\(bl)"
            }
            break;
        case 0:
            strResule = String(fs)
            break;
        case -1:
            if (bl < 100 && bl > 0){
                let str1 = (Double(fs) + Double(bl) / 100.0)
                strResule = "\(fs)/\(str1)"
            }else{
                strResule = "\(fs)-\(bl)"
            }
            break;
        case -2:
            strResule = String(Double(fs) + 0.5)
            break;
        default:
            strResule = " "
        }
        return strResule
    }
    
}
