//
//  PRXRequestManagerMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
@testable import PhilipsProductRegistrationDev

class PRXRequestManagerMock: PRXRequestManager {
    var response: PRXResponseData!
    var error: NSError!
    
    override func execute(_ request: PRXRequest!,
                          completion success: ((PRXResponseData?) -> Swift.Void)!,
                                     failure: ((Error?) -> Swift.Void)!) {
        if let error = self.error {
            failure(error)
        } else {
            success(self.response)
        }
    }
    
    class func mockMetadataResponse(_ isSerialNumRequired: Bool,isPurchasedataReuired: Bool) -> PRXRequestManagerMock {
        let mock = PRXRequestManagerMock()
        let dict = PPRProductMetaDataJSONObject().fakeValidResponse(with: isPurchasedataReuired, isSerialNumberRequired: isSerialNumRequired)
        mock.response = PRXProductMetaDataResponse(withDictonary: dict as NSDictionary)
        return mock
    }
    
    class func mockResponse(_ response: PRXResponseData) -> PRXRequestManagerMock {
        let mock = PRXRequestManagerMock()
        mock.response = response
        return mock
    }

    
    class func mockError(_ error: NSError) -> PRXRequestManagerMock {
        let mock = PRXRequestManagerMock()
        mock.error = error
        return mock
    }
}
