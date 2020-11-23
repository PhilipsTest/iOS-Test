/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS
import SafariServices

class IAPOrderSummaryViewController: IAPBaseViewController, IAPWorldPayProtocol, IAPWorldPayDelegate,
        UITextFieldDelegate, IAPBuyDirectCartProtocol, IAPNavigationControllerBackButtonDelegate,
IAPBuyDirectLeftToRightSwipeProtocol,UITextViewDelegate {
    
    @IBOutlet weak var privacyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeightConstratin: NSLayoutConstraint!
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var payNowButton: UIDButton?
    @IBOutlet weak var cancelPaymentBtn: UIDButton?
    @IBOutlet weak var cvvShadowView: UIView!
    @IBOutlet weak var cvvContainerView: UIView!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var cvvTextField: UIDTextField!
    @IBOutlet weak var cardNumberLabel: UIDLabel!
    @IBOutlet weak var cvvHelpLabel: UIDLabel!
    @IBOutlet weak var stepView: UIDView!
    @IBOutlet weak var stepLabel: UIDLabel!
    
    var cartInfo: IAPCartInfo! = IAPCartInfo()
    var productList: [IAPProductModel] = [IAPProductModel]()
    var shippingAddress: IAPUserAddress!
    var billingAddress: IAPUserAddress!
    var paymentDetails: IAPPaymentInfo!
    var paymentOrderId: String! = ""
    var isFirstTimeUser: Bool = false
    var isFromWorldPay: Bool = false
    var isCVVToBeAsked: Bool = false
    var privacyURL: String = ""
    var termsURL: String = ""
    var faqURL: String = ""
    var cvvUsed: String = ""
    var cartSyncHelper = IAPCartSyncHelper()
    fileprivate var indexOfMode = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = IAPLocalizedString("iap_checkout")
        self.styleSubViews()
        self.cvvTextField.delegate = self
        stepLabel.textColor = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryText)!
        stepView.backgroundColor? = (UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryBackground)!
        self.checkPrivacyAndTerms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.updateCartIconVisibility(false)
        super.startActivityProgressIndicator()
        self.fetchCartInformation()
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kOrderSummaryPageName)
        if self.isFromBuyDirect() {
            self.navigationController?.delegate = self
        }
    }
    
    // MARK: -
    // MARK: No internet related methods
    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.fetchCartInformation()
    }
    
    // MARK: -
    // MARK: Navigation related
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        self.handlePossibleBuyDirectCancel()
    }
    
    override func handleCancelNavigationForNormalFlow() {
        IAPUtility.popToShoppingCartController(self.navigationController!)
    }
    
    // MARK: -
    // MARK: IAPNavigationControllerBackButtonDelegate method
    
    func viewControllerShouldPopOnBackButton() -> Bool {
        guard false == self.isFromBuyDirect() else {
            self.deleteBuyDirectCartAndPop()
            return false
        }
        guard self.paymentOrderId == "" else {
            let uidCancelAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_cancel"),
                                                      style: .primary, handler: { (uidAction) in
                                                        self.uidAlertController?.dismiss(animated: true, completion: nil)
            })
            let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                                  style: .primary, handler: { (uidAction) in
                                                    IAPUtility.popToShoppingCartController(self.navigationController!)
            })
            super.displayDLSAlert(IAPLocalizedString("iap_cancel_order_title"),
                                  withMessage: IAPLocalizedString("iap_cancel_payment"),
                                  firstButton: uidCancelAction,
                                  secondButton: uidOkAction,
                                  usingController: self,
                                  viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
            return false
        }
        return (self.navigationController?.skipBeforeViewControllerWhenBackPressed(self))!
    }
    
    // MARK: -
    // MARK: Fetch info for order summary
    
    func urlClicked(url: URL) {
        IAPUtility.tagExitLink(exitURL: url)
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.urlClicked(url: URL)
        return false
    }

    fileprivate func updateTextViewSize() {
        
        guard self.privacyTextViewHeightConstraint.constant == 0 else {
            return
        }
        let size = self.privacyTextView.getTextViewSize()
        self.privacyTextViewHeightConstraint.constant = size.height
        self.buttonViewHeightConstratin.constant += self.privacyTextViewHeightConstraint.constant
    }
    
    
    fileprivate func updatePrivacyTextView() {
        
        
        guard let termsURL = URL(string: self.termsURL),
            let privacyURL = URL(string: self.privacyURL),
            let faqURL = URL(string: self.faqURL) else {
            return
        }
        
        let privacyString = IAPUNWrappedLocaliseString("iap_privacy")
        let justRead = ""
        let readPrivacyString = IAPUNWrappedLocaliseString("iap_read_privacy")
        let termsString = IAPUNWrappedLocaliseString("iap_terms_conditions")
        let agreePrivacyString = IAPUNWrappedLocaliseString("iap_accept_terms")
        let askQuestionsString = IAPUNWrappedLocaliseString("iap_questions")
        let faqString = IAPUNWrappedLocaliseString("iap_faq")
        let pageString = IAPUNWrappedLocaliseString("iap_page")
        
        let message = "\(readPrivacyString) \(privacyString) \(justRead).\n\(askQuestionsString) \(faqString) \(pageString).\n\(agreePrivacyString) \(termsString)."
        
        let privacyRange = (message as NSString).range(of: privacyString, options: [NSString.CompareOptions.caseInsensitive])
        let termsRange = (message as NSString).range(of: termsString, options: [NSString.CompareOptions.caseInsensitive])
        let faqRange = (message as NSString).range(of: faqString, options: [NSString.CompareOptions.caseInsensitive])

        let totalString = NSMutableAttributedString(string: message)
        let links = [(privacyURL,privacyRange),(termsURL,termsRange),(faqURL,faqRange)]
        totalString.addIAPLinkAttributes(links: links, fontSize: 12.0)
        self.privacyTextView.addLinkAttributesAsPerIAP(fontSize: 12.0)
        self.privacyTextView.attributedText = totalString
        self.privacyTextView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        self.privacyTextView.delegate = self
        self.updateTextViewSize()
    }
    
    fileprivate func fetchURLForKey(key:String,completionHandler:@escaping ((String) -> Void)) {
        IAPConfiguration.sharedInstance.fetchSDURLForKey(forKey:key,  completionHandler: {
            url , error in
            guard error == nil  else {
                return
            }
            
            guard let urlString = url else {
                return
            }
            completionHandler(urlString)
        }
        )
    }
    
    fileprivate func checkPrivacyAndTerms() {
        
        guard IAPConfiguration.sharedInstance.supportsHybris == true else {
            return
        }
        
        self.fetchURLForKey(key: IAPConstants.SDURLKeys.kPrivacy, completionHandler: {
           [weak self]  aURL in
            self?.privacyURL = aURL
            self?.fetchURLForKey(key: IAPConstants.SDURLKeys.kTerms, completionHandler: {
                [weak self] bURL in
                self?.termsURL = bURL
                self?.fetchURLForKey(key: IAPConstants.SDURLKeys.kFAQ, completionHandler: {
                    [weak self] cURL in
                    self?.faqURL = cURL
                    self?.updatePrivacyTextView()
                })
            })
        })
    }
    
    fileprivate func fetchCartInformation() {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        super.startActivityProgressIndicator()
        IAPShoppingCartDataSource().getCartInformation(self.productList, success: { (inSuccess, withObject, withProductList) -> () in
            self.cartInfo = withObject
            self.productList = withProductList
            self.shoppingTableView.reloadData()
            super.stopActivityProgressIndicator()
            self.payNowButton?.isEnabled = true
            super.removeNoInternetView()
        }) { (inError: NSError) -> () in
            super.stopActivityProgressIndicator()
            self.payNowButton?.isEnabled = false
            super.displayErrorMessage(inError, shouldDisplayNoInternetView:(0==self.productList.count))
        }
    }
    
    // MARK: -
    // MARK: Button action and CVV handling
    
    @IBAction func payNowButtonClicked(_ sender: AnyObject) {
        guard false == self.isCVVToBeAsked else { self.displayModelAlertForCVV(); return }
        self.makePayment()
    }
    
    func makePayment() {
        if self.isFromWorldPay == true {
            self.sendRequestToMakePayment(self.paymentOrderId)
        } else {
            guard self.paymentOrderId == "" else {
                self.sendRequestToMakePayment(self.paymentOrderId)
                return
            }
            self.sendRequestToSubmitOrder()
        }
    }
    
    fileprivate func displayModelAlertForCVV() {
        self.cvvHelpLabel.text(IAPLocalizedString("iap_cvvpopup_info")!, lineSpacing: 5)
        self.cardNumberLabel.text(IAPLocalizedString("iap_cvv_code")! + self.paymentDetails.getCardType() + " " + self.paymentDetails.getCardnumber(), lineSpacing: 5)
        self.cvvView.layer.cornerRadius = 4.0
        self.cvvShadowView.isHidden = false
        self.cvvContainerView.isHidden = false
    }

    @IBAction func tappedOnCVVView(_ sender: Any) {
        cvvTextField.resignFirstResponder()
    }

    @IBAction func tappedOutsideCVVView(_ sender: AnyObject) {
        if !cvvTextField.isFirstResponder {
            cancelCVVView()
        } else {
            cvvTextField.resignFirstResponder()
        }
    }
    
    func cancelCVVView()  {
        cvvTextField.resignFirstResponder()
        self.cvvContainerView.isHidden = true
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              willShowViewController viewController: UIViewController, animated: Bool) {
        self.handleSwipeLeftToRight(navigationController, willShowViewController: viewController, animated: animated)
    }
    
    @IBAction func proceedToPayment() {
        guard (cvvTextField.text?.length)! > 0 else {
            return
        }
        self.cvvUsed = self.cvvTextField.text!
        self.makePayment()
    }
    

    @IBAction func cancelPayment() {
        cancelCVVView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn
        range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 4
    }

    // MARK: -
    // MARK: Hybris occ api calls
    
    fileprivate func sendRequestToSubmitOrder() {
        super.startActivityProgressIndicator()
        IAPCartSyncHelper().submitOrderForUser(self.cvvUsed, success: { (orderinfo: IAPOrderInfo) -> Void in
            if self.isFirstTimeUser == true {
                super.startActivityProgressIndicator()
                IAPAddressSyncHelper().updateDeliveryAddress(self.shippingAddress, isDefaultAddress: true,
                                                             success: { (inSuccess: Bool) -> () in
                                                                super.stopActivityProgressIndicator()
                                                                self.paymentOrderId = orderinfo.getOrderId()
                                                                self.sendRequestToMakePayment(orderinfo.getOrderId())
                }) { (inError: NSError) -> () in
                    super.stopActivityProgressIndicator()
                    super.displayErrorMessage(inError)
                }
            } else {
                super.startActivityProgressIndicator()
                IAPAddressSyncHelper().updateDeliveryAddress(self.shippingAddress, isDefaultAddress:true,
                                                             success: { (inSuccess: Bool) -> () in
                                                                super.stopActivityProgressIndicator()
                                                                self.pushConfirmationScreen(orderinfo.getOrderId())
                }) { (inError: NSError) -> () in
                    super.stopActivityProgressIndicator()
                    super.displayErrorMessage(inError)
                }
            }
        }) { (inError: NSError) -> () in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }

    fileprivate func sendRequestToMakePayment(_ orderId: String) {
        super.startActivityProgressIndicator()
        IAPCartSyncHelper().makePaymentForUser(orderId, inAddress: self.billingAddress,
                                               success: { (paymentInfo: IAPMakePaymentInfo) -> () in
                                                super.stopActivityProgressIndicator()
                                                guard paymentInfo.worldPayURL == "" else {
                                                    self.pushToWorldpayScreen(orderId, paymentInfo: paymentInfo)
                                                    return
                                                }
                                                let uidOkAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                                                                      style: .primary,
                                                                                      handler: { (uidAction) in
                                                                                        self.uidAlertController?.dismiss(animated: true,
                                                                                                                         completion: nil)
                                                })
                                                super.displayDLSAlert(IAPLocalizedString("iap_server_error"),
                                                                      withMessage: IAPLocalizedString("iap_something_went_wrong"),
                                                                      firstButton: uidOkAction,
                                                                      secondButton: nil,
                                                                      usingController: self,
                                                                      viewTag: IAPConstants.IAPAlertViewTags.kApologyAlertViewTag)
        }) {(inError: NSError) -> () in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }

    func pushToWorldpayScreen(_ orderId: String, paymentInfo: IAPMakePaymentInfo) {
        let worldPayVC = IAPWorldPayViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        worldPayVC.worldPayURL = paymentInfo.worldPayURL
        worldPayVC.orderID = orderId
        worldPayVC.delegate = self
        worldPayVC.cartIconDelegate = self.cartIconDelegate
        self.navigationController?.pushViewController(worldPayVC, animated: true)
        
        trackAction(parameterData: ["deliveryMethod": "UPSParcel"], action: IAPAnalyticsConstants.sendData)
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "newBillingAddressAdded"], action: IAPAnalyticsConstants.sendData)
    }

    func pushConfirmationScreen(_ orderId: String) {
        super.notifyCartDelegateOfCartCountChange()
        let confirmationVC = IAPPaymentConfirmationViewController.instantiateFromAppStoryboard(appStoryboard: .worldPay)
        confirmationVC.orderNo = orderId
        confirmationVC.delegate = self
        confirmationVC.paymentStatusTag = IAPConstants.IAPPaymentResponseStatus.kPaymentSuccessTag
        confirmationVC.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
    
    // MARK: IAPWorldPayProtocol delegate
    func navigateToParentFlowScreen(_ inSender: AnyObject, statusTag: Int) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: PAYMENT_SUCCESS_NOTIFICATION), object: self.navigationController)
    }
    
    // MARK: -
    // MARK: IAPWorldPayDelegate method
    func navigateToOrderSummaryScreen(_ isNavigationFromWorldPay:Bool,orderId:String) {
        self.isFromWorldPay = isNavigationFromWorldPay
        self.paymentOrderId = orderId
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    // MARK: -
    // MARK: UI element style formatting
    fileprivate func getDisplayTextWithAddress(_ inAddress: IAPUserAddress) -> NSMutableAttributedString {
        if inAddress.formattedAddress == nil {
            self.setFormattedAddress(inAddress)
            return inAddress.getDisplayTextForAddress(true)
        } else {
            return inAddress.getDisplayTextForAddress(true)
        }
    }

    fileprivate func setFormattedAddress(_ inAddress: IAPUserAddress) {
        inAddress.countryName = shippingAddress.countryName //Setting country name in billing address as it is not coming
        inAddress.formattedAddress = inAddress.createFormattedString()
    }
    
    fileprivate func styleSubViews() {
        self.shoppingTableView.rowHeight = UITableView.automaticDimension
        self.shoppingTableView.estimatedRowHeight = IAPConstants.IAPOrderSummaryConstants.kRowHeightConstant
    }
}

