/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECDataBus: NSObject {
    var shoppingCart: ECSPILShoppingCart? {
        didSet {
            MECConfiguration.shared.cartUpdateDelegate?.didUpdateCartCount(cartCount: shoppingCart?.data?.attributes?.units ?? 0)
        }
    }
    var savedAddresses: [ECSAddress]?
    var paymentsInfo: MECPaymentsInfo?

    override init() {
        super.init()
        paymentsInfo = MECPaymentsInfo()
    }
}

class MECPaymentsInfo: NSObject {
    var fetchedPaymentMethods: [ECSPayment]?
    var isPaymentsDownloaded = false
    var selectedPayment: ECSPayment?

    override init() {
        super.init()
        fetchedPaymentMethods = []
    }
}
