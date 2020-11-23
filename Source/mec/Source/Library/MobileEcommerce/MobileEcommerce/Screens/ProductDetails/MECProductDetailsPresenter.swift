/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// swiftlint:disable file_length

import PhilipsEcommerceSDK
import BVSDK
import PhilipsPRXClient

protocol MECProductDetailsDelegate: NSObjectProtocol {
    func productDetailsDownloadSuccees()
    func productDetailsDownloadFailure()
    func productAddedToShoppingCart()
    func showError(error: Error?)
}

class MECProductDetailsPresenter: MECBasePresenter {

    weak var productDetailDelegate: MECProductDetailsDelegate?
    fileprivate(set) var fetchedProduct: MECProduct?
    var bazaarVoiceHandler: BazaarVoiceHandler?
    var prxManager: MECPRXHandler?

    override init() {
        super.init()
        bazaarVoiceHandler = BazaarVoiceHandler.sharedInstance
        prxManager = MECPRXHandler()
    }

    var actualProductPrice: String? {
        var actualProductPrice: String?
        guard let discountedPrice = fetchedProduct?.product?.attributes?.discountPrice else {
            return ""
        }
        if fetchedProduct?.product?.attributes?.price?.value != discountedPrice.value {
            actualProductPrice = fetchedProduct?.product?.attributes?.price?.formattedValue
        }
        return actualProductPrice ?? ""
    }

    var discountedProductPrice: String? {
        guard let discountedPrice = fetchedProduct?.product?.attributes?.discountPrice else {
            return fetchedProduct?.product?.attributes?.price?.formattedValue
        }
        return discountedPrice.formattedValue
    }

    var discountedPercentage: String? {
        if let actualPrice = fetchedProduct?.product?.attributes?.price?.value,
            let discountedPrice = fetchedProduct?.product?.attributes?.discountPrice?.value {
            if actualPrice != discountedPrice {
                let discountAmount = actualPrice - discountedPrice
                let discountPercentage = (discountAmount/actualPrice)*100
                return "-\(String(format: "%.2f", discountPercentage))%"
            }
        }
        return ""
    }

    var productImageURLs: [String]? {
        return fetchedProduct?.product?.productAssets?.assets?.asset?.map({
            if let assetURL = ($0 as? PRXAssetAsset)?.asset, assetURL.count > 0 {
                return "\(assetURL)?wid=%@&hei=%@&$pnglarge$&fit=fit,1"
            }
            return ""
        })
    }

    var isStockAvailableInHybris: Bool {
        return MECUtility.isPILStockAvailable(stockLevelStatus: fetchedProduct?.product?.attributes?.availability?.status,
                                           stockAmount: fetchedProduct?.product?.attributes?.availability?.quantity ?? 0)
    }

    var isStockAvailableInRetailers: Bool {
        return fetchedProduct?.retailers?.retailerList?
            .contains(where: { $0.availability?.caseInsensitiveCompare("YES") == .orderedSame }) ?? false
    }

    var productDisclaimers: String? {
        var productDisclaimer = ""
        fetchedProduct?.product?.productDisclaimers?.disclaimers?.disclaimer?.forEach({
            productDisclaimer = "\(productDisclaimer)\n- "
            productDisclaimer = "\(productDisclaimer)\(($0 as? PRXDisclaimer)?.disclaimerText ?? "")"
        })
        return productDisclaimer.count > 0 ? productDisclaimer : nil
    }
}

extension MECProductDetailsPresenter {
    func addProductToCart() {
        oauthHybris { [weak self] (_, error) in
            guard error == nil else {
                self?.productDetailDelegate?.showError(error: error)
                return
            }
            guard let productCTN = self?.fetchedProduct?.fetchProductCTN() else { return }
            MECConfiguration.shared.ecommerceService?.addECSProductToShoppingCart(ctn: productCTN,
                                                                                  completionHandler: { [weak self] (_, error) in
                guard let weakSelf = self else { return }
                if let errorObject = error {
                    if errorObject.code == noCartErrorCode {
                        weakSelf.createCartWith(ctn: productCTN) { (_, error) in
                            guard let cartError = error else {
                                weakSelf.productAddedToCartSuccessfully()
                                return
                            }
                            self?.productDetailDelegate?.showError(error: cartError)
                        }
                    } else {
                        errorObject.handleOauthError {(handled, error) in
                            if handled == true {
                                weakSelf.addProductToCart()
                            } else {
                                weakSelf.productDetailDelegate?.showError(error: errorObject)
                            }
                        }
                    }
                } else {
                    self?.productAddedToCartSuccessfully()
                }
            })
        }
    }

