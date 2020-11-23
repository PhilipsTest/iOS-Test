//
//  AppAuthSwizzle.swift
//  PIMTests
//
//  Created by Philips on 4/2/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import UIKit
import Foundation
import AppAuth

extension OIDAuthorizationService {
    
    class func loadSwizzler() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(discoverConfiguration(forIssuer:completion:)))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(discoveryConfigTest(forIssuer:completion:)))!
        method_exchangeImplementations(originalMethod, extendedMethod)
    }
    
    class func deSwizzle() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(discoveryConfigTest(forIssuer:completion:)))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(discoverConfiguration(forIssuer:completion:)))!
        method_exchangeImplementations(originalMethod, extendedMethod)
    }
    
    @objc class func discoveryConfigTest(forIssuer:URL, completion:OIDDiscoveryCallback){
        var oidServiceConfig:OIDServiceConfiguration;
        
        //Success with blank discovery document
        if forIssuer.absoluteString == "https://www.philips.com" {
            oidServiceConfig = OIDServiceConfiguration(authorizationEndpoint:forIssuer, tokenEndpoint: forIssuer, issuer: forIssuer)
            completion(oidServiceConfig,nil)
            return
        }
        //Success with discovery document and blank authorization endpoint
        if forIssuer.absoluteString == "https://www.philips.com/pim" {
            
            var dict = [String:String]()
            dict["revokeEndpoint"] = "http://google.com"
            do {
                let oidcDictionary = try OIDServiceDiscovery(dictionary: dict)
                oidServiceConfig = OIDServiceConfiguration(discoveryDocument: oidcDictionary)
                completion(oidServiceConfig,nil)
            } catch{
                completion(nil,error)
            }
            return
        }
        //Success with discovery document and issuer
            var oidcDict = [String:String]()
            oidcDict["issuer"] = "https://www.philips.com/pim"
            oidcDict["authorization_endpoint"] = "https://www.philips.com/pim"
            oidcDict["token_endpoint"] = "https://www.philips.com/pim"
            oidcDict["jwks_uri"] = "pim"
            oidcDict["response_types_supported"] = "pim"
            oidcDict["subject_types_supported"] = "pim"
            oidcDict["id_token_signing_alg_values_supported"] = "pim"
            do {
                let oidcDictionary = try OIDServiceDiscovery(dictionary: oidcDict)
                oidServiceConfig = OIDServiceConfiguration(discoveryDocument: oidcDictionary)
                completion(oidServiceConfig,nil)
            } catch{
                completion(nil,error)
            }
    }
}
