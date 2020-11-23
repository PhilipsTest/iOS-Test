//
//  PRXRequestManagerWrapper.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient

enum REQUEST_TYPE {
    case NOREQUEST
    case METADATA
    case REGISTER_PRODUCT
    case PRODUCT_SUMMARY
    case REGISTERED_PRODUCT_LIST
}

class PRXRequestManagerWrapper: NSObject {
    lazy var requestManager: PRXRequestManager = {
        var dependencies = PRXDependencies(appInfra: PPRInterfaceInput.sharedInstance.appDependency.appInfra, parentTLA: "prg")
        let requestManager = PRXRequestManager(dependencies: dependencies)
        
        return  requestManager!
    }()
    private lazy var errorHelper: PPRErrorHelper = {
        return PPRErrorHelper()
    }()
    var requestType: REQUEST_TYPE
    
    override init() {
        self.requestType = REQUEST_TYPE.NOREQUEST
    }
    
    func execute(_ request: PRXRequest!, success: ((PRXResponseData?) -> Void)!, failure: @escaping PPRFailure) {
        
        if requestType == REQUEST_TYPE.REGISTER_PRODUCT {
            request.getRequestUrl(from: PPRInterfaceInput.sharedInstance.appDependency.appInfra) { (urlString, error) in
                guard let serviceUrl = urlString else { return }
                let registerURL = URL(string: serviceUrl)
                var restRequest = URLRequest(url: registerURL!)
                restRequest.httpMethod = PRXRequestEnums.string(withRequest: request.getRequestType())
                restRequest.allHTTPHeaderFields = request.getHeaderParam() as? [String : String]
                let httpBodyContent: [AnyHashable: Any] = request.getBodyParameters()
                let jsonData = try? JSONSerialization.data(withJSONObject: httpBodyContent)
                restRequest.httpBody = jsonData
                
                let session = URLSession.shared
                session.dataTask(with: restRequest) { (data, response, error) in
                    if let receivedError = error {
                        DispatchQueue.main.async {
                            self.errorHelper.handleError(statusCode: receivedError._code, failure: failure)
                        }
                    }
                    if let receivedData = data {
                        DispatchQueue.main.async {
                            success(request.getResponse(receivedData))
                        }
                    }
                }.resume()
            }
        } else {
            self.requestManager.execute(request, completion: success)
            {
                (error) -> Void in
                var errCode = PPRError.UNKNOWN.rawValue
                if let code = error?._code{
                    errCode = code
                }
                self.errorHelper.handleError(statusCode: errCode, failure: failure)
            }
        }
        
        
    }
}
