/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsPRXClient

class PRXRequestManagerMock: PRXRequestManager {
    var response: PRXResponseData!
    var assetResponse: PRXResponseData!
    var disclaimerResponse: PRXResponseData!
    var error: NSError!
    
    override func execute(_ request: PRXRequest!,
                          completion success: ((PRXResponseData?) -> Swift.Void)!,
                          failure: ((Error?) -> Swift.Void)!) {
        
        if (request as? PRXAssetRequest) != nil {
            if assetResponse != nil {
                success(self.assetResponse)
            } else {
                failure(error)
            }
            return
        } else if (request as? PRXDisclaimerRequest) != nil {
            if disclaimerResponse != nil {
                success(self.disclaimerResponse)
            } else {
                failure(error)
            }
            return
        } else if (request as? PRXSummaryListRequest) != nil {
            if response != nil {
                success(self.response)
            } else {
                failure(error)
            }
        }
    }
}

class ECSUtilityMock {
    static var requestManager: PRXRequestManagerMock?
    
    @objc dynamic class func getRequestManager() -> PRXRequestManagerMock? {
        return ECSUtilityMock.requestManager
    }
}

