/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS
import PhilipsIconFontDLS

class IAPShoppingCartViewController: IAPBaseViewController, IAPShoppingDecoratorProtocol,
IAPProductAndHistoryProtocol {
    
    @IBOutlet weak var shoppingCartTblView: UITableView!
    @IBOutlet weak var checkoutBtn: UIDButton?
    @IBOutlet weak var continueShoppingBtn: UIDButton?
    @IBOutlet weak var noItemsLabel: UIDLabel?
    @IBOutlet weak var lblAlert: UIDLabel!
    @IBOutlet weak var noProductView: UIView!
    @IBOutlet weak var lblNoProductTitle: UIDLabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var continueShoppingButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!

    var decorator: IAPShoppingCartDecorator!
    var cartDatasource: IAPShoppingCartDataSource!
    var productCTN: String = ""
    var failureHandler: (NSError)->Void = { arg in }
    var initialBottomConstraintForContinueShoppingButton: CGFloat?
    let kSpacingBetweenNoItemsLabelAndContinueButton: CGFloat = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViewSetUp()
        self.cartDatasource         = IAPShoppingCartDataSource()
        self.decorator              = IAPShoppingCartDecorator(withTableView: self.shoppingCartTblView)
        self.decorator.delegate     = self
        lblAlert.textColor          = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
        lblAlert.font               = UIFont.iconFont(size: 22.0)
        lblAlert.text               = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        noProductView?.isHidden     = true
        headerView.backgroundColor  = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(IAPShoppingCartViewController.refreshCartTableView),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kShoppingCartPageName)
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "shoppingCartView"], action: IAPAnalyticsConstants.sendData)
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        IAPUtility.setIAPPreference({[weak self] (inSuccess) in
            self?.initialiseAndLoadData()
        }) { (inError) in
            super.displayErrorMessage(inError)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:
    // MARK: No internet related methods
    // MARK:
    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.initialiseAndLoadData()
    }
    
    func fetchDataForPage(_ : Int) {
        guard 0 == self.productCTN.length else {
            self.iapHandler?.getCartState().buyProduct(self.productCTN, success: { (inSuccess:Bool) in
                self.removeNoInternetView()
                self.refreshCartTableView()
            }, failureHandler:{ (inError:NSError) in
                self.failureHandler(inError)
            })
            return
        }
        self.refreshCartTableView()
    }
    
    // MARK:
    // MARK: Private methods
    // MARK:
    fileprivate func initializeViewSetUp() {
        self.navigationItem.title = IAPLocalizedString("iap_shopping_cart")
        self.initialBottomConstraintForContinueShoppingButton = self.continueShoppingButtonBottomConstraint.constant
    }
    
    fileprivate func updateUI(_ withPRoductList: [IAPProductModel]) {
        DispatchQueue.main.async(execute: { () -> Void in
            if(withPRoductList.count == 0) {
                self.updateUIForEmptyCart()
            } else {
                self.updateUIForNonEmptyCart()
            }
            self.shoppingCartTblView.reloadData()
        })
    }
    
    func updateUIForEmptyCart() {
        self.noItemsLabel?.isHidden = false
        noProductView?.isHidden = false
        self.checkoutBtn?.isHidden = true
        self.continueShoppingBtn?.isHidden = false
        self.continueShoppingButtonBottomConstraint.constant = self.view.frame.size.height - self.noItemsLabel!.center.y - kSpacingBetweenNoItemsLabelAndContinueButton
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func updateUIForNonEmptyCart() {
        noProductView?.isHidden = true
        self.noItemsLabel?.isHidden = true
        self.continueShoppingBtn?.isHidden = false
        self.checkoutBtn?.isHidden = false
        self.continueShoppingButtonBottomConstraint.constant = self.initialBottomConstraintForContinueShoppingButton!
    }
    
    func navigateToAddressSelectionView() {
        let shippingViewController = IAPShippingAddressSelectionViewcontroller.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingViewController.cartInfo = self.decorator.shoppingCartInfo
        shippingViewController.productList = self.decorator.productList
        shippingViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingViewController, animated: true)
    }
    
    func navigateToShippingAddressEditView() {
        let shippingAddressEditViewController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        shippingAddressEditViewController.cartInfo = self.decorator.shoppingCartInfo
        shippingAddressEditViewController.productList = self.decorator.productList
        shippingAddressEditViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(shippingAddressEditViewController, animated: true)
    }
    
    // MARK: Cart related methods
    @objc func refreshCartTableView() {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        super.startActivityProgressIndicator()
        self.refetchCartAgain { (completion) in }
    }
    
    func refetchCartAgain(completion: @escaping (Bool) -> ()) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            displayNoNetworkError()
            return
        }
        startActivityProgressIndicator()
        cartDatasource.getCartInformation(decorator.productList, success:{[weak self] (inSuccess, withObject, withProductList) -> () in
            completion(true)
            guard let weakSelf = self else { return }
            if inSuccess {
                weakSelf.checkoutBtn?.isEnabled = true
                weakSelf.decorator.shoppingCartInfo = withObject
                weakSelf.decorator.productList = withProductList
                if
                    let voucherId = IAPConfiguration.sharedInstance.voucherId,
                    withProductList.count > 0 {
                    weakSelf.autoApplyVoucher(voucherCode: voucherId)
                }
            } else {
                weakSelf.decorator.productList.removeAll()
            }
            weakSelf.updateUI(weakSelf.decorator.productList)
            weakSelf.removeNoInternetView()
            weakSelf.sendProductListAnalytics()
            weakSelf.stopActivityProgressIndicator()
        }) {[weak self] (inError:NSError) -> Void in
            completion(true)
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            if inError.domain == IAPConstants.IAPCartError.kNoCartError {
                weakSelf.decorator.productList.removeAll()
                weakSelf.updateUI(weakSelf.decorator.productList)
            } else {
                weakSelf.displayErrorMessage(inError, shouldDisplayNoInternetView: (0 == weakSelf.decorator.productList.count))
            }
        }
    }
    
    func autoApplyVoucher(voucherCode: String) {
        startActivityProgressIndicator()
        IAPConfiguration.sharedInstance.voucherId = nil
        let cartHelper = IAPCartSyncHelper()
        cartHelper.applyVoucher(voucherID: voucherCode, success: { [weak self] (inSuccess:Bool) in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            weakSelf.refetchCartAgain(completion: { (completed) in })
        }) {[weak self] (_) in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
        }
    }

    // Mark: IAPShoppingDecoratorProtocol
    func updateQuantity(_ objectToBeUpdated: IAPProductModel, withCartInfo: IAPCartInfo, quantityValue: Int) {
        super.startActivityProgressIndicator()
        self.cartDatasource.product   = objectToBeUpdated
        self.cartDatasource.cartInfo  = withCartInfo
        self.cartDatasource.quantity  = quantityValue
        var anlyticsParamValue:String = "productRemoved"
        if quantityValue != objectToBeUpdated.getQuantity() {
            if quantityValue > objectToBeUpdated.getQuantity() {
                anlyticsParamValue = "scAdd"
            }
            trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: anlyticsParamValue], action: IAPAnalyticsConstants.sendData)
        }
        self.cartDatasource.updateQuantity({ (inSuccess:Bool) -> Void in
            self.refetchCartAgain(completion: { (completed) in
                self.notifyCartDelegateOfCartCountChange()
            })
            
        }) { (inError:NSError) -> Void in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }
    
    func adjsutView(_ shouldEnable: Bool) {
        self.checkoutBtn?.isEnabled = shouldEnable
    }

    func pushDetailView(_ withObject: IAPProductModel) {
        let productDetailViewController = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        productDetailViewController.productInfo = withObject
        productDetailViewController.shoppingCartInfo = self.decorator.shoppingCartInfo
        productDetailViewController.iapHandler = self.iapHandler
        productDetailViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func displayDeliveryModeView() {
        let deliveryVC = IAPDeliveryModeViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        deliveryVC.cartIconDelegate = self.cartIconDelegate
        deliveryVC.deliveryModeName  = self.decorator.shoppingCartInfo.deliveryModeName
        navigationController?.pushViewController(deliveryVC, animated: true)
    }
    
    func displayVoucherView() {
        let voucherVC = IAPVoucherViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        self.navigationController?.pushViewController(voucherVC, animated: true)
    }
    
    @IBAction func checkOutClicked(_ sender: AnyObject) {
        guard shouldAllowCheckout() else {
            let okAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary)
            displayDLSAlert(IAPLocalizedString("iap_shopping_cart"), withMessage: String(format:IAPLocalizedString("iap_cart_count_exceed_message") ?? "",IAPConfiguration.sharedInstance.maximumCartCount), firstButton: okAction, secondButton: nil, usingController: nil, viewTag: 1)
            return
        }
        super.startActivityProgressIndicator()
        IAPAddressSyncHelper().getDeliveryAddressesForUser({ (inAdress: IAPUserAddressInfo) -> () in
            super.stopActivityProgressIndicator()
            if inAdress.address.count > 0 {
                self.navigateToAddressSelectionView()
            } else {
                self.navigateToShippingAddressEditView()
            }
        }) {(inError:NSError) -> Void in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
        
        guard self.decorator.shoppingCartInfo.shippingCost != nil else {
            return
        }
        let rawShippingCost:String = String(self.decorator.shoppingCartInfo.shippingCost.dropFirst())
        rawShippingCost == "0.00" ? trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "freeDelivery"], action: IAPAnalyticsConstants.sendData) : ()
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "checkoutButtonSelected"], action: IAPAnalyticsConstants.sendData)
    }
    
    func shouldAllowCheckout() -> Bool {
        let maximumCartCount = IAPConfiguration.sharedInstance.maximumCartCount
        let actualCartCount = decorator.shoppingCartInfo.totalUnitCount ?? 0
        
        if maximumCartCount > 0 && actualCartCount > maximumCartCount {
            return false
        }
        return true
    }
    
    @IBAction func continueShoppingClicked(_ sender: AnyObject) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        super.updateCartIconVisibility(true)
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "continueShoppingSelected"], action: IAPAnalyticsConstants.sendData)
        self.navigationController?.popToProductCatalogue(self, withCartDelegate: self.cartIconDelegate,
                                                         withInterfaceDelegate: self.iapHandler)
    }
    
    //Mark: Analytics methods
    func sendProductListAnalytics() {
        guard self.decorator.productList.count>0 else { return }
        var productListForAnalytics:String = ""
        var productCount:Int = 0
        
        for product in self.decorator.productList {
            productListForAnalytics += ";" + product.getProductTitle() + ";" + String(product.getQuantity()) + ";" + product.getPriceValue()
            productCount += 1
            if productCount < self.decorator.productList.count { productListForAnalytics += "," }
        }
        trackAction(parameterData: [IAPAnalyticsConstants.product: productListForAnalytics], action: IAPAnalyticsConstants.sendData)
    }
    
    // Handling Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            if self.noProductView?.isHidden == false {
                self.continueShoppingButtonBottomConstraint.constant = self.view.frame.size.height - self.noItemsLabel!.center.y - self.kSpacingBetweenNoItemsLabelAndContinueButton
            }
        }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
            // Something after animation
        }
    }
}
