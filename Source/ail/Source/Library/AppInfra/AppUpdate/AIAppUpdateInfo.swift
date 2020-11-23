//
//  AIAppUpdateInfo.swift
//  AppInfra
//
//  Created by Hashim MH on 16/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

open class AIAppUpdateInfo: NSObject {
    
    var infoDictionary:[String: NSDictionary]?
    var appVersion:AIVersion?
    
    var currentVersionMessage:String?  {
        return infoDictionary?["messages"]?["currentVersionMessage"] as? String
    }
    
    var minimumVersionMessage:String?  {
        return infoDictionary?["messages"]?["minimumVersionMessage"] as? String
    }
    
    var deprecatedVersionMessage:String?  {
        return infoDictionary?["messages"]?["deprecatedVersionMessage"] as? String
    }
    
    var minimumOSMessage:String? {
        return (infoDictionary?["messages"]?["minimumOSMessage"]) as? String
    }
    
    var isDeprecated:Bool  {
        if let minVersion = minimumVersion, let appVersion = appVersion{
            let alreadyDeprecated = appVersion < minVersion
            var justNowDeprecated = false
            if let deprecatedDate =  deprecatedDate , let depVersion = deprecatedVersion{
                justNowDeprecated =  appVersion <= depVersion && Date() > deprecatedDate
            }
            return alreadyDeprecated || justNowDeprecated
            
        }
        return false;
    }
    var isToBeDeprecated:Bool  {
        if let minVersion = minimumVersion, let appVersion = appVersion, let depVersion = deprecatedVersion {
            return (minVersion <= appVersion) && (appVersion <= depVersion)
        }
        return false;
    }
    
    var isUpdateAvailable:Bool  {
        if  let appVersion = appVersion, let currentVersion = currentVersion {
            return (appVersion < currentVersion)
        }
        return false;
    }
    
    
    var minimumVersion:AIVersion?  {
        return AIVersion(string: infoDictionary?["version"]?["minimumVersion"] as? String)
    }
    
    var deprecatedVersion:AIVersion?  {
        return AIVersion(string: infoDictionary?["version"]?["deprecatedVersion"] as? String)
    }
    
    var currentVersion:AIVersion?  {
        return AIVersion(string: infoDictionary?["version"]?["currentVersion"] as? String)
    }
    
    
    var minimumOSVersion:String?  {
        return (infoDictionary?["requirements"]?["minimumOSVersion"] as? String)
    }
    
    
    var deprecatedDate:Date?{        
        var date:Date?
        if  let dateString = infoDictionary?["version"]?["deprecationDate"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            date = formatter.date(from: dateString)
        }
        return date;
    }
    
    public init(dictionary: [String: NSDictionary]?) {
        self.infoDictionary = dictionary
        //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        self.appVersion = AIVersion(string: versionString as? String)
        super.init()
    }
    
    public static func getSavedInfo() -> AIAppUpdateInfo?{
        let dictionary = AIUtility.fetchDictionary(from:"appupdateinfo")
        if dictionary != nil {
            return AIAppUpdateInfo(dictionary: dictionary as? [String : NSDictionary]);
   
        }
        return nil
    }
    public static func saveInfo(_ dictionary: [String: NSDictionary]) -> Void {
        AIUtility.save(dictionary,to:"appupdateinfo")
    }
    
}