    func productAddedToCartSuccessfully() {
        let entry = ECSPILItem()
        entry.discountPrice = fetchedProduct?.product?.attributes?.discountPrice
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.scAdd,
                MECAnalyticsConstants.productListKey: preparePILCartEntryListString(entries: [entry],
                                                                                          updatedQuantity: 1)])
        productDetailDelegate?.productAddedToShoppingCart()
    }
}

extension MECProductDetailsPresenter {

    func loadProductDetailFor(productCTN: String) {
        if MECConfiguration.shared.isHybrisAvailable == true {
            MECConfiguration.shared.ecommerceService?.fetchECSProductFor(ctn: productCTN,
                                                                      completionHandler: { [weak self] (product, error) in
                if error != nil {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchProductForCTN,
                                              serverName: MECAnalyticServer.hybris,
                                              error: error as NSError?)
                }
                self?.processProductDetailsDownloadFor(product: product)
            })
        } else {
            MECConfiguration.shared.ecommerceService?.fetchECSProductSummariesFor(ctns: [productCTN],
                                                                               completionHandler: { [weak self] (products, _, error) in
                if error != nil {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchProductSummariesForCTNList,
                                              serverName: MECAnalyticServer.prx,
                                              error: error as NSError?)
                }
                self?.processProductDetailsDownloadFor(product: products?.first)
            })
        }
    }

    func loadProductDetailFor(product: MECProduct) {
        loadAllPendingDataFor(mecProduct: product)
    }

    func processProductDetailsDownloadFor(product: ECSPILProduct?) {
        if let product = product {
            let mecProduct = MECProduct(product: product)
            loadAllPendingDataFor(mecProduct: mecProduct)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.productDetailDelegate?.productDetailsDownloadFailure()
            }
        }
    }

    func loadAllPendingDataFor(mecProduct: MECProduct) {
        if let ecsProduct = mecProduct.product {
            MECConfiguration.shared.ecommerceService?.fetchECSProductDetailsFor(product: ecsProduct,
                                                                             completionHandler: { [weak self] (_, error) in
                guard error == nil else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchProductDetailsForProduct,
                                                                serverName: MECAnalyticServer.prx,
                                                                error: error as NSError?)
                    DispatchQueue.main.async { [weak self] in
                        self?.productDetailDelegate?.productDetailsDownloadFailure()
                    }
                    return
                }
                self?.fetchedProduct = mecProduct
                self?.loadAllInformationsForProduct {
                    DispatchQueue.main.async {
                        self?.productDetailDelegate?.productDetailsDownloadSuccees()
                    }
                }
            })
        }
    }
}

// MARK: BazaarVoice Section

extension MECProductDetailsPresenter {

    func fetchTotalNumberOfReviews() -> Int {
        return fetchedProduct?.productReviews?.count ?? 0
    }

    func shouldLoadMoreReviews() -> Bool {
        guard fetchedProduct?.isDownloadingReviews == false else {
            return false
        }
        return !(fetchedProduct?.isAllReviewsDownloaded ?? true)
    }

    func fetchReviewerDetailsFor(review: BVReview) -> String {
        var reviewerDetails = ""
        reviewerDetails.appendWith(text: "\(review.userNickname ?? MECLocalizedString("mec_anonymous"))", withPrefix: nil)
        if let reviewTime = review.lastModificationTime?.convertToReviewFormat(), reviewTime.count > 0 {
            reviewerDetails.appendWith(text: reviewTime, withPrefix: " - ")
        }
        if let howLong = review.contextDataValues
            .first(where: { $0.identifier == MECBazaarVoiceConstants.MECHowLongHaveYouBeenUsingThisProductKey }),
            let period = howLong.valueLabel, period.count > 0 {
            reviewerDetails.appendWith(text: "\(MECLocalizedString("mec_has_used_this_product_for")) \(period)", withPrefix: " - ")
        }
        return reviewerDetails
    }

