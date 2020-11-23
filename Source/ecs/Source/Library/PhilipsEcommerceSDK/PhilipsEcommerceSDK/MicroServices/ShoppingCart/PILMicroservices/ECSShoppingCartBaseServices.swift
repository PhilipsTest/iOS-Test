/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol ECSShoppingCartServices: ECSHybrisMicroService {
    func parseShoppingCart(data: Data?, error: Error?, completionHandler: ECSPILShoppingCartCompletion)
    func microServicePILError(completion: ECSValidationCompletion)
}

extension ECSShoppingCartServices {

    func parseShoppingCart(data: Data?, error: Error?,
                           completionHandler: ECSPILShoppingCartCompletion) {
        do {
            if let shoppingCartData = data {
                if let errorObject = getPILHybrisError(for: shoppingCartData), error != nil {
                    completionHandler(nil, errorObject.hybrisPILError)
                    return
                }
                let jsonDecoder = JSONDecoder()
                let shoppingCart = try jsonDecoder.decode(ECSPILShoppingCart.self, from: shoppingCartData)
                completionHandler(shoppingCart, nil)
            } else {
                completionHandler(nil, error ?? ECSPILHybrisErrors().hybrisPILError)
            }
        } catch {
            ECSConfiguration.shared.ecsLogger?.log(.verbose, eventId: "ECSParsingError",
                                                   message: "\(error.fetchCatchErrorMessage())")
            completionHandler(nil, ECSPILHybrisErrors().hybrisPILError)
        }
    }

    func microServicePILError(completion: ECSValidationCompletion) {
        commonPILValidation { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            guard ECSConfiguration.shared.hybrisToken != nil else {
                completion(ECSHybrisError(with: .ECSOAuthNotCalled).hybrisError)
                return
            }
            guard ECSConfiguration.shared.siteId != nil else {
                completion(ECSHybrisError(with: .ECSPIL_MISSING_PARAMETER_siteId).hybrisError)
                return
            }
            completion(nil)
        }
    }
}