// MARK: IAPOrderSummaryViewController Extension

extension IAPOrderSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Tableview data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.productList.count > 0 {
            return 8//self.productList.count + IAPShoppingCartCells.kAccessoryCartCell
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case IAPConstants.TableviewSectionConstants.kShoppingCartSection,IAPConstants.TableviewSectionConstants.kOrderSummarySection:
            return self.productList.count
        case IAPConstants.TableviewSectionConstants.kVoucherDiscountSection:
            if let voucherList = cartInfo.voucherDiscounts?.voucherList, voucherList.count > 0 {
                return voucherList.count
            }
            return 0
        case IAPConstants.TableviewSectionConstants.kOrderDiscountSection:
            if let orderDiscountList = cartInfo.orderDiscounts?.orderDiscountList, orderDiscountList.count > 0 {
                return orderDiscountList.count
            }
            return 0
        case IAPConstants.TableviewSectionConstants.kShippingCostSection:
            let shippingRowCount = cartInfo.deliveryModeName == nil ? 0 : 1
            return shippingRowCount
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewList = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPPurchaseHistoryOverviewSectionHeader,
                                                                       owner: self,
                                                                       options: nil),
        let headerView = headerViewList[0] as? IAPPurchaseHistoryOverviewSectionHeader else {
            return nil
        }

        let headerViewCommonView =
            IAPUtility.commonViewForHeaderInSection(IAPConstants.IAPCommonSectionHeaderView.kOrderSummarySection,
                                                             sectionValue: section,
                                                             productCount: self.productList.count,
                                                    headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
        return headerViewCommonView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == IAPConstants.TableviewSectionConstants.kShoppingCartSection ||
            section == IAPConstants.TableviewSectionConstants.kAddressCellSection ||
            section == IAPConstants.TableviewSectionConstants.kOrderSummarySection {
            let heightForHeader: CGFloat = self.tableView(tableView, numberOfRowsInSection: section) < 1 ? 0 : 48.0
            return heightForHeader
        }
        
        return 0
    }

    func getCartProductCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.productCell) as? IAPCartProductCell {
            cell.configureUIWithModel(self.productList[indexPath.row])
            cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }

    func getAddressCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.AddressCell, for: indexPath) as? IAPOrderSummaryAddressTableCell {
            cell.headerLabel.text = IAPLocalizedString("iap_shipping_address")
            let addressToBeUsed = self.getDisplayTextWithAddress(self.shippingAddress)
            cell.headerTitleLabel.attributedText = addressToBeUsed
            cell.billingHeaderLabel.text = IAPLocalizedString("iap_billing_address")
            cell.billingAddressLabel.attributedText = self.getDisplayTextWithAddress(self.billingAddress)
            cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }

    func getOrderSummaryCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IPAPurchaseHistoryOrderSummaryCustomCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.summaryCustomCell)
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.summaryCustomCell, for: indexPath) as? IPAPurchaseHistoryOrderSummaryCustomCell {
            let productModel = self.productList[indexPath.row]
            cell.totalItemsAndItemNameLabel?.text = "\(productModel.getQuantity())" + "x " + "\(productModel.getProductTitle())"
            cell.totalPriceLabel?.text = productModel.getTotalPrice()
            if indexPath != IndexPath(row: 0, section: 3) {
                cell.topConstraint.constant = 8
            } else {
                cell.topConstraint.constant = 16
            }
            cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }

    func getOrderDetailSummaryCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryOrderDetailsPriceSummaryCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell)
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell,
            for: indexPath) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell {
            cell.updateWithUIForOrderSummary(cartInfo: self.cartInfo)
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func getShippingCostDisplayCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
            if cartInfo.deliveryModeName != nil {
                cell.orderDetailsNameLabel?.text = IAPLocalizedString("iap_shipping_cost")
                cell.orderDetailsValueLabel?.text = cartInfo.shippingCost
            } else {
                cell.orderDetailsNameLabel?.isHidden = true
                cell.orderDetailsValueLabel?.isHidden = true
            }
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    
    
    func getOrderPromotionDiscountCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
            
            if let orderPromotions = cartInfo.orderDiscounts?.orderDiscountList, orderPromotions.count > 0  {
                let orderPromotionDetails = orderPromotions[indexPath.row]
                cell.orderDetailsNameLabel.text = orderPromotionDetails.orderDiscountDescription
                cell.orderDetailsValueLabel.text = "- \(orderPromotionDetails.orderDiscountValue ?? "0.00")"
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }
    
    func getVoucherDiscountCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
            
            if let vouchers = cartInfo.voucherDiscounts?.voucherList, vouchers.count > 0  {
                let voucherDetails = vouchers[indexPath.row]
                cell.orderDetailsNameLabel.text = voucherDetails.voucherName
                cell.orderDetailsValueLabel.text = "- \(voucherDetails.discountAmount ?? "0.00")"
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case IAPConstants.TableviewSectionConstants.kShoppingCartSection:
            return getCartProductCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kAddressCellSection:
            return getAddressCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kDeliveryModeSection:
            if let cell = self.shoppingTableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.shippingCostCell)! as? IAPCartShippingCostCell {
                if let deliveryModeName = self.cartInfo.deliveryModeName {
                    cell.shippingCostLbl.text = IAPLocalizedString("iap_delevery_via", deliveryModeName) ?? ""
                }
                cell.shippingPriceLbl.text = self.cartInfo.freeDelivery
                cell.deliveryModeLbl.text = self.cartInfo.deliveryModeDescription
                cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
                cell.isUserInteractionEnabled = false
                cell.arrowButton.isHidden = true
                return cell
            } else {
                return UITableViewCell(frame: .zero)
            }
        case IAPConstants.TableviewSectionConstants.kOrderSummarySection:
            return getOrderSummaryCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kShippingCostSection:
            return getShippingCostDisplayCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kVoucherDiscountSection:
            return getVoucherDiscountCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kOrderDiscountSection:
            return getOrderPromotionDiscountCell(tableView: tableView, indexPath: indexPath)
        case IAPConstants.TableviewSectionConstants.kTotalCellSection:
            let orderDetailsCell = getOrderDetailSummaryCell(tableView: tableView, indexPath: indexPath) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell
            orderDetailsCell?.deliveryParcelTextLabel?.isHidden = true
            orderDetailsCell?.deliveryParcelValueLabel?.isHidden = true
            return orderDetailsCell ?? UITableViewCell(frame: .zero)
        default:
            guard let totalCell = IAPUtility.getTotalCell(self.shoppingTableView,
                                                    withTotal: self.cartInfo.totalPriceWithTax,
                                                    withItems: self.cartInfo.totalItems) as? IAPCartTotalCell else {
                                                        return UITableViewCell(frame: .zero)
            }
            totalCell.inclusiveVATLabel.text = IAPLocalizedString("iap_including_vat")
            totalCell.vatPriceLabel.text = self.cartInfo.vatTotal
            return totalCell
        }
    }

    // MARK: Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == IAPConstants.TableviewSectionConstants.kShoppingCartSection {
            let productModel = self.productList[indexPath.row]

            let productDetailViewController = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
            productDetailViewController.iapHandler = self.iapHandler
            productDetailViewController.productInfo = productModel
            productDetailViewController.cartIconDelegate = self.cartIconDelegate
            productDetailViewController.isFromPurchaseHistoryOrderDetailView = true
            tableView.deselectRow(at: indexPath, animated: false)
            self.navigationController?.pushViewController(productDetailViewController, animated: true)

        }
    }
}
