//
//  CookieConsentInterface.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//


import Foundation
import PlatformInterfaces
import AppInfra

struct CookieConsentInterface {
    private var appInfra: AIAppInfra!
    
    init(withappInfra appInfra: AIAppInfra) {
        self.appInfra = appInfra
    }
    
    func registerCookieConsentHandler(withHandler handler:ConsentHandlerProtocol, andTypes types:[String]){
        try? self.appInfra.consentManager.registerHandler(handler: handler, forConsentTypes: types)
    }
    
    func postCookieConsent(consentDefinition: ConsentDefinition, withStatus: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        self.appInfra?.consentManager.storeConsentState(consent: consentDefinition, withStatus: withStatus) { (result, error) in
            completion(result,error)
        }
    }
    
    func fetchCookieConsent(consentDefinition: ConsentDefinition,completion: @escaping (ConsentDefinitionStatus?, NSError?) -> Void){
        self.appInfra?.consentManager.fetchConsentState(forConsentDefinition: consentDefinition) { (result, error) in
            completion(result,error)
        }
    }
    
    func registerAndFetchCookieConsentValue(completion: @escaping (Bool) -> Void) {
        let deviceStoredInteractor = CookieConsentProvider.createConsentDeviceHandler()
        let clickStreamInteractor = CookieConsentProvider.createConsentClickStreamHandler()
        self.registerCookieConsentHandler(withHandler:deviceStoredInteractor, andTypes:[Constants.ABTest_Consent_Type,Constants.Cloud_Logging_Consent_Type])
        self.registerCookieConsentHandler(withHandler:clickStreamInteractor, andTypes:[Constants.Click_Stream_Consent_Type])
        self.fetchCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination(), completion: {(consentStatus, error) in
            if(consentStatus?.status == ConsentStates.active) {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}

class CookieConsentProvider: NSObject {
    
    static func createConsentDeviceHandler() -> ConsentHandlerProtocol {
        return (AppInfraSharedInstance.sharedInstance.appInfraHandler?.deviceHandler)!
    }
    
    static func createConsentClickStreamHandler() -> ConsentHandlerProtocol {
        return (AppInfraSharedInstance.sharedInstance.appInfraHandler?.tagging.getClickStreamConsentHandler())!
    }
    
    static func getCookieConsentDefination() -> ConsentDefinition{
        let locale = AppInfraSharedInstance.sharedInstance.appInfraHandler?.internationalization.getBCP47UILocale()
        if let locale = locale {
            return ConsentDefinition(types: [Constants.Click_Stream_Consent_Type,Constants.Cloud_Logging_Consent_Type, Constants.ABTest_Consent_Type], text: Constants.Cookie_Header_Title ?? "", helpText:Constants.Cookie_Primary_Description_Paragraph ?? "", version: 2, locale: locale)
        }else{
            return ConsentDefinition(types: [Constants.Click_Stream_Consent_Type,Constants.Cloud_Logging_Consent_Type, Constants.ABTest_Consent_Type], text: Constants.Cookie_Header_Title ?? "", helpText:Constants.Cookie_Primary_Description_Paragraph ?? "", version: 2, locale: "en-US")
        }
    }
    
}
