//
//  AICLoudLogRequestSerializer.swift
//  AppInfra
//
//  Created by Hashim MH on 21/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
extension String {
    mutating func removingRegexMatches(pattern: String="[$&+,:;=?@#|<>()\\\\\\[\\]]", replaceWith: String = "_") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return
        }
    }
}


class LogDateFormatter:DateFormatter {
    override init() {
        super.init()
        customFormat()
    }
    
    func customFormat() {
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        self.locale = Locale(identifier: "en_US_POSIX")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customFormat()
    }
}

struct LogModel: Codable{
    var entry:[Entry] {
        didSet{
            total = entry.count
        }
    }
    
    var productKey:String
    var resourceType = "bundle"
    var type = "transaction"
    var total:Int = 0
    
    init(entry: [Entry], productKey: String) {
        self.entry = entry
        self.productKey = productKey
        self.total = entry.count
    }
    
    var debugDescription: String {
        let desc = "productKey:\(productKey) \nresourceType:\(resourceType) \ntype:\(type) \ntotal:\(total) \nentry:\(entry)"
        return desc
    }
}

struct Entry: Codable {
    var resource:Resource
    init(log: AILog) {
        self.resource = Resource(log:log)
    }
}

struct LogData: Codable {
    var message:String
    init(log: AILog) {
        self.message = LogMessage(log: log).base64 ?? "NA"
    }
}

struct LogMessage: Codable {
    var devicetype:String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return modelCode ?? ""
    }()
    
    var appstate:String
    var locale:String
    var homecountry:String
    var localtime:String
    var networktype:String
    var description:String
    var details:String
    
    init(log: AILog) {
        self.appstate = log.appState ?? ""
        self.locale = log.locale ?? ""
        self.homecountry = log.homeCountry ?? ""
        self.localtime = ""
        if let localtime = log.localTime as Date? {
            self.localtime = LogDateFormatter().string(from: localtime)
        }
        self.networktype = log.networkType ?? ""
        self.description = log.logDescription ?? ""
        self.details = log.details ?? ""
    }
    
    var base64:String? {
        guard let stringValue = stringValue else{
            return nil
        }
        return Data(stringValue.utf8).base64EncodedString()
    }
    
    var stringValue:String? {
        do {
            let logBytes = try JSONEncoder().encode(self)
            if let log = String(bytes: logBytes, encoding: .utf8) { return log }
        } catch  {
        }
        return nil
    }
}

struct Resource: Codable{
    init(log: AILog) {
        self.id = log.logID ?? "NA"
        self.serverName = log.serverName ?? "NA"
        self.eventId = log.eventID ?? "NA"
        self.severity = log.severity ?? "NA"
        self.applicationInstance = log.appsId ?? "NA"
        self.component = log.component ?? "NA"
        self.serverName = log.serverName ?? "NA"
        self.logTime = ""
        if let logTime = log.logTime as Date? {
            self.logTime = LogDateFormatter().string(from: logTime)
        }
        self.originatingUser = log.userUUID ?? "NA"
        self.applicationVersion = log.appVersion ?? "NA"
        self.logData = LogData(log: log)
        self.transactionId = self.id
        
        applicationName?.removingRegexMatches()
        applicationVersion?.removingRegexMatches()
        applicationInstance.removingRegexMatches()
        component.removingRegexMatches()
        eventId.removingRegexMatches()
        originatingUser.removingRegexMatches()
        self.severity.removingRegexMatches()
    }
    
    var id:String
    var category = "TRACELOG"
    var resourceType = "LogEvent"
    var serverName:String
    var applicationName:String? = {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }()
    var applicationVersion:String? = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }()
    var applicationInstance:String
    var component:String
    var eventId:String
    var transactionId:String
    var originatingUser:String
    var logTime:String
    var severity:String
    var logData:LogData
}

class AICLoudLogRequestSerializer: NSObject {
    var productKey:String?
    
    init(productKey:String?) {
        self.productKey = productKey
    }
    
    func postData(logs:[AILog]) -> Data? {
        guard logs.count > 0, let productKey = productKey  else {
            return nil
        }
        
        var entry = [Entry]()
        
        logs.forEach { (log) in
            entry.append(Entry(log:log))
        }
        
        let logModel = LogModel(entry:entry, productKey: productKey)
        
        do {
            let data = try   JSONEncoder().encode(logModel)
            return data
        } catch  {
            return nil
        }
    }
}
