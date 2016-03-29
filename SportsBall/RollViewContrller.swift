//
//  RollViewContrller.swift
//  SportsBall
//
//  Created by Brook on 16/3/24.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class RollViewContrller:UIViewController,ResultDelegate {
    @IBOutlet var myContent: UIView!
    var common=CommonParameter()//网络请求
    var myTable:MyTableView!
    
    func setResult(strResult: String)  {
        
        var allUnionArr:Array<UnionTitleVO> = Array()
        var info = toJsonArray(strResult)
        
        var unionAllJson = info[1]
        var objCount:Int = unionAllJson.count - 1
        for index in 0...objCount {
            var model:UnionTitleVO = UnionTitleVO()
            model.N_NO = String(unionAllJson[index].objectForKey("N_NO")!)
            model.N_LMMC = String(unionAllJson[index].objectForKey("N_LMMC")!)
            allUnionArr.append(model)
        }
        
        var showUnion:NSMutableArray = NSMutableArray()
        var matchAllJson = info[0]
        var matchCount:Int = matchAllJson.count - 1
        for union in allUnionArr {
            var unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.id = String(union.N_NO)
            unionTitleModel.name = String(union.N_LMMC)
            
            var order:Array<OrderCellRollModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchAllJson[index].objectForKey("N_LMNO")!) {
                    var orderCellRollModel:OrderCellRollModel = OrderCellRollModel()
                    //给注单属性赋值
                    orderCellRollModel.setValuesForKeysWithDictionary(matchAllJson[index] as! [String : AnyObject])
                    order.append(orderCellRollModel)
                }
            }
            unionTitleModel.count = String(order.count)
            unionTitleModel.orderCellRollModels = order
            if order.count > 0 {
               showUnion.addObject(unionTitleModel)
            }
        }
        
        var width = self.myContent.frame.size.width
        var height = self.myContent.frame.size.height - 20
        myTable = MyTableView(frame: CGRect(x: 0, y: 25, width: width, height: height))
        myTable.matchCells = showUnion
        myTable.setDelegate()
        myContent.addSubview(myTable)
    }
    
    //转成json格式
    //格式：{"uname":"张三","tel":{"home":"010","mobile":"138"}}
    func toJson(strResult:String)->AnyObject{
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
    func toJsonArray(strResult:String)->AnyObject{
        let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
        
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
            options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        return jsonArr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        common.delegate = self
        common.matchingElement = "GetFootballMatchResult"
        var strParam:String = "<GetFootballMatch xmlns=\"http://tempuri.org/\">";
        strParam.appendContentsOf("<strLM></strLM>")
        strParam.appendContentsOf("<strSort>0</strSort>")
        strParam.appendContentsOf("<strPageIndex>1</strPageIndex>")
        strParam.appendContentsOf("<strPageSize>3</strPageSize>")
        strParam.appendContentsOf("<strUser></strUser>")
        strParam.appendContentsOf("<strType>0</strType>")
        strParam.appendContentsOf("</GetFootballMatch>")
        common.getResult(strParam,strResultName: "LoginResult")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
