    //
    //  ShopingViewController.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/4/11.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //
    
    import UIKit
    
    class ShopingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate,UITextFieldDelegate {
//        var betManger:BetListManager?
//        var betList:[BetInfo]?
        var comm=CommonParameter()
        var intRowIndex:Int = 0
        var flag=false
        let button = UIButton(type: UIButtonType.Custom)
        var textViewMoney=UITextField()
        var kMaxLength: Int {
            return 5
        }
        @IBOutlet weak var activityView: UIActivityIndicatorView!
        
        @IBAction func btnSelectClick(sender: UIBarButtonItem) {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        @IBOutlet weak var switchStatus: UISwitch!
        @IBAction func switchChanged(sender: UISwitch) {
            
            if(flag){
                flag=false
               
            }else{
                flag=true
                
            }
            print(flag)
            
        }
        //清除按钮
        @IBAction func btnClear(sender: AnyObject) {
            let alertView = UIAlertView()
            alertView.title = NSLocalizedString("SystemPrompt", comment: "")
            alertView.message = NSLocalizedString("ClearCart", comment: "")
            alertView.addButtonWithTitle(NSLocalizedString("Cancel", comment: ""))
            alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
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
//                BetListManager.sharedManager.clearBetList()
                
                let navigationViews = self.navigationController!.viewControllers
                let tabBar:BallViewController = navigationViews[navigationViews.count - 2] as! BallViewController
                tabBar.clearAllOdds()
                self.tableList.reloadData()
                textBetMoneyt.text="0.0"
                textKyje.text="0.0"
               
            }
        }
        @IBOutlet weak var tableList: UITableView!
        
        @IBOutlet weak var textBetMoneyt: UILabel!
        
        @IBOutlet weak var textKyje: UILabel!
        
        @IBOutlet weak var textBalance: UILabel!
        @IBAction func payChlick(sender: UIButton) {
           
            if(BetListManager.sharedManager.getBetList().count==0){
              
                let alertView = UIAlertView()
                alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                alertView.message = "必须选择两笔注单"
                alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alertView.show()
            return
            }
              self.activityView.startAnimating()
            var jsonObject: [AnyObject] = []
            
            for objbet in BetListManager.sharedManager.getBetList(){
                jsonObject.append(objbet.toDict())
            }
            var str=toJSONString(jsonObject)
            addBet(str)
        }
        @IBAction func controlTouchDown(sender: AnyObject) {
            
        }
        override func viewDidLoad() {
            self.title=NSLocalizedString("ShopCart", comment: "")
            self.tableList.dataSource=self
            self.tableList.delegate=self
            comm.delegate=self
            button.setTitle("Return", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.frame = CGRectMake(0, 163, 106, 53)
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: "Done:", forControlEvents: UIControlEvents.TouchUpInside)
            getBalanceResult()//取得账户余额
            intCountMoney()//初始化计算投注金额和可赢金额
             view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"handleTap:"))
        }
        func handleTap(sender: UITapGestureRecognizer) {
            if sender.state == .Ended {
//                print("收回键盘")
//                UIView.animateWithDuration(0.4, animations: {
//                    self.view.frame.origin.y = 0
//                })
                textViewMoney.resignFirstResponder()
                
            }
            sender.cancelsTouchesInView = false
        }
        override func viewWillAppear(animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            
            return (BetListManager.sharedManager.getBetList().count)
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
            
            lableV.text=BetListManager.sharedManager.getBetList()[indexPath.row].visitname
            lableH.text=BetListManager.sharedManager.getBetList()[indexPath.row].homename
            lableBetTeam.text=BetListManager.sharedManager.getBetList()[indexPath.row].betteamName
            lableRate.text=BetListManager.sharedManager.getBetList()[indexPath.row].rate
            lableKY.text=BetListManager.sharedManager.getBetList()[indexPath.row].kyje
            lableDC.text=BetListManager.sharedManager.getBetList()[indexPath.row].dcsx
            textMoney.text=BetListManager.sharedManager.getBetList()[indexPath.row].dMoney
            lableDZ.text=BetListManager.sharedManager.getBetList()[indexPath.row].dzxx+"-"+BetListManager.sharedManager.getBetList()[indexPath.row].dzsx
            textMoney.addTarget(self, action: "changeMoney:", forControlEvents: UIControlEvents.EditingDidEnd)
            textMoney.addTarget(self, action: "limitLength:", forControlEvents: UIControlEvents.EditingChanged)
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
             var intTag:Int=sender.tag
            if(BetListManager.sharedManager.betList.count==0){
            return
             }
            
            let navigationViews = self.navigationController!.viewControllers
            let tabBar:BallViewController = navigationViews[navigationViews.count - 2] as! BallViewController
            tabBar.synchronizationData(BetListManager.sharedManager.getBetInfo(intTag))
            BetListManager.sharedManager.delectListRow(intTag)
            self.tableList.reloadData()
           intCountMoney()
            
        }
        func limitLength(sender:UITextField){
            
            if sender.text?.characters.count >= kMaxLength {
                sender.text = sender.text?.substringToIndex((sender.text?.startIndex.advancedBy(5))!)
                
            }

        
        }
        //计算可赢金额方法
        func changeMoney(sender:UITextField){
            
            var intTag=sender.tag
            var objList=BetListManager.sharedManager.getBetList()
            var objBet=objList[intTag]
            var strbetMoney=sender.text=="" ? "0" : sender.text
            var dbetMoney=Double(strbetMoney!)
            if(dbetMoney==0){
                
                objBet.dMoney="10"
                var dRate=Double(objBet.rate)
                var winMoney=calculateWinMoney(objBet.playType,intBet:10,dRale: dRate!)
                  objBet.kyje="\(winMoney)"
                self.tableList.reloadData()
            return
            }
            objBet.dMoney=sender.text!
            var betdzsx=Double(objBet.dzsx)!
            var betMoney=Double(objBet.dMoney)!
            if(betMoney>betdzsx){
                sender.text="\(betdzsx)"
                objBet.dMoney="\(betdzsx)"
              betMoney=betdzsx
            }
            var dRate=Double(objBet.rate)
            var winMoney=calculateWinMoney(objBet.playType,intBet: betMoney,dRale: dRate!)
            objBet.kyje="\(winMoney)"
            objList[intTag]=objBet
            BetListManager.sharedManager.setList(objList)
            print(sender.tag)
            self.tableList.reloadData()
            intCountMoney()
            
        }
        
     
        func intCountMoney(){
            var betMoney:Double=0
            var betKYJE:Double=0
//                        if(BetListManager.sharedManager.getBetList().isEmpty){
//            
//                        return
//                        }
            for objBet in  BetListManager.sharedManager.getBetList(){
                if(objBet.dMoney != ""){
                    betMoney += Double(objBet.dMoney)!
                }
                let betMoney=Double(objBet.dMoney)
                let dRate=Double(objBet.rate)
                let winMoney=calculateWinMoney(objBet.playType,intBet: betMoney!,dRale: dRate!)
                    betKYJE += winMoney
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
                print(strResult)
                self.activityView.stopAnimating()
                var msg=""
                var strSuccess=""
                var strErrorCode=""
                NSLog(strResult)
                let infoArr = ToolsCode.toJsonArray(strResult)
                var intCountRow=infoArr.count
                for index in 0..<intCountRow{
                    msg=String(infoArr[index].objectForKey("sErroMessage")!)
                    strSuccess=String(infoArr[index].objectForKey("bSucceed")!)
                    strErrorCode=String(infoArr[index].objectForKey("iErroCode")!)
                }
                if(strErrorCode=="10001"){
                    
                    Tool.showMsg(NSLocalizedString("Maintain", comment: "")+msg)

                    var vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                if(strErrorCode=="10002"){
                    Tool.showMsg(NSLocalizedString("LoginError", comment: ""))
                    var vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                if(strErrorCode=="24"){
                    let alertView = UIAlertView()
                    alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                    alertView.message = NSLocalizedString("LackMoney", comment: "")
                    alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                     alertView.show()
                    return
                }
                
                if(strSuccess=="0"){
                    let alertView = UIAlertView()
                    alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                    alertView.message = msg
                    alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                    alertView.show()
                    return
                }else{
                    let navigationViews = self.navigationController!.viewControllers
                    let tabBar:BallViewController = navigationViews[navigationViews.count - 2] as! BallViewController
                    tabBar.clearAllOdds()
                    jumpPage()
                }
                
            }
            if(strType=="GetCreditResult"){
                NSLog(strResult)
                var result = ( strResult as NSString ).floatValue;
                textBalance.text="\(result*10000)"
            }
            
        }
        //批次下注方法
        func addBet(strPar:NSString){
            print(strPar)
            var strParam:String = "<BatchAddBet xmlns=\"http://tempuri.org/\">";
            strParam.appendContentsOf("<strpara>\(strPar)</strpara>")
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
//            UIView.animateWithDuration(0.4, animations: {
//                self.view.frame.origin.y = -220
//            })
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            
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
            strParam.appendContentsOf("<strUser>\(UserInfoManager.sharedManager.getUserID())</strUser>")
            strParam.appendContentsOf("</GetCredit>")
            comm.getResult(strParam,strResultName: "GetCreditResult")
        }
        func jumpPage(){
            var sb = UIStoryboard(name: "Main", bundle:nil)
            var vcAbout = sb.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
            self.navigationController?.pushViewController(vcAbout, animated: true)
            
        }
        
        
    }