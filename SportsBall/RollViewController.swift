//
//  RollViewController.swift
//  SportsBall
//
//  Created by Brook on 16/4/28.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewController: UIViewController,ResultDelegate,HeaderViewDelegate {
//    @IBOutlet var mainView: UIView!
//    @IBOutlet var headerView: UIView!
//    @IBOutlet var contentView: UIView!
    //@IBOutlet var headerView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var contentView: UIView!

    var common=CommonParameter()//网络请求
    var mPlayType = "2"//0:早盘；1：单式；2：滚球
    let getOtherMatchResult = "GetOtherMatchResult"
    
    //远端回传资料响应协议
    func setResult(strResult: String,strType:String)  {
        clearAllNotice()
        if(strType == "Error" || strResult == ""){
            return
        }
        if(strType == getOtherMatchResult){
            print(strResult)
            let basket = ToolsCode.toJsonArray(strResult)
            var ooo = ""
        }
    }
    
    func getOtherMatch(){
        pleaseWait()
        common.delegate = self
        common.matchingElement = getOtherMatchResult
        var strParam:String = "<GetOtherMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>1</strPageSize>")
        strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
        strParam.appendContentsOf("<strType>2</strType>")
        strParam.appendContentsOf("<strCourtType>1</strCourtType>")
        strParam.appendContentsOf("<strBall>b_bk</strBall>")
        strParam.appendContentsOf("</GetOtherMatch>")
        common.getResult(strParam,strResultName: getOtherMatchResult)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头部
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView" , owner: nil, options: nil).first as? HeaderView
        headerView?.frame.size.height = 48
        headerView?.delegate = self
        self.headerView.addSubview(headerView!)
        
        getOtherMatch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
