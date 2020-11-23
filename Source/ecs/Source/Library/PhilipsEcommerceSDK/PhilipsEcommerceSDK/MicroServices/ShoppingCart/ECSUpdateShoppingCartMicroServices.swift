/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// swiftlint:disable line_length
class ECSUpdateShoppingCartMicroServices: NSObject, ECSHybrisMicroService, ECSServiceDiscoveryURLDownloader, ECSShoppingCartServices {
// swiftlint:enable line_length

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func updateECSShoppingCart(cartItem: ECSPILItem,
                               quantity: Int,
                               completionHandler: @escaping ECSPILShoppingCartCompletion) {
        guard quantity >= 0 else {
            completionHandler(nil, ECSPILHybrisErrors(errorType: .ECSPIL_NEGATIVE_QUANTITY).hybrisPILError)
            return
        }
        microServicePILError { (error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            guard let appInfra = ECSConfiguration.shared.appInfra,
                let hybrisToken = ECSConfiguration.shared.hybrisToken,
                let siteId = ECSConfiguration.shared.siteId,
                let language = ECSConfiguration.shared.language,
                let country = ECSConfiguration.shared.country,
                let entryNumber = cartItem.entryNumber else {
                    completionHandler(nil, ECSHybrisError(with: .ECSUnknownIdentifierError).hybrisError)
                    return
            }

            let replacementDict = [ServiceDiscoveryReplacementConstants.entryNumber.rawValue: entryNumber,
                                   ServiceDiscoveryReplacementConstants.cartId.rawValue: ECSConstant.current.rawValue,
                                   ServiceDiscoveryReplacementConstants.siteID.rawValue: siteId,
                                   ServiceDiscoveryReplacementConstants.language.rawValue: language,
                                   ServiceDiscoveryReplacementConstants.country.rawValue: country,
                                   ServiceDiscoveryReplacementConstants.quantity.rawValue: "\(quantity)"]

            fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.updateCart.rawValue,
                                            replacementDict: replacementDict) { (url, error) in
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
                self.hybrisRequest?.baseURL = url ?? ""
                self.hybrisRequest?.httpMethod = .PUT
                self.hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                ECSRestClientCommunicator().performRequestAsynchronously(for: self.hybrisRequest,
                                                                         with: appInfra) { (data, error) in
                    self.parseShoppingCart(data: data, error: error, completionHandler: completionHandler)
                }
            }
        }
    }
}
