/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import AppInfra
import SafariServices

class IAPShoppingCartDetailsViewController: IAPBaseViewController,
UIDPageControlDelegate, UIGestureRecognizerDelegate, IAPUpdateQuantityTableDelegate {
    
    @IBOutlet weak var addToCartButton: UIDProgressButton!
    @IBOutlet weak var buyFromRetailerButton: UIDProgressButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    @IBOutlet weak var productTitleLabel: UIDLabel?
    @IBOutlet weak var productPriceLabel: UIDLabel?
    @IBOutlet weak var productDiscountPriceLabel: UIDLabel?
    @IBOutlet weak var productCTNNumber: UIDLabel?
    @IBOutlet weak var productOverviewLabel: UIDLabel?
    @IBOutlet weak var deleteButtonContainerView: UIView?
    @IBOutlet weak var productCatalogueDetailView: UIView?
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var pageControl: UIDPageControl!
    @IBOutlet weak var buyFromRetailerNonHybrisView: UIDView!
    @IBOutlet weak var noProductsLabel: UIDLabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var productRatingLabel: UIDLabel!
    @IBOutlet weak var stockStatusLabel: UIDLabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var productQantityView: UIView!
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var scrollViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var disclaimerLabel: UIDLabel!

    var productInfo: IAPProductModel!
    var shoppingCartInfo: IAPCartInfo!
    var isFromProductCatalogueView: Bool = false
    var isFromShoppingCartView: Bool = false
    var isFromPurchaseHistoryOrderDetailView: Bool = false
    var views = [UIViewController]()
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var imageUrlList: [String] = []
    var productCTN: String = ""
    var failureHandler: (NSError) -> Void = { arg in }
    fileprivate var iapDownloadHelper = IAPProductInfoHelper()
    fileprivate var cartSyncHelper : IAPCartSyncHelper = IAPCartSyncHelper()
    let popoverController = IAPCustomPopoverController()
    weak var delegate: IAPShoppingDecoratorProtocol?
    var retailerLoadedURL: URL?
    var selectedRetailer: IAPRetailerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.delegate = self
        self.setLabelFont()
        
        self.noProductsLabel.text = IAPLocalizedString("iap_no_product_available")
        self.deleteButtonContainerView?.isHidden = true
        self.buyFromRetailerNonHybrisView.isHidden = true
        self.productCatalogueDetailView?.isHidden = true
        IAPUtility.setIAPPreference({[weak self] (inSuccess) in
            self?.updateProductDetailView()
        }) { (inError) in
            super.displayErrorMessage(inError)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.productCTN.length == 0 else { return }
        self.updateUIForProduct()
        self.sendProductListAnalytics()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        buyFromRetailerButton.isActivityIndicatorVisible = false
        addToCartButton.isActivityIndicatorVisible = false
    }

    func updateProductDetailView() {
        guard self.productCTN.length == 0 else {
            IAPOAuthConfigurationData.isDataLoadedFromHybris() ?
                initialiseAndLoadData(false) :
                downloadInfo(productCTN)
            
            self.deleteButtonContainerView?.isHidden = true
            return
        }
        self.sendRequestToFetchDisclaimer()
        self.sendRequestToFetchProductDetailAssets()
        self.lblProductQuantity.text = IAPLocalizedString("iap_quantity",String(self.productInfo.getQuantity()))!
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(quantityViewClicked(_:)))
        gestureRecognizer.delegate = self
        productQantityView.isUserInteractionEnabled = true
        productQantityView.addGestureRecognizer(gestureRecognizer)
    }

    func updateUIForProduct() {
        self.navigationItem.title = IAPLocalizedString("iap_product_detail_title")
        guard IAPOAuthConfigurationData.isDataLoadedFromHybris() else {
            self.updateUIForNonHybris()
            return
        }
        self.updateUIForHybris()
    }
    
    func updateUIForHybris() {
        if isFromProductCatalogueView == true {
            scrollViewBottomSpaceConstraint.constant = 104.0
            let colorRange = UIDThemeManager.sharedInstance.defaultTheme?.colorRange ?? .aqua
            let tonalRange = UIDThemeManager.sharedInstance.defaultTheme?.tonalRange ?? .ultraLight
            let navigationTonalRange = UIDThemeManager.sharedInstance.defaultTheme?.navigationTonalRange ?? .bright
            let configuration = UIDThemeConfiguration(colorRange: colorRange, tonalRange: tonalRange,
                                                      navigationTonalRange: navigationTonalRange,
                                                      accentColorRange: .pink)
            let theme = UIDTheme(themeConfiguration: configuration)
                addToCartButton.theme = theme
            addToCartButton.setTitle(IAPLocalizedString("iap_add_to_cart"), for: .normal)
            buyFromRetailerButton.setTitle(IAPLocalizedString("iap_buy_from_retailers"), for: .normal)
            self.deleteButtonContainerView?.isHidden = true
            self.buyFromRetailerNonHybrisView.isHidden = true
            self.productCatalogueDetailView?.isHidden = false
            super.updateCartIconVisibility(true)
            super.applyPlainShadow(self.productCatalogueDetailView!)
            trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kProductDetailPage)
        } else {
            deleteItemButton.setTitle(IAPLocalizedString("iap_delete"), for: .normal)
            if isFromPurchaseHistoryOrderDetailView {
                self.deleteButtonContainerView?.isHidden = true
                //this condition is for shopping cart detail view from purchase history
                self.scrollViewBottomSpaceConstraint.constant = 0
            } else {
                self.deleteButtonContainerView?.isHidden = false
                //this condition is for shopping cart detail view
                scrollViewBottomSpaceConstraint.constant = 104.0
                super.applyPlainShadow(self.deleteButtonContainerView!)
                trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kShoppingCartItemDetailPageName)
            }
            self.productCatalogueDetailView?.isHidden = true
            self.buyFromRetailerNonHybrisView.isHidden = true
            super.updateCartIconVisibility(false)
            trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kShoppingCartItemDetailPageName)
        }
        /* TODO: comment this as feature is not available*/
        productRatingLabel?.isHidden = false
        ratingView?.isHidden = false
        stockStatusLabel.isHidden = true
        if !IAPUtility.isStockAvailable(stockLevelStatus: productInfo.getProductStockLevelStatus(),
                                         stockAmount: productInfo.getStockAmount()) {
            addToCartButton.isEnabled = false
            trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "outOfStock"], action: IAPAnalyticsConstants.sendData)
            if self.productInfo.getDiscountPriceValue() == self.productInfo.getPriceValue() {
                productPriceLabel?.text = IAPLocalizedString("iap_out_of_stock")
                productPriceLabel?.textColor = UIColor.color(range: .signalRed, level: .color60)
                productPriceLabel?.font = UIFont(name: "CentraleSansBook", size: 12)
                stockStatusLabel.isHidden = true
            } else {
                stockStatusLabel?.text = IAPLocalizedString("iap_out_of_stock")
                stockStatusLabel?.textColor = UIColor.color(range: .signalRed, level: .color60)
                stockStatusLabel?.isHidden = false
            }
        } else {
            self.stockStatusLabel.isHidden = true
        }
    }
    
    func updateUIForNonHybris() {
        scrollViewBottomSpaceConstraint.constant = 72.0
        self.buyFromRetailerNonHybrisView.isHidden = false
        self.deleteButtonContainerView?.isHidden = true
        self.productCatalogueDetailView?.isHidden = true
        self.productPriceLabel?.isHidden = true
        self.productDiscountPriceLabel?.isHidden = true
        self.stockStatusLabel?.isHidden = true
        self.productRatingLabel?.isHidden = true
        self.ratingView?.isHidden = true
        buyFromRetailerButton.setTitle(IAPLocalizedString("iap_buy_from_retailers"), for: .normal)
        applyShadowForContainer(buyFromRetailerNonHybrisView)
    }

    func sendRequestToFetchDisclaimer() {
        IAPPRXDataDownloader().getPRXProductDisclaimerText(self.productInfo) { (disclaimerList) in
            var alertText = ""
            for disclaimers in self.productInfo.disclaimers {
                alertText = alertText + "\n" + "-  " //+ "\u{2022}  "
                alertText = alertText + disclaimers.disclaimerText!
            }
            self.disclaimerLabel.text = alertText
        }
    }

    func sendRequestToFetchProductDetailAssets() {
        super.startActivityProgressIndicator()
        IAPPRXDataDownloader().getPRXProductDetailsAssets(self.productInfo!) {
            (successProductInfo: IAPProductModel, errorCTNList: String) -> () in
            super.removeNoInternetView()
            super.stopActivityProgressIndicator()
            self.productInfo = successProductInfo
            self.updateUI()
        }
    }
    
    func setLabelFont() {
        productTitleLabel?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        productCTNNumber?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productOverviewLabel?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        lblProductQuantity.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonQuietEmphasisText
    }
    
    func updateUI() {
        self.initializePageViewController()
        self.activityIndicatorView?.stopAnimating()
        self.pageControl.isHidden = !(self.imageUrlList.count > 0)
        self.productTitleLabel?.text = self.productInfo.getProductTitle()
        self.productOverviewLabel?.text = self.productInfo.getProductDescription()
        self.productCTNNumber?.text = self.productInfo.getProductCTN()
        
        if self.productInfo.getProductDescription().isEmpty {
            let taggingMessage = getCustomErrorTaggingMessageWithCTN("PRX", message: "ProductDescriptionMissing")
            trackAction(parameterData: ["error": taggingMessage], action: IAPAnalyticsConstants.sendData)
        }
        guard self.productInfo.getDiscountPrice().isEmpty else {
            guard self.isFromProductCatalogueView == true &&
                self.productInfo.getDiscountPriceValue() != self.productInfo.getPriceValue() else {
                self.productDiscountPriceLabel?.text = self.productInfo.getDiscountPrice()
                return
            }
            self.productDiscountPriceLabel?.text = self.productInfo.getDiscountPrice()
            self.productPriceLabel?.attributedText = IAPUtility.getStrikeThroughAttributedText(self.productInfo.getTotalPrice())
            return
        }
        self.productDiscountPriceLabel?.text = self.productInfo.getProductBasePriceValue()
        self.productPriceLabel?.isHidden = true
    }

    func initializePageViewController() {

        guard let imageUrls = (self.productInfo!.getProductDetailURLS() as NSArray).value(forKey: "asset") as? [String] else {
            return
        }
        self.imageUrlList = imageUrls

        guard self.imageUrlList.count > 0 else {
            self.setUpPageViewController(true)
            guard self.productInfo.getDetailFetchError() != nil else { return }
            let taggingMessage = getCustomErrorTaggingMessageWithCTN("PRX", message: "NoImagesFound")
            trackAction(parameterData: ["error": taggingMessage], action: IAPAnalyticsConstants.sendData)
            return
        }
        self.setUpPageViewController()
    }
    
    fileprivate func setUpPageViewController(_ withError: Bool = false) {
        guard withError == false else {
            guard let contentController = self.getPageContentViewController(0, withImageURL:"", isError: withError) else { return }
            views.append(contentController)
            self.setUpPageControl()
            return
        }
        
        for imageIndex in 0..<self.imageUrlList.count {
            guard let contentController = self.getPageContentViewController(imageIndex,
                                                                            withImageURL: self.imageUrlList[imageIndex],
                                                                            isError: withError) else { continue }
            views.append(contentController)
        }
        self.setUpPageControl()
    }
    
    fileprivate func setUpPageControl() {
        pageViewController = self.children[0] as? UIPageViewController
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        pageViewController?.setViewControllers([views[0]], direction: .forward, animated: true, completion: nil)
        pageControl?.numberOfPages = views.count
    }
    
    fileprivate func getPageContentViewController(_ withIndex: Int,
                                                  withImageURL: String = "",
                                                  isError: Bool) -> IAPPageContentViewController? {
        if let pageContentViewController = self.storyboard?.instantiateViewController(
            withIdentifier: "IAPPageContentViewController") as? IAPPageContentViewController {
            pageContentViewController.containerHeight = self.container.frame.size.height
            pageContentViewController.containerWidth = self.container.frame.size.width
            pageContentViewController.index  = withIndex
            pageContentViewController.imageUrlString = withImageURL
            pageContentViewController.isErrorToBeShown = isError
            return pageContentViewController
        }
        return nil
    }

    /*
     * TODO: code refactoring is required for cart state handling. Once placing order with existing address and new
     billing address, cart state is not changing to IAPNoCartState. Its in IAPCartCreatedState.
     */
    func addProductToEmptyCart() {
        self.iapHandler?.getCartState().buyProduct(self.productInfo.getProductCTN(), success: { (inSuccess: Bool) -> Void in
            self.sendAddAnalytics()
            self.hideProgressIndicatorOnButton(self.addToCartButton)
            if let shoppingCtlr = IAPUtility.getShoppingCartController(self.cartIconDelegate,
                                                                       withInterfaceDelegate: self.iapHandler) {
                self.navigationController?.pushViewController(shoppingCtlr, animated: true)
            }
        }) { (inError: NSError) in
            self.hideProgressIndicatorOnButton(self.addToCartButton)
            super.displayErrorMessage(inError)
        }
    }
    
    func sendAddAnalytics() {
        let infoDict: NSMutableDictionary = [:]
        infoDict.setValue(self.productInfo.getPriceValue(), forKey: "originalPrice")
        infoDict.setValue(self.productInfo.getDiscountPriceValue(), forKey: "discountedPrice")

        if let userInfoDict = infoDict as NSDictionary as? [AnyHashable: Any] {
            if let userDict = userInfoDict as? [String : Any] {
                trackAction(parameterData: userDict, action: IAPAnalyticsConstants.sendData)
            }
            trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "scAdd"], action: IAPAnalyticsConstants.sendData)
        }
    }
    
    override func didTapTryAgain() {
        super.didTapTryAgain()
        super.removeNoInternetView()
        self.downloadInfo(self.productCTN)
    }
    
    fileprivate func fetchRetailers() {
        let retailerInterface = IAPRetailerInterface(inProductCode: self.productInfo.getProductCTN(),
                                                     inLocale: IAPConfiguration.sharedInstance.locale!)
        let httpInterface = retailerInterface.getInterfaceForRetailers()
        retailerInterface.getRetailersInfoForProduct(httpInterface, completionHandler: { (withRetailers) -> Void in
            self.processRetailerResponseFromWTB(withRetailers)
        }){ (inError: NSError) -> () in
            super.displayErrorMessage(inError, shouldDisplayNoInternetView: false,
                                      needToPopOnTap: false, serverType: "WTB")
            self.hideProgressIndicatorOnButton(self.buyFromRetailerButton)
        }
    }
    
    func processRetailerResponseFromWTB(_ withRetailers: [IAPRetailerModel]) {
        self.hideProgressIndicatorOnButton(self.buyFromRetailerButton)
        guard withRetailers.count > 0 else {
            self.showAlertForNoRetailers()
            return
        }
        let retailerListToIgnore = IAPConfiguration.sharedInstance.getBlackListRetailers()
        if retailerListToIgnore.count > 0 {
            let filterRetailerList:[IAPRetailerModel] = self.filterOutBlackListedRetailers(retailerListToIgnore,
                                                                                actualRetailerModelList: withRetailers)
            guard filterRetailerList.count > 0 else {
                self.showAlertForNoRetailers()
                return
            }
            self.pushToRetailerScreen(filterRetailerList)
        } else {
            self.pushToRetailerScreen(withRetailers)
        }
        super.removeNoInternetView()
    }
    
    /*
     * If retailer array contains more than one then show retailer list
     * If retailer array contains only one value and it is Philips site then directly launch webview
     * If retailer array contains only one value and it's not philips one then show retailer list view
     */
    func pushToRetailerScreen(_ inRetailers: [IAPRetailerModel]) {
        guard inRetailers.count == 1 && inRetailers[0].isPhilipsStore == "Y"  else {
            self.loadRetailerScreen(inRetailers)
            return
        }
        self.loadRetailerWebView(inRetailers[0])
    }
    
    func loadRetailerWebView(_ inRetailer: IAPRetailerModel) {
        if let retailerBuyURL = inRetailer.buyURL {
            if let retailerURL = URL(string: retailerBuyURL){
                let safariVC = SFSafariViewController(url:retailerURL)
                safariVC.preferredBarTintColor = UINavigationBar.appearance().barTintColor
                safariVC.preferredControlTintColor = UINavigationBar.appearance().tintColor
                safariVC.delegate = self
                selectedRetailer = inRetailer
                let stockStatus = inRetailer.isProductAvailabile ? IAPAnalyticsConstants.available : IAPAnalyticsConstants.outOfStock
                
                trackAction(parameterData: [IAPAnalyticsConstants.product: IAPUtility.prepareProductString(products: [productInfo]),
                                            IAPAnalyticsConstants.retailerName: "Philips",
                                            IAPAnalyticsConstants.stockStatus: stockStatus], action: IAPAnalyticsConstants.sendData)
                
                self.navigationController?.present(safariVC, animated: true, completion:{
                })
            }
        }
    }
    
    fileprivate func loadRetailerScreen(_ retailerList: [IAPRetailerModel]) {
        let retailerViewController = IAPRetailerViewController.instantiateFromAppStoryboard(appStoryboard: .retailer)
        retailerViewController.retailers = retailerList
        retailerViewController.product = productInfo
        retailerViewController.cartIconDelegate = self.cartIconDelegate
        navigationController?.pushViewController(retailerViewController, animated: true)
    }
    
    fileprivate func downloadInfo(_ forProduct: String) {
        super.startActivityProgressIndicator()

        self.iapDownloadHelper.fetchDetailsOfProducts([self.productCTN], completion: { (withProducts, failedProducts) in
            guard withProducts.count > 0 else {
                super.stopActivityProgressIndicator()
                self.handleErrors(failedProducts)
                let taggingMessage = self.getCustomErrorTaggingMessageWithCTN("PRX", message: "NoProductFound")
                self.trackAction(parameterData: ["error": taggingMessage], action: IAPAnalyticsConstants.sendData)
                return
            }
            IAPPRXDataDownloader().getProductInformationFromPRX(withProducts, completion: { (withProducts: [IAPProductModel]) in
                super.stopActivityProgressIndicator()
                guard let productModel = withProducts.first else { return }
                guard productModel.getProductTitle() != "" else {
                    super.stopActivityProgressIndicator()
                    self.noProductsLabel.isHidden = false
                    return
                }
                self.productInfo = productModel
                self.updateUIForProduct()
                self.sendRequestToFetchDisclaimer()
                self.sendRequestToFetchProductDetailAssets()
                self.sendProductListAnalytics()
            })
        }) { (inError: NSError) in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError, shouldDisplayNoInternetView: true,
                                      needToPopOnTap: false,
                                      serverType: "PRX")
        }
    }

    fileprivate func handleErrors(_ inErrors: [NSError]) {
        let objectsNotFound = inErrors.filter ({ $0.code == IAPConstants.IAPNoInternetError.kServerNotReachable})
        guard objectsNotFound.count == inErrors.count else { self.noProductsLabel.isHidden = false; return }
        let error = NSError(domain: NSURLErrorDomain,
                            code: IAPConstants.IAPNoInternetError.kServerNotReachable,
                            userInfo: nil)
        super.displayErrorMessage(error, shouldDisplayNoInternetView: true)
    }

    @objc func quantityViewClicked(_ sender: UIGestureRecognizer!) {
        guard let view = sender.view else {
            return
        }
        let productQuantity = self.productInfo.getStockAmount()
        //Table view is to be presentingViewController
        if productQuantity > 0 {
            let presentingViewController = IAPQuantityTableViewController()
            presentingViewController.setProductTotalQuantity(productQuantity)
            let indexPath = IndexPath(row: 0, section: 0)
            presentingViewController.selectedProductIndexPath = indexPath
            presentingViewController.delegate = self
            let popOverViewHeight = presentingViewController.popOverViewHeight
            self.popoverController.popOverMenuOnItem(view.subviews.first!,
                                                     presentationController: presentingViewController,
                                                     presentingController: self,
                                                     preferredContentSize: CGSize(width: 80, height: popOverViewHeight))
        }
    }

    //MARK: -
    //MARK: IAPUpdateQuantityTableDelegate
    func controllerDidSelectQuantity(_ quantity: NSInteger,
                                     selectedProductIndexPath: IndexPath,
                                     tableViewController: UITableViewController) {
        let presentedViewController: UIViewController = tableViewController.presentationController!.presentingViewController
        presentedViewController.dismiss(animated: false) {

            let cartDatasource = IAPShoppingCartDataSource()
            cartDatasource.product     = self.productInfo
            cartDatasource.cartInfo    = self.shoppingCartInfo
            cartDatasource.quantity    = quantity

            cartDatasource.updateQuantity({ (inSuccess: Bool) -> () in
                super.notifyCartDelegateOfCartCountChange()
                self.lblProductQuantity.text = IAPLocalizedString("iap_quantity", String(quantity))!
            }) { (inError: NSError) -> () in
                super.stopActivityProgressIndicator()
                super.displayErrorMessage(inError)
            }
        }
    }
}

