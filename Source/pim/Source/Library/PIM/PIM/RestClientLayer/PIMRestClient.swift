/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppInfra

typealias PIMRestClientCompletionHandler = (URLResponse?, Any?, Error?) -> Void
typealias PIMLogoutCompletionHnadler     = (Data?, URLResponse?, Error?) -> Void

class PIMRestClient : NSObject, URLSessionDelegate {
    
    private var appInfraRestClient: AIRESTClientProtocol?
    private var redirectCompletionHandler:PIMRestClientCompletionHandler?
    
    init(_ restClientInterface: AIRESTClientProtocol) {
        appInfraRestClient = restClientInterface
    }
    
    func invokeRequest(_ interface: PIMRequestInterface, completionHandler: @escaping PIMRestClientCompletionHandler) {
        if let request = makerestClientRequest(interface) {
            appInfraRestClient?.dataTask(with: request) { (urlResponse, data, error) in
                completionHandler(urlResponse,data,error)
                }.resume()
        }
    }
    
    func invokeLogoutRequest(_ interface: PIMRequestInterface, completionHandler: @escaping PIMLogoutCompletionHnadler) {
        if var request = makerestClientRequest(interface) {
            let semaphore = DispatchSemaphore(value: 0)
            URLCache.shared.removeAllCachedResponses()
            request.cachePolicy = .reloadIgnoringCacheData
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                completionHandler(data, response, error)
                semaphore.signal()
                }.resume()
            semaphore.wait()
        }
    }
    
    func invokeRedirectRequest(_ interface: PIMRequestInterface, completionHandler: @escaping PIMRestClientCompletionHandler) {
        
        self.redirectCompletionHandler = completionHandler
        
        appInfraRestClient?.setTaskWillPerformHTTPRedirectionBlock { (session, task, response, request) in
            if (response as! HTTPURLResponse).statusCode == 302 {
                self.redirectCompletionHandler?(response,nil,nil)
                self.redirectCompletionHandler = nil
            }
            return request;
        }
        _ = appInfraRestClient?.get((interface.getURL()?.absoluteString)!, parameters: interface.getHeaderContent(), progress: nil, success: { task,object in
//            self.redirectCompletionHandler?(nil,nil,NSError())
        }, failure: { task,error in
            self.redirectCompletionHandler?(nil,nil,error)
        })
    }
    
    func makerestClientRequest(_ interface: PIMRequestInterface) -> URLRequest? {
        if let url = interface.getURL() {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod =  interface.getMethodType()
            urlRequest.allHTTPHeaderFields = interface.getHeaderContent()
            urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            urlRequest.httpBody = interface.getBodyContent()
            return urlRequest
        }
        return nil
    }
}

