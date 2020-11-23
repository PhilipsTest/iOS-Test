/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import MobileEcommerceDev

class FlowCompletionDelegate: NSObject, MECOrderFlowCompletionProtocol {
    var didPlaceOrderCalled = false
    var didCancelOrderCalled = false
    
    func shouldPopToProductList() -> Bool {
        return true
    }
    
    func didPlaceOrder() {
        didPlaceOrderCalled = true
    }

    func didCancelOrder() {
        didCancelOrderCalled = true
    }
}
