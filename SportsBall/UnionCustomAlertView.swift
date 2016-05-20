//
//  UnionCustomAlertView.swift
//  SportsBall
//
//  Created by Brook on 16/5/6.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

//页面 实例化
protocol UnionDelegate: NSObjectProtocol {
    //联盟点击事件
    func unionClickDelegate(keys:String)
}

class UnionCustomAlertView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var unionTable: UITableView!
    @IBOutlet var selAllView: UIView!
    @IBOutlet var selAllButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
    var backgroundView:UIView!
    var arrayUnionVO:Array<UnionTitleVO>!
    var dicUnionNO:Dictionary<String ,Bool> = Dictionary<String ,Bool>()
    var delegate:UnionDelegate!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayUnionVO.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 350, height: 48))
        var image:UIImage?
        if dicUnionNO.keys.contains(arrayUnionVO[indexPath.row].N_NO as String) {
            image = UIImage(named:"checkbox_off")
        } else {
            image = UIImage(named:"checkbox_on")
        }
        cell.imageView?.image = image
        cell.textLabel?.text = arrayUnionVO[indexPath.row].N_LMMC as String
        //点击不改变整行Cell的颜色
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var image:UIImage?
        if !(dicUnionNO.keys.contains(arrayUnionVO[indexPath.row].N_NO as String)) {
            image = UIImage(named:"checkbox_off")
            dicUnionNO[arrayUnionVO[indexPath.row].N_NO as String] = true
            if(arrayUnionVO.count != 0 && dicUnionNO.count == arrayUnionVO.count){
                selAllButton.selected = true
            }
        } else {
            image = UIImage(named:"checkbox_on")
            dicUnionNO.removeValueForKey(arrayUnionVO[indexPath.row].N_NO as String)
            selAllButton.selected = false
        }
        
        cell.imageView?.image = image
    }

    @IBAction func canel(sender: UIButton) {
        backgroundView.removeFromSuperview()
        dicUnionNO.removeAll(keepCapacity: false)
        self.removeFromSuperview()
    }
    
    @IBAction func ok(sender: UIButton) {
        backgroundView.removeFromSuperview()
        var blank:String = ""
        var keys:String = ""
        for keysTemp in dicUnionNO.keys {
            keys += blank + keysTemp
            blank = ","
        }
        delegate.unionClickDelegate(keys)
        self.removeFromSuperview()
    }
    
    func checkboxClick(sender: UITapGestureRecognizer) {
        selAllButton.selected = !selAllButton.selected
        
        if selAllButton.selected {
            for union in arrayUnionVO {
                dicUnionNO[union.N_NO as String] = true
            }
        } else {
            dicUnionNO.removeAll(keepCapacity: false)
        }
        unionTable.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selAllButton.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Normal)
        selAllButton.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Selected)
        selAllView.userInteractionEnabled = true
        // 单击手势识别
        selAllView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkboxClick:"))
        selAllButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkboxClick:"))
        
        unionTable.userInteractionEnabled = true
        unionTable.dataSource = self
        unionTable.delegate = self
        let allUnionVO:AllUnionVO = AllUnionVO.getAllUnionVOInstance()
        arrayUnionVO = allUnionVO.arrayUnionVO
        self.superclass
    }
}
