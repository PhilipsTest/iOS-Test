//
//  CookieStateMock.swift
//  AppFrameworkTests
//
//  Created by Philips on 8/23/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PlatformInterfaces
@testable import AppFramework

class CookieStateMock : NSObject, ConsentHandlerProtocol {
    
    var fetchConsentTypeState : Bool?
    var storeConsentState : Bool?
    
    init(fetchConsentTypestatus : Bool, storeConsentCompletiontype : Bool) {
        fetchConsentTypeState = fetchConsentTypestatus
        storeConsentState = storeConsentCompletiontype
    }
    
    func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        let consent : ConsentStatus?
        if let value = fetchConsentTypeState, value{
            consent = ConsentStatus(status: .active, version: 1)
        } else {
            consent = ConsentStatus(status: .rejected, version: 1)
        }
        completion(consent,nil)
    }
    
    func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        if let value = storeConsentState , value {
            completion(true,nil)
        } else {
            completion(false,nil)
        }
    }
}
