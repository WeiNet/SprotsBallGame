    //
    //  PassShopingViewController.swift
    //  SportsBall
    //
    //  Created by abel jing on 16/5/18.
    //  Copyright © 2016年 abel jing. All rights reserved.
    //
    
    import UIKit
    
    class PassShopingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultDelegate,UITextFieldDelegate {
        var betManger:BetListManager?
        var betList:[BetInfo]?
        var comm=CommonParameter()
        var menuArray: Array<Dictionary<String,String>> = [["0":NSLocalizedString("SingleNote", comment: "")],["1":NSLocalizedString("EvenTouch", comment: "")]]
        var intRowIndex:Int = 0
        let button = UIButton(type: UIButtonType.Custom)
        
        @IBOutlet weak var textBanlance: UILabel!
        
        @IBOutlet weak var textKY: UILabel!
        var textViewMoney=UITextField()
        var alertMenu:UIAlertController!
        var alertSubMenu:UIAlertController!
        var betType=0//下注方式，0为单注，1为连碰
        var touchFlag=true//连碰标志
        
        @IBOutlet weak var singleButton: UIButton!
        
        @IBOutlet weak var btnSelect: UIButton!
        
        @IBOutlet weak var view1: UIView!
        
        @IBOutlet weak var teamCount: UILabel!
        @IBOutlet weak var view2: UIView!
        
        @IBOutlet weak var view3: UIView!
        
        @IBAction func btnSelectClick(sender: UIBarButtonItem) {
          
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        @IBOutlet weak var textBetMoney: UITextField!
        @IBAction func btnTypeClick(sender: UIButton) {
            self.presentViewController(alertMenu, animated: true, completion: nil)
            
        }
        
        @IBAction func subTypeClick(sender: UIButton) {
            
            if(betType==1&&betList?.count<=2)
            {
                return
            }
            
         self.presentViewController(alertSubMenu, animated: true, completion: nil)
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
                if(betList?.isEmpty==false){
                    let navigationViews = self.navigationController!.viewControllers
                    let tabBar:BallViewController = navigationViews[navigationViews.count - 2] as! BallViewController
                    tabBar.clearAllOdds()
                    betList?.removeAll()
                    self.tableList.reloadData()
                }
            }
        }
        @IBOutlet weak var tableList: UITableView!
        
        
        
        @IBAction func payChlick(sender: UIButton) {
            if(betList?.count<2){
                let alertView = UIAlertView()
                alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                alertView.message = "必须选择两场比赛"
                alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alertView.show()
                return
            }
            if(self.textBetMoney.text!==""){
                let alertView = UIAlertView()
                alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                alertView.message = NSLocalizedString("PleaseAmount", comment: "")
                alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alertView.show()
                return
            }
            if(touchFlag==false){
                let alertView = UIAlertView()
                alertView.title = NSLocalizedString("SystemPrompt", comment: "")
                alertView.message = NSLocalizedString("NoTouchPlease", comment: "")
                alertView.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alertView.show()
                return
            }
            var objBetPara=BetPara()
            objBetPara.USER=UserInfoManager.sharedManager.getUserID()
            
            
            if(betType==0)
            {
                objBetPara.money=self.textBetMoney.text!
                objBetPara.moneySum=self.textBetMoney.text!
                objBetPara.inum="\(betList!.count)"
            }
            else{
                var strTeamCount=(teamCount.text! as NSString).substringFromIndex(3)
                var sumMoney=Double(strTeamCount)!*Double(self.textBetMoney.text!)!
                objBetPara.money=self.textBetMoney.text!
                objBetPara.moneySum="\(sumMoney)"
                var strInum=btnSelect.titleLabel?.text!
                objBetPara.inum="\((strInum! as NSString).substringToIndex(1))"
            }
            var jsonObject: [AnyObject] = []
            
            for objbet in betList!{
                objbet.dMoney=self.textBetMoney.text!
                jsonObject.append(objbet.toDict())
            }
            var strBetContent=toJSONString(jsonObject)
            var strBet=objBetPara.toString(strBetContent)
            print(strBet)
            addBet(strBet)
        }
        
        
        override func viewDidLoad() {
            self.title=NSLocalizedString("ShopCart", comment: "")
            betManger=BetListManager.sharedManager
            betList=betManger!.getBetList()
            self.tableList.dataSource=self
            self.tableList.delegate=self
            self.textBetMoney.delegate=self
            comm.delegate=self
            button.setTitle("Return", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.frame = CGRectMake(0, 163, 106, 53)
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: "Done:", forControlEvents: UIControlEvents.TouchUpInside)
            setViewBackground()
            getBalanceResult()//取得账户余额
            createMenu(menuArray)
            createSubMenu(getSpinnerItem("0"))
            
            
            
        }
        
        override func viewWillAppear(animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: animated)
            
        }
        
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
            
            var btnDel=UIButton(frame: CGRect(x: 260, y: 80, width: 73, height: 53))
            
            btnDel.setImage(UIImage(named: "ibtn_delete_item"), forState: UIControlState.Normal)
            btnDel.setImage(UIImage(named: "ibtn_delete_select"), forState: UIControlState.Selected)
            btnDel.tag=indexPath.row
            cell?.addSubview(btnDel)
            var lableV=cell?.viewWithTag(5) as! UILabel
            var lableH=cell?.viewWithTag(6) as! UILabel
            var lableBetTeam=cell?.viewWithTag(7) as! UILabel
            var lableRate=cell?.viewWithTag(10) as! UILabel
            var lableKY=cell?.viewWithTag(11) as! UILabel
            var lableDC=cell?.viewWithTag(12) as! UILabel
            var lableDZ=cell?.viewWithTag(13) as! UILabel
            lableDZ.text=betList![indexPath.row].dzxx+"-"+betList![indexPath.row].dzsx
            lableV.text=betList![indexPath.row].visitname
            lableH.text=betList![indexPath.row].homename
            lableBetTeam.text=betList![indexPath.row].betteamName
            lableRate.text=betList![indexPath.row].rate
            lableKY.text=betList![indexPath.row].kyje
            lableDC.text=betList![indexPath.row].dcsx
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
            if(BetListManager.sharedManager.betList.count==0){
                return
            }
            
            let navigationViews = self.navigationController!.viewControllers
            let tabBar:BallViewController = navigationViews[navigationViews.count - 2] as! BallViewController
            tabBar.synchronizationData(BetListManager.sharedManager.getBetInfo(intTag))
            BetListManager.sharedManager.delectListRow(intTag)
            betList?.removeAtIndex(intTag)
            self.tableList.reloadData()
            if(betType==0){
                if(betList?.count<2){
                   btnSelect.setTitle(NSLocalizedString("Limit", comment: ""), forState: UIControlState.Normal)
                    
                }else{
                       btnSelect.setTitle("\(betList!.count)"+NSLocalizedString("String1", comment: ""), forState: UIControlState.Normal)
                }
                
          
            }
           
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
                
                var result = ( strResult as NSString ).floatValue;
                textBanlance.text="\(result*10000)"
                btnSelect.setTitle("\(betList!.count)"+NSLocalizedString("String1", comment: ""), forState: UIControlState.Normal)
            }
            if(strType=="AddGGBetResult"){
                
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
            
            
        }
        //批次下注方法
        func addBet(strPar:NSString){
            var strParam:String = "<AddGGBet xmlns=\"http://tempuri.org/\">";
            strParam.appendContentsOf("<strpara>\(strPar)</strpara>")
            strParam.appendContentsOf("</AddGGBet>")
            comm.getResult(strParam,strResultName: "AddGGBetResult")
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
            strParam.appendContentsOf("<strUser>\(UserInfoManager.sharedManager.getUserID())</strUser>")
            strParam.appendContentsOf("</GetCredit>")
            comm.getResult(strParam,strResultName: "GetCreditResult")
        }
        func setViewBackground(){
            
            self.view1.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
            self.view1.layer.borderWidth = 1
            self.view2.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
            self.view2.layer.borderWidth = 1
            self.view3.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor;
            self.view3.layer.borderWidth = 1
        }
        
        //创建玩法菜单
        func createMenu(menuArray: Array<Dictionary<String,String>>){
            if(menuArray.count <= 0){
                return
            }
            alertMenu = UIAlertController(title: NSLocalizedString("GameType", comment: ""), message: NSLocalizedString("PleaseSelect", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            for menu in menuArray {
                for (key,value) in menu {
                    let item = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                        self.clickMenuItem(key)
                    })
                    alertMenu.addAction(item)
                }
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
            alertMenu.addAction(cancel)
        }
        
        //玩法菜单选项响应事件
        func clickMenuItem(key:String){
            
            print("点击项\(key)")
            
            
            if(key=="0"){
                self.touchFlag=true
                betType=0
                singleButton.setTitle(NSLocalizedString("SingleNote", comment: ""), forState: UIControlState.Normal)
                var arry=getSpinnerItem("0")
                btnSelect.titleLabel?.text=arry[0]["0"]
                createSubMenu(arry)
                teamCount.text=NSLocalizedString("Group", comment: "")+":1"
                
                return
                
            }
            if(key=="1"){
                betType=1
                singleButton.titleLabel?.text=NSLocalizedString("EvenTouch", comment: "")
                var arry11 = getSpinnerItem("1")
                var content:String=arry11[0]["0"]!
//                btnSelect.titleLabel?.text=content
                btnSelect.setTitle(content, forState: UIControlState.Normal)
                btnSelect.titleLabel!.adjustsFontSizeToFitWidth=true
                
                if(betList?.count<=2){
                    return
                }
                var intTeamCount=(content as NSString).substringToIndex(1)
                teamCount.text=NSLocalizedString("Group", comment: "")+":\(betCount((betList?.count)!,pNumber: Int(intTeamCount)!))"
                createSubMenu(arry11)
                return
            }
            
        }
        
        //创建玩法菜单
        func createSubMenu(menuArray: Array<Dictionary<String,String>>){
            if(menuArray.count <= 0){
                return
            }
            alertSubMenu = UIAlertController(title: NSLocalizedString("GameType", comment: ""), message: NSLocalizedString("PleaseSelect", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            for menu in menuArray {
                for (key,value) in menu {
                    let item = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                        self.clickSubMenuItem(value)
                    })
                    alertSubMenu.addAction(item)
                }
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
            alertSubMenu.addAction(cancel)
        }
        
        //玩法菜单选项响应事件
        func clickSubMenuItem(value:String){
            if betType==0{
                singleButton.titleLabel?.text=NSLocalizedString("SingleNote", comment: "")
                self.touchFlag=true
            }
            else{
                singleButton.titleLabel?.text=NSLocalizedString("EvenTouch", comment: "")
            }
            btnSelect.titleLabel?.text=value
            var intTeamCount=(value as NSString).substringToIndex(1)
            teamCount.text=NSLocalizedString("Group", comment: "")+":\(betCount((betList?.count)!,pNumber: Int(intTeamCount)!))"
        }
        
        //组合数计算
        func betCount(pBase:Int,pNumber:Int)->Int
        {
            var base=arrayCount(pBase, number: pNumber)
            var number=arrayCount(pNumber, number: pNumber)
            return base/number
            
        }
        //排列数计算
        func arrayCount(pBase:Int,number:Int)->Int
        {
            if number>0 {
                return pBase*arrayCount(pBase-1,number: number-1)
            }
            else{
                return 1
            }
        }
        
        func getSpinnerItem(strPosition:String)->Array<Dictionary<String,String>>
        {
            print("strPosition\(strPosition)")
            var arryMenu: Array<Dictionary<String,String>>=[]
            var key:Int=(betList?.count)!
            
            switch(key){
            case 0,1:
                if strPosition=="0"{
                    arryMenu.append(["0":NSLocalizedString("Limit", comment: "")])
                }else{
                    self.touchFlag=false
                    arryMenu.append(["0":NSLocalizedString("NoTouch", comment: "")])
                    
                }
                break
            case 2:
                if strPosition=="0"{
                    arryMenu.append(["0":"\(key)"+NSLocalizedString("String1", comment: "")])
                    
                }else{
                    self.touchFlag=false
                    arryMenu.append(["0":NSLocalizedString("NoTouch", comment: "")])
                }
                break
            default:
                
                for(var i=key,j=0;i>2&&j<3;i--,j++){
                    
                    if strPosition=="0"{
                        arryMenu.append(["0":"\(key)"+NSLocalizedString("String1", comment: "")])
                        break
                        
                    }
                    
                    if(strPosition=="1"){
                        arryMenu.append(["0":"\(i-1)"+NSLocalizedString("String1", comment: "")])
                    }
                }
                
                
                break
            }
            
            return arryMenu
        }
        
        func jumpPage(){
            var sb = UIStoryboard(name: "Main", bundle:nil)
            var vcAbout = sb.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
            self.navigationController?.pushViewController(vcAbout, animated: true)
            
        }
        
    }