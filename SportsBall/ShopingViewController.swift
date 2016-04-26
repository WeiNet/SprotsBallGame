//
//  ShopingViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/4/11.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class ShopingViewController: UIViewController {
    
    override func viewDidLoad() {
        self.title="购物车"
          var betManger=BetListManager.sharedManager
            var betlist=betManger.getBetList()
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)    }
}


func toJSONString()->NSString{
    var dict=[BetInfo]()
    var objInfo1=BetInfo()
    objInfo1.dMoney="10"
    objInfo1.dzsx="11"
    objInfo1.dzxx="45"
    objInfo1.homename="dfdf"
    dict.append(objInfo1)
    
    //        let dict = ["name":"Jobs","friends":["Ive","Cook"]]
    let data = try!NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
    var strJson=NSString(data: data, encoding: NSUTF8StringEncoding)
    return strJson!
}