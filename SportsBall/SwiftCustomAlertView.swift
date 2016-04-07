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

class SwiftCustomAlertView: UIView {
    
    private var viewX:Double!
    private var viewY:Double!
    private var viewWidth: Double = 350.0
    private var viewHeight: Double = 214.0
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
    var cornerRadius: Double = 40.0
    var bottom:UIView!
    
    weak var delegate: SwiftCustomAlertViewDelegate? // delegate
    
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
        var viewWin = view.frame.size
        viewX = (Double(viewWin.width) - viewWidth)/2
        viewY = (Double(viewWin.height) - viewHeight)/2
        var myView = NSBundle.mainBundle().loadNibNamed("SwiftCustomAlertView" , owner: nil, options: nil).first as? SwiftCustomAlertView
        
        myView?.layer.cornerRadius = CGFloat(cornerRadius)
        myView?.frame = CGRect(x: viewX, y: viewY - 50, width: viewWidth, height: viewHeight)
        
        var bottom:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        bottom.backgroundColor = UIColor.blackColor()
        bottom.alpha = 0.8
        view.addSubview(bottom)
        myView?.bottom = bottom
        myView?.delegate = myDelegate
        
        view.addSubview(myView!)
        view.bringSubviewToFront(myView!)
    }
}
