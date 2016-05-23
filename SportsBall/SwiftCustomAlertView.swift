//
//  SwiftCustomAlertView.swift
//  SportsBall
//
//  Created by Brook on 16/4/5.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

@objc protocol SwiftCustomAlertViewDelegate : NSObjectProtocol{
    optional func  selectOkButtonalertView()
    optional func  selecttCancelButtonAlertView()
}
//即时下注popuWin
class SwiftCustomAlertView: UIView {
    
    @IBOutlet var visit: UILabel!
    @IBOutlet var N_VISIT_JZF: UILabel!
    @IBOutlet var N_HOME_JZF: UILabel!
    @IBOutlet var home: UILabel!
    
    @IBOutlet var betText: UILabel!
    @IBOutlet var rate: UILabel!
    @IBOutlet var gain: UILabel!
    @IBOutlet var money: UITextField!
    
    @IBOutlet var max: UILabel!
    @IBOutlet var limits: UILabel!
    
    private var viewX:Double!
    private var viewY:Double!
    private var viewWidth: Double = 350.0
    private var viewHeight: Double = 214.0
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
    var cornerRadius: Double = 40.0
    var bottom:UIView!
    var myView:SwiftCustomAlertView!
    var strPlayType:String!
    
    weak var delegate: SwiftCustomAlertViewDelegate?
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        bottom.removeFromSuperview()
        self.removeFromSuperview()
        delegate?.selecttCancelButtonAlertView!()
    }
    
    @IBAction func okButtonClicked(sender: AnyObject) {
        bottom.removeFromSuperview()
        self.removeFromSuperview()
        delegate?.selectOkButtonalertView!()
    }
    
    func show(myDelegate:SwiftCustomAlertViewDelegate) {
        if let window: UIWindow = UIApplication.sharedApplication().keyWindow {
            showWin(window, viewDelegate: myDelegate)
        }
    }
    
    
    func showWin(view: UIView,viewDelegate myDelegate: SwiftCustomAlertViewDelegate) {
        let viewWin = view.frame.size
        viewX = (Double(viewWin.width) - viewWidth)/2
        viewY = (Double(viewWin.height) - viewHeight)/2
        //加载设计好的XIB
        myView = NSBundle.mainBundle().loadNibNamed("SwiftCustomAlertView" , owner: nil, options: nil).first as! SwiftCustomAlertView
        
        myView.layer.cornerRadius = CGFloat(cornerRadius)
        myView.frame = CGRect(x: viewX, y: viewY - 50, width: viewWidth, height: viewHeight)
        //在XIB的后面加入一个透明的View
        let bottom:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        bottom.backgroundColor = UIColor.blackColor()
        bottom.alpha = 0.8
        view.addSubview(bottom)
        myView.bottom = bottom
        myView.delegate = myDelegate
        myView.money.addTarget(self, action: "changeMoney:", forControlEvents: UIControlEvents.EditingChanged)
        
        view.addSubview(myView!)
        view.bringSubviewToFront(myView!)
    }
    
    //计算可赢金额方法
    func changeMoney(sender:UITextField){
        let money = (myView.money.text == "" ? "0" : myView.money.text)
        let betMoney = Double(money!)
        let dRate = Double(myView.rate.text!)
        myView.gain.text = String(calculateWinMoney(myView.strPlayType,intBet: betMoney!,dRale: dRate!))
    }
    
    //计算可赢金额
    func calculateWinMoney (strPlayType:String,intBet:Double,dRale:Double)->Double{
        var winbet:Double=0.0
        switch(strPlayType){
        case "ZDRF","ZDDX","RF","DX":
            winbet = intBet * dRale;
            break
        case "ZDDS","ZDDY","DS","DY","HJ":
            winbet = intBet * dRale - intBet;
            break
        default:
            winbet = intBet * dRale - intBet;
            break
        }
        return winbet
    }
}
