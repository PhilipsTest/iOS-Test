/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsEcommerceSDK

protocol MECInitializer: NSObjectProtocol, MECAnalyticsTracking {
    func initializeEcommerceSDK(completionHandler:@escaping (_ isHybrisAvailable: Bool, _ error: Error?) -> Void)
}

extension MECInitializer {

    func initializeEcommerceSDK(completionHandler:@escaping (_ isHybrisAvailable: Bool, _ error: Error?) -> Void) {

        guard let isHybrisAvailable = MECConfiguration.shared.isHybrisAvailable else {
            guard let ecsService = MECUtility.createECSService() else {
                completionHandler(false, nil)
                return
            }
            MECConfiguration.shared.ecommerceService = ecsService
            MECConfiguration.shared.ecommerceService?.configureECSWithConfiguration {[weak self] (config, error) in
                if error != nil {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.configureECSWithConfiguration,
                                              serverName: MECAnalyticServer.hybris, error: error)
                }
                MECConfiguration.shared.isHybrisAvailable = !MECConfiguration.shared.supportsHybris ?
                    false :
                    config?.rootCategory != nil
                MECConfiguration.shared.locale = config?.locale
                MECConfiguration.shared.rootCategory = config?.rootCategory
                let configError = (!MECConfiguration.shared.supportsHybris && config != nil) ? nil : error
                completionHandler(MECConfiguration.shared.isHybrisAvailable ?? false, configError)
            }
            return
        }
        completionHandler(isHybrisAvailable, nil)
    }
}
