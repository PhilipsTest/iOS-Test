//
//  PRXProductSummaryDataRequest.swift
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

class PRXProductSummaryDataRequest : PRXRequest{
    private (set) var ctn:String!
    
    private (set) var product: PPRProduct!
    
    init(product:PPRProduct) {
        self.product = product
        super.init(sector: product.sector, catalog: product.catalog, ctnNumber: product.ctn, serviceID: "prxclient.summary")
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
        return PRXProductSummaryDataResponse().parseResponse(data)
    }
}
