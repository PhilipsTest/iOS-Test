//
//  AICloudLoggerRestClient.swift
//  AppInfra
//
//  Created by Philips on 5/22/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

@objc open class AICloudLoggerRestClient: NSObject {
    fileprivate let serviceId = "appinfra.cloudLogging"

    fileprivate var aiappinfra: AIAppInfraProtocol?
    fileprivate var apiSigning: AIAPISigningProtocol?
    
    
    //MARK: - init
    public init(appinfra: AIAppInfraProtocol, sharedKey:String?, secretKey:String? ) {
        
        self.aiappinfra = appinfra
        
        if let sharedKey = sharedKey , let secretKey = secretKey {
            self.apiSigning = AICloudApiSigner(apiSigner: sharedKey, andhexKey: secretKey)
        }
        super.init()
    }
    
    open func uploadLog(logData:Data,  success: (() -> Swift.Void)?, failure: ((Bool ,Error?) -> Swift.Void)? = nil)   {
        guard let aiappinfra = aiappinfra, let apisigner = self.apiSigning else { return }
        
        if aiappinfra.restClient.isInternetReachable() {
            
            let currentISOFormat = LogDateFormatter().string(from: aiappinfra.time.getUTCTime())
            
            var headers = ["SignedDate": currentISOFormat, "Accept": "application/json", "Content-Type": "application/json", "api-version": "1"]
            
            let signatureHeader = apisigner.clonableClient("", dhpUrl: "", queryString: "", headers: headers, requestBody: Data())

            headers["hsdp-api-signature"] = signatureHeader
            
            aiappinfra.serviceDiscovery.getServicesWithCountryPreference([serviceId], withCompletionHandler: {
                services, error in
                
                guard error == nil else {
                    failure?(true,error)
                    return
                }
                guard let aService = services?[self.serviceId] else {
                    failure?(true,error)
                    return
                }
                
                //var url = "https://logingestor2-int.us-east.philips-healthsuite.com/core/log/LogEvent"
                guard let url = aService.url else {
                    failure?(true,error)
                    return
                }
                
                var request: NSMutableURLRequest? = nil
                if let aString = URL(string: url) {
                    request = NSMutableURLRequest(url: aString)
                }
                request?.httpMethod = "POST"
                request?.allHTTPHeaderFields = headers
                request?.httpBody = logData
                
                guard let urlRequest = request?.mutableCopy() as? URLRequest else {
                    return
                }
                
                aiappinfra.restClient.dataTask(with: urlRequest, completionHandler: { (response, responseObject,  error) -> Void in
                    if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                        success?()
                    }
                    else if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                          failure?(false,error)
                    }
                    else{
                        failure?(true,error)
                    }
                }).resume()
                
            }, replacement: nil)
        }
        else{
            failure?(true,nil)
        }
    }
    
}
