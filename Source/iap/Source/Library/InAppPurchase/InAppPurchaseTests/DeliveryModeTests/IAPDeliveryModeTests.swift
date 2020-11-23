/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPDeliveryModeTests: XCTestCase {
    
    func testModelInitialisztion() {
        let dictionary = self.deserializeData("IAPDeliveryModes")
        let deliveryModes = IAPDeliveryModeDetails(inDict: dictionary!)
        
        XCTAssertNotNil(deliveryModes, "Delivery modes Model is not initialised")
        XCTAssert(deliveryModes.deliveryModeDetails.count > 0, "The collection is empty")
        
        let deliveryMode = deliveryModes.deliveryModeDetails.first!
        XCTAssertNotNil(deliveryMode.getdeliveryCodeType(), "Code type returned is nil")
        XCTAssertNotNil(deliveryMode.getdeliveryCost(), "Cost returned is nil")
        XCTAssertNotNil(deliveryMode.getdeliveryModeName(), "Name returned is nil")
        XCTAssertNotNil(deliveryMode.getDeliveryModeDescription(), "Description returned is nil")
        XCTAssertEqual(deliveryMode, deliveryMode)
        
        let objects = IAPDeliveryModeDetails(inDict: dictionary!)
        let object  = objects.deliveryModeDetails.first!
        object.deliveryModeName = "Sample"
        XCTAssertNotEqual(object, deliveryMode)
    }
}
