//
//  PIMserviceDiscoveryMock.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 4/30/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import AppInfra

let authorizationURL = "https://stg.accounts.philips.com/c2a48310-9715-3beb-895e-000000000000/login"
let migrationURL = "https://stg.eu-west-1.api.philips.com/consumerIdentityService/identityAssertions"
let marketingOptinURL = "https://stg.eu-west-1.api.philips.com/consumerIdentityService/users"
let userProfileURL = "https://stg.accounts.philips.com/c2a48310-9715-3beb-895e-000000000000/auth-ui/profile?client_id=%id%&ui_locales=%locale%"

class PIMServiceDiscoveryMock: NSObject, AIServiceDiscoveryProtocol {
    
    var error: Error?
    var service = AISDService(url: "", andLocale: "en_US")
    
    func getHomeCountry(_ completionHandler: ((String?, String?, Error?) -> Void)!) {
        
    }
    
    func getHomeCountry() -> String! {
        return "US"
    }
    
    func setHomeCountry(_ countryCode: String!) {
        
    }
    
    func getServiceUrl(withLanguagePreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Void)!) {
        
    }
    
    func getServiceUrl(withLanguagePreference serviceId: String!, withCompletionHandler
        completionHandler: ((String?, Error?) -> Void)!, replacement: [AnyHashable : Any]!) {
        
    }
    
    func getServiceUrl(withCountryPreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Void)!) {
        
    }
    
    func getServiceUrl(withCountryPreference serviceId: String!,
                       withCompletionHandler completionHandler: ((String?, Error?) -> Void)!, replacement: [AnyHashable : Any]!) {
        
    }
    
    func getServicesWithLanguagePreference(_ serviceIds: [Any]!,
                                           withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Void)!) {
        
    }
    
    func getServicesWithLanguagePreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Void)!,
                                           replacement: [AnyHashable : Any]!) {
        
    }
    
    func getServicesWithCountryPreference(_ serviceIds: [Any]!, withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Void)!) {
        
    }
    
    func getServicesWithCountryPreference(_ serviceIds: [Any]!,
                                          withCompletionHandler completionHandler: (([String : AISDService]?, Error?) -> Void)!,
                                          replacement: [AnyHashable : Any]!) {
        if error != nil {
            completionHandler(nil, error)
        } else {
            if let serviceId = serviceIds.first as? String {
                if serviceId == "userreg.janrainoidc.issuer" {
                    service?.url = authorizationURL
                } else if serviceId == "userreg.janrainoidc.migration" {
                    service?.url = migrationURL
                } else if serviceId == "userreg.janrainoidc.userprofile" {
                    service?.url = userProfileURL
                } else if serviceId == "userreg.janrainoidc.marketingoptin" {
                    service?.url = marketingOptinURL
                } else {
                    service?.url = ""
                }
                
                guard let inService = service else {
                    completionHandler(nil, nil)
                    return
                }
                completionHandler([serviceId: inService], nil)
            }
        }
    }
    
    func getServiceLocale(withLanguagePreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Void)!) {
        
    }
    
    func getServiceLocale(withCountryPreference serviceId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Void)!) {
        
    }
    
    func applyURLParameters(_ URLString: String!, parameters map: [AnyHashable : Any]!) -> String! {
        return ""
    }
    
    func refresh(_ completionHandler: ((Error?) -> Void)!) {
        
    }
}
