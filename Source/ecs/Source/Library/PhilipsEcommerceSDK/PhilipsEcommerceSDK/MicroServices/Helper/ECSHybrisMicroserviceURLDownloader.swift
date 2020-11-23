/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol ECSServiceDiscoveryURLDownloader: class {
    func fetchURLFromServiceDiscoveryFor(serviceID: String,
                                         replacementDict: [String: Any]?,
                                         completionHandler: @escaping (_ url: String?, _ error: Error?) -> Void)
}

extension ECSServiceDiscoveryURLDownloader {

    func fetchURLFromServiceDiscoveryFor(serviceID: String,
                                         replacementDict: [String: Any]?,
                                         completionHandler: @escaping (_ url: String?, _ error: Error?) -> Void) {
        ECSConfiguration.shared.appInfra?.serviceDiscovery?
            .getServicesWithCountryPreference([serviceID],
                                              withCompletionHandler: { (services, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let requestURL = services?[serviceID]?.url else {
                completionHandler(nil, services?[serviceID]?.error ?? ECSHybrisError().hybrisError)
                return
            }
            completionHandler(requestURL, nil)
        }, replacement: replacementDict)
    }
}
