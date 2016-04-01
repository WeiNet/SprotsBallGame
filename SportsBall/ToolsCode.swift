//
//  ToolsCode.swift
//  SportsBall
//
//  Created by Brook on 16/4/1.
//  Copyright © 2016年 abel jing. All rights reserved.
//

struct ToolsCode {
    //***************************用于区分点击那个赔率***************************//
    static var LDYPL:Int = 56661
    static var HJPL:Int = 56662
    static var RDYPL:Int = 56663
    static var LRFView:Int = 56664
    static var RRFView:Int = 56665
    static var LDXBLView:Int = 56666
    static var RDXBLView:Int = 56667
    
    static var LDYPL2:Int = 56668
    static var HJPL2:Int = 56669
    static var RDYPL2:Int = 56670
    static var LRFView2:Int = 56671
    static var RRFView2:Int = 56672
    static var LDXBLView2:Int = 56673
    static var RDXBLView2:Int = 56674
    //***************************用于区分点击那个赔率***************************//
    
    static func codeBy(code : Int) -> String {
        var controlName:String = ""
        switch(code){
        case 56661:
            controlName = "N_LDYPL"
        case 56662:
            controlName = "N_HJPL"
        case 56663:
            controlName = "N_RDYPL"
        case 56664:
            controlName = "N_LRFPL"
        case 56665:
            controlName = "N_RRFPL"
        case 56666:
            controlName = "N_DXDPL"
        case 56667:
            controlName = "N_DXXPL"
            
        case 56668:
            controlName = "N_LDYPL2"
        case 56669:
            controlName = "N_HJPL2"
        case 56670:
            controlName = "N_RDYPL2"
        case 56671:
            controlName = "N_LRFPL2"
        case 56672:
            controlName = "N_RRFPL2"
        case 56673:
            controlName = "N_DXDPL2"
        case 56674:
            controlName = "N_DXXPL2"
        default:
            controlName = ""
        }
        return controlName
    }
}
