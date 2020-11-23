//
//  PPRProductListResponse.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
/// Object of this class provides the list of registered products for signed in user. Object of this class is created internally and returned as a response of registered list call.
/// - Since: 1.0.0
@objc public class PPRProductListResponse: PRXResponseData {
    /// If the list is successfully obtained, this boolean property is set to true.
    /// - Since: 1.0.0
    @objc public private (set) var success: Bool
    /// This property provides the array of registered product i.e. **PPRRegisteredProduct**.
    /// - Since: 1.0.0
    @objc public private (set) var data : [PPRRegisteredProduct]!
    /// This property provides the last date when the list was successfully retrieved.
    /// - Since: 1.0.0
    @objc public private (set) var lastSyncDate: NSDate!

    
    class func productListResponseFrom(prxResponse: PRXProductListResponse, userUUID: String?) -> PPRProductListResponse
    {
        guard prxResponse.data != nil else {
            return PPRProductListResponse()
        }
        let resultArray = prxResponse.data
        let data = PPRProductListResponse.convertResultDataTo(data: resultArray, userUUID: userUUID)
        return PPRProductListResponse(data: data)
    }
    
    private override init() {
        self.success = false
        self.data = []
        self.lastSyncDate = nil
    }
    
    init(data: [PPRRegisteredProduct]!) {
        self.success = true
        self.data = data
        self.lastSyncDate = NSDate()
    }
    
    private class func convertResultDataTo(data:[PRXProductResultData]!, userUUID: String?) -> [PPRRegisteredProduct]! {
        guard !data.isEmpty else {
            return nil
        }
        var list = [PPRRegisteredProduct]()
        for result in data {
            let product = PPRRegisteredProduct(ctn: result.productModelNumber!, sector: DEFAULT, catalog: CATALOG_DEFAULT)
            product.purchaseDate = result.purchaseDate as Date?
            product.serialNumber = result.productSerialNumber
            product.error = nil
            product.endWarrantyDate = result.warrantyExpires as Date?
            product.userUuid = userUUID
            product.registeredLocale = PPRInterfaceInput.sharedInstance.getAppLocale()
            product.contractNumber = result.contractNumber
            product.registrationDate = result.purchaseDate as Date?
            
            list.append(product)
        }
        return list
    }
}
