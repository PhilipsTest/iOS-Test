/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECManageAddressPresenter: MECDeliveryDetailsPresenter {

    var savedAddresses: [ECSAddress]?
    var currentShippingAddress: ECSAddress?
}

extension MECManageAddressPresenter {

    func shuffleSavedAddresses() {
        guard let currentShippingAddress = currentShippingAddress else {
            return
        }
        guard let shippingAddressIndexPath = savedAddresses?.firstIndex(where: { $0.addressID == currentShippingAddress.addressID }) else {
            return
        }
        guard shippingAddressIndexPath != 0 else {
            return
        }
        savedAddresses?.remove(at: shippingAddressIndexPath)
        savedAddresses?.insert(currentShippingAddress, at: 0)
    }

    func deleteAddress(address: ECSAddress, completionHandler: @escaping (_ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.deleteAddress(address: address,
                                                                completionHandler: { [weak self] (savedAddresses, error) in
            guard error == nil else {
                error?.handleOauthError { (handled, error) in
                    if handled == true {
                        self?.deleteAddress(address: address, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.deleteAddress,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(error)
                    }
                }
                return
            }
            self?.dataBus?.savedAddresses = savedAddresses
            self?.fetchMECShoppingCart(completionHandler: { (shoppingCart, error) in
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                self?.dataBus?.shoppingCart = shoppingCart
                completionHandler(nil)
            })
        })
    }

    func setUserSelectedDeliveryAddress(address: ECSAddress, completionHandler: @escaping (_ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.setDeliveryAddress(address: address,
                                                                     completionHandler: { [weak self] (addresses, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.setUserSelectedDeliveryAddress(address: address, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.setDeliveryAddress,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(error)
                    }
                })
                return
            }
            self?.dataBus?.savedAddresses = addresses
            self?.fetchMECShoppingCart(completionHandler: { (shoppingCart, error) in
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                self?.dataBus?.shoppingCart = shoppingCart
                completionHandler(nil)
            })
        })
    }
}
