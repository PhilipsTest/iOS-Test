/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra

class MECServiceDiscoveryUtility: NSObject {

    func getMECServiceURL(serviceKey: String, completionHandler:@escaping ((String?, Error?) -> Void)) {
        let mecServiceKey = "iap.\(serviceKey)"
        MECConfiguration.shared.sharedAppInfra.serviceDiscovery
            .getServicesWithCountryPreference([mecServiceKey],
                                              withCompletionHandler: { (returnedValue, inError) in
            var url: String?
            if let serviceDiscoveryValue = returnedValue?[mecServiceKey] {
                url = serviceDiscoveryValue.url
            }
            completionHandler(url, inError)
        }, replacement: nil)
    }
}
