//
//  BallViewController.swift
//  SportsBall
//
//  Created by Brook on 16/5/16.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //显示赛事（联盟、赛事队伍）
    func stringToDictionary(strResult: String)->NSMutableArray{
        let aryUnionInfo:NSMutableArray = NSMutableArray()
        
        let allUnionVO:AllUnionVO = AllUnionVO.getAllUnionVOInstance()
        allUnionVO.arrayUnionVO.removeAll(keepCapacity: false)
        var aryUnionVO:Array<UnionTitleVO> = Array()
        let info = ToolsCode.toJsonArray(strResult)
        let unionJson = info[1]
        if unionJson.count == 0 {//没有资料
            print("没有资料")
            return aryUnionInfo
        }
        let objCount:Int = unionJson.count - 1
        for index in 0...objCount {
            let unionVO:UnionTitleVO = UnionTitleVO()
            unionVO.N_NO = String(unionJson[index].objectForKey("N_NO")!)
            unionVO.N_LMMC = String(unionJson[index].objectForKey("N_LMMC")!)
            aryUnionVO.append(unionVO)
        }
        allUnionVO.arrayUnionVO = aryUnionVO
        
        let matchJson = info[0]
        let matchCount:Int = matchJson.count - 1
        for union in aryUnionVO {
            let unionTitleModel:UnionTitleModel = UnionTitleModel()
            unionTitleModel.id = String(union.N_NO)
            unionTitleModel.name = String(union.N_LMMC)
            
            var aryOrderCellModel:Array<OrderCellModel> = Array()
            for index in 0...matchCount{
                if union.N_NO == String(matchJson[index].objectForKey("N_LMNO")!) {
                    let orderCellModel:OrderCellModel = OrderCellModel()
                    //给注单属性赋值
                    orderCellModel.setValuesForKeysWithDictionary(matchJson[index] as! [String : AnyObject])
                    aryOrderCellModel.append(orderCellModel)
                }
            }
            unionTitleModel.count = String(aryOrderCellModel.count)
            unionTitleModel.orderCellModels = aryOrderCellModel
            if aryOrderCellModel.count > 0 {
                aryUnionInfo.addObject(unionTitleModel)
            }
        }
        return aryUnionInfo
    }
    
    
    //主窗体添加购物车、赛事列表、即时/复合下注
    func addControls(showUnion:NSMutableArray,contentView:UIView,mainView:UIView,delegate:BindDelegate,cartDelegate:CartButtonDelegate,orderHeight:CGFloat){
        
        var startY:CGFloat = 0
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 20
        
        let cartButtonView = NSBundle.mainBundle().loadNibNamed("CartButtonView" , owner: nil, options: nil).first as? CartButtonView
        cartButtonView?.frame.size.width = width
        cartButtonView?.frame.size.height = 48
        cartButtonView?.delegate = cartDelegate
        contentView.addSubview(cartButtonView!)
        //添加购物车控件后Y轴空出
        startY = startY + 48
        
        //先创建一个数组用于设置分段控件的标题
        let appsArray:[String] = ["即时下注","复合下注"]
        let segment:UISegmentedControl = UISegmentedControl(items: appsArray)
        segment.frame = CGRect(x: (width-180)/2, y: height+45, width: 180, height: 20)
        //默认选中下标为0的
        segment.selectedSegmentIndex = 0
        //设置标题颜色
        //segment.tintColor = UIColor.redColor()
        //添加事件，当segment改变时，触发 Parent
        segment.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
        mainView.addSubview(segment)
        
        let cgr = CGRect(x: 0, y: startY, width: width, height: height - 20 - 36)
        let tableView = TableView(frame: cgr)
        tableView.initDelegate(showUnion)
        tableView.orderHeight = orderHeight
        tableView.bindDelegate = delegate
        contentView.addSubview(tableView)
    }
    
    //绑定队伍标题
    func bindCommonMatchDelegate(cell:Cell,orderCellModel:OrderCellModel){
        //绑定注单标题资料
        cell.N_VISIT_NAME.text = orderCellModel.N_VISIT_NAME + "[主]"
        cell.N_HOME_NAME.text = orderCellModel.N_HOME_NAME
        if (orderCellModel.N_ZDFLAG != "Y") {
            let gameDate = orderCellModel.N_GAMEDATE
            cell.N_GAMEDATE.text = ToolsCode.formatterDate(gameDate,format: "MM/dd HH:mm")
            cell.N_VISIT_JZF.text = ""
            cell.N_HOME_JZF.text = ""
        }else{
            cell.N_GAMEDATE.text = orderCellModel.N_ZDTIME
            cell.N_VISIT_JZF.text = String(orderCellModel.N_VISIT_JZF)
            cell.N_HOME_JZF.text = String(orderCellModel.N_HOME_JZF)
        }
    }
    
}
