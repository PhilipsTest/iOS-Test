/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPCartCreatedStateTests: XCTestCase {

    func testFetchCartCount() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPCartCreatedState = IAPCartCreatedState()
        IAPConfiguration.sharedInstance.oauthInfo = nil
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 0, "Count expected is not matching the returned count")
            }) { (inError) in
                XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = true
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 0, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForSyncing = false
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 0, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        IAPConfiguration.sharedInstance.oauthInfo = nil
        noCartStateSyncHelper.cartCountToReturn = 1
        noCartStateSyncHelper.productCount = 1
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 1, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.productCount = 2
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 2, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.productCount = -1
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 0, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }

        
        noCartStateSyncHelper.productCount = -1
        noCartStateSyncHelper.createNoCartError = true
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 0, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        noCartStateSyncHelper.createNoCartError = false
        
        noCartStateSyncHelper.cartCountToReturn = 2
        noCartStateSyncHelper.productCount = 1
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 1, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.shouldInvokeFailureForDeletion = true
        noCartStateSyncHelper.productCount = 1
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 1, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.cartCountToReturn = -1
        cartStateToTest.fetchCartCount({ (inValue) in
            XCTAssert(inValue == 1, "Count expected is not matching the returned count")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
    }
    
    func testAddProduct() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPCartCreatedState = IAPCartCreatedState()
        IAPConfiguration.sharedInstance.oauthInfo = nil
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.addProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        IAPConfiguration.sharedInstance.oauthInfo = nil
    }
    
    func testBuyProduct() {
        let noCartStateSyncHelper = IAPTestCartSyncHelper()
        let cartStateToTest: IAPCartCreatedState = IAPCartCreatedState()
        IAPConfiguration.sharedInstance.oauthInfo = nil
        cartStateToTest.syncHandler = noCartStateSyncHelper
        
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        IAPConfiguration.sharedInstance.oauthInfo = nil
        
        noCartStateSyncHelper.returnFalseForProductCheck = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
        
        noCartStateSyncHelper.returnFalseForProductCheck = false
        noCartStateSyncHelper.shouldInvokeErrorForCheckProduct = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }

        noCartStateSyncHelper.shouldInvokeErrorForCheckProduct = false
        noCartStateSyncHelper.shouldInvokeFailureForAddProduct = true
        noCartStateSyncHelper.returnFalseForProductCheck = true
        cartStateToTest.buyProduct("", success: { (inValue) in
            XCTAssert(inValue, "Value returned is false")
        }) { (inError) in
            XCTAssertNotNil(inError, "Error returned is empty")
        }
    }
}
