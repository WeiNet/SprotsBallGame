//
//  CommonParameter.swift
//  SwiftCallOCWebService
//
//  Created by abel jing on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CommonParameter: NSObject ,NSXMLParserDelegate,NSURLConnectionDataDelegate{
    var xmlParser=NSXMLParser()
    var strRequestType=""
    var isFind=false
    var strResult=""
    var matchingElement="LoginResult"
    var elementIsFound=false
    var url:NSURL=NSURL(string:WebServiceAddress)!
    var delegate:ResultDelegate?
    func getSoapMsg(strParame:String)->String{
        
        var soapMsg = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        soapMsg.appendContentsOf("<soap12:Envelope ")
        soapMsg.appendContentsOf("xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ")
        soapMsg.appendContentsOf("xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" ")
        soapMsg.appendContentsOf("xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">")
        soapMsg.appendContentsOf("<soap12:Body>")
        soapMsg.appendContentsOf(strParame)
        soapMsg.appendContentsOf("</soap12:Body>")
        soapMsg.appendContentsOf("</soap12:Envelope>")
        
        return soapMsg
        
    }
    func getResult(strParam:String ,strResultName:String){
        let soapMsg = getSoapMsg                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                (strParam)
        //        self.strRequestType=strType//设置请求类型
        self.matchingElement=strResultName
        let reachability = Reachability.reachabilityForInternetConnection()
        
        //判断连接状态
        if reachability!.isReachable(){
           
        }else{
            delegate?.setResult("WebError",strType: "Error")
            return
        }
        
        //判断连接类型
        if reachability!.isReachableViaWiFi() {
            
           
        }else if reachability!.isReachableViaWWAN() {
           
        }else {
            delegate?.setResult("WebError",strType: "Error")
            return 
        }
       
        let request = NSMutableURLRequest(URL: url)
        var msgLength = String(soapMsg.characters.count)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMsg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (resp, data, error) -> Void in
            //            print(resp)
            if let e = error {
                print(e)
            }
            if  let d = data {
                //                print(NSString(data: d , encoding: NSUTF8StringEncoding))
                self.xmlParser = NSXMLParser(data: d)
                self.xmlParser.delegate = self
                self.xmlParser.parse()
                self.xmlParser.shouldResolveExternalEntities = true
            }
        }
    
    }
    func getSynchronousRequest(strParam:String ,strResultName:String){
        let soapMsg = getSoapMsg                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                (strParam)
        self.matchingElement=strResultName
        let reachability = Reachability.reachabilityForInternetConnection()
        
        //判断连接状态
        if reachability!.isReachable(){
            
        }else{
            delegate?.setResult("WebError",strType: "Error")
            return
        }
        
        //判断连接类型
        if reachability!.isReachableViaWiFi() {
            
            
        }else if reachability!.isReachableViaWWAN() {
            
        }else {
            delegate?.setResult("WebError",strType: "Error")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        var msgLength = String(soapMsg.characters.count)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMsg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        var response: NSURLResponse?
        do {
            let dataResult = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
           
                self.xmlParser = NSXMLParser(data: dataResult)
                self.xmlParser.delegate = self
                self.xmlParser.parse()
                self.xmlParser.shouldResolveExternalEntities = true
           
            
        } catch (let e) {
            print(e)
        }
       
    
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName==matchingElement){
            elementIsFound=true
        }
    }
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        if (strResult != "") {
            strResult = ""
            delegate?.setResult(parseError.debugDescription,strType: "Error")
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if(elementIsFound){
            strResult.appendContentsOf(string)
        }
    }
    func parserDidEndDocument(parser: NSXMLParser){
        if (strResult != "") {
            strResult = ""
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        elementIsFound = false;
        // 强制放弃解析
        self.xmlParser.abortParsing()
        delegate?.setResult(strResult,strType: matchingElement)
    }
    
    //http请求
    func getHttpResult (strApiName:String,strBody:String)
    {
        let urlString:String = httpAddress+strApiName
        var url:NSURL!
        url = NSURL(string:urlString)
        var request = NSMutableURLRequest(URL:url)
        var body=strBody
        //编码POST数据
        var postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        //保用 POST 提交
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        var conn:NSURLConnection!
        conn = NSURLConnection(request: request,delegate: self)
        conn.start()
        print(conn)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    {
        print("请求成功！");
        //            print(response)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData!)
    {
        print("请求成功1！");
        var datastring = NSString(data:data, encoding: NSUTF8StringEncoding)
        print(datastring!)
        delegate?.setResult(datastring as! String,strType: "")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        print("请求成功2！");
    }
    
    
}
