//
//  PRXRegisterProductDataBuilder.swift
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

let PPRSerialNumber:String = "serialNumber"
let PPRPurchaseDate:String = "purchased"
let PPRRegistrationChannel:String = "registrationChannel"
let PPRReceiveMarketingEmail:String = "receiveMarketingEmail"
let PPRSendEmail:String = "sendEmail"
let PPRUserAccessToken:String = "x-accessToken"
let kCatalog:String = "CONSUMER"
let kSector:String = "B2C"
let kType: String = "productRegistration"

let PPRAPIKey: String = "Api-Key"
let PPRAPIVersion: String = "Api-Version"
let PPRAPIVersionValue: String = "1"
let PPRAuthorizationProvider:String = "Authorization-Provider"
let PPRAuthorization: String = "Authorization"
let PPRBearer: String = "Bearer"
let PPRContentType: String = "content-type"
let PPRAcceptType: String = "Accept"
let PPRContentFormat: String = "application/json"

class PRXRegisterProductRequest : PRXRequest {
    
    fileprivate (set) var serialNumber: String!
    fileprivate (set) var purchaseDate: Date!
    fileprivate (set) var accessToken: String!
    fileprivate (set) var micrositeID: String!
    fileprivate (set) var ctn: String!
    fileprivate (set) var catalog: Catalog!
    fileprivate (set) var sector: Sector!
    fileprivate var receiveMarketingEmail: Bool = {
        return false
    }()
    fileprivate var isSendingEmail: Bool = {
        return false
    }()
    fileprivate lazy var headerParamters: [AnyHashable: Any] = {
        return [AnyHashable: Any]()
    }()
    fileprivate lazy var bodyParameters: [AnyHashable: Any] = {
        return [AnyHashable: Any]()
    }()
    fileprivate lazy var usrDataInterface: UserDataInterface = {
        return PPRInterfaceInput.sharedInstance.appDependency.userDataInterface
    }()
    fileprivate var janrainToken: String? {
        do {
            let accessToken = try self.usrDataInterface.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN]
            return accessToken as? String
        }
        catch{
            return nil
        }
    }
    
    init(product:PPRProduct, accessToken _accessToken: String!, micrositeID: String!, receiveMarketingEmail: Bool!) {
        super.init(sector: product.sector, catalog: product.catalog, ctnNumber: product.ctn, serviceID: "prxclient.registeredProductsRequestOIDC")
        self.serialNumber = product.serialNumber
        self.purchaseDate = product.purchaseDate
        self.accessToken = _accessToken
        self.micrositeID = micrositeID
        self.isSendingEmail = product.sendEmail
        self.ctn = product.ctn
        self.receiveMarketingEmail = (receiveMarketingEmail != nil) ? receiveMarketingEmail : false
        self.sector = product.sector
        self.catalog = product.catalog
    }
    
    override func getRequestType() -> REQUESTTYPE {
        return POST
    }
    
    override func getHeaderParam() -> [AnyHashable: Any]! {
        self.headerParamters[PPRAPIVersion] = PPRAPIVersionValue
        self.headerParamters[PPRContentType] = PPRContentFormat
        self.headerParamters[PPRAcceptType] = PPRContentFormat
        if let legacyToken = self.janrainToken {
            self.headerParamters[PPRAuthorization] = PPRBearer + " " + legacyToken
        }
        if let apiKeyValue = getPRGConfig(PPRConfigurations.PPRApiKey, appinfra: PPRInterfaceInput.sharedInstance.appDependency.appInfra) {
            self.headerParamters[PPRAPIKey] = apiKeyValue
        }
        return self.headerParamters
    }
    
    override func getBodyParameters() -> [AnyHashable : Any]! {
        var attributeDict = [String: Any]()
        attributeDict["productId"] = self.ctn
        attributeDict["sector"] = kSector
        attributeDict["catalog"] = kCatalog
        attributeDict["locale"] = PPRInterfaceInput.sharedInstance.getAppLocale()
        attributeDict["micrositeId"] = self.micrositeID
        if let purchaseDate = self.purchaseDate?.stringDateWith("yyyy-MM-dd") {
            attributeDict[PPRPurchaseDate] = purchaseDate
        }
        if let serialNumber = self.serialNumber {
            attributeDict[PPRSerialNumber] = serialNumber
        }
        
        var userProfileDict = [String: Any]()
        userProfileDict["optIn"] = self.receiveMarketingEmail
        attributeDict["userProfile"] = userProfileDict
        
        var dataDict = [String: Any]()
        dataDict["type"] = kType
        dataDict["attributes"] = attributeDict
        
        var metaInfoDict = [String: Any]()
        metaInfoDict[PPRSendEmail] = "\(self.isSendingEmail)"
        
        self.bodyParameters["data"] = dataDict
        self.bodyParameters["meta"] = metaInfoDict
        
        return self.bodyParameters
    }
    
    override func getResponse(_ data: Any) -> PRXResponseData {
        return PRXRegisterProductResponse().parseResponse(data)!
    }
    
    //Remove once the serviceDiscovery updates the correct URL
    override public func getRequestUrl(from appInfra: AIAppInfraProtocol!, completionHandler: ((String?, Error?) -> Swift.Void)!) {
        if let serviceIdentifier = serviceID {
            var placeHolders = ["sector": PRXRequestEnums.string(with: getSector()), "catalog": PRXRequestEnums.string(with: getCatalog())]
            if self.ctn.length > 0 {
                placeHolders["ctn"] = self.ctn
            }
            
            appInfra.serviceDiscovery.getServicesWithCountryPreference([serviceIdentifier], withCompletionHandler: { (dictionary, sdError) in
                if let serviceURL:AISDService = dictionary?[serviceIdentifier] {
                    if serviceURL.url == nil{
                        let userInfo = [NSLocalizedDescriptionKey: "Service URL not found"]
                        let customError = NSError(domain: "PRXClient", code: PPRError.SERVICE_URL_NOT_PRESENT.rawValue, userInfo: userInfo)
                        completionHandler(nil, customError)
                        return
                    }
                    PPRInterfaceInput.sharedInstance.setAppLocale(with: serviceURL.locale)
                    
                    if ((serviceURL.url) != nil && serviceURL.url.range(of: PPRChinaBaseUrl) != nil) {
                        self.headerParamters[PPRAuthorizationProvider] = (self.usrDataInterface.isOIDCToken() == true) ? PPRProvider.PPRChinaOIDCProvider : PPRProvider.PPRChinaJanrainProvider
                    } else {
                        self.headerParamters[PPRAuthorizationProvider] = (self.usrDataInterface.isOIDCToken() == true) ? PPRProvider.PPRGlobalOIDCProvider : PPRProvider.PPRGlobalJanrainProvider
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

extension PRXRequest {
    func getPRGConfig(_ configKey: String, appinfra: AIAppInfra) -> String? {
        do {
            let configValue = try appinfra.appConfig.getPropertyForKey(configKey, group: PPRConfigurations.PPRGroup)
            return configValue as? String
        }catch{
            assertionFailure("Key is not set in AppCOnfig.json")
        }
        return ""
    }
}
