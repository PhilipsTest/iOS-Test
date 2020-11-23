/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECDeliveryDetailsPresenter: MECBaseDeliveryDetailsPresenter {

    var currentDeliveryMode: ECSDeliveryMode?
    var fetchedDeliveryModes: [ECSDeliveryMode]?

    init(deliveryDetailsDataBus: MECDataBus?) {
        super.init()
        self.dataBus = deliveryDetailsDataBus
    }
}

// MARK: Shipping Address Section
extension MECDeliveryDetailsPresenter {

    func setUpShippingAddress(completionHandler: @escaping () -> Void) {
        shippingAddress = nil
        if let shoppingCartDeliveryAddress = dataBus?.savedAddresses?
            .first(where: { $0.addressID == dataBus?.shoppingCart?.data?.attributes?.deliveryAddress?.addressId }) {
            shippingAddress = shoppingCartDeliveryAddress
            completionHandler()
            return
        }
        fetchDefaultAddressFromUserProfile { [weak self] (defaultAddress, error) in
            if let defaultShippingAddress = self?.dataBus?.savedAddresses?.first(where: { $0.addressID == defaultAddress?.addressID }) {
                self?.setDeliveryAddress(address: defaultShippingAddress) { (_, error) in
                    guard error == nil else {
                        completionHandler()
                        return
                    }
                    self?.shippingAddress = defaultShippingAddress
                    completionHandler()
                }
            } else if let savedAddresses = self?.dataBus?.savedAddresses,
                savedAddresses.count > 0,
                let firstShippingAddress = savedAddresses.first {
                self?.setDeliveryAddress(address: firstShippingAddress) { [weak self] (_, error) in
                    guard error == nil else {
                        completionHandler()
                        return
                    }
                    self?.shippingAddress = firstShippingAddress
                    completionHandler()
                }
            } else {
                completionHandler()
            }
        }
    }

    func fetchDefaultAddressFromUserProfile(completionHandler: @escaping (_ defaultAddress: ECSAddress?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchUserProfile(completionHandler: { (userProfile, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { [weak self] (handled, error) in
                    if handled == true {
                        self?.fetchDefaultAddressFromUserProfile(completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchUserProfile,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(nil, error)
                    }
                })
                return
            }
            completionHandler(userProfile?.defaultAddress, nil)
        })
    }
}

// MARK: Delivery Modes Section
extension MECDeliveryDetailsPresenter {

    func fetchDeliveryModes(completionHandler: @escaping (_ deliveryModes: [ECSDeliveryMode]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchDeliveryModes(completionHandler: { [weak self] (deliveryModes, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.fetchDeliveryModes(completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchDeliveryModes,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(deliveryModes, error)
                    }
                })
                return
            }
            self?.fetchedDeliveryModes = deliveryModes
            completionHandler(deliveryModes, error)
        })
    }

    func setDeliveryMode(deliveryMode: ECSDeliveryMode, completionHandler: @escaping (_ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.setDeliveryMode(deliveryMode: deliveryMode,
                                                                  completionHandler: { [weak self] (_, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.setDeliveryMode(deliveryMode: deliveryMode, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.setDeliveryMode,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(error)
                    }
                })
                return
            }
            self?.fetchMECShoppingCart { (shoppingCart, error) in
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                self?.dataBus?.shoppingCart = shoppingCart
                completionHandler(nil)
            }
        })
    }

    func fetchNumberOfDeliveryModes() -> Int {
        return fetchedDeliveryModes?.count ?? 0
    }

    func setCurrentSelectedDeliveryMode() {
        currentDeliveryMode = fetchedDeliveryModes?
            .first(where: { $0.deliveryModeId == dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId })
    }
}

// MARK: Payment List Section
extension MECDeliveryDetailsPresenter {

    func fetchSavedPayments(completionHandler: @escaping (_ paymentList: [ECSPayment]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchPaymentDetails(completionHandler: { [weak self] (payments, error) in
            self?.dataBus?.paymentsInfo?.isPaymentsDownloaded = true
            guard error == nil else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.fetchSavedPayments(completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchPaymentDetails,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(payments, error)
                    }
                })
                return
            }
            if let fetchedPayments = payments {
                self?.dataBus?.paymentsInfo?.fetchedPaymentMethods?.append(contentsOf: fetchedPayments)
            }
            completionHandler(self?.dataBus?.paymentsInfo?.fetchedPaymentMethods, error)
        })
    }

    func fetchNumberOfPayments() -> Int {
        let fetchedPaymentsCount = dataBus?.paymentsInfo?.fetchedPaymentMethods?.count ?? 0
        guard dataBus?.paymentsInfo?.fetchedPaymentMethods?.contains(where: { $0.isNewPayment() }) == true else {
            return fetchedPaymentsCount + 1
        }
        return fetchedPaymentsCount
    }
}
