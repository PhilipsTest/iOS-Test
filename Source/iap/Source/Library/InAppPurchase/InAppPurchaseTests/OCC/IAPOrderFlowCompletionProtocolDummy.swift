/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
@testable import InAppPurchaseDev

class IAPOrderFlowCompletionProtocolDummy: NSObject, IAPOrderFlowCompletionProtocol {
    
    var shouldPop: Bool = true
    var orderPlaced: Bool = false
    var orderCancelled: Bool = false
    
    func shouldPopToProductList() -> Bool {
        return shouldPop
    }
    
    func didPlaceOrder() {
        orderPlaced = true
    }
    
    func didCancelOrder() {
        orderCancelled = true
    }
}

class IAPOrderCompletionPartialImplementationDummy: NSObject, IAPOrderFlowCompletionProtocol {
    
    var shouldPop: Bool = true
    
    func shouldPopToProductList() -> Bool {
        return shouldPop
    }
}

class WorldPayProtocolDummy: NSObject, IAPWorldPayProtocol {
    var didNavigate: Bool = false
    
    func navigateToParentFlowScreen(_ inSender: AnyObject, statusTag: Int) {
        didNavigate = true
    }
}
