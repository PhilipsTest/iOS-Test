/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
@testable import AppInfra

class IAPConfigurationTests: XCTestCase {
    
    func testSetters(){
        
        let config = IAPConfiguration()
        config.setSiteIdentifier("siteID")
        XCTAssert(config.siteID == "siteID" , "siteID not set")

        config.setOauth(IAPOAuthInfo())
        XCTAssertNotNil(config.oauthInfo)
        
        config.logoutSessionSuccess()
        XCTAssertNil(config.oauthInfo)
    }
}
