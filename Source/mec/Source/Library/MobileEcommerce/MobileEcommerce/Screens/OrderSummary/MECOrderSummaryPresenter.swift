/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class MECOrderSummaryPresenter: MECBasePresenter {

    var dataBus: MECDataBus?
    var orderDetail: ECSOrderDetail?

    init(with summaryDataBus: MECDataBus?) {
        super.init()
        dataBus = summaryDataBus
    }
}

// MARK: UI Configuration Section
extension MECOrderSummaryPresenter {

    func numberOfProductInCart() -> Int {
        return dataBus?.shoppingCart?.data?.attributes?.items?.count ?? 0
    }

    func totalTax() -> String {
        return dataBus?.shoppingCart?.data?.attributes?.pricing?.tax?.formattedValue ?? ""
    }

    func totalPrice() -> String {
        return dataBus?.shoppingCart?.data?.attributes?.pricing?.total?.formattedValue ?? ""
    }

    func isFirstTimePayment() -> Bool {
        return dataBus?.paymentsInfo?.selectedPayment?.isNewPayment() == true
    }

    func shouldShowPrivacy(completionHandler: @escaping (_ shouldShow: Bool) -> Void) {
        getPrivacyURL { (url) in
            completionHandler(url != nil)
        }
    }

    func getFAQUrl(completionHandler: @escaping (_ url: String?) -> Void) {
        MECServiceDiscoveryUtility().getMECServiceURL(serviceKey: MECServiceKeys.MECFAQ) { (url, _) in
            completionHandler(url)
        }
    }

    func getPrivacyURL(completionHandler: @escaping (_ url: String?) -> Void) {
        MECServiceDiscoveryUtility().getMECServiceURL(serviceKey: MECServiceKeys.MECPrivacy) { (url, _) in
            completionHandler(url)
        }
    }

    func getTermsURL(completionHandler: @escaping  (_ url: String?) -> Void) {
        MECServiceDiscoveryUtility().getMECServiceURL(serviceKey: MECServiceKeys.MECTerms) { (url, _) in
            completionHandler(url)
        }
    }
}

// MARK: Payment Section
extension MECOrderSummaryPresenter {

    func makePayment(for order: ECSOrderDetail?,
                     completionHandler: @escaping  (_ paymentProvider: ECSPaymentProvider?, _ error: Error?) -> Void) {
        guard let billingAddress = dataBus?.paymentsInfo?.selectedPayment?.billingAddress, let orderDetail = order else {
            completionHandler(nil, nil)
            return
        }
        MECConfiguration.shared.ecommerceService?.makePaymentFor(order: orderDetail,
                                                                 billingAddress: billingAddress,
                                                                 completionHandler: { [weak self] (paymentProvider, error) in
                guard let paymentError = error else {
                    completionHandler(paymentProvider, nil)
                    return
                }
                paymentError.handleOauthError {(handled, error) in
                    if handled == true {
                        self?.makePayment(for: order, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.makePaymentFor,
                                            serverName: MECAnalyticServer.hybris,
                                            error: error)
                        completionHandler(paymentProvider, error)
                    }
                }
        })
    }

    func submitOrder(with cvvCode: String? = nil, completionHandler: @escaping (_ orderDetail: ECSOrderDetail?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.submitOrder(cvvCode: cvvCode, completionHandler: { [weak self] (orderDetail, error) in
            guard error == nil else {
                error?.handleOauthError {(handled, error) in
                    if handled == true {
                        self?.submitOrder(with: cvvCode, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.submitOrder,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(orderDetail, error)
                    }
                }
                return
            }
            self?.orderDetail = orderDetail
            completionHandler(orderDetail, error)
        })
    }

    func setPayment(payment: ECSPayment, completionHandler: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.setPaymentDetail(paymentDetail: payment,
                                                                   completionHandler: { [weak self] (success, error) in
            guard error == nil else {
                error?.handleOauthError {(handled, error) in
                    if handled == true {
                        self?.setPayment(payment: payment, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.setPaymentDetail,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(success, error)
                    }
                }
                return
            }
            completionHandler(success, error)
        })
    }

    func payForOrderWith(cvv: String, completionHandler: @escaping ((_ orderDetail: ECSOrderDetail?, _ error: Error?) -> Void)) {
        guard let selectedPayment = dataBus?.paymentsInfo?.selectedPayment else {
            let errorMessage = MECLocalizedString("mec_no_payment_error_message")
            let error = NSError(domain: errorMessage, code: 111, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            completionHandler(nil, error)
            return
        }

        setPayment(payment: selectedPayment) { [weak self] (_, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            self?.submitOrder(with: cvv) { (orderDetail, error) in
                completionHandler(orderDetail, error)
            }
        }
    }
}
