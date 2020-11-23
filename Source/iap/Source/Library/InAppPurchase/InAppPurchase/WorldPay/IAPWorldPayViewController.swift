/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import WebKit
import AppInfra
import PhilipsUIKitDLS

protocol IAPWorldPayDelegate: class {
    func navigateToOrderSummaryScreen(_ isNavigationFromWorldPay: Bool, orderId: String)
}

class IAPWorldPayViewController: IAPBaseViewController, WKNavigationDelegate, IAPWorldPayProtocol,
IAPBuyDirectUINavigationProtocol {
    
    @IBOutlet weak var closeButton: UIDButton!
    
    var wpWebView: WKWebView!
    weak var delegate: IAPWorldPayDelegate!
    var worldPayURL: String!
    var orderID: String!
    var preferredPaymentMethod: String!
    var timeOut: Timer?
    fileprivate var successURL: String!
    fileprivate var failureURL: String!
    fileprivate var pendingURL: String!
    fileprivate var cancelURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.notifyCartDelegateOfCartCountChange()
        self.navigationItem.title = IAPLocalizedString("Payment")
        self.addWorldpayWebKit()
        self.loadWorldPayWebView()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.wpWebView.navigationDelegate = nil
        self.wpWebView.removeFromSuperview()
    }
    
    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.loadWorldPayWebView()
    }
    
    func addWorldpayWebKit() {
        let webConfiguration = WKWebViewConfiguration()
        wpWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        wpWebView.navigationDelegate = self
        wpWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wpWebView)
        guard let wpWebView = wpWebView else { return }
        let horizontalConstraint = NSLayoutConstraint(item: wpWebView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: wpWebView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: wpWebView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: wpWebView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        view.bringSubviewToFront(self.closeButton)
    }
    
    fileprivate func loadWorldPayWebView() {
        super.startActivityProgressIndicator()
        //(self.successURL,self.failureURL,self.pendingURL,self.cancelURL) = IAPOAuthConfigurationData.getWorldPayStatusURLS()
        let worldpayURLS = IAPOAuthConfigurationData.getWorldPayStatusURLS()
        
        self.successURL = worldpayURLS.successURL
        self.failureURL = worldpayURLS.failureURL
        self.pendingURL = worldpayURLS.pendingURL
        self.cancelURL = worldpayURLS.cancelURL
        
        let successParameter = "&successURL=" + successURL
        let failureParameter = "&failureURL=" + failureURL
        let pendingParameter = "&pendingURL=" + pendingURL
        let cancelParameter = "&cancelURL=" + cancelURL
        let paramatersToBeAppended = successParameter + failureParameter + pendingParameter + cancelParameter
        let finalString = self.worldPayURL + paramatersToBeAppended
        //self.worldPayURL + "&successURL=" + successURL + "&failureURL=" + failureURL + "&pendingURL=" + pendingURL + "&cancelURL=" + cancelURL
        let nsurl = URL(string: finalString)
        let nsurlRequest = URLRequest(url: nsurl!)
        self.wpWebView!.load(nsurlRequest)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kCreditCardInputPage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.timeOut?.invalidate()
        self.wpWebView.navigationDelegate = nil
        self.wpWebView.removeFromSuperview()
    }

    //MARK : -
    //MARK : WKWebView delegate method
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var retValue = false
        guard let redirectionURl = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
           return
        }
        
        if redirectionURl.contains(self.worldPayURL) {
            retValue = true
        } else {
            if redirectionURl.contains(self.successURL) {
                retValue = false
                showWorldPayWith(orderID: self.orderID, tag: IAPConstants.IAPPaymentResponseStatus.kPaymentSuccessTag)
            } else if redirectionURl.contains(self.failureURL) {
                retValue = false
                trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "paymentFailure"], action: IAPAnalyticsConstants.sendData)
                showAlertWith(title:  IAPLocalizedString("iap_payment_failed_title"),
                              message:  IAPLocalizedString("iap_payment_failed_message"))
                
            } else if redirectionURl.contains(self.pendingURL) {
                retValue = false
                showWorldPayWith(orderID: nil, tag: IAPConstants.IAPPaymentResponseStatus.kPaymentPendingTag)
            } else if redirectionURl.contains(self.cancelURL) {
                retValue = false
                showWorldPayWith(orderID: nil, tag: IAPConstants.IAPPaymentResponseStatus.kPaymentCancelTag)
            } else {
                retValue = true
            }
        }
        decisionHandler(retValue ? .allow : .cancel)
    }
    
    func showAlertWith(title: String!, message: String!) {
        stopActivityProgressIndicator()
        let alert = UIDAlertController(title: title, message: message)
        let okAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary) { (uidAction) in
            self.finishIAPFlow()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showWorldPayWith(orderID: String?, tag: Int?) {
        let worldPayVC = IAPPaymentConfirmationViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        worldPayVC.cartIconDelegate = self.cartIconDelegate
        worldPayVC.delegate = self
        worldPayVC.orderNo = orderID
        worldPayVC.paymentStatusTag = tag
        stopActivityProgressIndicator()
        navigationController?.pushViewController(worldPayVC, animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.timeOut = Timer.scheduledTimer(timeInterval: 30.0, target: self,
                                            selector: #selector(IAPWorldPayViewController.cancelWorldPayOnTimeout),
                                            userInfo: nil, repeats: false)
        super.startActivityProgressIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.timeOut?.invalidate()
        super.stopActivityProgressIndicator()
        super.removeNoInternetView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.timeOut?.invalidate()
        super.stopActivityProgressIndicator()
        
        if error._code == 102 {
            return
        }
        super.displayErrorMessage(error as NSError)
    }

    // MARK : -
    // MARK : IAPWorldPayProtocol delegate method
    func navigateToParentFlowScreen(_ inSender: AnyObject, statusTag: Int) {
        switch statusTag {
        case IAPConstants.IAPPaymentResponseStatus.kPaymentSuccessTag  :
            NotificationCenter.default.post(name: Notification.Name(rawValue: PAYMENT_SUCCESS_NOTIFICATION),
                                            object: self.navigationController)
            break
        default :
            finishIAPFlow()
        }
    }

    @IBAction func closeIconClicked(_ sender: AnyObject) {
        let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary,
                                              handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
            self.finishIAPFlow()
        })
        
        let uidCancelAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_cancel"), style: .secondary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
            self.trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "cancelPayment"], action: IAPAnalyticsConstants.sendData)
        })
        
        super.displayDLSAlert(IAPLocalizedString("iap_cancel_order_title"),
                              withMessage: IAPLocalizedString("iap_cancel_payment"),
                              firstButton: uidOkAction,
                              secondButton: uidCancelAction,
                              usingController: self,
                              viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
    }
    
    @objc func cancelWorldPayOnTimeout() {
        let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
            self.finishIAPFlow()
        })
        
        super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                              withMessage: IAPLocalizedString("iap_time_out_error"),
                              firstButton: uidOkAction,
                              secondButton: nil,
                              usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
    }
    
    func finishIAPFlow() {
        guard let orderFlowCompletionDelegate = IAPConfiguration.sharedInstance.orderFlowCompletionDelegate else {
            popToCataloguePage(bypassDelegateCheck: true)
            return
        }
        if let orderCancelledCallback = orderFlowCompletionDelegate.didCancelOrder {
            orderCancelledCallback()
            popToCataloguePage(bypassDelegateCheck: false)
        } else {
            popToCataloguePage(bypassDelegateCheck: false)
        }
    }
    
    func popToCataloguePage(bypassDelegateCheck:Bool) {
        if bypassDelegateCheck {
            self.navigationController?.popToProductCatalogue(nil, withCartDelegate: self.cartIconDelegate,withInterfaceDelegate: self.iapHandler)
        } else {
            if let shouldPopToCatalogue = IAPConfiguration.sharedInstance.orderFlowCompletionDelegate?.shouldPopToProductList(), shouldPopToCatalogue == true {
                self.navigationController?.popToProductCatalogue(nil, withCartDelegate: self.cartIconDelegate,withInterfaceDelegate: self.iapHandler)
            }
        }
    }
}
