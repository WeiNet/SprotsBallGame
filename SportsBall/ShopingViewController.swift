    //
    //  ShopingViewController.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/4/11.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //
    
    import UIKit
    
    class ShopingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate,UITextFieldDelegate {
        var betManger:BetListManager?
        var betList:[BetInfo]?
        var comm=CommonParameter()
        var intRowIndex:Int = 0
        let button = UIButton(type: UIButtonType.Custom)
        var textViewMoney=UITextField()
        
        @IBAction func btnSelectClick(sender: UIBarButtonItem) {
        }
        //清除按钮
        @IBAction func btnClear(sender: AnyObject) {
            let alertView = UIAlertView()
            alertView.title = "系统提示"
            alertView.message = "确定要清除吗？"
            alertView.addButtonWithTitle("取消")
            alertView.addButtonWithTitle("确定")
            alertView.cancelButtonIndex=0
            alertView.delegate=self;
            alertView.show()
        }
        //弹出框
        func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
            if(buttonIndex==alertView.cancelButtonIndex){
                print("点击了取消")
            }
            else
            {
                if(betList?.isEmpty==false){
                    betList?.removeAll()
                    self.tableList.reloadData()
                    textBetMoneyt.text="0.0"
                    textKyje.text="0.0"
                }
            }
        }
        @IBOutlet weak var tableList: UITableView!
        
        @IBOutlet weak var textBetMoneyt: UILabel!
        
        @IBOutlet weak var textKyje: UILabel!
        
        @IBOutlet weak var textBalance: UILabel!
        @IBAction func payChlick(sender: UIButton) {
            var jsonObject: [AnyObject] = []
            
            for objbet in betList!{
                jsonObject.append(objbet.toDict())
            }
            var str=toJSONString(jsonObject)
            addBet(str)
        }
        @IBAction func controlTouchDown(sender: AnyObject) {
            
        }
        override func viewDidLoad() {
            self.title="购物车"
            betManger=BetListManager.sharedManager
            betList=betManger!.getBetList()
            self.tableList.dataSource=self
            self.tableList.delegate=self
            comm.delegate=self
            button.setTitle("Return", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.frame = CGRectMake(0, 163, 106, 53)
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: "Done:", forControlEvents: UIControlEvents.TouchUpInside)
            getBalanceResult()//取得账户余额
            countMoney()//计算投注金额和可赢金额
        }
        override func viewWillAppear(animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: animated)    }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            
            return (betList?.count)!
        }
        
        
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
            var cell=tableView.dequeueReusableCellWithIdentifier("shopingcell")
            
            if(cell==nil){
                cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "shopingcell")
            }
            cell?.backgroundColor=UIColor.whiteColor()
            var textMoney=UITextField(frame: CGRect(x: 170, y: 71, width: 97, height: 30))
            var btnDel=UIButton(frame: CGRect(x: 316, y: 80, width: 73, height: 53))
            btnDel.setImage(UIImage(named: "ibtn_delete_item"), forState: UIControlState.Normal)
            btnDel.setImage(UIImage(named: "ibtn_delete_select"), forState: UIControlState.Selected)
            btnDel.tag=indexPath.row
            textMoney.clearButtonMode=UITextFieldViewMode.WhileEditing
            textMoney.tag=indexPath.row
            textMoney.keyboardType=UIKeyboardType.NumberPad
            textMoney.borderStyle=UITextBorderStyle.Line
            textMoney.backgroundColor=UIColor.whiteColor()
            textMoney.delegate=self
            cell!.addSubview(textMoney)
            cell?.addSubview(btnDel)
            var lableV=cell?.viewWithTag(5) as! UILabel
            var lableH=cell?.viewWithTag(6) as! UILabel
            var lableBetTeam=cell?.viewWithTag(7) as! UILabel
            var lableRate=cell?.viewWithTag(10) as! UILabel
            var lableKY=cell?.viewWithTag(11) as! UILabel
            var lableDC=cell?.viewWithTag(12) as! UILabel
            var lableDZ=cell?.viewWithTag(13) as! UILabel
            
            lableV.text=betList![indexPath.row].visitname
            lableH.text=betList![indexPath.row].homename
            lableBetTeam.text=betList![indexPath.row].betteamName
            lableRate.text=betList![indexPath.row].rate
            lableKY.text=betList![indexPath.row].kyje
            lableDC.text=betList![indexPath.row].dcsx
            textMoney.text=betList![indexPath.row].dMoney
            lableDZ.text=betList![indexPath.row].dzxx+"-"+betList![indexPath.row].dzsx
            textMoney.addTarget(self, action: "changeMoney:", forControlEvents: UIControlEvents.EditingDidEnd)
             btnDel.addTarget(self, action: "deleteRow:", forControlEvents: UIControlEvents.TouchDown)
            return cell!
            
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var cell=tableView.cellForRowAtIndexPath(indexPath)
            cell?.backgroundColor=UIColor.whiteColor()
            self.textViewMoney.backgroundColor=UIColor.whiteColor()
            self.textViewMoney.resignFirstResponder()
        }
        //删除方法
        func deleteRow(sender:UIButton){
        
            var intTag=sender.tag
            betList?.removeAtIndex(intTag)
            self.tableList.reloadData()
        
        }
        //计算可赢金额方法
        func changeMoney(sender:UITextField){
            var intTag=sender.tag
            var objBet=betList![intTag]
            objBet.dMoney=sender.text!
            var betMoney=Double(objBet.dMoney)
            var dRate=Double(objBet.rate)
            var winMoney=calculateWinMoney(objBet.playType,intBet: betMoney!,dRale: dRate!)
            objBet.kyje="\(winMoney)"
            betList![intTag]=objBet
            print(sender.tag)
            countMoney()
            
        }
        
        func countMoney(){
            var betMoney:Double=0
            var betKYJE:Double=0
            for objBet in betList!{
                if(objBet.dMoney != ""){
                    betMoney += Double(objBet.dMoney)!
                }
                if(objBet.kyje != ""){
                    betKYJE += Double(objBet.kyje)!
                }
                
            }
            textBetMoneyt.text="\(betMoney)"
            textKyje.text="\(betKYJE)"
        }
        
        //转json方法
        func toJSONString(jsonObject: [AnyObject])->NSString{
            
            let data = try!NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
            var strJson=NSString(data: data, encoding: NSUTF8StringEncoding)
            return strJson!
        }
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
            return 190.0
        }
        //结果返回
        func setResult(strResult: String, strType: String) {
            if(strType=="Error"){
                return
            }
            if(strResult==""){
                return
            }
            
            if(strType=="BatchAddBetResult"){
                NSLog(strResult)
            }
            if(strType=="GetCreditResult"){
                NSLog(strResult)
                var result = ( strResult as NSString ).floatValue;
                textBalance.text="\(result*10000)"
            }
            
        }
        //批次下注方法
        func addBet(strParam:NSString){
            
            var strParam:String = "<BatchAddBet xmlns=\"http://tempuri.org/\">";
            strParam.appendContentsOf("<strpara>\(strParam)</strpara>")
            strParam.appendContentsOf("<isBeting>false</isBeting>")
            strParam.appendContentsOf("</BatchAddBet>")
            comm.getResult(strParam,strResultName: "BatchAddBetResult")
        }
        //软键盘return方法
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        //文本框开始输入方法
        func textFieldDidBeginEditing(textField: UITextField) {
            textViewMoney=textField
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            
        }
        
        //键盘显示
        func keyboardWillShow(note : NSNotification) -> Void{
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.button.hidden = false
                let keyBoardWindow = UIApplication.sharedApplication().windows.last
                self.button.frame = CGRectMake(0, (keyBoardWindow?.frame.size.height)!-53, 106, 53)
                keyBoardWindow?.addSubview(self.button)
                keyBoardWindow?.bringSubviewToFront(self.button)
                
                UIView.animateWithDuration(((note.userInfo! as NSDictionary).objectForKey(UIKeyboardAnimationCurveUserInfoKey)?.doubleValue)!, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.view.frame = CGRectOffset(self.view.frame, 0, 0)
                    }, completion: { (complete) -> Void in
                        print("Complete")
                })
            }
            
        }
        //return
        func Done(sender : UIButton){
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.textViewMoney.resignFirstResponder()
                
            }
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
        //取得账户余额
        func getBalanceResult(){
            var strParam:String = "<GetCredit xmlns=\"http://tempuri.org/\">";
            strParam.appendContentsOf("<strUser>DEMOFZ-0P0P00</strUser>")
            strParam.appendContentsOf("</GetCredit>")
            comm.getResult(strParam,strResultName: "GetCreditResult")
        }
        
    }