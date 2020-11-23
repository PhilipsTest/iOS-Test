/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// swiftlint:disable file_length

import PhilipsUIKitDLS
import PhilipsIconFontDLS
import SafariServices

class MECProductDetailsViewController: MECBaseViewController {

    var pageViewController: UIPageViewController?
    var productImageViewControllers = [MECProductImageViewController]()
    var currentIndex = 0
    var presenter: MECProductDetailsPresenter!
    var productCTN: String?
    var product: MECProduct?
    var productSpecsTableManager: MECProductSpecsTableViewManager?
    var productFeaturesTableManager: MECProductFeaturesTableViewManager?
    var productReviewsTableManager: MECProductReviewsTableViewManager?
    var notificationTimer: Timer?
    var notifyMeSuccessNotification: UIDNotificationBarView?

    @IBOutlet weak var productImagesPageControl: UIDPageControl!
    @IBOutlet weak var favouriteButton: UIDCircularButton!
    @IBOutlet weak var productTitleLabel: UIDLabel!
    @IBOutlet weak var productRatingBar: UIDRatingBar!
    @IBOutlet weak var productReviewLabel: UIDLabel!
    @IBOutlet weak var productCTNLabel: UIDLabel!
    @IBOutlet weak var productStockLabel: UIDLabel!
    @IBOutlet weak var productDetailMainView: UIView!
    @IBOutlet weak var productPriceView: MECPriceView!
    @IBOutlet weak var productDiscountView: MECPriceView!
    @IBOutlet weak var productImagesContainerView: UIView!
    @IBOutlet weak var productDetailsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var productInformationSection: UIStackView!
    @IBOutlet weak var productSummaryLabel: UIDLabel!
    @IBOutlet weak var productDisclaimerLabel: UIDLabel!
    @IBOutlet weak var productReviewsSection: UIStackView!
    @IBOutlet weak var productSummaryView: UIDView!
    @IBOutlet weak var addProductToCartButton: UIDButton!
    @IBOutlet weak var viewRetailerButton: UIDButton!
    @IBOutlet weak var productReviewsTableView: UITableView!
    @IBOutlet weak var noProductLabel: UIDLabel!
    @IBOutlet weak var noReviewsLabel: UIDLabel!
    @IBOutlet weak var productSpecsTableView: UITableView!
    @IBOutlet weak var productSpecsSection: UIStackView!
    @IBOutlet weak var productFeaturesSection: UIStackView!
    @IBOutlet weak var productFeaturesTableView: UITableView!
    @IBOutlet weak var notifyMeStackView: UIStackView!
    @IBOutlet weak var notifyMeButton: UIDButton!
    @IBOutlet weak var notifyMeMessageLabel: UIDLabel!
    @IBOutlet weak var suggestedRetailPriceLabel: UIDLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MECProductDetailsPresenter()
        presenter.productDetailDelegate = self
        setUpProductTableViewManagers()
        initialize { [weak self] (_, error) in
            guard error == nil || error?.code == 5055 else {
                let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                    self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                }
                self?.showAlert(title: MECLocalizedString("mec_product_detail_title"),
                                message: error?.localizedDescription,
                                okButton: okButton,
                                cancelButton: nil)
                self?.shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
                self?.noProductLabel.isHidden = false
                return
            }
            self?.startActivityProgressIndicator()
            if let product = self?.product {
                self?.presenter.loadProductDetailFor(product: product)
            } else if let productCTN = self?.productCTN {
                self?.presenter.loadProductDetailFor(productCTN: productCTN)
            } else {
                self?.stopActivityProgressIndicator()
            }
            self?.shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
        }
        configureUIAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.productDetails)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissNotifyMeSuccessNotification()
    }

    deinit {
        presenter.clearAllProductReviews()
    }
}

extension MECProductDetailsViewController: MECViewControllerDismissDelegate {
    func viewControllerDidDismiss() {
        trackPage(pageName: MECAnalyticPageNames.productDetails)
    }
}

