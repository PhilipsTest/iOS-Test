/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPCartCreatedHelperTests: XCTestCase {

    func testCartCreatedStateHelper() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateHelperToTest: IAPCartCreatedStateHelper = IAPCartCreatedStateHelper { (inValue) in
            XCTAssert(inValue, "Value returned is not correct")
        }
        
        cartStateHelperToTest.iapCartHelper = noCartStateSyncHelper
        cartStateHelperToTest.setAddressAndDeliveryMode()
        noCartStateSyncHelper.shouldReturnNilDefaultAddress = true
        cartStateHelperToTest.setAddressAndDeliveryMode()
        noCartStateSyncHelper.shouldReturnNilDefaultAddress = false
        
        noCartStateSyncHelper.shouldInvokeFailureForGetDefaultaddress = true
        cartStateHelperToTest.setAddressAndDeliveryMode()
    }
    
    func testCartCreatedStateHelperSetDeliveryAddress() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateHelperToTest: IAPCartCreatedStateHelper = IAPCartCreatedStateHelper { (inValue) in
            XCTAssert(inValue, "Value returned is not correct")
        }
        cartStateHelperToTest.iapCartHelper = noCartStateSyncHelper
        
        let dict = self.deserializeData("IAPOCCGetUser")!
        if let dictVal = dict["defaultAddress"] as? [String: AnyObject] {
            let address = IAPUserAddress(inDict: dictVal)
            cartStateHelperToTest.setCartDefaultAddress(address)
            noCartStateSyncHelper.shouldInvokeFailureForSetDeliveryAddress = true
            cartStateHelperToTest.setCartDefaultAddress(address)
            noCartStateSyncHelper.shouldInvokeFailureForSetDeliveryAddress = false

            noCartStateSyncHelper.shouldReturnFalseForSetDefaultAddress = true
            cartStateHelperToTest.setCartDefaultAddress(address)
        } else {
            assertionFailure("Address failure")
        }
    }
    
    func testSetDeliveryMode() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateHelperToTest: IAPCartCreatedStateHelper = IAPCartCreatedStateHelper { (inValue) in
            XCTAssert(inValue, "Value returned is not correct")
        }
        cartStateHelperToTest.iapCartHelper = noCartStateSyncHelper
        
        let dict = self.deserializeData("IAPDeliveryModes")!
        let deliveryModeContainer = IAPDeliveryModeDetails(inDict: dict)
        let delvieryMode = deliveryModeContainer.deliveryModeDetails.first!
        cartStateHelperToTest.setDeliveryMode(delvieryMode.deliveryModeName)
        
        noCartStateSyncHelper.shouldInvokeFailureForSetDeliveryMode = true
        cartStateHelperToTest.setDeliveryMode(delvieryMode.deliveryModeName)
    }
    
    func testGetAndSetDeliveryMode() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateHelperToTest: IAPCartCreatedStateHelper = IAPCartCreatedStateHelper { (inValue) in
            XCTAssert(inValue, "Value returned is not correct")
        }
        cartStateHelperToTest.iapCartHelper = noCartStateSyncHelper
        cartStateHelperToTest.getAndSetDeliveryModes()
        
        noCartStateSyncHelper.shouldInvokeFailureForGetDeliveryMode = true
        cartStateHelperToTest.getAndSetDeliveryModes()
        
        noCartStateSyncHelper.shouldInvokeFailureForGetDeliveryMode = false
        noCartStateSyncHelper.shouldReturnEmptyForGetDeliveryMode = true
        cartStateHelperToTest.getAndSetDeliveryModes()

    }

}
