/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class InAppPurchaseOrderHistoryState: InAppPurchaseState {
    
    override func updateDataModel() {
        dataModel?.launchingOption = IAPLandingOptions.iapPurchaseHistoryOption
        dataModel?.errorHandler = { error in
            if error != nil {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_SETTINGS_TAG, message: "\(Constants.LOGGING_INAPP_ERROR_MESSAGE) \(String(describing: error))")
            } else {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_SETTINGS_TAG, message: Constants.LOGGING_INAPP_MESSAGE)
            }

        }
    }
}
