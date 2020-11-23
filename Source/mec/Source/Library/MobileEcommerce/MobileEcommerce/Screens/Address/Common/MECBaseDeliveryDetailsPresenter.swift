/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECBaseDeliveryDetailsPresenter: MECBasePresenter {

    var fetchedRegions: [ECSRegion]?
    var dataBus: MECDataBus?
    var salutations: [MECAddressSalutation] {
        return [MECAddressSalutation.mr, MECAddressSalutation.ms]
    }
    var addressFieldConfigurationData: MECAddressFieldsConfigModel?
    var shippingAddress: ECSAddress?
}

// MARK: Region Section
extension MECBaseDeliveryDetailsPresenter {

    func fetchRegions(country: String?, completionHandler: @escaping () -> Void) {
        if let countryISO = country {
            MECConfiguration.shared.ecommerceService?.fetchRegionsFor(countryISO: countryISO,
                                                                      completionHandler: { [weak self] (regions, _) in
                self?.fetchedRegions = regions
                completionHandler()
                return
            })
        }
        completionHandler()
    }
}

// MARK: Address Section
extension MECBaseDeliveryDetailsPresenter {

    func setDeliveryAddress(address: ECSAddress, completionHandler: @escaping (_ savedAddresses: [ECSAddress]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.setDeliveryAddress(deliveryAddress: address,
                                                                     completionHandler: { [weak self] (_, setDeliveryAddressError) in
            if setDeliveryAddressError != nil {
                self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.setDeliveryAddress,
                                          serverName: MECAnalyticServer.hybris, error: setDeliveryAddressError)
            }
            self?.fetchSavedAddresses { (addresses, error) in
                guard error == nil else {
                    completionHandler(addresses, nil)
                    return
                }
                self?.dataBus?.savedAddresses = addresses
                guard setDeliveryAddressError == nil else {
                    setDeliveryAddressError?.handleOauthError { (handled, error) in
                        if handled == true {
                            self?.setDeliveryAddress(address: address, completionHandler: completionHandler)
                        } else {
                            completionHandler(addresses, error)
                        }
                    }
                    return
                }
                self?.fetchMECShoppingCart(completionHandler: { (shoppingCart, error) in
                    guard error == nil else {
                        completionHandler(addresses, nil)
                        return
                    }
                    self?.dataBus?.shoppingCart = shoppingCart
                    completionHandler(addresses, nil)
                })
            }
        })
    }

    func fetchSavedAddresses(completionHandler: @escaping (_ addressList: [ECSAddress]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchSavedAddresses(completionHandler: { [weak self] (addressList, error) in
            guard let addressError = error else {
                completionHandler(addressList, error)
                return
            }
            addressError.handleOauthError {(handled, error) in
                if handled == true {
                    self?.fetchSavedAddresses(completionHandler: completionHandler)
                } else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchSavedAddresses,
                                              serverName: MECAnalyticServer.hybris, error: error)
                    completionHandler(addressList, error)
                }
            }
        })
    }
}
