//
//  PRXProductMetaDataResponse.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient

class PRXProductMetaDataResponse : PRXResponseData {
    private (set) var success: Bool = false
    private (set) var data : PRXProductMetaDataInfoData?
    
     override func parseResponse(_ data: Any!) -> PRXProductMetaDataResponse? {
        if PPRUtils.isDictionary(dictionary: data as AnyObject?) {
            let obj : PRXProductMetaDataResponse = PRXProductMetaDataResponse(withDictonary: (data as? NSDictionary)!)!
            return obj
        }
        return self
    }
    
    override init() {
        self.success = false
        super.init()
    }
    
    required init?(withDictonary dict:NSDictionary) {
        if PPRUtils.isDictionary(dictionary: dict) {
            if let success = PPRUtils.objectOrNSNull(object: dict[kPRXAssetBaseClassSuccess] as AnyObject?) {
                self.success = success.boolValue
            }
            if let data = PPRUtils.objectOrNSNull(object: dict[kPRXAssetBaseClassData] as AnyObject?) {
                if PPRUtils.isDictionary(dictionary: data) {
                    self.data = PRXProductMetaDataInfoData.modelObjectWithDictionary(dict: data as! NSDictionary)
                }
            }
        }
    }
}
