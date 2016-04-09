//
//  ProblemFeedbackViewController.swift
//  SportsBall
//
//  Created by abel jing on 16/4/5.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit


class ProblemFeedbackViewController: UIViewController,ResultDelegate {
    
    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textContent: UITextView!
    var connection=CommonParameter()
    override func viewDidLoad() {
        connection.delegate=self
        self.title="我要反馈"
        navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Bordered, target: self, action: "commit"), animated: true)
        
    }
    func commit(){
        let myQuestion=Bean_Questions(_account: "gt001@FUNTEST", _title:textTitle.text!, _content: textContent.text, _telNum: "", _status: "0", _lang: "cn")
        
        do {
            let airports: Dictionary<String, String> = ["account": "gt001@FUNTEST", "title":"\(textTitle.text!)","content":"\(textContent.text)","telNum":"","status":"0","lang":"cn"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(airports, options: NSJSONWritingOptions())
            let str = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            
            var body = "sData=\(str!)"
            
            connection.getHttpResult("FeedBackServlet", strBody: body)
            
        }catch
        {
            print("解析失败")
            
        }
        
        
    }
    func setResult(strResult: String, strType: String) {
        NSLog(strResult)
    }
}
