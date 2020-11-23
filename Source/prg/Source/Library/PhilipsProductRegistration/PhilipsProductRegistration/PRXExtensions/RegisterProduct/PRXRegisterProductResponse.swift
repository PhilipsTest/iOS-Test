//
//  PRXRegisterProductResponse.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient

class PRXRegisterProductResponse : PRXResponseData{
   private (set) var success: Bool = false
   private (set) var data : PRXRegisterProductInfoData?
    
     override func parseResponse(_ data: Any!) -> PRXRegisterProductResponse? {
        if PPRUtils.isDictionary(dictionary: data as AnyObject?) {
            let obj : PRXRegisterProductResponse = PRXRegisterProductResponse(withDictonary: (data as? NSDictionary)!)!
            return obj
        }
        return self
    }
    
    override init() {
        super.init()
    }
    
    required init?(withDictonary dict:NSDictionary) {
        if PPRUtils.isDictionary(dictionary: dict) {
            if let _ = PPRUtils.objectOrNSNull(object: dict["errors"] as AnyObject?) {
                self.success = false
            }
            if let data = PPRUtils.objectOrNSNull(object: dict[kPRXAssetBaseClassData] as AnyObject?) {
                self.success = true
                if PPRUtils.isDictionary(dictionary: data) {
                    self.data = PRXRegisterProductInfoData.modelObjectWithDictionary(data as! NSDictionary)
                }
            }
        }
    }
}
