/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import Foundation

class HttpConnection {
    var http: HTTP?
    
    fileprivate let requestQueue: DispatchQueue
    fileprivate let responseQueue: DispatchQueue
    
    init () {
        self.requestQueue = DispatchQueue(label: "IAPRequestQueue", attributes: [])
        self.responseQueue = DispatchQueue.main
        self.http = HTTP()
    }

    func performRequestAsynchronously (_ url: String, method: String,
                                       httpHeaders: [String: String]?,
                                       bodyParameters: [String: String]?,
                                       success: @escaping ([String: AnyObject]) -> (),
                                       failure: @escaping (NSError) -> ()) {
        let environmentData = ProcessInfo.processInfo.environment
        if environmentData["APIMock"] == "1" {
            success(IAPMockingHelper.getReponseForURL(methodName: method, url: url))
        } else {
            self.requestQueue.async(execute: {
                let request = HttpRequest(httMethod: method, url: url, httpHeaders: httpHeaders, bodyParameters:bodyParameters)
                let requestCURL = self.convertURLRequestToString(httMethod: method,
                                                                 url: url,
                                                                 httpHeaders: httpHeaders,
                                                                 bodyParameters: bodyParameters)
                IAPConfiguration.sharedInstance.iapAppLogging?.log(.debug, eventId: "IAP", message:requestCURL)
                let response: HTTPResponse = self.http!.request(request)
                self.responseQueue.async(execute: {
                    if response.error != nil {
                        failure(response.error!)
                    } else {
                        success(response.body ?? [:])
                    }
                })
            })
        }
    }
    
    func convertURLRequestToString(httMethod: String,
                                   url: String,
                                   httpHeaders: [String: String]?,
                                   bodyParameters: [String: String]?) -> String {
        var curlCommandString = String(format: "curl -v -X %@ ", httMethod)
        curlCommandString.append(String(format: "\'%@\' ", url))
        httpHeaders?.forEach({ (key: String, value: String) in
            curlCommandString.append(String(format:"-H \'%@: %@\' ", key, value))
        })
        
        if (bodyParameters != nil ) {
            curlCommandString.append("-d \'")
            bodyParameters?.forEach({(key: String, value: String) in
                curlCommandString.append(String(format:"%@=%@&", key, value))
            })
            curlCommandString = String(curlCommandString.dropLast())
            curlCommandString.append("'")
        }
        return curlCommandString
    }
}
