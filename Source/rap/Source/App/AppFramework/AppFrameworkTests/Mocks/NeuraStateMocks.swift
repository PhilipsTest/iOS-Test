//
//  NeuraStateMocks.swift
//  AppFrameworkTests
//
//  Created by philips on 4/20/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PlatformInterfaces
@testable import AppFramework

@objc class AIConsentManagerProtocolmock : NSObject, AIConsentManagerProtocol {
    
    var consentValue : Bool?
    var consentDefinitionToReturn: ConsentDefinition!
    var consentDefinitionStatusToReturn:ConsentDefinitionStatus?
    var errorToReturn:NSError?
    var returnInactiveState: Bool!
    
    init (consent : Bool){
        self.consentValue = consent
    }
    
    func registerHandler(handler: ConsentHandlerProtocol, forConsentTypes: [String]) throws {
        return
    }
    
    func deregisterHandler(forConsentTypes: [String]) {
        return
    }
    
    func getConsentDefinition(forConsentType: String) -> ConsentDefinition?{
        
        return consentDefinitionToReturn
    }
    
    func storeConsentState(consent consentDefinition: ConsentDefinition, withStatus status: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        completion(consentValue!, nil)
    }
    
    func fetchConsentStates(forConsentDefinitions consentDefinitions: [ConsentDefinition], completion: @escaping ([ConsentDefinitionStatus]?, NSError?) -> Void) {
    }
    
    func fetchConsentState(forConsentDefinition consentDefinition: ConsentDefinition, completion: @escaping (ConsentDefinitionStatus?, NSError?) -> Void) {
        if(returnInactiveState == true){
            consentDefinitionStatusToReturn = ConsentDefinitionStatus(status: .inactive , versionStatus: .appVersionIsHigher, consentDefinition: consentDefinition )
        }
        else{
            if consentValue == true {
                consentDefinitionStatusToReturn = ConsentDefinitionStatus(status: .active , versionStatus: .inSync, consentDefinition: consentDefinition )
            } else {
                consentDefinitionStatusToReturn = ConsentDefinitionStatus(status: .rejected , versionStatus: .inSync, consentDefinition: consentDefinition )
            }
        }
        completion(consentDefinitionStatusToReturn,nil)
    }
}



