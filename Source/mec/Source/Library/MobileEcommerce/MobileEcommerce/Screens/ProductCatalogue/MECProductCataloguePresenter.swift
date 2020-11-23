/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK
import BVSDK

protocol MECProductCatalogueDelegate: NSObjectProtocol {
    func productListLoaded()
    func productSearchCompleted()
    func emptyRequestThresholdReached()
    func showError(error: Error?)
}

class MECProductCataloguePresenter: NSObject, MECAnalyticsTracking {
    fileprivate let emptyRequestThreshold = 5
    fileprivate var productList: [MECProduct]? = []
    fileprivate var searchedProductList: [MECProduct]? = []
    fileprivate var filterCTNList: [String] = []
    var bazaarVoiceHandler: BazaarVoiceHandler?
    var isProductSearchInProgress: Bool = false
    var isDataFetching: Bool = false
    var isAllProductsDownloaded: Bool = false
    var productFetchOffset: Int = 0
    weak var productCatalogueDelegate: MECProductCatalogueDelegate?
    var appliedFilter: ECSPILProductFilter

    override init() {
        bazaarVoiceHandler = BazaarVoiceHandler.sharedInstance
        appliedFilter = ECSPILProductFilter()
        super.init()
    }

    // MARK: Public methods
    func loadProductList(withCTNs: [String], filter: ECSPILProductFilter) {
        filterCTNList = withCTNs
        isAllProductsDownloaded = false
        productFetchOffset = 0
        productList = []
        if MECConfiguration.shared.isHybrisAvailable == true {
            fetchProductFromHybris(withCTNs: withCTNs, filter: filter)
        } else {
            fetchProductForRetailer(withCTNs: withCTNs)
        }
    }

    func loadMoreProducts() {
        if MECConfiguration.shared.isHybrisAvailable == true {
            fetchProductFromHybris(withCTNs: filterCTNList, filter: appliedFilter)
        } else {
            fetchProductForRetailer(withCTNs: filterCTNList)
        }
    }

    func shouldLoadMoreProducts() -> Bool {
        return haveMoreProductsToLoad() && hasProductsToFilter() && !isProductSearchInProgress
    }

    func numberOfProducts() -> Int {
        if isProductSearchInProgress == true {
            return searchedProductList?.count ?? 0
        } else {
            return productList?.count ?? 0
        }
    }

    func productAtIndex(index: Int ) -> MECProduct? {
        if isProductSearchInProgress == true {
            guard index < (searchedProductList?.count ?? 0)  else { return nil }
            return searchedProductList?[index]
        } else {
            guard index < (productList?.count ?? 0)  else { return nil }
            return productList?[index]
        }
    }

    func searchProduct(searchText: String) {
        isProductSearchInProgress = true
        searchProductList(searchText: searchText)
    }

    func cancelProductSearch() {
        searchedProductList = nil
        isProductSearchInProgress = false
        DispatchQueue.main.async {
            self.productCatalogueDelegate?.productSearchCompleted()
        }
    }

    func fetchPrivacyURL(completionHandler: @escaping ((String?, Error?) -> Void)) {
        MECServiceDiscoveryUtility().getMECServiceURL(serviceKey: MECServiceKeys.MECPrivacy) { (url, error) in
            completionHandler(url, error)
        }
    }

    // MARK: Private methods
    fileprivate func searchProductList(searchText: String) {
        if searchText.count > 0 {
            searchedProductList = productList?.filter({
                ($0.product?.productPRXSummary?.productTitle?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                ($0.fetchProductCTN().localizedCaseInsensitiveContains(searchText))
            })
        } else {
            searchedProductList = productList
        }
        DispatchQueue.main.async {
            self.productCatalogueDelegate?.productSearchCompleted()
        }
    }

    fileprivate func hasProductsToFilter() -> Bool {
        guard filterCTNList.count > 0 else {
            return true     // Returning true if the CTN list is empty so that it can continue loading the products.
        }
        return (productList?.count ?? 0 < filterCTNList.count)
    }

    fileprivate func haveMoreProductsToLoad() -> Bool {
        guard isDataFetching == false else {
            return false
        }
        guard isAllProductsDownloaded == false else {
            return false
        }
        return true
    }

    fileprivate func fetchProductFromHybris(withCTNs: [String], filter: ECSPILProductFilter) {
        isDataFetching = true
        let category = MECConfiguration.shared.productCategory ?? MECConfiguration.shared.rootCategory
        let appliedFilter = ECSPILProductFilter()
        appliedFilter.sortType = filter.sortType
        appliedFilter.stockLevels = filter.stockLevels
        MECConfiguration.shared.ecommerceService?.fetchECSProducts(category: category,
                                                                   limit: Int(MECConstants.MECProductDownloadLimit),
                                                                   offset: productFetchOffset,
                                                                   filterParameter: appliedFilter,
                                                                   completionHandler: { [weak self] (product, error) in
            guard let weakSelf = self else { return }
            weakSelf.isDataFetching = false
            guard error == nil else {
                weakSelf.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchProducts,
                                             serverName: MECAnalyticServer.hybris,
                                             error: error as NSError?)
                DispatchQueue.main.async {
                    weakSelf.productCatalogueDelegate?.showError(error: error)
                }
                return
            }
            self?.appliedFilter = filter
            self?.productFetchOffset += MECConstants.MECProductDownloadLimit
            guard let products = product?.products, products.count > 0 else {
                self?.isAllProductsDownloaded = true
                DispatchQueue.main.async {
                    weakSelf.productCatalogueDelegate?.productListLoaded()
                }
                return
            }

            if products.count < MECConstants.MECProductDownloadLimit {
                self?.isAllProductsDownloaded = true
            }
            let mecProductList = weakSelf.createMECProduct(productList: product?.products)

            if withCTNs.count > 0 {
                weakSelf.processProductListForCategorised(product: mecProductList, withCTNs: withCTNs)
            } else {
                weakSelf.productList?.append(contentsOf: mecProductList)
                weakSelf.fetchReviews(for: weakSelf.productList, completion: { (inProductList) in
                    weakSelf.productList = inProductList
                    if !(weakSelf.isProductSearchInProgress) {
                        weakSelf.trackAction(parameterData: [MECAnalyticsConstants.productListKey:
                            weakSelf.prepareProductString(productList: mecProductList)])
                        DispatchQueue.main.async {
                            weakSelf.productCatalogueDelegate?.productListLoaded()
                        }
                    }
                })
            }
        })
    }

