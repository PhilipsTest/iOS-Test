/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// swiftlint:disable line_length
class ECSCreateShoppingCartMicroServices: NSObject, ECSHybrisMicroService, ECSServiceDiscoveryURLDownloader, ECSShoppingCartServices {
// swiftlint:enable line_length

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    func createECSShoppingCart(ctn: String,
                               quantity: Int,
                               completionHandler: @escaping ECSPILShoppingCartCompletion) {
        var ctnValue = ctn
        guard ctnValue.isValidCTN() else {
            completionHandler(nil, ECSPILHybrisErrors(errorType: .ECSPIL_NOT_FOUND_productId).hybrisPILError)
            return
        }
        guard quantity > 0 else {
            completionHandler(nil, ECSPILHybrisErrors(errorType: .ECSPIL_INVALID_QUANTITY).hybrisPILError)
            return
        }
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
                let replacementDict = [ServiceDiscoveryReplacementConstants.siteID.rawValue: siteId,
                                       ServiceDiscoveryReplacementConstants.language.rawValue: language,
                                       ServiceDiscoveryReplacementConstants.country.rawValue: country,
                                       ECSConstant.ctn.rawValue: ctn,
                                       ServiceDiscoveryReplacementConstants.quantity.rawValue: "\(quantity)"]

                fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.createCart.rawValue,
                                                replacementDict: replacementDict) { (url, error) in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
                    self.hybrisRequest?.httpMethod = .POST
                    self.hybrisRequest?.headerParameter = [ECSConstant.authorization.rawValue: hybrisToken]
                    self.hybrisRequest?.baseURL = url ?? ""
                    ECSRestClientCommunicator().performRequestAsynchronously(for: self.hybrisRequest,
                                                                            with: appInfra,
                                                                            completionHandler: {(data, error) in
                            self.parseShoppingCart(data: data, error: error, completionHandler: completionHandler)
                    })
                }
            }
        }
    }
}
