//
//  PRXProductListResponse.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient

class PRXProductListResponse: PRXResponseData {
    private (set) var stat: String?
    private (set) var resultCount: UInt = 0
    private (set) var data: [PRXProductResultData]?
    
     override func parseResponse(_ data: Any!) -> PRXProductListResponse? {
        if PPRUtils.isDictionary(dictionary: data as AnyObject?) {
            let obj : PRXProductListResponse = PRXProductListResponse(withDictonary: (data as? NSDictionary)!)!
            return obj
        }
        return self
    }
    
    override init() {
        self.resultCount = 0
        super.init()
    }
    
    required init?(withDictonary dict: NSDictionary) {
        if PPRUtils.isDictionary(dictionary: dict) {
            if let results = PPRUtils.objectOrNSNull(object: dict["productRegistrations"] as AnyObject?) {
                let resultsArray = results as! NSArray
                self.resultCount = UInt(resultsArray.count)
                if PPRUtils.isArray(array: resultsArray) && resultsArray.count > 0 {
                    var productList = [PRXProductResultData]()
                    for result in resultsArray {
                        if PPRUtils.isDictionary(dictionary: result as AnyObject?) {
                            let productListData = PRXProductResultData.modelObjectWithDictionary(result as! NSDictionary)
                            productList.append(productListData)
                        }
                    }
                    self.data = productList
                }
            }

        }
    }
}
