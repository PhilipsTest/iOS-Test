//
//  FireBaseRequestMock.swift
//  AppFramework
//
//  Created by philips on 8/18/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import XCTest
import AppInfra
import Firebase
@testable import AppFramework

class AppIndentityMock : NSObject, AIAppIdentityProtocol{
    
    public var appVersion : String = "1804"
    
    func getMicrositeId() -> String! {
        return ""
    }
    
    func getAppState() -> AIAIAppState {
        return AIAIAppState.TEST
    }
    
    func getSector() -> String! {
        return ""
    }
    
    func getAppName() -> String! {
        return ""
    }
    
    func getLocalizedAppName() -> String! {
        return ""
    }
    
    func getAppVersion() -> String! {
        return appVersion
    }
    
    func getServiceDiscoveryEnvironment() -> String! {
        return ""
    }
    
    
}

class FirebaseRequestMock : ABTestingServerRequest {
    
    var testValue : Bool = false
    var keys : [String] = []
    var keyValue : [String:String]? = [:]
    
    init(testValue:Bool, keys:[String], keyValue: [String:String]) {
        self.testValue = testValue
        self.keys = keys
        self.keyValue = keyValue
    }
    
    func getTestValueFromServer(_ successHandler:@escaping (Bool) -> Void, failureHandler: @escaping (Error) -> Void){
        if testValue {
            successHandler(true)
        } else {
            let error = NSError(domain: "aiabtestHelperTest", code: 1000, userInfo: nil)
            failureHandler(error)
        }
    }
    
    func requestServerForAllKeys() -> [String] {
        return keys
    }
    
    func requestServerValueforKey(key: String) -> String? {
        return keyValue?[key]
    }
}
