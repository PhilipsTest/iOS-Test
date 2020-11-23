/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

let HTTPTIMEOUT = TimeInterval(30)

class HttpRequest {
    var method: String?
    var url: String?
    var httpHeaders: [String: AnyObject]?
    var bodyParameters: [String: String]?
    
    init(httMethod: String, url: String,
         httpHeaders: [String: String]?,
         bodyParameters: [String: String]?) {
        self.method = httMethod
        self.url = url
        
        if let parameters = httpHeaders {
            self.httpHeaders = parameters as [String: AnyObject]?
        }
        
        if let parameters = bodyParameters {
            self.bodyParameters = parameters
        }
    }
    
    internal func urlRequest () -> NSMutableURLRequest {
        let result = NSMutableURLRequest(url: URL(string: self.url!)!)
        result.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        result.setValue("application/json", forHTTPHeaderField: "Accept")
        result.timeoutInterval = HTTPTIMEOUT
        result.httpMethod = self.method!
        if let parameters = self.bodyParameters {
            result.setBodyContent(parameters)
        }

        if let parameters = self.httpHeaders {
            for (headerField, value) in parameters {
                result.setValue(value as? String, forHTTPHeaderField: headerField)
            }
        }
        return result
    }
}

class HTTPResponse {
    var code: Int?
    var body: Dictionary <String, AnyObject>?
    var error: NSError?
    init () {
    }
}

class HTTP: NSObject, URLSessionDelegate {
    func request(_ request: HttpRequest) -> HTTPResponse {
        let urlRequest: NSMutableURLRequest = request.urlRequest()
        if let headers = request.httpHeaders, nil != headers[IAPConstants.IAPOAuthParameterKeys.kAuthorisationKey] {
            //IAPConfiguration.sharedInstance.sharedAppInfra?.logging.log(.info, eventId: "IAPHTTP", message: "\n\n *** Token used: \(token) \n\n")
        }
        return self.requestSynchronousData(urlRequest as URLRequest)
    }
    
    fileprivate func requestSynchronousData(_ request: URLRequest) -> HTTPResponse {
        let httpResponse = HTTPResponse()
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let session = Foundation.URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request, completionHandler: {
            taskData, response, error -> () in
            if error != nil {
                httpResponse.error = error as NSError?
            } else if let castedResponse = response as? HTTPURLResponse {
                let bodyDict = self.deserializeData(taskData!) ?? [:]
                if IAPConstants.IAPHTTPStatusKeys.kHTTPSuccessCode == castedResponse.statusCode || IAPConstants.IAPHTTPStatusKeys.kHTTPCreationSuccessCode == castedResponse.statusCode {
                    httpResponse.body = bodyDict
                } else {
                    let (errorMessage) = self.getErrorResponse(bodyDict)
                    if let value = bodyDict["error"] as? String, value == "invalid_grant" {
                        let userInfo = ["Error_Info_Dict":
                                        ["errors": [["type": "InvalidGrantError"]]]]
                        httpResponse.error = NSError(domain: IAPLocalizedString("iap_something_went_wrong")!,
                                                     code: castedResponse.statusCode, userInfo: userInfo)
                    } else if let message = errorMessage {
                        httpResponse.error = NSError(domain: message, code: castedResponse.statusCode,
                                                     userInfo:
                            [NSLocalizedDescriptionKey: message, IAPConstants.IAPHTTPErrorResponseCode.kErrorDictionaryKey:bodyDict])
                    } else {
                        httpResponse.error = NSError(domain: IAPLocalizedString("iap_something_went_wrong")!,
                                                     code: castedResponse.statusCode, userInfo: nil)
                    }
                }
            }
            semaphore.signal();
        })
        task.resume()
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return httpResponse
    }

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if IAPOAuthConfigurationData.isDataLoadedFromHybris() {
                    if IAPBaseURLBuilder().getHostPort().contains(challenge.protectionSpace.host) ||
                        challenge.protectionSpace.host.contains(IAPRetailerURLBuilder().getHostPort()) {
                        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,
                                          URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    }
                } else {
                    if challenge.protectionSpace.host.contains(IAPRetailerURLBuilder().getHostPort()) {
                        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,
                                          URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    }
                }
            }
    }

    fileprivate func getErrorResponse(_ responseDict: [String: AnyObject])-> String? {
        var errorMessage: String?
        if  let errorArray = responseDict[IAPConstants.IAPHTTPErrorKeys.kErrorsKey] as? [[String: String]] {
            if let error = errorArray.first {
                errorMessage = error[IAPConstants.IAPHTTPErrorKeys.kErrorMessageKey]
            }
        }
        return errorMessage
    }

    fileprivate func deserializeData(_ data: Data) -> [String: AnyObject]? {
        var jsonDict: [String: AnyObject]? = [:]
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
        } catch _ as NSError {
            //IAPConfiguration.sharedInstance.sharedAppInfra?.logging.log(.error, eventId: "IAPHTTP",
            //message: "*** Error: \(#file)->\(#function)->\(#line): \(error)")
        }
        return jsonDict
    }
}

extension NSMutableURLRequest {
    func setBodyContent(_ contentMap: [String: String]?) {
        if let content = contentMap {
            var firstOneAdded = false
            var contentBodyAsString = String()
            let contentKeys: [String] = Array(content.keys)
            for contentKey in contentKeys {
                if !firstOneAdded {
                    contentBodyAsString += contentKey + "=" + content[contentKey]!
                    firstOneAdded = true
                } else {
                    contentBodyAsString += "&" + contentKey + "=" + content[contentKey]!
                }
            }
            contentBodyAsString = contentBodyAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            self.httpBody = contentBodyAsString.data(using: String.Encoding.utf8)
        }
    }
}
