/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOAuthInfoTest: XCTestCase {

   func testOAuthModel() {
        let aToken = "ed39cfa6-e517-4a67-9778-8866b7007587"
        let rToken = "f90b2456-4c29-493d-9f74-2037ae513dfa"
        var accessToken = aToken
        var refreshToken = rToken
        let tokenDictionary = ["access_token": accessToken, "refresh_token": refreshToken,
                               "token_type": "bearer", "expires_in": "43199"]
    let modelInfo = IAPOAuthInfo(inDictionary: tokenDictionary as [String: AnyObject])

        XCTAssertNotNil(modelInfo)
        XCTAssertNotNil(modelInfo.tokenType)
        XCTAssertNotNil(modelInfo.refreshToken)
        XCTAssertNotNil(modelInfo.accessToken)
        XCTAssert(0 != modelInfo.accessToken?.length, "Token length is 0")
        XCTAssert(0 != modelInfo.refreshToken?.length, "Refresh token length is 0")
        XCTAssert(0 != modelInfo.tokenType?.length, "Token type length is not 0")
        XCTAssert(modelInfo.accessToken == accessToken, "Token values don't match")
        XCTAssert(modelInfo.refreshToken == refreshToken, "Refresh token values don't match")
        
        let accessDict = modelInfo.getOAuthDictionary()
        accessToken = accessDict["access_token"] as? String ?? ""
        refreshToken = accessDict["refresh_token"] as? String ?? ""
        XCTAssert(refreshToken.length == rToken.length, "Refresh token returned is not same")
        XCTAssert(accessToken.length == aToken.length, "Access token returned is not same")
    }
    
    func testParameterDictCreation() {
        var dict = IAPOAuthInfo.httpHeadersParameterDictForOCCRequest()
        XCTAssertNotNil(dict, "Dictionary returned is nil")
        
        IAPConfiguration.sharedInstance.oauthInfo = nil
        dict = IAPOAuthInfo.httpHeadersParameterDictForOCCRequest()
        XCTAssertNil(dict, "Dictionary returned is not nil")
    }
    
    func testEncodingAndDeCoding() {
        let accessToken = "ed39cfa6-e517-4a67-9778-8866b7007587"
        let refreshToken = "f90b2456-4c29-493d-9f74-2037ae513dfa"
        let tokenDictionary = ["access_token": accessToken, "refresh_token": refreshToken,
                               "token_type": "bearer", "expires_in": "43199"]
        let modelInfo = IAPOAuthInfo(inDictionary: tokenDictionary as [String: AnyObject])
        let path = NSTemporaryDirectory() as String
        let locToSave = path + "/" + "teststasks"
        
        NSKeyedArchiver.archiveRootObject([modelInfo], toFile: locToSave)
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? [IAPOAuthInfo]
        XCTAssertNotNil(data, "Unarchived data is nil")
        XCTAssert(data!.first?.accessToken == modelInfo.accessToken, "Values returned is not right")
        XCTAssert(data!.first?.refreshToken == modelInfo.refreshToken, "Values returned is not right")
    }

}