extension MECProductDetailsViewController {
    @IBAction func addToCartButtonClicked(_ sender: UIDButton) {
        if MECConfiguration.shared.isUserLoggedIn {
            startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
            presenter.addProductToCart()
        } else {
            let continueAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_cart_login_error_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_authentication"),
                      message: MECLocalizedString("mec_cart_login_error_message"), okButton: continueAction, cancelButton: nil)
        }
    }

    @IBAction func notifyMeButtonClicked(_ sender: Any) {
        dismissNotifyMeSuccessNotification()
        if let notifyMeViewController = MECNotifyMeViewController.instantiateFromAppStoryboard(appStoryboard: .notifyMe) {
            let notifyMeNavigationController = UINavigationController(rootViewController: notifyMeViewController)
            notifyMeNavigationController.modalPresentationStyle = .overCurrentContext
            notifyMeViewController.delegate = self
            notifyMeViewController.ctn = presenter.fetchedProduct?.fetchProductCTN()
            present(notifyMeNavigationController, animated: true, completion: nil)
        }
    }

    @IBAction func productDetailSegmentSelectionChanged(sender: UISegmentedControl) {
        let selectedSegmentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)
        switch selectedSegmentTitle {
        case MECLocalizedString("mec_info"):
            displayProductInfoSection()
        case MECLocalizedString("mec_features"):
            displayProductFeaturesSection()
        case MECLocalizedString("mec_specs"):
            displayProductSpecsSection()
        case MECLocalizedString("mec_reviews"):
            displayProductReviewsSection()
        default:
            break
        }
    }

    @IBAction func viewRetailersButtonClicked(_ sender: UIDButton) {
        if let productRetailersController = MECProductRetailersViewController
            .instantiateFromAppStoryboard(appStoryboard: .productRetailers) {
            let retailerNavigationController = UINavigationController(rootViewController: productRetailersController)
            productRetailersController.fetchedRetailers = presenter.fetchedProduct?.retailers?.retailerList
            productRetailersController.product = presenter.fetchedProduct
            productRetailersController.delegate = self
            retailerNavigationController.modalPresentationStyle = .overCurrentContext
            present(retailerNavigationController, animated: true, completion: nil)
        }
    }

    func setUpProductTableViewManagers() {
        productSpecsTableManager = MECProductSpecsTableViewManager(detailsPresenter: presenter)
        productSpecsTableView.delegate = productSpecsTableManager
        productSpecsTableView.dataSource = productSpecsTableManager

        productFeaturesTableManager = MECProductFeaturesTableViewManager(detailsPresenter: presenter)
        productFeaturesTableView.delegate = productFeaturesTableManager
        productFeaturesTableView.dataSource = productFeaturesTableManager

        productReviewsTableManager = MECProductReviewsTableViewManager(detailsPresenter: presenter)
        productReviewsTableManager?.reviewDelegate = self
        productReviewsTableView.delegate = productReviewsTableManager
        productReviewsTableView.dataSource = productReviewsTableManager
    }

    func configureUIAppearance() {
        title = MECLocalizedString("mec_product_detail_title")
        favouriteButton.circularButtonType = .regular
        favouriteButton.icon = PhilipsDLSIconType.capture
        productTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        productReviewLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextWarning
        productCTNLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productSummaryLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        productDisclaimerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productSummaryView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        suggestedRetailPriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText

        productReviewsTableView.estimatedRowHeight = 100
        productReviewsTableView.rowHeight = UITableView.automaticDimension
        productReviewsTableView.sectionHeaderHeight = UITableView.automaticDimension
        productReviewsTableView.estimatedSectionHeaderHeight = 80

        productSpecsTableView.estimatedRowHeight = 100
        productSpecsTableView.rowHeight = UITableView.automaticDimension
        productSpecsTableView.sectionHeaderHeight = UITableView.automaticDimension
        productSpecsTableView.estimatedSectionHeaderHeight = 80

        productFeaturesTableView.estimatedRowHeight = 200
        productFeaturesTableView.rowHeight = UITableView.automaticDimension
        productFeaturesTableView.sectionHeaderHeight = UITableView.automaticDimension
        productFeaturesTableView.estimatedSectionHeaderHeight = 80

        noProductLabel.text = MECLocalizedString("mec_no_product_available")
        noReviewsLabel.text = MECLocalizedString("mec_no_review_available")
        configureProductSegmentedControl()
        configureButtons()

        productDetailMainView.isHidden = true
        favouriteButton.isHidden = true
        productReviewsSection.isHidden = true
        productSpecsSection.isHidden = true
        productFeaturesSection.isHidden = true
        productReviewsTableView.register(UINib(nibName: MECNibName.MECLoadingCell, bundle: MECUtility.getBundle()),
                                         forCellReuseIdentifier: MECCellIdentifier.MECProductReviewLoadingCell)
    }

    func configureButtons() {
        addProductToCartButton.titleFont = UIFont(uidFont: .bold, size: UIDSize16)
        addProductToCartButton.buttonStyle = .textWithIcon
        addProductToCartButton.setImage(UIImage.imageWithMECIconFontType(.cart, iconSize: UIDSize16), for: .normal)
        addProductToCartButton.setTitle(MECLocalizedString("mec_add_to_cart"), for: .normal)

        viewRetailerButton.philipsType = .secondary
        viewRetailerButton.titleLabel?.numberOfLines = 0
        viewRetailerButton.titleLabel?.lineBreakMode = .byWordWrapping
        viewRetailerButton.buttonStyle = .textWithIcon
        viewRetailerButton.setImage(UIImage.imageWithIconFontType(.listView, iconSize: UIDSize16), for: .normal)
        viewRetailerButton.setTitle(MECLocalizedString("mec_buy_from_retailers"), for: .normal)
    }

    func configureProductSegmentedControl() {
        productDetailsSegmentedControl.setTitle(MECLocalizedString("mec_info"), forSegmentAt: 0)
        productDetailsSegmentedControl.setTitle(MECLocalizedString("mec_features"), forSegmentAt: 1)
        productDetailsSegmentedControl.setTitle(MECLocalizedString("mec_specs"), forSegmentAt: 2)
        productDetailsSegmentedControl.setTitle(MECLocalizedString("mec_reviews"), forSegmentAt: 3)
        productDetailsSegmentedControl.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryBackground
        productDetailsSegmentedControl
            .setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText as Any,
                                     NSAttributedString.Key.font: UIFont(uidFont: .book, size: 14.0) as Any],
                                                              for: .normal)
        productDetailsSegmentedControl
            .setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                UIDThemeManager.sharedInstance.defaultTheme?.contentPrimaryBackground as Any,
                                     NSAttributedString.Key.font: UIFont(uidFont: .book, size: 14.0) as Any],
                                                              for: .selected)
        if #available(iOS 13.0, *) {
            productDetailsSegmentedControl.selectedSegmentTintColor = UIDThemeManager.sharedInstance.defaultTheme?.tabsDefaultOnIndicator
        } else {
            productDetailsSegmentedControl.tintColor = UIDThemeManager.sharedInstance.defaultTheme?.tabsDefaultOnIndicator
        }
    }

    func configureNotifyMeView() {
        guard presenter.shouldDisplayNotifyMeSection() == true else {
            notifyMeStackView.isHidden = true
            return
        }

        notifyMeStackView.isHidden = false
        notifyMeMessageLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText

        notifyMeButton.titleFont = UIFont(uidFont: .book, size: UIDSize16)
        notifyMeButton.setImage(UIImage.imageWithIconFontType(.message, iconSize: UIDSize16), for: .normal)
        notifyMeButton.layer.borderWidth = 1.0
        notifyMeButton.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonQuietEmphasisText?.cgColor

        configureNotifyMeNotificationView()
    }

    func configureNotifyMeNotificationView() {
        notifyMeSuccessNotification = UIDNotificationBarView.makePreparedForAutoLayout()
        notifyMeSuccessNotification?.accessibilityIdentifier = "mec_notify_me_success_notification"
        notifyMeSuccessNotification?.titleMessage = MECLocalizedString("mec_notify_me_success_notification_title")
        notifyMeSuccessNotification?.descriptionMessage = MECLocalizedString("mec_notify_me_success_notification_message")
        notifyMeSuccessNotification?.leadingButton?.setTitle(MECLocalizedString("mec_dismiss_text"), for: .normal)
        notifyMeSuccessNotification?.leadingButton?.accessibilityIdentifier = "mec_notify_me_notification_dismiss_button"
        notifyMeSuccessNotification?.closeButton?.isHidden = true
        notifyMeSuccessNotification?.delegate = self
        notifyMeSuccessNotification?.isHidden = true
        if let notifyMeSuccessNotification = notifyMeSuccessNotification {
            view.addSubview(notifyMeSuccessNotification)
            notifyMeSuccessNotification.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            notifyMeSuccessNotification.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            notifyMeSuccessNotification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
    }

    func dismissNotifyMeSuccessNotification() {
        notifyMeSuccessNotification?.isHidden = true
        notificationTimer?.invalidate()
        notificationTimer = nil
    }

    func displayProductInfoSection() {
        productInformationSection.isHidden = false
        productReviewsSection.isHidden = true
        productSpecsSection.isHidden = true
        productFeaturesSection.isHidden = true
    }

    func displayProductFeaturesSection() {
        if let product = presenter.fetchedProduct {
            trackAction(parameterData: [MECAnalyticsConstants.productTabsClick: MECAnalyticsConstants.features,
                                        MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
        }
        productReviewsSection.isHidden = true
        productSpecsSection.isHidden = true
        productInformationSection.isHidden = true
        productFeaturesSection.isHidden = false
    }

    func displayProductSpecsSection() {
        if let product = presenter.fetchedProduct {
            trackAction(parameterData: [MECAnalyticsConstants.productTabsClick: MECAnalyticsConstants.specs,
                                        MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
        }
        productSpecsSection.isHidden = false
        productInformationSection.isHidden = true
        productReviewsSection.isHidden = true
        productFeaturesSection.isHidden = true
    }

    func displayProductReviewsSection() {
        if let product = presenter.fetchedProduct {
            trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.userReviewsViewed,
                                        MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
        }
        productReviewsSection.isHidden = false
        productInformationSection.isHidden = true
        productSpecsSection.isHidden = true
        productFeaturesSection.isHidden = true
    }

    fileprivate func setUpProductImages() {
        guard let imageURLs = presenter.productImageURLs, imageURLs.count > 0  else {
            guard let contentController = getPageContentViewController(0, withImageURL: "", isError: true) else { return }
            productImageViewControllers.append(contentController)
            setUpPageControl()
            return
        }

        for imageIndex in 0..<imageURLs.count {
            guard let contentController = getPageContentViewController(imageIndex,
                                                                       withImageURL: imageURLs[imageIndex],
                                                                       isError: false) else { continue }
            productImageViewControllers.append(contentController)
        }
        setUpPageControl()
    }

    fileprivate func setUpPageControl() {
        pageViewController = children[0] as? UIPageViewController
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        pageViewController?.setViewControllers([productImageViewControllers[0]], direction: .forward, animated: true, completion: nil)
        productImagesPageControl?.numberOfPages = productImageViewControllers.count
        productImagesPageControl.delegate = self
    }

    fileprivate func getPageContentViewController(_ withIndex: Int,
                                                  withImageURL: String = "",
                                                  isError: Bool) -> MECProductImageViewController? {
        if let pageContentViewController = MECProductImageViewController.instantiateFromAppStoryboard(appStoryboard: .productDetails) {
            pageContentViewController.imageHeight = Int(productImagesContainerView.frame.height)
            pageContentViewController.imageWidth = Int(productImagesContainerView.frame.width)
            pageContentViewController.index = withIndex
            pageContentViewController.imageUrlString = withImageURL
            pageContentViewController.shouldDisplayError = isError
            return pageContentViewController
        }
        return nil
    }

    func updateUIWithProductDetails() {
        productDetailMainView.isHidden = false
        setUpProductImages()
        productTitleLabel.text = presenter.fetchedProduct?.product?.productPRXSummary?.productTitle
        productCTNLabel.text = presenter.fetchedProduct?.product?.productPRXSummary?.ctn
        productPriceView.displayActual(price: presenter.actualProductPrice)
        productPriceView.displayDiscounted(price: presenter.discountedProductPrice)
        productDiscountView.displayDiscountPercentage(discountPercentValue: presenter.discountedPercentage)
        productDisclaimerLabel.text = presenter.productDisclaimers
        productSummaryLabel.text = presenter.fetchedProduct?.product?.productPRXSummary?.marketingTextHeader
        updateBottomButtonsSection()
        updateProductStockInformation()
        configureNotifyMeView()
        updateProductReviewSection()
        updateProductSpecSection()
        updateProductFeaturesSection()
        MECUtility.shouldShowSRP(for: presenter.fetchedProduct) { (shouldShow) in
            self.suggestedRetailPriceLabel.isHidden = !shouldShow
        }
    }

    func updateProductSpecSection() {
        if presenter.fetchNumberOfChapters() > 0 {
            productSpecsTableView.isHidden = false
            productSpecsTableView.reloadData()
        } else {
            productSpecsTableView.isHidden = true
        }
    }

    func updateProductFeaturesSection() {
        if presenter.fetchNumberOfBenefitAreas() > 0 {
            productFeaturesTableView.isHidden = false
            productFeaturesTableView.reloadData()
        } else {
            productDetailsSegmentedControl.removeSegment(at: 1, animated: false)
            productFeaturesTableView.isHidden = true
        }
    }

    func updateProductReviewSection() {
        if presenter.fetchTotalNumberOfReviews() > 0 {
            noReviewsLabel.isHidden = true
            productReviewsTableView.isHidden = false
            productReviewsTableView.reloadData()
        } else {
            noReviewsLabel.isHidden = false
            productReviewsTableView.isHidden = true
        }

        let totalProductReviews = presenter.fetchedProduct?.totalNumberOfReviews
        let averageProductRating = presenter.fetchedProduct?.averageRating?.floatValue.rounded(digits: 1) ?? 0
        productRatingBar.ratingText = "\(averageProductRating)"
        productRatingBar.ratingValue = CGFloat(averageProductRating)
        productReviewLabel.text = "(\(totalProductReviews ?? 0) \(MECLocalizedString("mec_reviews")))"
    }

    func updateProductStockInformation() {

        if presenter.isStockAvailableInHybris || presenter.isStockAvailableInRetailers {
            productStockLabel.displayInStock()
        } else {
            productStockLabel.displayOutOfStock()
            if let product = presenter.fetchedProduct {
                trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.outOfStock,
                                            MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
            }
        }
    }

    func updateBottomButtonsSection() {
        viewRetailerButton.philipsType = MECConfiguration.shared.isHybrisAvailable == false ? .primary : .secondary
        addProductToCartButton.isHidden = MECConfiguration.shared.isHybrisAvailable == false
        viewRetailerButton.isHidden = MECConfiguration.shared.supportsRetailers == false
        addProductToCartButton.isEnabled = presenter.isStockAvailableInHybris
        viewRetailerButton.isEnabled = presenter.isStockAvailableInRetailers
    }
}

extension MECProductDetailsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? MECProductImageViewController else { return nil }
        let pageIndex = pageContentViewController.index + 1
        if pageIndex < productImageViewControllers.count {
            return productImageViewControllers[pageIndex]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? MECProductImageViewController else { return nil }
        let pageIndex = pageContentViewController.index - 1
        if pageIndex >= 0 {
            return productImageViewControllers[pageIndex]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard false == completed else {
            guard let imageViewController = pageViewController.viewControllers?.first as? MECProductImageViewController else { return }
            productImagesPageControl.currentPage = productImageViewControllers.firstIndex(of: imageViewController) ?? 0
            currentIndex = productImagesPageControl.currentPage
            return
        }
    }
}

extension MECProductDetailsViewController: UIDPageControlDelegate {

    func pageDidChange(_ sender: UIDPageControl) {
        if sender.currentPage > currentIndex {
            pageViewController?.setViewControllers([productImageViewControllers[sender.currentPage]], direction: .forward,
                                                   animated: true, completion: nil)
        } else {
            pageViewController?.setViewControllers([productImageViewControllers[sender.currentPage]], direction: .reverse,
                                                   animated: true, completion: nil)
        }
        currentIndex = sender.currentPage
    }
}

extension MECProductDetailsViewController: MECProductDetailsDelegate {

    func productDetailsDownloadSuccees() {
        stopActivityProgressIndicator()
        if let product = presenter.fetchedProduct {
            trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.prodView,
                                        MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
        }
        updateUIWithProductDetails()
    }

    func productDetailsDownloadFailure() {
        stopActivityProgressIndicator()
        noProductLabel.isHidden = false
        productDetailMainView.isHidden = true
    }

    func productAddedToShoppingCart() {
        stopActivityProgressIndicator()
        self.navigationController?.moveToShoppingCartScreen()
    }

    func showError(error: Error?) {
        stopActivityProgressIndicator()
        let continueAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
            self.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
        }
        showAlert(title: MECLocalizedString("mec_authentication"),
                  message: error?.localizedDescription,
                  okButton: continueAction,
                  cancelButton: nil)
    }
}

extension MECProductDetailsViewController: MECProductReviewsTableViewManagerProtocol {

    func reviewsDownloaded() {
        updateProductReviewSection()
    }

    func didClickOnReviewsPrivacy(link: String) {
        if let termsURL = URL(string: link) {
            trackExitLink(exitURL: termsURL)
            let retailerSafariVC = SFSafariViewController(url: termsURL)
            retailerSafariVC.view.accessibilityIdentifier = "mec_review_privacy_web_view"
            retailerSafariVC.preferredBarTintColor = UINavigationBar.appearance().barTintColor
            retailerSafariVC.preferredControlTintColor = UINavigationBar.appearance().tintColor
            present(retailerSafariVC, animated: true, completion: nil)
        }
    }
}

extension MECProductDetailsViewController: MECNotifyMeSuccessDelegate {

     func notifyMeDidSucceed() {
        notifyMeSuccessNotification?.isHidden = false
        notificationTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] (_) in
            self?.dismissNotifyMeSuccessNotification()
        })
    }
}

extension MECProductDetailsViewController: UIDNotificationBarViewDelegate {

    func notificationBar(_ notificationBar: UIDNotificationBarView, forTapped buttonType: UIDActionButtonType) {
        dismissNotifyMeSuccessNotification()
    }
}
// swiftlint:enable file_length
