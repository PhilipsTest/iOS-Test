/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PlatformInterfaces

class MECDataImplementation: NSObject, MECDataInterface, MECInitializer, MECAnalyticsTracking {

    static let sharedInstance = MECDataImplementation()

    func addCartUpdateDelegate(_ cartUpdateDelegate: MECCartUpdateProtocol) {
        MECConfiguration.shared.cartUpdateDelegate = cartUpdateDelegate
    }

    func removeCartUpdateDelegate(_ cartUpdateDelegate: MECCartUpdateProtocol) {
        MECConfiguration.shared.cartUpdateDelegate = nil
    }

    func isHybrisAvailable(_ completionHandler:@escaping (_ isHybrisAvailable: Bool, _ error: Error?) -> Void) {
        guard let isInternetReachable = MECConfiguration.shared.sharedAppInfra?.restClient.isInternetReachable(),
            isInternetReachable else {
                trackInformationalError(errorMessage: MECEnglishString("mec_no_internet"))
                completionHandler(false, NSError(domain: MECErrorDomain.MECNoNetworkDomain,
                                                 code: MECErrorCode.MECNoInternetCode,
                                                 userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_no_internet")]))
                return
        }

        if MECConfiguration.shared.supportsHybris {
            MECConfiguration.shared.resetSavedUserData()
            initializeEcommerceSDK(completionHandler: completionHandler)
        } else {
            completionHandler(false, MECErrorUtility.prepareHybrisDisabledError())
        }
    }

    func fetchCartCount(completionHandler: @escaping (_ cartCount: Int, _ error: Error?) -> Void) {
        guard let isInternetReachable = MECConfiguration.shared.sharedAppInfra?.restClient.isInternetReachable(),
            isInternetReachable else {
                trackInformationalError(errorMessage: MECEnglishString("mec_no_internet"))
                completionHandler(0, NSError(domain: MECErrorDomain.MECNoNetworkDomain,
                                             code: MECErrorCode.MECNoInternetCode,
                                             userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_no_internet")]))
                return
        }
        guard MECConfiguration.shared.supportsHybris == true else {
            completionHandler(0, MECErrorUtility.prepareHybrisDisabledError())
            return
        }

        MECConfiguration.shared.resetSavedUserData()
        initializeEcommerceSDK { (isHybrisAvailable, error) in
            guard isHybrisAvailable == true else {
                completionHandler(0, error)
                return
            }
            guard MECConfiguration.shared.sharedUDInterface?.loggedInState() == .userLoggedIn else {
                completionHandler(0, MECErrorUtility.prepareNoAutherizationError())
                return
            }
            MECOAuthHandler.shared.oauthHybris { (_, error) in
                guard error == nil else {
                    completionHandler(0, error)
                    return
                }

                MECConfiguration.shared.ecommerceService?.fetchECSShoppingCart(completionHandler: { [weak self] (shoppingCart, error) in
                    guard let cartError = error else {
                        completionHandler(shoppingCart?.data?.attributes?.units ?? 0, nil)
                        return
                    }
                    cartError.handleOauthError {(handled, error) in
                        if handled == true {
                            self?.fetchCartCount(completionHandler: completionHandler)
                        } else {
                            guard cartError.code != noCartErrorCode else {
                                completionHandler(0, nil)
                                return
                            }
                            self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchShoppingCart,
                                                      serverName: MECAnalyticServer.hybris, error: error)
                            completionHandler(0, error)
                        }
                    }
                })
            }
        }
    }
}