    func fetchProsFor(review: BVReview) -> String {
        return extractProsAndConsFrom(review: review, forProsAndConsType: MECBazaarVoiceConstants.MECProsKey)
    }

    func fetchConsFor(review: BVReview) -> String {
        return extractProsAndConsFrom(review: review, forProsAndConsType: MECBazaarVoiceConstants.MECConsKey)
    }

    func loadAllReviews(reviewCompletionHandler: @escaping ((_ downloaded: Bool, _ error: NSError?) -> Void)) {
        let productFetchOffset = UInt(fetchedProduct?.productReviews?.count ?? 0)
        let productCTN = fetchedProduct?.fetchProductCTN() ?? ""
        fetchedProduct?.isDownloadingReviews = true
        bazaarVoiceHandler?.fetchAllReviewsFor(productCTN: productCTN, offset: productFetchOffset) { [weak self] (reviews, errors) in
            self?.fetchedProduct?.isDownloadingReviews = false
            guard let errors = errors else {
                if let reviews = reviews, reviews.count > 0 {
                    self?.fetchedProduct?.productReviews?.append(contentsOf: reviews)
                    if reviews.count < MECConstants.MECProductReviewsDownloadLimit {
                        self?.fetchedProduct?.isAllReviewsDownloaded = true
                    }
                } else {
                    self?.fetchedProduct?.isAllReviewsDownloaded = true
                }
                reviewCompletionHandler(true, nil)
                return
            }
            reviewCompletionHandler(false, errors.first)
        }
    }

    func clearAllProductReviews() {
        fetchedProduct?.productReviews?.removeAll()
        fetchedProduct?.isDownloadingReviews = false
        fetchedProduct?.isAllReviewsDownloaded = false
    }

    fileprivate func loadAllInformationsForProduct(productInformationsCompletionHandler: @escaping () -> Void) {
        let productInformationsGroupDownload = DispatchGroup()

        if fetchedProduct?.averageRating == nil {
            productInformationsGroupDownload.enter()
            loadBulkRatings {
                productInformationsGroupDownload.leave()
            }
        }

        productInformationsGroupDownload.enter()
        loadAllReviews { (_, _) in
            productInformationsGroupDownload.leave()
        }

        if MECConfiguration.shared.supportsRetailers == true {
            productInformationsGroupDownload.enter()
            loadProductRetailers {
                productInformationsGroupDownload.leave()
            }
        }

        productInformationsGroupDownload.enter()
        fetchProductSpecs {
            productInformationsGroupDownload.leave()
        }

        productInformationsGroupDownload.enter()
        fetchProductFeatures {
            productInformationsGroupDownload.leave()
        }

        productInformationsGroupDownload.notify(queue: .main) {
            productInformationsCompletionHandler()
        }
    }

    fileprivate func loadBulkRatings(bulkRatingCompletionHandler: @escaping () -> Void) {
        let productCTN = fetchedProduct?.fetchProductCTN() ?? ""
        bazaarVoiceHandler?.fetchBulkRatingsFor(productCTNs: [productCTN]) { [weak self] (productStatistics) in
            let fetchedProductStatistics = productStatistics?.first(where: { $0.productId == productCTN })
            self?.fetchedProduct?.averageRating = fetchedProductStatistics?.reviewStatistics?.averageOverallRating
            self?.fetchedProduct?.totalNumberOfReviews = fetchedProductStatistics?.reviewStatistics?.totalReviewCount
            bulkRatingCompletionHandler()
        }
    }

