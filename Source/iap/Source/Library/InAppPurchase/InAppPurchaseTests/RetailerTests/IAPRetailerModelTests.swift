/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import InAppPurchaseDev

class IAPRetailerModelTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
    }
    
    override class func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testModelCreation() {
        let dictionary   = self.deserializeData("IAPRetailerSampleResponse")
        let retailers = IAPRetailerModelCollection(inDict: dictionary!)
        XCTAssert(retailers.getRetailers().count != 0, "Product models are not created")
        XCTAssert(retailers.getRetailers().count > 0, "Product models count isn't right")
    }

}

