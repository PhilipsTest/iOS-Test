/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsUIKitDLS

class IAPPaymentSelectionViewController: IAPBaseViewController, IAPPaymentDecoratorProtocol {
    fileprivate var iapCartHelper: IAPCartSyncHelper!
    fileprivate var paymentDecorator: IAPPaymentDecorator!
    var orderId: String!
    var paymentDetailsInfo: [IAPPaymentInfo]!
    
    var cartInfo: IAPCartInfo!
    var productList = [IAPProductModel]()
    var shippingAddress: IAPUserAddress!
    
    @IBOutlet weak var paymentSelectionTableView: UITableView!
    @IBOutlet weak var headerTitleLabel: UIDLabel!
    @IBOutlet weak var headerSeparatorView: UIDView!
    @IBOutlet weak var stepView: UIDView!
    @IBOutlet weak var stepLabel: UIDLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kCreditCardSelectionPageName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = IAPLocalizedString("iap_checkout")
        stepLabel.text = IAPLocalizedString("iap_chckout_payment_steps","2")
        headerTitleLabel.text = IAPLocalizedString("iap_checkout_payment_method")
        updateUI()
    }
    
    // MARK: IBAction methods
    
    @IBAction func cancelPaymentMethodClicked(_ sender: AnyObject) {
        IAPUtility.popToShoppingCartController(self.navigationController!)
    }
    
    // MARK: IAPPaymentDecoratorProtocol methods
    
    func didSelectAddNewPaymentMethod() {
        processPaymentForUser()
    }
    
    func didSelectUseThisPaymentMethod(_ selectedPayment: IAPPaymentInfo) {
        processReauthPaymentForUser(selectedPayment)
    }
    // MARK: Private methods
    fileprivate func updateUI() {
        stepLabel.textColor = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryText)!
        stepView.backgroundColor? = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryBackground)!
        iapCartHelper = IAPCartSyncHelper()
        paymentDecorator = IAPPaymentDecorator(withTableView: self.paymentSelectionTableView,
                                               withPayments: self.paymentDetailsInfo)
        paymentDecorator.delegate = self
    }
    
    func processPaymentForUser() {
        let shippingAddressEditViewController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingAddressEditViewController.isEditMode = false
        shippingAddressEditViewController.isBillingAddressModeOnly = true
        shippingAddressEditViewController.savedAddress = shippingAddress
        shippingAddressEditViewController.productList = self.productList
        shippingAddressEditViewController.cartInfo = self.cartInfo
        shippingAddressEditViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingAddressEditViewController, animated: true)
    }
    
    func processReauthPaymentForUser(_ paymentInfo: IAPPaymentInfo) {
        super.startActivityProgressIndicator()
        self.iapCartHelper.setReauthPaymentForUser(paymentInfo.getPaymentId(), success: { (successfulPayment) -> () in
            super.stopActivityProgressIndicator()
            self.pushToOrderSummaryScreen(paymentInfo)
        }) { (inError:NSError) -> () in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }

    func pushToOrderSummaryScreen(_ paymentInfo: IAPPaymentInfo) {
        let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        orderViewController.shippingAddress = self.shippingAddress
        orderViewController.billingAddress  = paymentInfo.getBillingAddress()
        orderViewController.paymentDetails  = paymentInfo
        orderViewController.isFirstTimeUser = false
        orderViewController.isCVVToBeAsked  = true
        orderViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(orderViewController, animated: true)
    }
}
