/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPRetailerURLBuilderTests: XCTestCase {
    
    let productCode = "HX8071/10"
    let locale = "en_US"
    
    func testGetWhereToBuyRetailerURL(){
        let builder = IAPRetailerURLBuilder(inProductCode: self.productCode, inLocale: self.locale)
        XCTAssertNotNil(builder, "IAPRetailerURLBuilder was not initialised")
        XCTAssertEqual(self.getURL(), builder.getWhereToBuyRetailerURL())
    }
    
    func testGetHostPort(){
        let builder = IAPRetailerURLBuilder(inProductCode: self.productCode, inLocale: self.locale)
        XCTAssertNotNil(builder, "IAPRetailerURLBuilder was not initialised")
        XCTAssertEqual(self.getHostPort(), builder.getHostPort())
    }
    
    func getURL() -> String{
        return "https://www.philips.com/api/wtb/v1/B2C/" + self.locale + "/online-retailers?product=" + self.productCode
    }
    
    func getHostPort() -> String{
        return "www.philips.com"
    }
    
}
