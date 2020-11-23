/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECNotifyMePresenter: MECBasePresenter {

    func registerForStockNotificationFor(ctn: String,
                                         email: String,
                                         completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.registerForProductAvailability(email: email,
                                                                                 ctn: ctn,
                                                                                 completionHandler: completionHandler)
    }

    func fetchUserEmail() -> String {
        return MECConfiguration.shared.getUserEmailID() ?? ""
    }
}
