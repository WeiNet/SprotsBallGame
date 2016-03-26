//
//  CommonParameter.swift
//  SwiftCallOCWebService
//
//  Created by abel jing on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CommonParameter: NSObject ,NSXMLParserDelegate{
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
        var request = NSMutableURLRequest(URL: url)
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
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName==matchingElement){
            elementIsFound=true
        }
    }
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        if (strResult != "") {
            strResult = ""
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
            delegate?.setResult(strResult)
    }

    
}
