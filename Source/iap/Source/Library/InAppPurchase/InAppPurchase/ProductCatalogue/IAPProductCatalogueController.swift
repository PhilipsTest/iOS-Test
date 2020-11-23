/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS
import PhilipsIconFontDLS
import SafariServices


class IAPProductCatalogueController:IAPBaseViewController, UITableViewDataSource, UITableViewDelegate,
IAPProductAndHistoryProtocol, IAPPaginationProtocol, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var privacyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var privacyNoticeLabel: UIDHyperLinkLabel!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var noProductsLabel:UIDLabel!
    @IBOutlet weak var catalogueStackView: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    
    var dataArray = [IAPProductModel]()
    var filterDataArray = [IAPProductModel]()
    fileprivate var categorizedCTNList = [String]()
    fileprivate var productInfoHelper = IAPProductInfoHelper()
    
    var paginationModel: IAPPaginationModel!
    private var isSearched = false
    private var searchController = UIDSearchController(searchResultsController: nil)
    private var noNaviationInLoadView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBannerView()
        self.updatePrivacyLabel()
        if self.navigationController == nil {
            noNaviationInLoadView = true
        }
        super.startActivityProgressIndicator()
        IAPUtility.setIAPPreference({[weak self] (inSuccess) in
            self?.updateProductCatalogueView()
        }) { (inError) in
            super.displayErrorMessage(inError)
        }
        self.checkAndUpdatePrivacyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(IAPOAuthConfigurationData.isDataLoadedFromHybris())
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kProductCataloguePage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.checkSearchBarActive()
    }
    
    func checkSearchBarActive() {
        if(noNaviationInLoadView && self.searchController.isActive) {
            self.searchController.isActive = false
        }
    }
    
    func configureBannerView() {
        if let bannerDelegate = IAPConfiguration.sharedInstance.bannerConfigDelegate {
            if !catalogueStackView.arrangedSubviews.contains(bannerView) {
                catalogueStackView.insertArrangedSubview(bannerView, at: 0)
            }
            if let actualBannerView = bannerDelegate.viewForBannerInCatalogueScreen() {
                actualBannerView.translatesAutoresizingMaskIntoConstraints = false
                bannerView.addSubview(actualBannerView)
                actualBannerView.constrainToSuperviewAccordingToLanguage()
            } else {
                catalogueStackView.removeArrangedSubview(bannerView)
                bannerView.removeFromSuperview()
            }
        } else {
            catalogueStackView.removeArrangedSubview(bannerView)
            bannerView.removeFromSuperview()
        }
    }
    
    private func updatePrivacyLabel() {
        self.privacyNoticeLabel.text = "\(IAPUNWrappedLocaliseString("iap_read")) \(IAPUNWrappedLocaliseString("iap_privacy")) \(IAPUNWrappedLocaliseString("iap_more_info"))"
    }
    
    func updateProductCatalogueView() {
        self.noProductsLabel?.isHidden = true
        self.navigationItem.title = IAPLocalizedString("iap_product_catalog")
        self.noProductsLabel?.text = IAPLocalizedString("iap_no_product_available")
        self.productTableView?.estimatedRowHeight = 160.0
        self.productTableView?.rowHeight = UITableView.automaticDimension
        
        configureSearchController()
        guard true == IAPOAuthConfigurationData.isDataLoadedFromHybris() else {
            guard self.categorizedCTNList.count == 0 else {
                self.downloadInfo(self.categorizedCTNList)
                return
            }
            noProductsLabel.isHidden = false
            catalogueStackView.isHidden = true
            super.stopActivityProgressIndicator()
            return
        }
        self.initialiseAndLoadData(false)
    }
    
    func setDataArray(_ inDataArray: [String]) {
        self.categorizedCTNList = inDataArray.removeDuplicates()
    }
    
    func downloadInfo(_ forProducts: [String]) {
        self.noProductsLabel.isHidden = true
        self.catalogueStackView.isHidden = false
        self.productInfoHelper.fetchDetailsOfProducts(forProducts, completion: {(withProducts, failedProducts) in
            super.removeNoInternetView()
            guard withProducts.count > 0 else {
                self.showNoProductView()
                return
            }
            self.getPRXInformationForProducts(withProducts)
        }) { (inError: NSError) in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError, shouldDisplayNoInternetView: (0 == self.dataArray.count),
                                      needToPopOnTap: false, serverType: "PRX")
        }
    }
    
    func handleErrors(_ inErrors: [NSError]) {
        let objectsNotFound = inErrors.filter ({ $0.code == IAPConstants.IAPNoInternetError.kServerNotReachable})
        guard objectsNotFound.count == inErrors.count else {
            self.noProductsLabel.isHidden = false
            self.catalogueStackView.isHidden = true
            return }
        
        let error = NSError(domain: NSURLErrorDomain, code: IAPConstants.IAPNoInternetError.kServerNotReachable, userInfo:nil)
        super.displayErrorMessage(error, shouldDisplayNoInternetView:true)
    }
    
    func fetchDataForPage(_ currentPage:Int) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface = cartInterfaceBuilder.withCurrentPage(currentPage).buildInterface()
        let httpInterface = occInterface.getInterfaceForProductCatalogue(IAPOAuthConfigurationData.isDataLoadedFromHybris())
        occInterface.getProductCatalogue(httpInterface, completionHandler: {[weak self] (withProducts: [IAPProductModel], paginationDict: [String: AnyObject]?) -> () in
            self?.processOutputResponseFromHybris(hybrisProductResponse: withProducts, paginationDict: paginationDict)
        }) { (inError:NSError) -> () in
            self.resetDataFetchingValue(false)
            super.stopActivityProgressIndicator()
            guard inError.code != 999 else {
                self.noProductsLabel.isHidden = false
                self.catalogueStackView.isHidden = true
                return
            }
            super.displayErrorMessage(inError, shouldDisplayNoInternetView:(0 == self.dataArray.count))
        }
    }
    
    func processOutputResponseFromHybris(hybrisProductResponse: [IAPProductModel], paginationDict: [String: AnyObject]?) {
        guard hybrisProductResponse.count != 0 else {
            self.noProductsLabel.isHidden = false
            self.catalogueStackView.isHidden = true
            super.stopActivityProgressIndicator()
            return
        }
        
        var finalizedProductModel:[IAPProductModel] = []
        if(self.categorizedCTNList.count != 0) {
            finalizedProductModel = self.getCategorizedProductModel(hybrisProductResponse)
        } else {
            finalizedProductModel = hybrisProductResponse
        }
        
        if let dict = paginationDict {
            self.paginationModel = IAPPaginationModel(inDict: dict)
        }
        
        if(finalizedProductModel.count == 0 ) {
            guard self.shouldFetchData() else {
                if self.dataArray.count > 0 {
                    self.productTableView.reloadData()
                } else {
                    self.noProductsLabel.isHidden = false
                    self.catalogueStackView.isHidden = true
                    super.stopActivityProgressIndicator()
                }
                return
            }
            self.resetDataFetchingValue(true)
            self.fetchDataForPage(self.paginationModel.getCurrentPage()+1)
        } else {
            self.getPRXInformationForProducts(finalizedProductModel)
            super.removeNoInternetView()
            self.catalogueStackView.isHidden = false
        }
    }
    
    func getPRXInformationForProducts(_ inProducts:[IAPProductModel]) {
        IAPPRXDataDownloader().getProductInformationFromPRX(inProducts, completion: { (withProducts:[IAPProductModel]) -> () in
            super.stopActivityProgressIndicator()
            self.updateUIAfterPRXDownload(inputProducts: withProducts)
        })
    }

    func showNoProductView() {
        self.noProductsLabel.isHidden = false
        self.catalogueStackView.isHidden = true
        super.stopActivityProgressIndicator()
        trackAction(parameterData: ["error": "PRX_NoProductFound"], action: IAPAnalyticsConstants.sendData)
    }
    
    func updateUIAfterPRXDownload(inputProducts: [IAPProductModel]) {
        super.removeNoInternetView()
        self.resetDataFetchingValue(false)
        let validPRXProducts = self.getValidProductsOfPRX(inputProducts)
        self.dataArray += validPRXProducts
        guard self.dataArray.count > 0 else {
            self.noProductsLabel.isHidden = false
            self.catalogueStackView.isHidden = true
            trackAction(parameterData: ["error": "PRX_NoProductFound"], action: IAPAnalyticsConstants.sendData)
            return
        }
        self.dataArray = self.reOrderDataArrayAsPerCTN(inProducts: self.dataArray, ctnArray: self.categorizedCTNList)
        self.filterDataArray = self.dataArray
        self.productTableView.reloadData()
        self.sendProductListAnalytics()
    }
    
    func reOrderDataArrayAsPerCTN( inProducts: [IAPProductModel], ctnArray: [String]) -> [IAPProductModel] {
        let arrayToReturn = inProducts.sorted { (product1, product2) -> Bool in
            if let indexOfProductCTN1 = ctnArray.firstIndex(of: product1.getProductCTN()),
                let indexOfProductCTN2 = ctnArray.firstIndex(of: product2.getProductCTN()) {
                if indexOfProductCTN1 <= indexOfProductCTN2 {
                    return true
                }
            }
            return false
        }
        return arrayToReturn
    }
    
    func getValidProductsOfPRX(_ inProducts:[IAPProductModel]) -> [IAPProductModel] {
        var validProducts = [IAPProductModel]()
        for product in inProducts {
            if product.getProductTitle() != "" {
                validProducts.append(product)
            }else {
                let message = "PRX_" + product.getProductCTN() + "_ProductTitleMissing"
                trackAction(parameterData: ["error": message], action: IAPAnalyticsConstants.sendData)
            }
        }
        return validProducts
    }
    
    func getCategorizedProductModel(_ inProducts: [IAPProductModel]) -> [IAPProductModel] {
        var validProducts = [IAPProductModel]()
        for productCTN in self.categorizedCTNList {
            for product in inProducts {
                if productCTN == product.getProductCTN() {
                    validProducts.append(product)
                }
            }
        }
        return validProducts
    }
    // MARK: -
    // MARK: No internet related methods
    // MARK: -
    override func didTapTryAgain() {
        super.didTapTryAgain()
        super.notifyCartDelegateOfCartCountChange()
        guard self.categorizedCTNList.count == 0 else { self.downloadInfo(self.categorizedCTNList); return }
        self.initialiseAndLoadData(false)
    }
    
    // MARK:
    // MARK: Tableview helper methods
    
    func getcatalogueWithoutProductCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.catalogueWithoutProductCell, for: indexPath) as? IAPCatalogueWithoutProductsCell {
            cell.updateUIWithSearchText(searchText: self.searchController.searchBar.text!)
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func getProductCell(_ tableView: UITableView, indexPath: IndexPath) -> IAPProductCatalogueCell {
        let productObject = self.dataArray[indexPath.row]
        let productCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.catalogueCell,
                                                        for: indexPath) as? IAPProductCatalogueCell
        productCell?.productNameLabel.text  = productObject.getProductTitle()
        productCell?.layoutMargins = UIEdgeInsets.zero
        productCell?.productCTNLabel.isHidden = true
        
        let image = productCell?.arrowButton.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection()
        productCell?.arrowButton.setImage(image, for: .normal)
        
        if(productObject.getProductThumbnailImageURL() == "") {
            let taggingMessage = "PRX_" + productObject.getProductCTN() + "_NoThumbnailImageFound"
            trackAction(parameterData: ["error": taggingMessage], action: IAPAnalyticsConstants.sendData)
        } else {
            productCell?.productImageView.setImageWith(URL(string: productObject.getProductThumbnailImageURL())!,
                                                       placeholderImage: nil)
        }
        
        productCell?.stockStatusLblTopConstraint.constant = -12
        productCell?.stockStatusLabel.isHidden = true
        
        guard IAPOAuthConfigurationData.isDataLoadedFromHybris() else {
            productCell?.removeUIElementsForNonHybris()
            return productCell!
        }
        
        guard false == productObject.getDiscountPrice().isEmpty else {
            productCell?.productDiscountLabel.text = productObject.getTotalPrice()
            productCell?.productPriceLabel.isHidden = true
            return productCell!
        }
        
        guard productObject.getDiscountPriceValue() != productObject.getPriceValue() else {
            productCell?.productDiscountLabel.text = productObject.getDiscountPrice()
            productCell?.productPriceLabel.isHidden = true
            return productCell!
        }
        
        productCell?.productPriceLabel.isHidden = false
        productCell?.productPriceLabel.attributedText = IAPUtility.getStrikeThroughAttributedText(productObject.getTotalPrice())
        productCell?.productDiscountLabel.text = productObject.getDiscountPrice()
        
        return productCell!
    }
    
    // MARK:
    // MARK: UITableView Datasource and Delegate methods
    // MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched == true && self.dataArray.count == 0 {
            return 1
        } else {
            let count = dataArray.count
            guard self.shouldFetchData() else { return count }
            return isSearched == true ? count : count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row == self.dataArray.count  && isSearched == false else {
            guard isSearched == true && self.dataArray.count == 0 else {
                return self.getProductCell(tableView, indexPath:indexPath)
            }
            return self.getcatalogueWithoutProductCell(tableView, indexPath: indexPath)
        }
        let loadingCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.loadingCell, for: indexPath) as? IAPLoadingCell
        loadingCell?.layoutMargins = UIEdgeInsets.zero
        loadingCell?.loadingActivityIndicator.startAnimating()
        return loadingCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.dataArray.count > 0 else { return }
        guard indexPath.row == self.dataArray.count else { return }
        guard self.shouldFetchData() else { return }
        self.resetDataFetchingValue(true)
        self.fetchDataForPage(self.paginationModel.getCurrentPage()+1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard dataArray.count != 0 else {
            return
        }
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }

        let productDetailViewController = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        productDetailViewController.iapHandler = self.iapHandler
        productDetailViewController.productInfo = self.dataArray[indexPath.row]
        productDetailViewController.isFromProductCatalogueView = true
        productDetailViewController.cartIconDelegate = self.cartIconDelegate
        self.checkSearchBarActive()
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    // MARK:
    // MARK: Analytics methods
    
    func sendProductListAnalytics() {
        guard self.dataArray.count > 0 else { return }
        var productListForAnalytics: String = ""
        productListForAnalytics = IAPUtility.prepareProductString(products: self.dataArray)
        trackAction(parameterData: [IAPAnalyticsConstants.product: productListForAnalytics], action: IAPAnalyticsConstants.sendData)
    }
    
    // MARK:
    // MARK: Search bar methods
    
    func configureSearchController() {
        searchController.searchBar.backgroundColor =  UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground
        searchController.delegate = self
        searchController.searchResultsUpdater = self;
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        if noNaviationInLoadView {
            self.searchController.hidesNavigationBarDuringPresentation = false
            definesPresentationContext = false
        } else {
            definesPresentationContext = true
        }
        self.productTableView.tableHeaderView = self.searchController.searchBar;
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.isFirstResponder == true {
            isSearched = true;
        }
        if searchController.searchBar.text == nil || searchController.searchBar.text == ""{
            self.dataArray = self.filterDataArray
        } else {
            self.dataArray = self.filterDataArray.filter({ $0.getProductTitle().localizedCaseInsensitiveContains(searchController.searchBar.text!)})
        }
        self.productTableView.reloadData()
    }
    
    
    private func checkAndUpdatePrivacyView() {
        guard IAPConfiguration.sharedInstance.supportsHybris == true else {
            self.isPrivacyViewToBeHidden(status: false, url: nil)
            return
        }

        IAPConfiguration.sharedInstance.fetchSDURLForKey(forKey:IAPConstants.SDURLKeys.kPrivacy,  completionHandler:  { (returnedValue, inError) in
                var isPrivacyToBeShown = false
                var url:String?
                if let aURL = returnedValue {
                    isPrivacyToBeShown = true
                    url = aURL
                }
                self.isPrivacyViewToBeHidden(status: isPrivacyToBeShown,url: url)
            })
    }
    
    private func isPrivacyViewToBeHidden(status:Bool,url:String?) {
        guard status == true else{
            self.privacyViewHeightConstraint.constant = 0
            self.catalogueStackView.removeArrangedSubview(privacyView)
            self.privacyView.removeFromSuperview()
            return
        }
        
        self.privacyNoticeLabel.isHidden = false
        let heightConstant = (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20) ? 60.0 : 40.0;
        
        self.privacyViewHeightConstraint.constant = CGFloat(heightConstant)
        self.privacyView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        let readText = IAPUNWrappedLocaliseString("iap_read")
        let privacyText = IAPUNWrappedLocaliseString("iap_privacy")
        let moreInfoText = IAPUNWrappedLocaliseString("iap_more_info")
        let atext = "\(readText) \(privacyText) \(moreInfoText)"
        let model = UIDHyperLinkModel()
        model.highlightRange = (atext as NSString).range(of: privacyText)
        self.privacyNoticeLabel.addLink(model, handler: {_ in
            self.navigateToPrivacyView(url: url)
        } )
    }
    
    private func navigateToPrivacyView(url:String?) {
        guard let stringURL = url, let aURL = URL(string: stringURL) else {
            return
        }
        IAPUtility.tagExitLink(exitURL: aURL)
        let safariVC = SFSafariViewController(url: aURL)
        present(safariVC, animated: true, completion: nil)
    }
}

extension IAPProductCatalogueController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard noNaviationInLoadView else {
            if bannerView != nil {
                bannerView.isHidden = true
            }
            return
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearched = false
        guard noNaviationInLoadView else {
            if bannerView != nil {
                bannerView.isHidden = false
            }
            return
        }
    }
}