extension IAPShoppingCartDetailsViewController {

    // MARK: Button action methods
    @IBAction func addToCartClicked(_ sender: AnyObject) {
        guard let senderButton = sender as? UIDProgressButton else {
            return
        }
        guard IAPConfiguration.sharedInstance.getUDInterface()?.loggedInState() == .userLoggedIn else {
            let okAction = UIDAction(title: IAPLocalizedString("iap_ok"), style: .primary)
            
            displayDLSAlert(IAPLocalizedString("iap_shopping_cart"), withMessage: IAPLocalizedString("iap_cart_login_error_message"), firstButton: okAction, secondButton: nil, usingController: nil, viewTag: 1)
            return
        }
        showProgressIndicatorOnButton(senderButton)
        self.iapHandler?.buyProduct(self.productInfo.getProductCTN(), success: {[weak self] (inSuccess: Bool) in
            guard let weakSelf = self else { return }
            weakSelf.hideProgressIndicatorOnButton(senderButton)
            weakSelf.sendAddAnalytics()
            weakSelf.trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "scAdd"], action: IAPAnalyticsConstants.sendData)
            if let shoppingCtlr = IAPUtility.getShoppingCartController(weakSelf.cartIconDelegate,
                                                                       withInterfaceDelegate: weakSelf.iapHandler) {
                weakSelf.navigationController?.pushViewController(shoppingCtlr, animated: true)
            }
        }) {[weak self] (inError: NSError) in
            guard let weakSelf = self else { return }
            if inError.localizedDescription == IAPConstants.IAPCartError.kNoCartError {
                weakSelf.iapHandler?.setCartState(IAPNoCartState())
                weakSelf.cartSyncHelper.createCartWithProduct(ProductInfo(productCTN: weakSelf.productInfo.getProductCTN(), quantity: 1)!, success: {[weak self] (inSuccess: Bool) -> () in
                    guard let weakSelf = self else { return }
                    weakSelf.hideProgressIndicatorOnButton(weakSelf.addToCartButton)
                    if let shoppingCtlr = IAPUtility.getShoppingCartController(weakSelf.cartIconDelegate,
                                                                               withInterfaceDelegate: weakSelf.iapHandler) {
                        weakSelf.navigationController?.pushViewController(shoppingCtlr, animated: true)
                        return
                    }
                    
                }) {[weak self](wasCartCreated: Bool, inError: NSError) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideProgressIndicatorOnButton(weakSelf.addToCartButton)
                    weakSelf.displayErrorMessage(inError)
                    return
                }
            } else {
                weakSelf.hideProgressIndicatorOnButton(senderButton)
                weakSelf.displayErrorMessage(inError)
            }
        }
    }

    @IBAction func buyRetailerClicked(_ sender: AnyObject) {
        guard IAPConfiguration.sharedInstance.isInternetReachable(),
            let senderButton = sender as? UIDProgressButton else {
                super.displayNoNetworkError()
                return
        }
        buyFromRetailerButton = senderButton 
        self.showProgressIndicatorOnButton(buyFromRetailerButton)
        self.fetchRetailers()
    }

    @IBAction func deleteProduct(_ sender: AnyObject) {
        let alertController = UIDAlertController(title: IAPLocalizedString("iap_delete_item_alert_title"),
                                                 icon: nil,
                                                 message: IAPLocalizedString("iap_product_remove_description")!)
        let uidCancelAction = UIDAction(title: IAPLocalizedString("iap_cancel"),
                                        style: .secondary) { (action: UIDAction!) in
                                            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(uidCancelAction)
        let OKAction = UIDAction(title: IAPLocalizedString("iap_remove_product"),
                                 style: .primary) { (action: UIDAction!) in
                                    alertController.dismiss(animated: true, completion: nil)
                                    let cartDatasource = IAPShoppingCartDataSource()
                                    cartDatasource.product     = self.productInfo
                                    cartDatasource.cartInfo    = self.shoppingCartInfo
                                    cartDatasource.quantity    = 0
                                    super.startActivityProgressIndicator()
                                    cartDatasource.updateQuantity({ (inSuccess: Bool) -> Void in
                                        super.stopActivityProgressIndicator()
                                        super.notifyCartDelegateOfCartCountChange()
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }) { (inError: NSError) -> () in
                                        super.stopActivityProgressIndicator()
                                        super.displayErrorMessage(inError)
                                    }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension IAPShoppingCartDetailsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    //TODO: check these UIPageViewControllerDelegate/UIPageViewControllerDataSource methods are required or not
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? IAPPageContentViewController else { return nil }
        let pageIndex = pageContentViewController.index + 1
        if pageIndex < views.count {
            return views[pageIndex]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? IAPPageContentViewController else { return nil }
        let pageIndex = pageContentViewController.index - 1
        if pageIndex >= 0 {
            return views[pageIndex]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard false == completed else {
            guard let view = pageViewController.viewControllers?.first else { return }
            pageControl.currentPage = views.firstIndex(of: view)!
            currentIndex = pageControl.currentPage
            return }
    }

    //MARK: Analytics methods
    func sendProductListAnalytics() {
        trackAction(parameterData: [IAPAnalyticsConstants.product:IAPUtility.prepareProductString(products: [self.productInfo]),
                                    IAPAnalyticsConstants.specialEvents: "prodView"], action: IAPAnalyticsConstants.sendData)
    }

    func showAlertForNoRetailers() {
        super.stopActivityProgressIndicator()
        let uidAction:UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                            style: .primary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
        })
        displayDLSAlert(IAPLocalizedString("iap_retailer_title_for_no_retailers"),
                        withMessage: IAPLocalizedString("iap_no_retailer_message"),
                        firstButton: uidAction,
                        secondButton: nil,
                        usingController: self,
                        viewTag: IAPConstants.IAPAlertViewTags.kNoRetailerAlertViewTage)
        let taggingMessage = getCustomErrorTaggingMessageWithCTN("WTB", message: "NoRetailersFound")
        trackAction(parameterData: ["error": taggingMessage], action: IAPAnalyticsConstants.sendData)
    }

    func getCustomErrorTaggingMessageWithCTN(_ serverName: String, message: String) -> String {
        var productCTNValue = ""
        if self.productCTN.length > 0 {
            productCTNValue = self.productCTN
        } else {
            productCTNValue = self.productInfo.getProductCTN()
        }
        return (serverName + "_" + productCTNValue + "_" + message)
    }

    // MARK: UIDPageControlDelegate method
    func pageDidChange(_ sender: UIDPageControl) {
        if sender.currentPage > currentIndex {
            pageViewController!.setViewControllers([views[sender.currentPage]], direction: .forward,
                                                   animated: true, completion: nil)
        } else {
            pageViewController!.setViewControllers([views[sender.currentPage]], direction: .reverse,
                                                   animated: true, completion: nil)
        }
        currentIndex = sender.currentPage
    }
    
    func applyShadowForContainer(_ containerView: UIDView) {
        let dropShadow = UIDDropShadow(level: .level2, theme: UIDThemeManager.sharedInstance.defaultTheme!)
        containerView.apply(dropShadow: dropShadow)
    }
    
    func filterOutBlackListedRetailers(_ ignoredRetailerList: [String],
                                       actualRetailerModelList: [IAPRetailerModel]) -> [IAPRetailerModel] {
        var notMatchingList: [String] = []
        var retailerNameList: [String] = []
        for retalierObject in actualRetailerModelList {
            let retailerName = retalierObject.retailerName
            retailerNameList.append(retailerName!)
        }
        for ignoreItem in ignoredRetailerList {
            let firstWordToSearch = ignoreItem.byWords.first
            notMatchingList = retailerNameList.filter({
                $0.range(of: firstWordToSearch!, options: .caseInsensitive) == nil
            })
            retailerNameList = notMatchingList
        }
        var filteredRetailerModelList: [IAPRetailerModel] = []
        for retailerNameValue in notMatchingList {
            for retailerModel in actualRetailerModelList {
                if retailerModel.retailerName == retailerNameValue {
                    filteredRetailerModelList.append(retailerModel)
                }
            }
        }
        return filteredRetailerModelList
    }
}

//MARK: IAPProductAndHistoryProtocol delegate methods implementation

extension IAPShoppingCartDetailsViewController: IAPProductAndHistoryProtocol {
    
    func fetchDataForPage(_ currentPage: Int) {
        downloadInfo(productCTN)
    }
}

extension IAPShoppingCartDetailsViewController: SFSafariViewControllerDelegate {
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        retailerLoadedURL = URL
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully, let loadedURL = retailerLoadedURL {
            IAPUtility.tagExitLink(exitURL: loadedURL)
        }
    }
}
