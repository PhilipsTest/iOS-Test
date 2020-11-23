//
//  CloudConsent.swift
//  AppInfraDemoApp
//
//  Created by philips on 6/27/18.
//  Copyright © 2018 philips. All rights reserved.
//

import Foundation
import PlatformInterfaces
import AppInfra

@objcMembers public class CloudConsentProvider: NSObject {
    
    public let Cloud_Consent_Text = "Enable Cloud Logging"                           //updatable and gettable.
    public let Cloud_Consent_Help = "To know more about Cloud Logging"                           //updatable and gettable.
    
    public var appinfraObject : AIAppInfraProtocol!
    
    init(withappInfra appInfra: AIAppInfraProtocol) {
        self.appinfraObject = appInfra
    }
    
    static func createConsentHandler(with appInfra: AIAppInfraProtocol) -> ConsentHandlerProtocol {
        return (appInfra.deviceHandler)!
    }
    
    public func getCloudConsentDefination() -> ConsentDefinition?{
        let locale = self.appinfraObject.internationalization.getBCP47UILocale()
        var consentDefinition:ConsentDefinition!
        
        if let cloudConsent = self.appinfraObject.cloudLogging.getCloudLoggingConsentIdentifier(){
            if let consentDef = self.appinfraObject?.consentManager.getConsentDefinition(forConsentType: cloudConsent){
                return consentDef
            }else{
                if let locale = locale {
                    consentDefinition = ConsentDefinition(type:cloudConsent, text: Cloud_Consent_Text, helpText:Cloud_Consent_Help, version: 2, locale: locale)
                }else{
                    consentDefinition = ConsentDefinition(type: cloudConsent, text: Cloud_Consent_Text, helpText:Cloud_Consent_Help, version: 2, locale: "en-US")
                }
            }
        }
        
        return consentDefinition
        
    }
}

@objcMembers public class CloudConsentInterface:NSObject {
    
    public var appInfra: AIAppInfraProtocol!
    
    public init(withappInfra appInfra: AIAppInfraProtocol) {
        self.appInfra = appInfra
    }
    
    @objc public func postCloudConsent(consentDefinition: ConsentDefinition, withStatus: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        self.appInfra?.consentManager.storeConsentState(consent: consentDefinition, withStatus: withStatus) { (result, error) in
            completion(result,error)
        }
    }
    
    @objc public func fetchCloudConsent(consentDefinition: ConsentDefinition,completion: @escaping (ConsentDefinitionStatus?, NSError?) -> Void){
        self.appInfra?.consentManager.fetchConsentState(forConsentDefinition: consentDefinition) { (result, error) in
            completion(result,error)
        }
    }
    
    @objc public func registerCloudConsentDefinition(wihConsentDefinition consentDefinition: ConsentDefinition,onCompletion completion: @escaping (Bool) -> Void){
        self.appInfra?.consentManager.registerConsentDefinitions!(consentDefinitions: [consentDefinition], completion: { (error) in
            if(error != nil){
                completion(false)
            }else{
                completion(true)
            }
        })
    }
}
