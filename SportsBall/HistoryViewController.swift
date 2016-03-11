//
//  HistoryViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/3/8.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var navigationHistory: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        var itme=UINavigationItem(title: "nihao")
        itme.backBarButtonItem=UIBarButtonItem(title: "add", style:UIBarButtonItemStyle.Bordered, target: nil, action: "addClick")
        navigationHistory.pushNavigationItem(itme, animated: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
