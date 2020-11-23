//
//  PRXProductMetaDataBuilder.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
import AppInfra

class PRXProductMetaDataRequest : PRXRequest{
    
    private (set) var product: PPRProduct!
    
    public var baseUrlString: String!
    
    init(product:PPRProduct) {
        self.product = product
        super.init(sector: product.sector, catalog: product.catalog, ctnNumber: product.ctn, serviceID: "prxclient.productmetadatarequest")
    }
    
    override func getRequestType() -> REQUESTTYPE {
        return GET
    }

    override func getHeaderParam() -> [AnyHashable : Any]! {
        return nil
    }

    override func getBodyParameters() -> [AnyHashable : Any]! {
        return nil
    }
    
    override func getResponse(_ data: Any!) -> PRXResponseData! {
        return PRXProductMetaDataResponse().parseResponse(data)
    }
    
    //Remove once the serviceDiscovery updates the correct URL
    override public func getRequestUrl(from appInfra: AIAppInfraProtocol!, completionHandler: ((String?, Error?) -> Swift.Void)!) {
        if let serviceIdentifier = serviceID {
            var placeHolders = ["sector": PRXRequestEnums.string(with: getSector()), "catalog": PRXRequestEnums.string(with: getCatalog())]
            if self.product.ctn.length > 0 {
                placeHolders["ctn"] = self.product.ctn
            }
            appInfra.serviceDiscovery.getServicesWithCountryPreference([serviceIdentifier], withCompletionHandler: { (dictionary, sdError) in
                if let serviceURL:AISDService = dictionary?[serviceIdentifier] {
                    if serviceURL.url == nil{
                        let userInfo = [NSLocalizedDescriptionKey: "Service URL not found"]
                        let customError = NSError(domain: "PRXClient", code: PPRError.SERVICE_URL_NOT_PRESENT.rawValue, userInfo: userInfo)
                        completionHandler(nil, customError)
                        return
                    }
                    let serviceUpdatedURL = serviceURL.url?.replacingOccurrences(of: "/prx/product/", with: "/prx/registration/")
                    
                    completionHandler(serviceUpdatedURL, sdError)
                }else{
                    let userInfo = [NSLocalizedDescriptionKey: "Service URL not found"]
                    let customError = NSError(domain: "PRXClient", code: PPRError.SERVICE_URL_NOT_PRESENT.rawValue, userInfo: userInfo)
                    completionHandler(nil, customError)
                }
            }, replacement: placeHolders as Any as? [AnyHashable : Any])
        }
    }
}
