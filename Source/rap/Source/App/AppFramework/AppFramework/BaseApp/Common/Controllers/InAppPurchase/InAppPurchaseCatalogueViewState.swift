/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class InAppPurchaseCatalogueViewState : InAppPurchaseState {

    var errorFromIAP :NSError?
    
    override func updateDataModel() {
        dataModel?.launchingOption = IAPLandingOptions.iapProductCatalogueOption
        dataModel?.CTNList = CTNUtilities.getProductCTNsForHomeCountry()
        weak var weakSelf = self
        dataModel?.errorHandler = { error in
            if let iapError = error {
                weakSelf?.errorFromIAP = iapError as NSError?
                _ = weakSelf?.stateCompletionHandler?.communicateFromState(weakSelf)
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_INAPP_TAG, message: " \(Constants.LOGGING_INAPP_ERROR_MESSAGE)\(String(describing: error))")
            } else {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_INAPP_TAG, message: Constants.LOGGING_INAPP_MESSAGE)
            }
        }
    }
}


