/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// swiftlint:disable line_length
class ECSFetchShoppingCartMicroServices: NSObject, ECSHybrisMicroService, ECSServiceDiscoveryURLDownloader, ECSShoppingCartServices {
// swiftlint:enable line_length

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func fetchECSShoppingCart(completionHandler: @escaping ECSPILShoppingCartCompletion) {
        microServicePILError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let appInfra = ECSConfiguration.shared.appInfra,
                let siteId = ECSConfiguration.shared.siteId,
                let language = ECSConfiguration.shared.language,
                let country = ECSConfiguration.shared.country,
                let hybrisToken = ECSConfiguration.shared.hybrisToken {

                let replacementDict = [ServiceDiscoveryReplacementConstants.cartId.rawValue: ECSConstant.current.rawValue,
                                       ServiceDiscoveryReplacementConstants.siteID.rawValue: siteId,
                                       ServiceDiscoveryReplacementConstants.language.rawValue: language,
                                       ServiceDiscoveryReplacementConstants.country.rawValue: country]

                fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.fetchCart.rawValue,
                                                replacementDict: replacementDict) { (url, error) in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
                    self.hybrisRequest?.baseURL = url ?? ""
                    self.hybrisRequest?.httpMethod = .GET
                    self.hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                    ECSRestClientCommunicator().performRequestAsynchronously(for: self.hybrisRequest,
                                                                             with: appInfra) { (data, error) in
                        self.parseShoppingCart(data: data, error: error, completionHandler: completionHandler)
                    }
                }
            }
        }
    }
}
