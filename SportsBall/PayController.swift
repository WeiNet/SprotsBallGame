//
//  PayController.swift
//  SportsBall
//
//  Created by abel jing on 16/5/17.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class PayController: UIViewController {
    @IBOutlet weak var viewOne: UIView!
    
    @IBOutlet weak var viewTwo: UIView!
    
    @IBAction func dateTimeClick(sender: AnyObject) {
        //配置零：内容配置
        let menuArray = [KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch1"), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch1"), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
            KxMenuItem.init("2016年5月23日", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:")]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 10,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 5,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        
        
        //菜单展示
        KxMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: menuArray, withOptions: options)

        
        
    }
    
    override func viewDidLoad() {
        
       setViewBackground()
        

    }
    func setViewBackground(){
    
        self.viewOne.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
        self.viewOne.layer.borderWidth = 1
        self.viewTwo.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
        self.viewTwo.layer.borderWidth = 1
    }
    func respondOfMenu(sender: AnyObject) {
        
        print(sender.title!)
    }

}
