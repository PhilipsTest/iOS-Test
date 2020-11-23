/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPMakePaymentInfoTests: XCTestCase {
    
   func testMakePaymentInfo() {
        let urlDict:[String:AnyObject] = ["worldpayUrl":"http://xyz.com" as AnyObject]
        let urlInfo = IAPMakePaymentInfo(inDict: urlDict)
        XCTAssertNotNil(urlInfo)
        XCTAssertNotNil(urlInfo.getWorldPayURL())
    }
    
}
