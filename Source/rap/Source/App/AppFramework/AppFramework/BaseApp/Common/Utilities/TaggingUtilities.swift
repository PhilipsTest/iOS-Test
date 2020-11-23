//
//  TaggingUtilities.swift
//  AppFramework
//
//  Created by Philips on 3/22/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation
import AppInfra

class TaggingUtilities : NSObject {
    
    //MARK: Variable Declarations
    @objc static func receiveTaggingData(notification:NSNotification){
        if let info = notification.userInfo as? Dictionary<String,String>{
            if let taggedPage = info[kAilTaggingPageName] {
                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                jsonObject.setValue(taggedPage, forKey: kAilTaggingPageName)
           AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "TaggingPage", message:notification.userInfo?.description)
            }
            else if let taggedAction = info[kAilTaggingActionName] {
                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                jsonObject.setValue(taggedAction, forKey: kAilTaggingActionName)
             AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "TaggingAction", message:notification.userInfo?.description)
            }
        }
    }
    
    //MARK: Helper methods
    
    static func trackPageWithInfo(page: String,params:[String:AnyObject]?){
        AppInfraSharedInstance.sharedInstance.taggingForAppFramework?.trackPage(withInfo: page, params: params)
    }
    
    static func trackPageWithInfo(page: String,key: String,value: String){
        AppInfraSharedInstance.sharedInstance.taggingForAppFramework?.trackPage(withInfo: page, paramKey: key, andParamValue: value)
    }
    
    static func trackActionWithInfo(key: String,params:[String:AnyObject]?){
        AppInfraSharedInstance.sharedInstance.taggingForAppFramework?.trackAction(withInfo: key, params: params)
    }
    
    static func trackActionWithInfo(action: String,key: String,value: String){
        AppInfraSharedInstance.sharedInstance.taggingForAppFramework?.trackAction(withInfo: action, paramKey: key, andParamValue: value)
    }
    
    static func JSONStringify(jsonObject: NSMutableDictionary, prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        do{
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "JSONConversion", message: error.localizedDescription)
        }
        
        return ""
        
    }
}
