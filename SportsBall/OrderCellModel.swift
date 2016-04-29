//
//  OrderCellRollModel.swift
//  MyViewCell
//
//  Created by Brook on 16/3/22.
//  Copyright © 2016年 Brook. All rights reserved.
//

import UIKit

class OrderCellModel: NSObject {
    var orderOpen:Bool = false//当前的注单赔率是张开还是关闭
    
    var N_HJPL:NSNumber!//和局赔率
    var N_HJPL_SEL:Bool = false
    var N_HJPL2:NSNumber!
    var N_HJPL2_SEL:Bool = false
    var N_RFLX:NSNumber!//让分类型
    var N_RFLX2:NSNumber!
    var N_RFFS:NSNumber!//让分方式
    var N_RFFS2:NSNumber!
    var N_RFBL:NSNumber!//让分比率
    var N_RFBL2:NSNumber!
    var N_LRFPL:NSNumber!//左队让分赔率
    var N_LRFPL_SEL:Bool = false
    var N_LRFPL2:NSNumber!
    var N_LRFPL2_SEL:Bool = false
    var N_RRFPL:NSNumber!//右队让分赔率
    var N_RRFPL_SEL:Bool = false
    var N_RRFPL2:NSNumber!
    var N_RRFPL2_SEL:Bool = false
    var N_RF_OPEN:NSNumber!//让分是否开放
    var N_RF_OPEN2:NSNumber!
    var N_RF_LOCK_V:NSNumber!//主队让分是否锁定
    var N_RF_LOCK_V2:NSNumber!
    var N_RF_LOCK_H:NSNumber!//可队让分是否锁定
    var N_RF_LOCK_H2:NSNumber!
    var N_DXLX:NSNumber!//大小类型
    var N_DXLX2:NSNumber!
    var N_DXFS:NSNumber!//大小方式
    var N_DXFS2:NSNumber!
    var N_DXBL:NSNumber!//大小比率
    var N_DXDPL:NSNumber!//左队大小赔率
    var N_DXDPL_SEL:Bool = false
    var N_DXXPL:NSNumber!//右队大小赔率
    var N_DXXPL_SEL:Bool = false
    var N_DXBL2:NSNumber!
    var N_DXDPL2:NSNumber!
    var N_DXDPL2_SEL:Bool = false
    var N_DXXPL2:NSNumber!
    var N_DXXPL2_SEL:Bool = false
    var N_DX_OPEN:NSNumber!//大小是否开放
    var N_DX_OPEN2:NSNumber!
    var N_DX_LOCK_V:NSNumber!//主队大小是否锁定
    var N_DX_LOCK_H:NSNumber!//客队大小是否锁定
    var N_DX_LOCK_V2:NSNumber!
    var N_DX_LOCK_H2:NSNumber!
    var N_LDYPL:NSNumber!//左队赌赢赔率
    var N_LDYPL_SEL:Bool = false
    var N_RDYPL:NSNumber!//右队赌赢赔率
    var N_RDYPL_SEL:Bool = false
    var N_LDYPL2:NSNumber!
    var N_LDYPL2_SEL:Bool = false
    var N_RDYPL2:NSNumber!
    var N_RDYPL2_SEL:Bool = false
    var N_DY_OPEN:NSNumber!//赌赢是否开放
    var N_DY_OPEN2:NSNumber!
    var N_DY_LOCK_V:NSNumber!//主队赌赢是否锁定
    var N_DY_LOCK_H:NSNumber!//客队赌赢是否锁定
    var N_DY_LOCK_V2:NSNumber!
    var N_DY_LOCK_H2:NSNumber!
    var N_ID2:NSNumber!//上半场的id
    var N_LET2:NSNumber!//上半场的让分互换，1后让前，0前让后
    var N_VISIT2:NSNumber!//上半场的主队ID
    var N_HOME2:NSNumber!//上半场的客队ID
    var N_ID:NSNumber!//id
    var N_LX:String!//类型
    var N_ZWDATE:String!//账务日期
    var N_GAMEDATE:String!//比赛时间
    var N_LMNO:NSNumber!//联盟id
    var N_VISIT:NSNumber!//主队ID
    var N_VISIT_NAME:String!//主队名称
    var N_HOME:NSNumber!//客队ID
    var N_HOME_NAME:String!//客队名称
    var N_CBXH:NSNumber!//场别型号
    var N_SAMEGAME:NSNumber!//上半场跟全场合并的ID
    var N_LET:NSNumber!//让分互换，1后让前，0前让后
    var N_SFXZ:NSNumber!//是否允许下注
    var N_LOCK:NSNumber!//是否锁定
    var N_ZBXH:NSNumber!//直播
    var N_SFZD:NSNumber!//是否走地
    var N_VISIT_NO:NSNumber!//场次编号A
    var N_HOME_NO:NSNumber!//场次编号B
    var N_VH:NSNumber!//主场代号
    var N_REMARK:String!//备注
    
    var N_ZDUPTIME:String!
    var N_HOME_JZF:NSNumber!//客队得分
    var N_ZDTIME:String!//赛事进行了时间
    var N_VISIT_JZF:NSNumber!//主队得分
    var N_HOME_REDCARD:NSNumber!
    var N_ZDFLAG:String!//走地标志
    var N_VISIT_REDCARD:NSNumber!
    
    var N_DSSPL:NSNumber!
    var N_RDSSPL_SEL:Bool = false
    var N_DSDPL:NSNumber!
    var N_RDSDPL_SEL:Bool = false
    
    var N_HJGGCJ:NSNumber!
    var N_LRFCJ:NSNumber!
    var N_RRFCJ:NSNumber!
    var N_RF_GG:NSNumber!
    var N_DXDCJ:NSNumber!
    var N_DXXCJ:NSNumber!
    var N_DX_GG:NSNumber!
    var N_DSDCJ:NSNumber!
    var N_DSSCJ:NSNumber!
    var N_DS_OPEN:NSNumber!
    var N_DS_LOCK_V:NSNumber!
    var N_DS_LOCK_H:NSNumber!
    var N_DS_GG:NSNumber!
    var N_LDYCJ:NSNumber!
    var N_RDYCJ:NSNumber!
    var N_DY_GG:NSNumber!
    var N_SAMETEAM:String!
    var N_RFL:String!
    var N_RFR:String!
    var N_DSL:String!
    var N_DSR:String!
    var N_DXL:String!
    var N_DXR:String!
    var N_DYL:String!
    var N_DYR:String!
    var N_HJ:String!
    var N_SYL:String!
    var N_SYR:String!
}
