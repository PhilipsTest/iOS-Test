/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra

class ServiceDiscoveryMock: NSObject, AIServiceDiscoveryProtocol {
    
    var serviceURL: String?
    var serviceKey: String?
    var serviceError: Error?
    var serviceObject = AISDService(url: "", andLocale: "en_US")
    
    
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
        
        serviceObject?.url = serviceURL
        
        if let serviceId = serviceIds.first as? String, let service = serviceObject {
            serviceKey = serviceId
            completionHandler([serviceId: service], serviceError)
        } else {
            serviceKey = nil
            completionHandler(nil, nil)
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

