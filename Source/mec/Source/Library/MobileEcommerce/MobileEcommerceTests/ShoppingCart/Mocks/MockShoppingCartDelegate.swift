/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


@testable import MobileEcommerceDev
import Foundation
class MockShoppingCartDelegate: NSObject, MECShoppingCartDelegate {
    
    var shoppingCartLoadedCalled = false
    var showErrorCalled = false
    var errorShowed: Error?
    
    func shoppingCartLoaded() {
        shoppingCartLoadedCalled = true
    }
    
    func showError(error: Error?) {
        errorShowed = error
        showErrorCalled = true
    }
}
