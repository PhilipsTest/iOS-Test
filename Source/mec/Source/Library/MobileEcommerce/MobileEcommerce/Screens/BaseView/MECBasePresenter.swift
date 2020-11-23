/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AVFoundation
import PhilipsEcommerceSDK
import PlatformInterfaces

class MECBasePresenter: NSObject, MECAnalyticsTracking {

    var completionHandler: ((_ sucess: Bool, _ error: Error?) -> Void)?

    func oauthHybris(completionHandler:@escaping(_ sucess: Bool, _ error: Error?) -> Void) {
        MECOAuthHandler.shared.oauthHybris(completionHandler: completionHandler)
    }

    func createCartWith(ctn: String, completionHandler: @escaping (_ shoppingCart: ECSPILShoppingCart?, _ error: Error?) -> Void ) {
        MECConfiguration.shared.ecommerceService?.createECSShoppingCart(ctn: ctn, completionHandler: { [weak self] (shoppingCart, error) in
            guard let cartError = error else {
                completionHandler(shoppingCart, error)
                return
            }
            cartError.handleOauthError {(handled, error) in
                if handled == true {
                    self?.createCartWith(ctn: ctn, completionHandler: completionHandler)
                } else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.createShoppingCart,
                                              serverName: MECAnalyticServer.hybris, error: error)
                    completionHandler(nil, error)
                }
            }
        })
    }

    func fetchMECShoppingCart(completionHandler: @escaping (_ shoppingCart: ECSPILShoppingCart?, _ error: Error?) -> Void ) {
        MECConfiguration.shared.ecommerceService?.fetchECSShoppingCart(completionHandler: { [weak self] (shoppingCart, error) in
            guard let cartError = error else {
                completionHandler(shoppingCart, error)
                return
            }
            cartError.handleOauthError { (handled, error) in
                if handled == true {
                    self?.fetchMECShoppingCart(completionHandler: completionHandler)
                } else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchShoppingCart,
                                              serverName: MECAnalyticServer.hybris, error: error)
                    completionHandler(nil, error)
                }
            }
        })
    }
}