    fileprivate func fetchReviews(for products: [MECProduct]?, completion: @escaping ([MECProduct]?) -> Void ) {
        guard let productList = products else {
            completion(products)
            return
        }
        let ctnsList = productList.map({ $0.fetchProductCTN()})
        bazaarVoiceHandler?.fetchBulkRatingsFor(productCTNs: ctnsList) { (productStatistics) in
            productList.forEach { (product) in
                let productReview = productStatistics?.filter({$0.productId == product.fetchProductCTN()}).first
                product.averageRating = productReview?.reviewStatistics?.averageOverallRating
                product.totalNumberOfReviews = productReview?.reviewStatistics?.totalReviewCount
            }
            completion(productList)
        }
    }

    fileprivate func createMECProduct(productList: [ECSPILProduct]?) -> [MECProduct] {
        guard let inProductList = productList else { return [] }
        var mecProductList: [MECProduct] = []
        for product in inProductList {
            mecProductList.append(MECProduct(product: product))
        }
        return mecProductList
    }

    fileprivate func processProductListForCategorised(product: [MECProduct]?, withCTNs: [String]) {
        let filteredList = filterProductList(inProductList: product ?? [], forCtns: withCTNs)
        productList?.append(contentsOf: filteredList)

        if filteredList.count == 0 && shouldLoadMoreProducts() == true {
            if shouldShowThresholdMessage() {
                DispatchQueue.main.async {
                    self.productCatalogueDelegate?.emptyRequestThresholdReached()
                }
            } else {
                loadMoreProducts()
            }
        } else {
            fetchReviews(for: productList, completion: { [weak self] (inProductList) in
                guard let weakSelf = self else { return }
                weakSelf.productList = inProductList
                if !weakSelf.isProductSearchInProgress {
                    weakSelf.trackAction(parameterData: [MECAnalyticsConstants.productListKey:
                        weakSelf.prepareProductString(productList: filteredList)])
                    DispatchQueue.main.async {
                        weakSelf.productCatalogueDelegate?.productListLoaded()
                    }
                }
            })
        }
    }

    fileprivate func fetchProductForRetailer(withCTNs: [String]) {
        isDataFetching = true
        let range = (productFetchOffset + MECConstants.MECProductDownloadLimit) < withCTNs.count ?
            (productFetchOffset + MECConstants.MECProductDownloadLimit) : withCTNs.count
        let ctns = range > 0 ? Array(withCTNs[productFetchOffset...(range - 1)]) : []

        MECConfiguration.shared.ecommerceService?.fetchECSProductSummariesFor(ctns: ctns,
                                                    completionHandler: { [weak self](productList, _, error) in
            guard let weakSelf = self else { return }
            weakSelf.isDataFetching = false
            guard error == nil else {
                weakSelf.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchBulkRatingsForCTNList,
                                             serverName: MECAnalyticServer.prx,
                                             error: error as NSError?)
                DispatchQueue.main.async {
                    weakSelf.productCatalogueDelegate?.showError(error: error)
                }
                return
            }
            if range == withCTNs.count {
                weakSelf.isAllProductsDownloaded = true
            }
            weakSelf.productFetchOffset += (MECConstants.MECProductDownloadLimit)
            let mecProductList = weakSelf.createMECProduct(productList: productList)
            weakSelf.productList?.append(contentsOf: mecProductList)
            weakSelf.fetchReviews(for: mecProductList, completion: { (inProductList) in
                if !(weakSelf.isProductSearchInProgress) {
                    weakSelf.trackAction(parameterData: [MECAnalyticsConstants.productListKey:
                        weakSelf.prepareProductString(productList: mecProductList)])
                    DispatchQueue.main.async {
                        if weakSelf.numberOfProducts() == 0 && weakSelf.shouldLoadMoreProducts() == true {
                            weakSelf.loadMoreProducts()
                        } else {
                            weakSelf.productCatalogueDelegate?.productListLoaded()
                        }
                    }
                }
            })
        })
    }

    fileprivate func filterProductList(inProductList: [MECProduct], forCtns: [String]) -> [MECProduct] {
        let list = inProductList.filter { forCtns.contains($0.product?.ctn ?? "") }
        return list
    }

    fileprivate func shouldShowThresholdMessage() -> Bool {
        if productList?.count ?? 0 == 0 && productFetchOffset / MECConstants.MECProductDownloadLimit == emptyRequestThreshold {
            return true
        }
        return false
    }
}