    fileprivate func extractProsAndConsFrom(review: BVReview, forProsAndConsType type: String) -> String {
        var prosAndConsForProduct = ""
        let tagDimensionsDict: [String: String] = [MECBazaarVoiceConstants.MECProsKey: MECBazaarVoiceConstants.MECProKey,
                                                   MECBazaarVoiceConstants.MECConsKey: MECBazaarVoiceConstants.MECConKey]

        if let additionalFieldsDict = review.additionalFields?[type] as? [String: Any],
            let additionalFieldValue = additionalFieldsDict[MECBazaarVoiceConstants.MECValueKey] as? String,
            additionalFieldValue.count > 0 {
            prosAndConsForProduct.appendWith(text: additionalFieldValue, withPrefix: nil)
        }

        if let tagDimensionValues = review.tagDimensions?.allValues as? [BVDimensionElement], tagDimensionValues.count > 0 {
            if let tagDimensionValue = tagDimensionValues.first(where: { $0.identifier == tagDimensionsDict[type] }) {
                tagDimensionValue.values?.forEach({ value in prosAndConsForProduct.appendWith(text: value, withPrefix: ", ")})
            }
        }
        return prosAndConsForProduct
    }
}

// MARK: Fetch Retailers Section

extension MECProductDetailsPresenter {

    func loadProductRetailers(fetchRetailersCompletionHandler: @escaping () -> Void) {
        if let mecProduct = fetchedProduct {
            MECConfiguration.shared.ecommerceService?.fetchRetailerDetailsFor(productCtn: mecProduct.fetchProductCTN(),
                                                                              completionHandler: { [weak self] (retailers, error) in
                if error != nil {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchRetailerDetailsForCTN,
                                              serverName: MECAnalyticServer.wtb,
                                              error: error as NSError?)
                }

                if let retailers = retailers {
                    self?.filterOutProductsFor(fetchedRetailers: retailers)
                    self?.fetchedProduct?.retailers = retailers
                    fetchRetailersCompletionHandler()
                } else {
                    fetchRetailersCompletionHandler()
                }
            })
        } else {
            fetchRetailersCompletionHandler()
        }
    }

    func filterOutProductsFor(fetchedRetailers: ECSRetailerList) {
        guard let retailers = fetchedRetailers.retailerList, retailers.count > 0 else {
            return
        }
        if let isHybrisEnabled = MECConfiguration.shared.isHybrisAvailable, isHybrisEnabled == true {
            fetchedRetailers.wrbresults?.onlineStoresForProduct?.retailers?.retailer?.removeAll { $0.isPhilipsStore == "Y" }
        }
        if let blackListedRetailers = MECConfiguration.shared.blacklistedRetailerNames, blackListedRetailers.count > 0 {
            blackListedRetailers.forEach { (retailerName) in
                fetchedRetailers.wrbresults?.onlineStoresForProduct?.retailers?.retailer?
                    .removeAll(where: { $0.name?.localizedCaseInsensitiveContains(retailerName) ?? false })
            }
        }
    }
}

// MARK: Fetch Product Specs Section

extension MECProductDetailsPresenter {

    func fetchProductSpecs(fetchSpecsCompletionHandler: @escaping () -> Void) {
        if let mecProduct = fetchedProduct {
            prxManager?.fetchProductSpecsFor(CTN: mecProduct.fetchProductCTN(),
                                             requestManager: prxManager?.fetchPRXRequestManager()) { (response) in
                mecProduct.productSpecs = response?.data
                fetchSpecsCompletionHandler()
            }
        } else {
            fetchSpecsCompletionHandler()
        }
    }

    func fetchNumberOfChapters() -> Int {
        return fetchedProduct?.productSpecs?.chapters.count ?? 0
    }

    func fetchNumberOfItemsFor(chapterIndex: Int) -> Int {
        if let chapterItems = fetchedProduct?.productSpecs?.chapters[chapterIndex] as? PRXSpecificationsChapterItem {
            return chapterItems.items.count
        }
        return 0
    }

    func fetchChapterNameFor(chapterIndex: Int) -> String {
        if let chapterItems = fetchedProduct?.productSpecs?.chapters[chapterIndex] as? PRXSpecificationsChapterItem {
            return chapterItems.chapterName
        }
        return ""
    }

    func fetchItemNameFor(chapterIndex: Int, itemIndex: Int) -> String {
        if let chapterItems = fetchedProduct?.productSpecs?.chapters[chapterIndex] as? PRXSpecificationsChapterItem,
            let chapterItem = chapterItems.items[itemIndex] as? PRXSpecificationsItem {
            return chapterItem.itemName
        }
        return ""
    }

