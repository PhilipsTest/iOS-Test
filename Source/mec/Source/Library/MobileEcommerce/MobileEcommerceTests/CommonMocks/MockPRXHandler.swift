/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import MobileEcommerceDev
import PhilipsPRXClient

class MockPRXHandler: MECPRXHandler {
    
    var mockProductSpecifications: PRXSpecificationsResponse?
    var mockProductFeatures: PRXFeaturesResponse?
    var mockCDLSDetails: PRXCDLSResponse?
    
    override func fetchCDLSDetailfor(category: String, requestManager: PRXRequestManager?, completionHandler: @escaping (PRXCDLSResponse?) -> Void) {
        completionHandler(mockCDLSDetails)
    }
    
    override func fetchProductSpecsFor(CTN: String, requestManager: PRXRequestManager?, completionHandler: @escaping (_ productSpecs: PRXSpecificationsResponse?) -> Void) {
        completionHandler(mockProductSpecifications)
    }
    
    override func fetchProductFeaturesFor(CTN: String, requestManager: PRXRequestManager?, completionHandler: @escaping (PRXFeaturesResponse?) -> Void) {
        completionHandler(mockProductFeatures)
    }
}

class MockPRXRequestManager: PRXRequestManager {
    var prxResponse: PRXResponseData?
    var prxError: NSError?
    fileprivate(set) var prxRequest: PRXRequest!
    
    override func execute(_ request: PRXRequest!, completion success: ((PRXResponseData?) -> Void)!, failure: ((Error?) -> Void)!) {
        prxRequest = request
        if prxResponse != nil {
            success(prxResponse)
        } else if prxError != nil {
            failure(prxError)
        } else {
            success(nil)
        }
    }
}
