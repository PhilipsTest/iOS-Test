//
//  CCBDeviceUtility.swift
//  ConversationalChatbotDev
//
//  Created by Shravana Kumar on 04/08/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import CoreBluetooth
import AppInfra

class CCBDeviceCapability: NSObject, CBCentralManagerDelegate {
    
    private var bleCompletionHandler: ((Bool?,Error?) -> ())?
    private var manager:CBCentralManager?
    
    //Check WiFi on or Off.
    static func checkIsWiFiEnabled() -> Bool {
        var addresses = [String]()

        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return false }
        guard let firstAddr = ifaddr else { return false }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString: ptr.pointee.ifa_name))
        }

        var counts:[String:Int] = [:]

        for item in addresses {
            counts[item] = (counts[item] ?? 0) + 1
        }

        freeifaddrs(ifaddr)
        guard let count = counts["awdl0"] else { return false }
        return count > 1
    }
    
    func checkIsBLEEnabled(completionHandler:@escaping ((Bool?,Error?) -> ())) {
        self.bleCompletionHandler = completionHandler
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.bleCompletionHandler?(false,nil)
//        })
        self.manager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey:false])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
                self.bleCompletionHandler?(false, NSError.errorWithLocalisedDesctiption("Status Unknown"))
                break;
            case .resetting:
                self.bleCompletionHandler?(false, NSError.errorWithLocalisedDesctiption("Status resetting"))
                break;
            case .unsupported:
                self.bleCompletionHandler?(false, NSError.errorWithLocalisedDesctiption("Status unsupported"))
                break;
            case .unauthorized:
                self.bleCompletionHandler?(false, NSError.errorWithLocalisedDesctiption("Status unauthorised"))
                break;
            case .poweredOff:
                self.bleCompletionHandler?(false,nil)
                break;
            case .poweredOn:
                self.bleCompletionHandler?(true, nil)
                break;
            default:
                self.bleCompletionHandler?(false, NSError.errorWithLocalisedDesctiption("Unknown state"))
                break;
        }
        self.bleCompletionHandler = nil;
    }
}

class CCBActionParser: NSObject {
    
    private var completionHandler: ((_ value:Bool?, _ error:Error?) -> ())?
    private let deviceCapability:CCBDeviceCapability = CCBDeviceCapability()
    
    func parseFunction(function:String,completion: @escaping (_ value:Bool?, _ error:Error?) -> ()) {
        self.completionHandler = completion
        let commands = function.components(separatedBy: CCBConstants.Bot.commandSeperator)
        
        guard let command = commands.last else {
            return
        }

        if  commands.contains(CCBConstants.Bot.commandBot) {
            self.executeCommand(command: command)
        } else if commands.contains(CCBConstants.Bot.commandUSR){
            self.executeUserCommand(command: command)
        }
    }
    
    func executeCommand(command:String) {
        if command.contains(CCBConstants.Bot.BLE) {
            deviceCapability.checkIsBLEEnabled {  isEnabled,error  in
                self.completionHandler?(isEnabled,error)
                self.completionHandler = nil
            }
        } else {
            let wifiStatus = CCBDeviceCapability.checkIsWiFiEnabled()
            self.completionHandler?(wifiStatus,nil)
            self.completionHandler = nil
        }
    }
    
    func executeUserCommand(command:String) {
        if command.contains(CCBConstants.Bot.Device) {
            let status = CCBManager.shared.ccbDependencies?.chatbotConfiguration?.deviceCapability?.isDeviceConnected(deviceID: "Device ID")
            self.completionHandler?(status,nil)
            self.completionHandler = nil
        }
    }
}


class CCBUtility: NSObject {
    static func logDebugMessage(eventId:String, message:String) {
        guard let logger = CCBManager.shared.ccbDependencies?.appInfra.logging else {
            return
        }
        NSLog("*-*-*-*-*-CCB : \(eventId), message \(message)")
        logger.log(AILogLevel.debug, eventId: eventId, message: message)
    }
    
    static func logInfoMessage(eventId:String, message:String) {
        guard let logger = CCBManager.shared.ccbDependencies?.appInfra.logging else {
            return
        }
        logger.log(AILogLevel.info, eventId: eventId, message: message)
    }
}

class CCBTaggingUtility : NSObject {
    
    static func tagCCBPageWithInfo(page: String,params:[String:AnyObject]?){
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackPage(withInfo: page, params: params)
    }
    
    static func tagCCBError(error: NSError){
        let errorString = "CCB:" + error.domain + ":" + "\(error.code):" + error.localizedDescription
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackAction(withInfo: CCBConstants.TaggingKeys.setError, paramKey: CCBConstants.TaggingKeys.technicalError, andParamValue: errorString)
    }
    
    static func tagCCBEvent(_ message: String,parameters:[String:AnyObject]?) {
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackAction(withInfo: message, params: parameters)
    }
    
    static func tagCCBVideoStart(_ video: String) {
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackVideoStart(video)
    }
    
    static func tagCCBVideoEnd(_ video: String) {
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackVideoEnd(video)
    }
    
    static func tagCCBUserLinkClick(_ url: String) {
        CCBManager.shared.ccbDependencies?.appInfra?.tagging?.trackLinkExternal(url)
    }
}
