/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation
import AppInfra

class ServiceDiscoveryMock: NSObject, AIServiceDiscoveryProtocol {
    var hybrisURL: String?
    var microserviceURL: String?
    var error: Error?
    var service = AISDService(url: "", andLocale: "en_US")
    var pilServiceIds: [Any]?
    var pilReplacementDict: [AnyHashable : Any]?
    
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
                 if serviceId == "iap.baseurl" {
                    service?.url = hybrisURL
                } else if serviceId.contains("ecs.") {
                    pilServiceIds = serviceIds
                    pilReplacementDict = replacement
                    service?.url = microserviceURL
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
    
    func refresh(_ completionHandler: ((Error?) -> Void)!) {
        
    }
    
    func applyURLParameters(_ URLString: String!, parameters map: [AnyHashable : Any]!) -> String! {
        return ""
    }
}
