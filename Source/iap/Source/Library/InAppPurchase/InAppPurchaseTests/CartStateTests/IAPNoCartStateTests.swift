/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPNoCartStateTests: XCTestCase {
    
    func testCartCountFetch() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPNoCartState = IAPNoCartState()
        IAPConfiguration.sharedInstance.oauthInfo = nil
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 0, "Cart count returned is not right")
            }) { (inError) in
                XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.cartCountToReturn = 1
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 1, "Cart count returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.cartCountToReturn = 2
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 2, "Cart count returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.cartCountToReturn = 2
        noCartStateSyncHelper.shouldInvokeFailureForDeletion = true
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 2, "Cart count returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.cartCountToReturn = -1
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 1, "Cart count returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = true
        cartStateToTest.syncHandler = noCartStateSyncHelper
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount, "Cart count returned is nil")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.fetchCartCount({ (inCount) in
            XCTAssertNotNil(inCount == 0, "Cart count returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
    
    func testBuyProduct() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPNoCartState = IAPNoCartState()
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
            }) { (inError) in
                XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = false

        noCartStateSyncHelper.shouldInvokeFailureForCartCreation = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        noCartStateSyncHelper.shouldInvokeFailureForCartCreation = false
        
        noCartStateSyncHelper.cartCountToReturn = 2
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForCartCreation = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.cartCountToReturn = -1
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue == true, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
    
    func testAddProduct() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPNoCartState = IAPNoCartState()
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is not right")
            }) { (inError) in
                XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForAddProduct = true
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        noCartStateSyncHelper.shouldInvokeFailureForAddProduct = false

        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForAddProduct = true
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
        noCartStateSyncHelper.shouldInvokeFailureForAddProduct = false
        IAPConfiguration.sharedInstance.oauthInfo = nil
        
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = true
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is not right")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
}