    func fetchItemValuesFor(chapterIndex: Int, itemIndex: Int) -> String {
        if let chapterItems = fetchedProduct?.productSpecs?.chapters[chapterIndex] as? PRXSpecificationsChapterItem,
            let chapterItem = chapterItems.items[itemIndex] as? PRXSpecificationsItem,
            chapterItem.itemValues.count > 0 {
            var specValue = ""
            chapterItem.itemValues.forEach { (itemValue) in
                if let itemSpecValue = itemValue as? PRXSpecificationsItemValue {
                    if specValue.count == 0 {
                        specValue = chapterItem.itemValues.count == 1 ? "\(itemSpecValue.valueName)" : "- \(itemSpecValue.valueName)"
                    } else {
                        specValue = "\(specValue)\n- \(itemSpecValue.valueName)"
                    }
                    if let itemMeasureSymbol = chapterItem.itemUnitOfMeasure?.unitOfMeasureSymbol, itemMeasureSymbol.count > 0 {
                        specValue = "\(specValue) \(itemMeasureSymbol)"
                    }
                }
            }
            return specValue
        }
        return ""
    }
}

// MARK: Fetch Product Features Section

extension MECProductDetailsPresenter {

    func fetchProductFeatures(fetchFeaturesCompletionHandler: @escaping () -> Void) {
        if let product = fetchedProduct {
            prxManager?.fetchProductFeaturesFor(CTN: product.fetchProductCTN(),
                                                requestManager: prxManager?.fetchPRXRequestManager(),
                                                completionHandler: { (response) in
                product.productFeatures = response?.data
                fetchFeaturesCompletionHandler()
            })
        } else {
            fetchFeaturesCompletionHandler()
        }
    }

    func fetchNumberOfBenefitAreas() -> Int {
        return fetchedProduct?.productFeatures?.keyBenefitArea?.count ?? 0
    }

    func fetchNumberOfFeaturesFor(benefitAreaIndex: Int) -> Int {
        return fetchedProduct?.productFeatures?.keyBenefitArea?[benefitAreaIndex].features?.count ?? 0
    }

    func fetchBenefitAreaNameFor(benefitAreaIndex: Int) -> String {
        return fetchedProduct?.productFeatures?.keyBenefitArea?[benefitAreaIndex].keyBenefitAreaName ?? ""
    }

    func fetchFeatureNameFor(benefitAreaIndex: Int, featureIndex: Int) -> String {
        return fetchedProduct?.productFeatures?.keyBenefitArea?[benefitAreaIndex].features?[featureIndex].featureLongDescription ?? ""
    }

    func fetchFeatureDescriptionFor(benefitAreaIndex: Int, featureIndex: Int) -> String {
        return fetchedProduct?.productFeatures?.keyBenefitArea?[benefitAreaIndex].features?[featureIndex].featureGlossary ?? ""
    }

    func fetchFeatureAssetURLFor(benefitAreaIndex: Int, featureIndex: Int) -> String? {
        guard let productFeatureCode = fetchedProduct?.productFeatures?.keyBenefitArea?[benefitAreaIndex]
            .features?[featureIndex]
            .featureCode,
            productFeatureCode.count > 0 else {
            return nil
        }
        //Remove the Video extension check when Video is Implemented in Product Features
        let productFeatureAssetDetail = fetchedProduct?.productFeatures?.assetDetails?.first(where: {
            return $0.featureCode?.caseInsensitiveCompare(productFeatureCode) == .orderedSame &&
                $0.extension?.isExtensionOfTypeVideo() == false &&
                $0.asset?.count ?? 0 > 0
        })
        if let productFeatureAssetDetail = productFeatureAssetDetail,
            let assetURL = productFeatureAssetDetail.asset,
            assetURL.count > 0 {
            return "\(assetURL)?wid=220&hei=220&$pnglarge$&fit=fit,1"
        }
        return nil
    }
}

// MARK: Notify Me Section

extension MECProductDetailsPresenter {

    func shouldDisplayNotifyMeSection() -> Bool {
        guard MECConfiguration.shared.isHybrisAvailable == true else {
            return false
        }

        guard isStockAvailableInHybris == false else {
            return false
        }
        return true
    }
}

// swiftlint:enable file_length
