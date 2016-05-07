//
//  UnionCustomAlertView.swift
//  SportsBall
//
//  Created by Brook on 16/5/6.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

public var externalObjects:String?

class UnionCustomAlertView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var unionTable: UITableView!
    @IBOutlet var selAllView: UIView!
    @IBOutlet var selAllButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var okButton: UIButton!
    
//    public var externalObjects:String?
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 350, height: 48))
        let image = UIImage(named:"checkbox_on")
        cell.imageView?.image = image
        cell.textLabel?.text = "tttttttt\(indexPath.row)"
        //点击不改变整行Cell的颜色
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
//        self.awakeFromNib()
//        NSBundle.mainBundle().loadNibNamed
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var image:UIImage?
        if cell.selected {
            image = UIImage(named:"checkbox_off")
        } else {
            image = UIImage(named:"checkbox_on")
        }
        cell.selected = !cell.selected
        
        cell.imageView?.image = image
        print("gggggggggggg")
    }

    @IBAction func canel(sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func ok(sender: UIButton) {
        print("ok")
    }
    
    func checkboxClick(sender: UITapGestureRecognizer) {
        selAllButton.selected = !selAllButton.selected
    }

    override func awakeFromNib() {
        selAllButton.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Normal)
        selAllButton.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Selected)
        selAllView.userInteractionEnabled = true
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: "checkboxClick:")
        selAllView.addGestureRecognizer(tapGesture)
        
        unionTable.userInteractionEnabled = true
        unionTable.dataSource = self
        unionTable.delegate = self
    }
}
