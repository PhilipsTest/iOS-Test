//
//  PRXProductListDataBuilder.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
import PlatformInterfaces

class PRXProductListDataRequest:PRXRequest{
    fileprivate (set) var user: UserDataInterface?
    fileprivate lazy var headerParameters: [AnyHashable: Any] = {
        return [AnyHashable: Any]()
    }()
    fileprivate var janrainToken: String? {
        do {
            let accessToken = try self.user?.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN]
            return accessToken as? String
        }
        catch{
            return nil
        }
    }
    
    init(user _user: UserDataInterface){
        super.init(sector: B2C, catalog: CONSUMER, ctnNumber: nil, serviceID: "prxclient.registeredProductsRequestOIDC")
        user = _user
    }
    
    override func getHeaderParam() -> [AnyHashable: Any]! {
        if let token = self.janrainToken {
            self.headerParameters[PPRAuthorization] = PPRBearer + " " + token
        }
        if let apiKeyValue = getPRGConfig(PPRConfigurations.PPRApiKey, appinfra: PPRInterfaceInput.sharedInstance.appDependency.appInfra) {
            self.headerParameters[PPRAPIKey] = apiKeyValue
        }
        self.headerParameters[PPRAPIVersion] = PPRAPIVersionValue
        self.headerParameters[PPRContentType] = PPRContentFormat
        self.headerParameters[PPRAcceptType] = PPRContentFormat
        
        return self.headerParameters as [NSObject : AnyObject]
    }
    
    override func getBodyParameters() -> [AnyHashable : Any]! {
        return nil
    }
    
    override func getRequestType() -> REQUESTTYPE {
        return GET;
    }
    
    override func getResponse(_ data: Any!) -> PRXResponseData! {
        return PRXProductListResponse().parseResponse(data)
    }
    
    //Remove once the serviceDiscovery updates the correct URL
    override public func getRequestUrl(from appInfra: AIAppInfraProtocol!, completionHandler: ((String?, Error?) -> Swift.Void)!) {
        if let serviceIdentifier = serviceID {
            let placeHolders = ["sector": PRXRequestEnums.string(with: getSector()), "catalog": PRXRequestEnums.string(with: getCatalog())]
            appInfra.serviceDiscovery.getServicesWithCountryPreference([serviceIdentifier], withCompletionHandler: { (dictionary, sdError) in
                if let serviceURL:AISDService = dictionary?[serviceIdentifier] {
                    if serviceURL.url == nil{
                        let userInfo = [NSLocalizedDescriptionKey: "Service URL not found"]
                        let customError = NSError(domain: "PRXClient", code: PPRError.SERVICE_URL_NOT_PRESENT.rawValue, userInfo: userInfo)
                        completionHandler(nil, customError)
                        return
                    }
                    
                    if ((serviceURL.url) != nil && serviceURL.url.range(of: PPRChinaBaseUrl) != nil) {
                        self.headerParameters[PPRAuthorizationProvider] = (self.user?.isOIDCToken() == true) ? PPRProvider.PPRChinaOIDCProvider : PPRProvider.PPRChinaJanrainProvider
                    } else {
                        self.headerParameters[PPRAuthorizationProvider] = (self.user?.isOIDCToken() == true) ? PPRProvider.PPRGlobalOIDCProvider : PPRProvider.PPRGlobalJanrainProvider
                    }
                    
                    completionHandler(serviceURL.url, sdError)
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Service URL not found"]
                    let customError = NSError(domain: "PRXClient", code: PPRError.SERVICE_URL_NOT_PRESENT.rawValue, userInfo: userInfo)
                    completionHandler(nil, customError)
                }
            }, replacement: placeHolders as Any as? [AnyHashable : Any])
        }
    }
}
