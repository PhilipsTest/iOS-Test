/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOrderInfoTests: XCTestCase {
    
    func testInit(){
        let dict = self.deserializeData("OrderInfoSampleResponse")
        let orderInfo = IAPOrderInfo(inDict: dict!)
        
        let orderId = orderInfo.getOrderId()
        XCTAssertNotNil(orderId)
        
        let address = orderInfo.getAddress()
        XCTAssertNotNil(address)
    }
}
