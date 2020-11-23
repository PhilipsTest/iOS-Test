/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import WebKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

enum MECWorldPayRedirection: String {
    case success = "https://www.philips.com/paymentsuccess"
    case failure = "https://www.philips.com/paymentfailure"
    case pending = "https://www.philips.com/paymentpending"
    case cancel  = "https://www.philips.com/paymentcancel"

    private var paramerKey: String {
        switch self {
        case .success: return "&successURL="
        case .failure: return "&failureURL="
        case .pending: return "&pendingURL="
        case .cancel: return "&cancelURL="
        }
    }

    var parameterValue: String {
        return "\(paramerKey)\(self.rawValue)"
    }
}

class MECWorldPayViewController: MECBaseViewController {

    var worldPayURL: String!
    var wpWebView: WKWebView!
    var orderDetail: ECSOrderDetail?

    fileprivate var successURL: String!
    fileprivate var failureURL: String!
    fileprivate var pendingURL: String!
    fileprivate var cancelURL: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        MECConfiguration.shared.cartUpdateDelegate?.didUpdateCartCount(cartCount: 0)
        title = MECLocalizedString("mec_payment")
        self.navigationItem.setHidesBackButton(true, animated: false)
        loadWorldPayURL(worldPayURL: worldPayURL)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.paymentPage)
    }

    private func loadWorldPayURL(worldPayURL: String) {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        // swiftlint:disable line_length
        let paramatersToBeAppended = "\(MECWorldPayRedirection.success.parameterValue)\(MECWorldPayRedirection.failure.parameterValue)\(MECWorldPayRedirection.pending.parameterValue)\(MECWorldPayRedirection.cancel.parameterValue)"
        // swiftlint:enable line_length
        let finalString = "\(self.worldPayURL ?? "")\(paramatersToBeAppended)"
        if let nsurl = URL(string: finalString) {
            let nsurlRequest = URLRequest(url: nsurl)
            self.wpWebView.load(nsurlRequest)
        }
    }

    override func loadView() {
        super.loadView()
        wpWebView = WKWebView()
        wpWebView.navigationDelegate = self
        view = wpWebView
    }

    func showOrderConfirmationScreen(paymentStatus: MECPaymentStates) {
        if let paymentConfirmationScreen = MECPaymentConfirmationViewController
            .instantiateFromAppStoryboard(appStoryboard: .paymentConfirmation) {
            paymentConfirmationScreen.paymentStatus = paymentStatus
            paymentConfirmationScreen.paymentType = .paymentTypeNew
            paymentConfirmationScreen.orderDetail = orderDetail
            self.navigationController?.pushViewController(paymentConfirmationScreen, animated: true)
        }
    }

    func finishMECFlow(successOrder: Bool = true ) {
        guard let orderFlowCompletionDelegate = MECConfiguration.shared.orderFlowCompletionDelegate else {
            popToCataloguePage(bypassDelegateCheck: true)
            return
        }

        if let orderPlacedCallback = (successOrder == true ? orderFlowCompletionDelegate.didPlaceOrder :
            orderFlowCompletionDelegate.didCancelOrder) {
            orderPlacedCallback()
            popToCataloguePage(bypassDelegateCheck: false)
        } else {
            popToCataloguePage(bypassDelegateCheck: false)
        }
    }

    func popToCataloguePage(bypassDelegateCheck: Bool) {
        if bypassDelegateCheck {
            navigationController?.popToProductListScreen()
        } else {
            if let shouldPopToCatalogue = MECConfiguration.shared.orderFlowCompletionDelegate?.shouldPopToProductList(),
                shouldPopToCatalogue == true {
                navigationController?.popToProductListScreen()
            }
        }
    }

    func trackPaymentFailure() {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.paymentFailure,
                                    MECAnalyticsConstants.paymentType: MECAnalyticsConstants.paymentTypeNew,
                                    MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: orderDetail?.entries)])
    }

    func trackCancelPayment() {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.cancelPayment,
                                    MECAnalyticsConstants.paymentType: MECAnalyticsConstants.paymentTypeNew,
                                    MECAnalyticsConstants.productListKey:
                                        prepareCartEntryListString(entries: orderDetail?.entries)])
    }

    func trackNewBillingAddressAdded() {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.newBillingAddressAdded,
                                    MECAnalyticsConstants.productListKey:
                                        prepareCartEntryListString(entries: orderDetail?.entries)])
    }
}

extension MECWorldPayViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var shouldRedirect = false
        guard let redirectionURL = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
            return
        }

        if redirectionURL.contains(self.worldPayURL) {
            shouldRedirect = true
        } else {
            if redirectionURL.contains(MECWorldPayRedirection.success.rawValue) {
                shouldRedirect = false
                trackNewBillingAddressAdded()
                showOrderConfirmationScreen(paymentStatus: .paymentSuccess)
            } else if redirectionURL.contains(MECWorldPayRedirection.failure.rawValue) {
                shouldRedirect = false
                trackPaymentFailure()
                let okAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                    self.finishMECFlow()
                    self.trackNotification(message: MECEnglishString("mec_payment_failed_message"),
                                            response: MECEnglishString("mec_ok"))
                }
                showAlert(title: MECLocalizedString("mec_payment"),
                          message: MECLocalizedString("mec_payment_failed_message"), okButton: okAction, cancelButton: nil)
            } else if redirectionURL.contains(MECWorldPayRedirection.pending.rawValue) {
                shouldRedirect = false
                showOrderConfirmationScreen(paymentStatus: .paymentPending)
            } else if redirectionURL.contains(MECWorldPayRedirection.cancel.rawValue) {
                shouldRedirect = false
                trackCancelPayment()
                finishMECFlow(successOrder: false)
            } else {
                shouldRedirect = true
            }
        }
        decisionHandler(shouldRedirect ? .allow : .cancel)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopActivityProgressIndicator()
        if error.code == 102 {
            return
        }
        let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
            self.trackNotification(message: error.localizedDescription, response: MECEnglishString("mec_ok"))
        }
        showAlert(title: MECLocalizedString("mec_payment"), message: error.localizedDescription, okButton: okButton, cancelButton: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityProgressIndicator()
    }
}
