/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import MobileEcommerceDev
import Foundation
class MockProductCatalogueDelegate: NSObject, MECProductCatalogueDelegate {
    
    var productListLoadedCalled = false
    var productSearchCompletedCalled = false
    var emptyRequestThresholdReachedCalled = false
    var showErrorCalled = false
    
    var errorReceived: NSError?
    
    func productListLoaded() {
        productListLoadedCalled = true
    }
    
    func productSearchCompleted() {
        productSearchCompletedCalled = true
    }
    
    func emptyRequestThresholdReached() {
        emptyRequestThresholdReachedCalled = true
    }
    
    func showError(error: Error?) {
        errorReceived = error as NSError?
        showErrorCalled = true
    }
}
