/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
import BVSDK
@testable import MobileEcommerceDev
import PhilipsPRXClient

class MECProductDetailsPresenterTests: XCTestCase {
    
    var productDetailsPresenter: MECProductDetailsPresenter!
    var mockECSService: MockECSService?
    var mockBazaarVoiceHandler: MockBazaarVoiceHandler?
    var mockPRXHandler: MockPRXHandler?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        productDetailsPresenter = MECProductDetailsPresenter()
        mockBazaarVoiceHandler = MockBazaarVoiceHandler()
        productDetailsPresenter.bazaarVoiceHandler = mockBazaarVoiceHandler
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        mockPRXHandler = MockPRXHandler()
        productDetailsPresenter.prxManager = mockPRXHandler
        MECConfiguration.shared.isHybrisAvailable = true
        MECConfiguration.shared.supportsRetailers = true
        
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }
    
    override func tearDown() {
        super.tearDown()
        productDetailsPresenter.productDetailDelegate = nil
        mockBazaarVoiceHandler = nil
        mockPRXHandler = nil
        productDetailsPresenter.bazaarVoiceHandler = nil
        productDetailsPresenter.prxManager = nil
        productDetailsPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.blacklistedRetailerNames = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.supportsRetailers = false
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.oauthData = nil
    }
}

//MARK: Product Details Unit test cases
extension MECProductDetailsPresenterTests {
    
    func testFetchProductDetailsForCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        productSummary.ctn = "TestCTN"
        product.ctn = "TestCTN"
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.product)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.ctn, productDetailsPresenter.fetchedProduct?.product?.productPRXSummary?.ctn)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.ctn, product.ctn)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.ctn, product.productPRXSummary?.ctn)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.ctn, "TestCTN")
    }
    
    func testFetchProductDetailsWithProduct() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        let mecProduct = MECProduct(product: product)
        
        productDetailsPresenter.loadProductDetailFor(product: mecProduct)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.ctn, "TestCTN")
    }
    
    func testFetchProductDoesNotCallHybrisForProduct() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attributes = ECSPILAttributes()
        stock.quantity = 10
        attributes.availability = stock
        product.attributes = attributes
        product.ctn = "TestCTN"
        let mecProduct = MECProduct(product: product)
        
        let testProduct = ECSPILProduct()
        let testStock = ECSPILProductAvailability()
        let testAttributes = ECSPILAttributes()
        testStock.quantity = 10
        testProduct.ctn = "TestCTN"
        testAttributes.availability = stock
        testProduct.attributes = testAttributes
        mockECSService?.fetchedProduct = testProduct
        
        productDetailsPresenter.loadProductDetailFor(product: mecProduct)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.attributes?.availability?.quantity , 10)
    }
    
    func testFetchProductDetailsForCTNSuccessCallback() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let productDetailsDelegate = MECMockProductDetailsDelegate()
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.productDetailDelegate = productDetailsDelegate
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let expectation = self.expectation(description: "testFetchProductDetailsForCTNSuccessCallback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(productDetailsDelegate.productDetailsSuccessCalled)
            XCTAssertFalse(productDetailsDelegate.productDetailsFailureCalled)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductDetailsForCTNFailureCallback() {
        let productDetailsDelegate = MECMockProductDetailsDelegate()
        mockECSService?.error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "fetch product for ctn failed"])
        productDetailsPresenter.productDetailDelegate = productDetailsDelegate
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let expectation = self.expectation(description: "testFetchProductDetailsForCTNFailureCallback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(productDetailsDelegate.productDetailsSuccessCalled)
            XCTAssertTrue(productDetailsDelegate.productDetailsFailureCalled)
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProductForCTN:Hybris:fetch product for ctn failed:1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductDetailsForProductFailureCallback() {
        let ecsProduct = ECSPILProduct()
        ecsProduct.ctn = "TestCTN"
        let mecProduct = MECProduct(product: ecsProduct)
        let productDetailsDelegate = MECMockProductDetailsDelegate()
        mockECSService?.error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "fetch product detail failed"])
        productDetailsPresenter.productDetailDelegate = productDetailsDelegate
        
        productDetailsPresenter.loadProductDetailFor(product: mecProduct)
        
        let expectation = self.expectation(description: "testFetchProductDetailsForProductFailureCallback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(productDetailsDelegate.productDetailsSuccessCalled)
            XCTAssertTrue(productDetailsDelegate.productDetailsFailureCalled)
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProductDetailsForProduct:PRX:fetch product detail failed:1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductDetailsForCTNSuccessCallbackForNonHybris() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let productDetailsDelegate = MECMockProductDetailsDelegate()
        product.productPRXSummary = productSummary
        mockECSService?.productList = [product]
        productDetailsPresenter.productDetailDelegate = productDetailsDelegate
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let expectation = self.expectation(description: "testFetchProductDetailsForCTNSuccessCallbackForNonHybris")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(productDetailsDelegate.productDetailsSuccessCalled)
            XCTAssertFalse(productDetailsDelegate.productDetailsFailureCalled)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductDetailsForCTNFailureCallbackForNonHybris() {
        let productDetailsDelegate = MECMockProductDetailsDelegate()
        mockECSService?.error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "fetch non hybris product failed"])
        productDetailsPresenter.productDetailDelegate = productDetailsDelegate
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let expectation = self.expectation(description: "testFetchProductDetailsForCTNFailureCallbackForNonHybris")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(productDetailsDelegate.productDetailsSuccessCalled)
            XCTAssertTrue(productDetailsDelegate.productDetailsFailureCalled)
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProductSummariesForCTNList:PRX:fetch non hybris product failed:1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testActualPriceForProductsWithoutDiscountForCTN() {
        let product = ECSPILProduct()
        let discountPrice = ECSPILPrice()
        let attributes = ECSPILAttributes()
        discountPrice.value = 100.0
        discountPrice.formattedValue = "$100.0"
        let actualPrice = ECSPILPrice()
        actualPrice.value = 100.0
        actualPrice.formattedValue = "$100.0"
        attributes.discountPrice = discountPrice
        attributes.price = actualPrice
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.actualProductPrice, "")
        XCTAssertEqual(productDetailsPresenter.discountedProductPrice, "$100.0")
    }
    
    func testActualPriceForProductsWithDiscountForCTN() {
        let product = ECSPILProduct()
        let discountPrice = ECSPILPrice()
        let attributes = ECSPILAttributes()
        discountPrice.value = 70.0
        discountPrice.formattedValue = "$70.0"
        let actualPrice = ECSPILPrice()
        actualPrice.value = 100.0
        actualPrice.formattedValue = "$100.0"
        attributes.discountPrice = discountPrice
        attributes.price = actualPrice
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.actualProductPrice, "$100.0")
        XCTAssertEqual(productDetailsPresenter.discountedProductPrice, "$70.0")
    }
    
    func testActualPriceForProductsWithNilDiscountForCTN() {
        let product = ECSPILProduct()
        let attributes = ECSPILAttributes()
        let actualPrice = ECSPILPrice()
        actualPrice.value = 100.0
        actualPrice.formattedValue = "$100.0"
        attributes.price = actualPrice
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.actualProductPrice, "")
        XCTAssertEqual(productDetailsPresenter.discountedProductPrice, actualPrice.formattedValue)
    }
    
    func testDiscountValueForWithDiscountWithCTN() {
        let product = ECSPILProduct()
        let discountPrice = ECSPILPrice()
        let attributes = ECSPILAttributes()
        discountPrice.value = 70.0
        discountPrice.formattedValue = "$70.0"
        let actualPrice = ECSPILPrice()
        actualPrice.value = 100.0
        actualPrice.formattedValue = "$100.0"
        attributes.discountPrice = discountPrice
        attributes.price = actualPrice
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.discountedPercentage, "-30.00%")
    }
    
    func testDiscountValueForWithoutDiscountWithCTN() {
        let product = ECSPILProduct()
        let discountPrice = ECSPILPrice()
        let attribute = ECSPILAttributes()
        discountPrice.value = 100.0
        discountPrice.formattedValue = "$100.0"
        let actualPrice = ECSPILPrice()
        actualPrice.value = 100.0
        actualPrice.formattedValue = "$100.0"
        attribute.discountPrice = discountPrice
        attribute.price = actualPrice
        product.attributes = attribute
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.discountedPercentage, "")
    }
    
    func testHybrisStockForProductWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attributes = ECSPILAttributes()
        stock.quantity = 10
        stock.status = "IN_STOCK"
        attributes.availability = stock
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertTrue(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductWithoutStockInformationWithCTN() {
        let product = ECSPILProduct()
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductForOutOfStockWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attribute = ECSPILAttributes()
        stock.quantity = 10
        stock.status = "OUT_OF_STOCK"
        attribute.availability = stock
        product.attributes = attribute
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductForOutOfStockWithoutStockWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attribute = ECSPILAttributes()
        stock.quantity = 0
        stock.status = "OUT_OF_STOCK"
        attribute.availability = stock
        product.attributes = attribute
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductForMixedStockInformationWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attribute = ECSPILAttributes()
        stock.quantity = 0
        stock.status = "IN_STOCK"
        attribute.availability = stock
        product.attributes = attribute
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductForLowStockWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attributes = ECSPILAttributes()
        stock.quantity = 10
        stock.status = "LOW_STOCK"
        attributes.availability = stock
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertTrue(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testHybrisStockForProductForLowStockInformationWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attribute = ECSPILAttributes()
        stock.quantity = 0
        stock.status = "LOW_STOCK"
        attribute.availability = stock
        product.attributes = attribute
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInHybris)
    }
    
    func testProductImageURLsForProductWithCTN() {
        let product = ECSPILProduct()
        let assetURL = "TestAssetURL"
        let productSummary = PRXSummaryData()
        let productAssets = PRXAssetData()
        let assets = PRXAssetAssets()
        let asset = PRXAssetAsset()
        asset.asset = assetURL
        assets.asset = [asset]
        productAssets.assets = assets
        product.productAssets = productAssets
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.productImageURLs?.first, "\(assetURL)?wid=%@&hei=%@&$pnglarge$&fit=fit,1")
    }
    
    func testProductImageURLsForBlankAssetsForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let assetData = PRXAssetData()
        let assets = PRXAssetAssets()
        let asset = PRXAssetAsset()
        assets.asset = [asset]
        assetData.assets = assets
        product.productAssets = assetData
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.productImageURLs?.first, "")
    }
    
    func testProductImageURLsForNilAssetsForProductWithCTN() {
        let product = ECSPILProduct()
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.productImageURLs)
    }
    
    func testProductImageURLsListForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let assetData = PRXAssetData()
        let assets = PRXAssetAssets()
        
        let firtsAssetURL = "TestAssetURL1"
        let firstAsset = PRXAssetAsset()
        firstAsset.asset = firtsAssetURL
        
        let secondAssetURL = "TestAssetURL2"
        let secondAsset = PRXAssetAsset()
        secondAsset.asset = secondAssetURL
        
        let thirdAssetURL = ""
        let thirdAsset = PRXAssetAsset()
        thirdAsset.asset = thirdAssetURL
        
        let fourthAsset = PRXAssetAsset()
        
        assets.asset = [firstAsset, secondAsset, thirdAsset, fourthAsset]
        assetData.assets = assets
        product.productAssets = assetData
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.productImageURLs?.count, 4)
    }
    
    func testDisclaimersForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let disclaimerData = PRXDisclaimerData()
        let disclaimers = PRXDisclaimers()
        let disclaimer = PRXDisclaimer()
        let disclaimerText = "Disclaimer1"
        disclaimer.disclaimerText = disclaimerText
        disclaimers.disclaimer = [disclaimer]
        disclaimerData.disclaimers = disclaimers
        product.productDisclaimers = disclaimerData
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.productDisclaimers, "\n- \(disclaimerText)")
    }
    
    func testDisclaimerListForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        let disclaimerData = PRXDisclaimerData()
        let disclaimers = PRXDisclaimers()
        
        let firstDisclaimer = PRXDisclaimer()
        let firstDisclaimerText = "Disclaimer1"
        firstDisclaimer.disclaimerText = firstDisclaimerText
        
        let secondDisclaimer = PRXDisclaimer()
        let secondDisclaimerText = "Disclaimer2"
        secondDisclaimer.disclaimerText = secondDisclaimerText
        
        let thirdDisclaimer = PRXDisclaimer()
        thirdDisclaimer.disclaimerText = ""
        
        let fourthDisclaimer = PRXDisclaimer()
        
        disclaimers.disclaimer = [firstDisclaimer, secondDisclaimer, thirdDisclaimer, fourthDisclaimer]
        disclaimerData.disclaimers = disclaimers
        product.productDisclaimers = disclaimerData
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.productDisclaimers, "\n- \(firstDisclaimerText)\n- \(secondDisclaimerText)\n- \n- ")
    }
    
    func testDisclaimerForBlankDisclaimerForProductWithCTN() {
        let product = ECSPILProduct()
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.productDisclaimers)
    }
    
    func testProductCTNForProductWithCTN() {
        let firstProduct = ECSPILProduct()
        firstProduct.ctn = "TestCTN"
        let firstMecProduct = MECProduct(product: firstProduct)
        XCTAssertEqual(firstMecProduct.fetchProductCTN(), "TestCTN")
        
        let secondProduct = ECSPILProduct()
        let secondProductSummary = PRXSummaryData()
        secondProductSummary.ctn = "TestCTN"
        secondProduct.productPRXSummary = secondProductSummary
        let secondMecProduct = MECProduct(product: secondProduct)
        XCTAssertEqual(secondMecProduct.fetchProductCTN(), "TestCTN")
        
        let thirdProduct = ECSPILProduct()
        let thirdMecProduct = MECProduct(product: thirdProduct)
        XCTAssertEqual(thirdMecProduct.fetchProductCTN(), "")
        
        let fourthProduct = ECSPILProduct()
        fourthProduct.ctn = "TestCTN"
        let fourthProductSummary = PRXSummaryData()
        fourthProductSummary.ctn = "TestCTN1"
        fourthProduct.productPRXSummary = fourthProductSummary
        let fourthMecProduct = MECProduct(product: fourthProduct)
        XCTAssertEqual(fourthMecProduct.fetchProductCTN(), "TestCTN")
    }
}

//MARK: Reviews and Ratings Unit test cases
extension MECProductDetailsPresenterTests {
    
    func testFetchProductDoesnotCallBulkRatingsIfRatingIsThere() {
        let product = ECSPILProduct()
        let mecProduct = MECProduct(product: product)
        mecProduct.averageRating = 4.3
        mecProduct.totalNumberOfReviews = 120
        product.ctn = "TestCTN"
        
        let bulkReviewStatistics = BVProductStatistics()
        let reviewStatistics = BVReviewStatistic()
        reviewStatistics.averageOverallRating = 3.9
        reviewStatistics.totalReviewCount = 200
        bulkReviewStatistics.reviewStatistics = reviewStatistics
        bulkReviewStatistics.productId = "TestCTN"
        mockBazaarVoiceHandler?.reviewAndRatingStatistics = [bulkReviewStatistics]
        
        productDetailsPresenter.loadProductDetailFor(product: mecProduct)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.averageRating, 4.3)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.totalNumberOfReviews, 120)
    }
    
    func testReviewsValuesForProductWithCTN() {
        let review = BVReview()
        let contextData = BVContextDataValue()
        contextData.identifier = "HowLongHaveYouBeenUsingThisProduct"
        contextData.valueLabel = "TestSinceValue"
        review.userNickname = "TestNickname"
        review.lastModificationTime = convertStringToDate(stringValue: "2019-10-30T01:30:44.000+00:00")
        review.contextDataValues = [contextData]
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.first?.userNickname, "TestNickname")
        XCTAssertEqual(productDetailsPresenter.fetchReviewerDetailsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestNickname - 30-10-2019 - Has used this product for TestSinceValue")
    }
    
    func testReviewsValueForNoAuthorNameForProductWithCTN() {
        let review = BVReview()
        let contextData = BVContextDataValue()
        contextData.identifier = "HowLongHaveYouBeenUsingThisProduct"
        contextData.valueLabel = "TestSinceValue"
        review.lastModificationTime = convertStringToDate(stringValue: "2019-10-30T01:30:44.000+00:00")
        review.contextDataValues = [contextData]
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 1)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productReviews?.first?.userNickname)
        XCTAssertEqual(productDetailsPresenter.fetchReviewerDetailsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "Anonymous - 30-10-2019 - Has used this product for TestSinceValue")
    }
    
    func testReviewsValueNoTimeForProductWithCTN() {
        let review = BVReview()
        let contextData = BVContextDataValue()
        contextData.identifier = "HowLongHaveYouBeenUsingThisProduct"
        contextData.valueLabel = "TestSinceValue"
        review.userNickname = "TestNickname"
        review.contextDataValues = [contextData]
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchReviewerDetailsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestNickname - Has used this product for TestSinceValue")
    }
    
    func testReviewsValueWithHowLongNoDataForProductWithCTN() {
        let review = BVReview()
        review.userNickname = "TestNickname"
        review.lastModificationTime = convertStringToDate(stringValue: "2019-10-30T01:30:44.000+00:00")
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchReviewerDetailsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestNickname - 30-10-2019")
    }
    
    func testProsValueForProductWithCTN() {
        let review = BVReview()
        let proDict = ["Value": "TestPros"]
        let proMainDict = ["Pros": proDict]
        review.additionalFields = proMainDict
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchProsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestPros")
    }
    
    func testConsValueForProductWithCTN() {
        let review = BVReview()
        let conDict = ["Value": "TestCons"]
        let conMainDict = ["Cons": conDict]
        review.additionalFields = conMainDict
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchConsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestCons")
    }
    
    func testProsFromTagDimensionsForProductWithCTN() {
        let review = BVReview()
        let proTagDimensionValue = BVDimensionElement()
        proTagDimensionValue.identifier = "Pro"
        proTagDimensionValue.values = ["TestProFirst", "TestProSecond", "TestProThird"]
        let proTagDimensions = TagDimensions(dictionary: ["Pro" : proTagDimensionValue])
        review.tagDimensions = proTagDimensions
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchProsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestProFirst, TestProSecond, TestProThird")
    }
    
    func testConsFromTagDimensionsForProductWithCTN() {
        let review = BVReview()
        let conTagDimensionValue = BVDimensionElement()
        conTagDimensionValue.identifier = "Con"
        conTagDimensionValue.values = ["TestConFirst", "TestConSecond", "TestConThird"]
        let conTagDimensions = TagDimensions(dictionary: ["Con": conTagDimensionValue])
        review.tagDimensions = conTagDimensions
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchConsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestConFirst, TestConSecond, TestConThird")
    }
    
    func testProsForMixedValuesForProductWithCTN() {
        let review = BVReview()
        let proTagDimensionValue = BVDimensionElement()
        proTagDimensionValue.identifier = "Pro"
        proTagDimensionValue.values = ["TestProFirst", "TestProSecond", "TestProThird"]
        let proTagDimensions = TagDimensions(dictionary: ["Pro" : proTagDimensionValue])
        review.tagDimensions = proTagDimensions
        let proDict = ["Value": "TestPros"]
        let proMainDict = ["Pros": proDict]
        review.additionalFields = proMainDict
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchProsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestPros, TestProFirst, TestProSecond, TestProThird")
    }
    
    func testConsForMixedValuesForProductWithCTN() {
        let review = BVReview()
        let conTagDimensionValue = BVDimensionElement()
        conTagDimensionValue.identifier = "Con"
        conTagDimensionValue.values = ["TestConFirst", "TestConSecond", "TestConThird"]
        let conTagDimensions = TagDimensions(dictionary: ["Con": conTagDimensionValue])
        review.tagDimensions = conTagDimensions
        let conDict = ["Value": "TestCons"]
        let conMainDict = ["Cons": conDict]
        review.additionalFields = conMainDict
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchConsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "TestCons, TestConFirst, TestConSecond, TestConThird")
    }
    
    func testWithoutProForProductWithCTN() {
        let review = BVReview()
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchProsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "")
    }
    
    func testWithoutConForProductWithCTN() {
        let review = BVReview()
        mockBazaarVoiceHandler?.reviews = [review]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchConsFor(review: productDetailsPresenter.fetchedProduct?.productReviews?.first ?? BVReview()), "")
    }
    
    func testNumberOfReviewsForProductWithCTN() {
        let firstReview = BVReview()
        let secondReview = BVReview()
        let thirdReview = BVReview()
        let fourthReview = BVReview()
        mockBazaarVoiceHandler?.reviews = [firstReview, secondReview, thirdReview, fourthReview]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchTotalNumberOfReviews(), 4)
    }
    
    func testNumberOfReviewsDefault() {
        XCTAssertEqual(productDetailsPresenter.fetchTotalNumberOfReviews(), 0)
    }
    
    func testFetchBulkReviewsForProductWithCTN() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        let bulkReviewStatistics = BVProductStatistics()
        let nativeReviewStatistics = BVReviewStatistic()
        nativeReviewStatistics.averageOverallRating = 4.4
        nativeReviewStatistics.totalReviewCount = 12
        bulkReviewStatistics.nativeReviewStatistics = nativeReviewStatistics
        let reviewStatistics = BVReviewStatistic()
        reviewStatistics.averageOverallRating = 5
        reviewStatistics.totalReviewCount = 120
        bulkReviewStatistics.reviewStatistics = reviewStatistics
        bulkReviewStatistics.productId = "TestCTN"
        mockBazaarVoiceHandler?.reviewAndRatingStatistics = [bulkReviewStatistics]
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.averageRating, 5)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.totalNumberOfReviews, 120)
    }
    
    func testFetchAllReviewsWithNilProduct() {
        let expectation = self.expectation(description: "testFetchAllReviewsWithNilProduct")
        productDetailsPresenter.loadAllReviews { (success, error) in
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct?.productReviews)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchBulkReviewsForNilReviewsForProductWithCTN() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        let bulkReviewStatistics = BVProductStatistics()
        let nativeReviewStatistics = BVReviewStatistic()
        bulkReviewStatistics.nativeReviewStatistics = nativeReviewStatistics
        let reviewStatistics = BVReviewStatistic()
        bulkReviewStatistics.reviewStatistics = reviewStatistics
        bulkReviewStatistics.productId = "TestCTN"
        mockBazaarVoiceHandler?.reviewAndRatingStatistics = [bulkReviewStatistics]
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.averageRating)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.totalNumberOfReviews)
    }
    
    func testFetchBulkReviewsForMixtureOfUnmatchingAndMatchingCTNsForProductWithCTN() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN1"
        let bulkReviewStatistics = BVProductStatistics()
        let nativeReviewStatistics = BVReviewStatistic()
        nativeReviewStatistics.averageOverallRating = 4.4
        nativeReviewStatistics.totalReviewCount = 12
        bulkReviewStatistics.nativeReviewStatistics = nativeReviewStatistics
        let reviewStatistics = BVReviewStatistic()
        reviewStatistics.averageOverallRating = 5
        reviewStatistics.totalReviewCount = 120
        bulkReviewStatistics.reviewStatistics = reviewStatistics
        bulkReviewStatistics.productId = "TestCTN"
        mockBazaarVoiceHandler?.reviewAndRatingStatistics = [bulkReviewStatistics]
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN1")
        
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.averageRating)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.totalNumberOfReviews)
    }
    
    func testPaginationLogicForNilReviewsForProductWithCTN() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded, true)
    }
    
    func testPaginationLogicForReviewsForProductWithCTN() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        
        let firstReview = BVReview()
        let secondReview = BVReview()
        mockBazaarVoiceHandler?.reviews = [firstReview, secondReview]
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(self.productDetailsPresenter.fetchedProduct?.productReviews?.count, 2)
        XCTAssertEqual(self.productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded, true)
        
        let thirdReview = BVReview()
        let fourthReview = BVReview()
        mockBazaarVoiceHandler?.reviews = [thirdReview, fourthReview]
        
        let firstExpectation = self.expectation(description: "testPaginationLogicForReviewsForProductWithCTN")
        productDetailsPresenter.loadAllReviews { (success, error) in
            XCTAssertEqual(self.productDetailsPresenter.fetchedProduct?.productReviews?.count, 4)
            XCTAssertEqual(self.productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded, true)
            firstExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testShouldLoadMoreReviewsForProductWithCTN() {
        XCTAssertFalse(productDetailsPresenter.shouldLoadMoreReviews())
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.shouldLoadMoreReviews())
        
        productDetailsPresenter.fetchedProduct?.isDownloadingReviews = true
        XCTAssertFalse(productDetailsPresenter.shouldLoadMoreReviews())
        
        productDetailsPresenter.fetchedProduct?.isDownloadingReviews = false
        productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded = true
        
        XCTAssertFalse(productDetailsPresenter.shouldLoadMoreReviews())
        
        productDetailsPresenter.fetchedProduct?.isDownloadingReviews = false
        productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded = false
        XCTAssertTrue(productDetailsPresenter.shouldLoadMoreReviews())
        
        productDetailsPresenter.fetchedProduct?.isDownloadingReviews = true
        productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded = true
        XCTAssertFalse(productDetailsPresenter.shouldLoadMoreReviews())
    }
    
    func testProductDetailsPresenterClearReviews() {
        let firstReview = BVReview()
        let secondReview = BVReview()
        let thirdReview = BVReview()
        mockBazaarVoiceHandler?.reviews = [firstReview, secondReview, thirdReview]
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 3)
        
        productDetailsPresenter.clearAllProductReviews()
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 0)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.isDownloadingReviews, false)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.isAllReviewsDownloaded, false)
    }
    
    func testFetchReviewsErrorForProductWithCTN() {
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attributes = ECSPILAttributes()
        stock.quantity = 10
        product.ctn = "TestCTN"
        attributes.availability = stock
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        let reviewError = NSError(domain: "", code: 123, userInfo: nil)
        mockBazaarVoiceHandler?.reviewsError = [reviewError]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productReviews?.count, 0)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.attributes?.availability?.quantity, 10)
    }
}

//MARK: Retailers Unit test cases
extension MECProductDetailsPresenterTests {
    
    func testFetchRetailersForProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 2)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.first?.name, "TestRetailerFirst")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.last?.name, "TestRetailerSecond")
    }
    
    func testBlackListedProductsFilterForProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        MECConfiguration.shared.blacklistedRetailerNames = ["testretailerS"]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.first?.name, "TestRetailerFirst")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), false)
    }
    
    func testInvalidBlackListedProducts() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        MECConfiguration.shared.blacklistedRetailerNames = ["TestRetailerInvalid"]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 2)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(firstRetailer), true)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), true)
    }
    
    func testBlackListedRetailersForNilRetailerName() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        MECConfiguration.shared.blacklistedRetailerNames = ["TestRetailers"]
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(firstRetailer), true)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), false)
    }
    
    func testFetchRetailersErrorForProductWithCTN() {
        let error = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "fetch retailer failed"])
        mockECSService?.retailerFetchError = error
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
        XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchRetailerDetailsForCTN:WTB:fetch retailer failed:123")
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.retailers)
    }
    
    func testFetchRetailersForNilProduct() {
        let expectation = self.expectation(description: "testFetchRetailersForNilProduct")
        productDetailsPresenter.loadProductRetailers {
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct?.retailers)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPhilipsStoreForNonHybris() {
        let product = ECSPILProduct()
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        firstRetailer.isPhilipsStore = "Y"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        secondRetailer.isPhilipsStore = "Y"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        mockECSService?.productList = [product]
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 2)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(firstRetailer), true)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), true)
    }
    
    func testPhilipsStoreForHybris() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        firstRetailer.isPhilipsStore = "Y"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        secondRetailer.isPhilipsStore = "N"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        MECConfiguration.shared.isHybrisAvailable = true
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(firstRetailer), false)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), true)
    }
    
    func testProductDetailsForNonHybrisWithProductCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        productSummary.ctn = "TestCTN"
        productSummary.marketingTextHeader = "TestMarketingTextHeader"
        product.productPRXSummary = productSummary
        mockECSService?.productList = [product]
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.fetchProductCTN(), "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.productPRXSummary?.marketingTextHeader, "TestMarketingTextHeader")
    }
    
    func testProductDetailsForNonHybrisFailureWithProductCTN() {
        mockECSService?.error = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:"Fetch product detail for non hybris failed"])
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchedProduct)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.product?.productPRXSummary)
        XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
        XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProductSummariesForCTNList:PRX:Fetch product detail for non hybris failed:123")
    }
    
    func testProductDetailsMethodCallsForNonHybrisForProductWithCTN() {
        let wrongProduct = ECSPILProduct()
        let wrongProductSummary = PRXSummaryData()
        wrongProduct.ctn = "WrongTestCTN"
        wrongProductSummary.marketingTextHeader = "WrongTestMarketingTextHeader"
        wrongProduct.productPRXSummary = wrongProductSummary
        
        let correctProduct = ECSPILProduct()
        let correctProductSummary = PRXSummaryData()
        correctProduct.ctn = "CorrectTestCTN"
        correctProductSummary.marketingTextHeader = "CorrectTestMarketingTextHeader"
        correctProduct.productPRXSummary = correctProductSummary
        
        mockECSService?.fetchedProduct = wrongProduct
        mockECSService?.productList = [correctProduct]
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.fetchProductCTN(), "CorrectTestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.productPRXSummary?.marketingTextHeader, "CorrectTestMarketingTextHeader")
    }
    
    func testProductDetailsGivesFirstProductForNonHybrisForProductWithCTN() {
        let firstProduct = ECSPILProduct()
        let firstProductSummary = PRXSummaryData()
        firstProduct.ctn = "FirstTestCTN"
        firstProductSummary.marketingTextHeader = "FirstTestMarketingTextHeader"
        firstProduct.productPRXSummary = firstProductSummary
        
        let secondProduct = ECSPILProduct()
        let secondProductSummary = PRXSummaryData()
        secondProduct.ctn = "SecondTestCTN"
        secondProductSummary.marketingTextHeader = "SecondTestMarketingTextHeader"
        secondProduct.productPRXSummary = secondProductSummary
        
        mockECSService?.productList = [firstProduct, secondProduct]
        MECConfiguration.shared.isHybrisAvailable = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.fetchProductCTN(), "FirstTestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.product?.productPRXSummary?.marketingTextHeader, "FirstTestMarketingTextHeader")
    }
    
    func testProductRetailerForOutOfStockProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        firstRetailer.availability = "NO"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        secondRetailer.availability = "NO"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInRetailers)
    }
    
    func testProductRetailerForInStockProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        firstRetailer.availability = "YES"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerSecond"
        secondRetailer.availability = "NO"
        retailers.retailer = [firstRetailer, secondRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertTrue(productDetailsPresenter.isStockAvailableInRetailers)
    }
    
    func testRetailerListForMixAndMatchOfDataForProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let firstRetailer = ECSRetailer()
        firstRetailer.name = "TestRetailerFirst"
        firstRetailer.availability = "NO"
        firstRetailer.isPhilipsStore = "N"
        let secondRetailer = ECSRetailer()
        secondRetailer.name = "TestRetailerS-Second"
        secondRetailer.availability = "NO"
        firstRetailer.isPhilipsStore = "N"
        let thirdRetailer = ECSRetailer()
        thirdRetailer.name = "TestRetailerThird"
        thirdRetailer.availability = "YES"
        thirdRetailer.isPhilipsStore = "Y"
        MECConfiguration.shared.isHybrisAvailable = true
        MECConfiguration.shared.blacklistedRetailerNames = ["TestRetailers"]
        retailers.retailer = [firstRetailer, secondRetailer, thirdRetailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(firstRetailer), true)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(secondRetailer), false)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.retailers?.retailerList?.contains(thirdRetailer), false)
    }
    
    func testProductRetailerStockForNilRetailerForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInRetailers)
    }
    
    func testProductRetailersWhenRetailersAreTurnedOffForProductWithCTN() {
        let retailerList = ECSRetailerList()
        let wrbResults = ECSWrbResults()
        let onlineStoresForProduct = ECSOnlineStoresForProduct()
        let retailers = ECSRetailers()
        let retailer = ECSRetailer()
        retailer.name = "TestRetailerFirst"
        retailer.availability = "YES"
        retailers.retailer = [retailer]
        onlineStoresForProduct.retailers = retailers
        wrbResults.onlineStoresForProduct = onlineStoresForProduct
        retailerList.wrbresults = wrbResults
        mockECSService?.retailers = retailerList
        MECConfiguration.shared.supportsRetailers = false
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.retailers)
        XCTAssertFalse(productDetailsPresenter.isStockAvailableInRetailers)
    }
}

//MARK: Product Specs Unit test cases

extension MECProductDetailsPresenterTests {
    
    func testFetchProductSpecsForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        let specChapter = PRXSpecificationsChapterItem()
        specChapter.chapterName = "TestChapterName"
        let specItem = PRXSpecificationsItem()
        specItem.itemName = "TestSpecItemName"
        let specItemValue = PRXSpecificationsItemValue()
        specItemValue.valueName = "TestSpecItemValueName"
        let specItemMeasure = PRXSpecificationsItemMeasure()
        specItemMeasure.unitOfMeasureSymbol = "TestSpecItemMeasureSymbol"
        
        specItem.itemValues = [specItemValue]
        specItem.itemUnitOfMeasure = specItemMeasure
        specChapter.items = [specItem]
        specChapters.chapters = [specChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.count, 1)
        XCTAssertEqual((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.count, 1)
        XCTAssertEqual(((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.first as? PRXSpecificationsItem)?.itemValues.count , 1)
        
        XCTAssertEqual((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.chapterName, "TestChapterName")
        XCTAssertEqual(((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.first as? PRXSpecificationsItem)?.itemName , "TestSpecItemName")
        XCTAssertEqual(((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.first as? PRXSpecificationsItem)?.itemUnitOfMeasure?.unitOfMeasureSymbol , "TestSpecItemMeasureSymbol")
        XCTAssertEqual(((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.first as? PRXSpecificationsItem)?.itemCode, "")
        XCTAssertEqual((((productDetailsPresenter.fetchedProduct?.productSpecs?.chapters.first as? PRXSpecificationsChapterItem)?.items.first as? PRXSpecificationsItem)?.itemValues.first as? PRXSpecificationsItemValue)?.valueName , "TestSpecItemValueName")
    }
    
    func testFetchProductSpecsErrorForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        productSummary.ctn = "TestCTN"
        product.ctn = "TestCTN"
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productSpecs)
    }
    
    func testFetchProductSpecsForTotalErrorForProductWithCTN() {
        let expectation = self.expectation(description: "testFetchProductSpecsForTotalErrorForProductWithCTN")
        productDetailsPresenter.fetchProductSpecs {
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct)
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct?.productSpecs)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testNumberOfChaptersForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        let secondSpecChapter = PRXSpecificationsChapterItem()
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfChapters(), 2)
    }
    
    func testNumberOfChaptersByDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfChapters(), 0)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfItemsFor(chapterIndex: 2), 0)
    }
    
    func testNumberOfItemsForChapterForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        let firstSpecItem = PRXSpecificationsItem()
        let secondSpecItem = PRXSpecificationsItem()
        let thirdSpecItem = PRXSpecificationsItem()
        firstSpecChapter.items = [firstSpecItem, secondSpecItem, thirdSpecItem]
        
        let secondSpecChapter = PRXSpecificationsChapterItem()
        secondSpecChapter.items = []
        
        let thirdSpecChapter = PRXSpecificationsChapterItem()
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter, thirdSpecChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfItemsFor(chapterIndex: 0), 3)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfItemsFor(chapterIndex: 1), 0)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfItemsFor(chapterIndex: 2), 0)
    }
    
    func testChapterNameForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        firstSpecChapter.chapterName = "TestFirstChapterName"
        let secondSpecChapter = PRXSpecificationsChapterItem()
        let thirdSpecChapter: PRXSpecificationsChapterItem? = nil
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter, thirdSpecChapter as Any]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchChapterNameFor(chapterIndex: 0), "TestFirstChapterName")
        XCTAssertEqual(productDetailsPresenter.fetchChapterNameFor(chapterIndex: 1), "")
        XCTAssertEqual(productDetailsPresenter.fetchChapterNameFor(chapterIndex: 2), "")
    }
    
    func testItemNameForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        let firstSpecItem = PRXSpecificationsItem()
        firstSpecItem.itemName = "FirstSpecItem"
        let secondSpecItem = PRXSpecificationsItem()
        secondSpecItem.itemName = "SecondSpecItem"
        let thirdSpecItem = PRXSpecificationsItem()
        firstSpecChapter.items = [firstSpecItem, secondSpecItem, thirdSpecItem]
        
        let secondSpecChapter = PRXSpecificationsChapterItem()
        secondSpecChapter.items = []
        
        let thirdSpecChapter = PRXSpecificationsChapterItem()
        let specItem = PRXSpecificationsItem()
        specItem.itemName = "SpecItem"
        thirdSpecChapter.items = [specItem]
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter, thirdSpecChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 0, itemIndex: 0), "FirstSpecItem")
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 0, itemIndex: 1), "SecondSpecItem")
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 2, itemIndex: 0), "SpecItem")
    }
    
    func testItemNameWithNilChapterForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        firstSpecChapter.chapterName = "TestFirstChapterName"
        let secondSpecChapter = PRXSpecificationsChapterItem()
        let thirdSpecChapter: PRXSpecificationsChapterItem? = nil
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter, thirdSpecChapter as Any]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 2, itemIndex: 0), "")
    }
    
    func testItemNameWithNilItemForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let specChapter = PRXSpecificationsChapterItem()
        let firstSpecItem = PRXSpecificationsItem()
        firstSpecItem.itemName = "FirstSpecItem"
        let secondSpecItem: PRXSpecificationsItem? = nil
        
        specChapter.items = [firstSpecItem, secondSpecItem as Any]
        specChapters.chapters = [specChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 0, itemIndex: 0), "FirstSpecItem")
        XCTAssertEqual(productDetailsPresenter.fetchItemNameFor(chapterIndex: 0, itemIndex: 1), "")
    }
    
    func testItemValuesForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let firstSpecChapter = PRXSpecificationsChapterItem()
        let firstSpecItem = PRXSpecificationsItem()
        let firstSpecItemMeasure = PRXSpecificationsItemMeasure()
        firstSpecItemMeasure.unitOfMeasureName = "TestFirstSpecItemMeasureName"
        firstSpecItemMeasure.unitOfMeasureSymbol = "TestFirstSpecItemMeasureSymbol"
        let firstSpecItemFirstValue = PRXSpecificationsItemValue()
        firstSpecItemFirstValue.valueName = "TestFirstSpecItemFirstValue"
        let firstSpecItemSecondValue = PRXSpecificationsItemValue()
        firstSpecItemSecondValue.valueName = "TestFirstSpecItemSecondValue"
        let firstSpecItemThirdValue = PRXSpecificationsItemValue()
        firstSpecItemThirdValue.valueName = "TestFirstSpecItemThirdValue"
        
        firstSpecItem.itemValues = [firstSpecItemFirstValue, firstSpecItemSecondValue, firstSpecItemThirdValue]
        firstSpecItem.itemUnitOfMeasure = firstSpecItemMeasure
        firstSpecChapter.items = [firstSpecItem]
        
        let secondSpecChapter = PRXSpecificationsChapterItem()
        let secondSpecItem = PRXSpecificationsItem()
        let secondSpecItemValue = PRXSpecificationsItemValue()
        secondSpecItemValue.valueName = "TestSecondSpecItemValue"
        secondSpecItem.itemValues = [secondSpecItemValue]
        secondSpecChapter.items = [secondSpecItem]
        
        let thirdSpecChapter = PRXSpecificationsChapterItem()
        let thirdSpecItem = PRXSpecificationsItem()
        let thirdSpecItemValue = PRXSpecificationsItemValue()
        let thirdSpecItemMeasure = PRXSpecificationsItemMeasure()
        thirdSpecItemMeasure.unitOfMeasureSymbol = ""
        thirdSpecItemValue.valueName = "TestThirdSpecItemValue"
        thirdSpecItem.itemValues = [thirdSpecItemValue]
        thirdSpecItem.itemUnitOfMeasure = thirdSpecItemMeasure
        thirdSpecChapter.items = [thirdSpecItem]
        
        let fourthSpecChapter = PRXSpecificationsChapterItem()
        let fourthSpecItem = PRXSpecificationsItem()
        let fourthSpecItemValue = PRXSpecificationsItemValue()
        let fourthSpecItemMeasure = PRXSpecificationsItemMeasure()
        fourthSpecItemMeasure.unitOfMeasureSymbol = "TestFourthSpecItemMeasureSymbol"
        fourthSpecItemValue.valueName = "TestFourthSpecItemValue"
        fourthSpecItem.itemValues = [fourthSpecItemValue]
        fourthSpecItem.itemUnitOfMeasure = fourthSpecItemMeasure
        fourthSpecChapter.items = [fourthSpecItem]
        
        specChapters.chapters = [firstSpecChapter, secondSpecChapter, thirdSpecChapter, fourthSpecChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 0, itemIndex: 0), "- TestFirstSpecItemFirstValue TestFirstSpecItemMeasureSymbol\n- TestFirstSpecItemSecondValue TestFirstSpecItemMeasureSymbol\n- TestFirstSpecItemThirdValue TestFirstSpecItemMeasureSymbol")
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 1, itemIndex: 0), "TestSecondSpecItemValue")
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 2, itemIndex: 0), "TestThirdSpecItemValue")
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 3, itemIndex: 0), "TestFourthSpecItemValue TestFourthSpecItemMeasureSymbol")
    }
    
    func testItemValuesForNilChapterForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let specChapter: PRXSpecificationsChapterItem? = nil
        
        specChapters.chapters = [specChapter as Any]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 0, itemIndex: 0), "")
    }
    
    func testItemValuesForNilItemForProductWithCTN() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        
        let specChapter = PRXSpecificationsChapterItem()
        let specItem: PRXSpecificationsItem? = nil
        
        specChapter.items = [specItem as Any]
        specChapters.chapters = [specChapter]
        specResponse.data = specChapters
        
        mockPRXHandler?.mockProductSpecifications = specResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productSpecs)
        XCTAssertEqual(productDetailsPresenter.fetchItemValuesFor(chapterIndex: 0, itemIndex: 0), "")
    }
}

//MARK: Product Features Unit test cases

extension MECProductDetailsPresenterTests {
    
    func testProductFeaturesForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featuresDetails = PRXFeaturesDetails()
        let featuresAssetDetails = PRXFeaturesAssetDetails()
        
        featuresKeyBenefitArea.keyBenefitAreaName = "TestKeyBenefitAreaName"
        featuresDetails.featureCode = "TestFeatureCode"
        featuresDetails.featureLongDescription = "TestFeatureLongDescription"
        featuresAssetDetails.asset = "TestAsset"
        featuresAssetDetails.featureCode = "TestFeatureCode"
        
        featuresKeyBenefitArea.features = [featuresDetails]
        featuresData.assetDetails = [featuresAssetDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures)
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails)
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productFeatures?.featureHighlight)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.count, 1)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.first?.asset, "TestAsset")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.first?.featureCode, "TestFeatureCode")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.keyBenefitAreaName, "TestKeyBenefitAreaName")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.first?.featureCode, "TestFeatureCode")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.first?.featureLongDescription, "TestFeatureLongDescription")
    }
    
    func testProductFeaturesErrorForProductWithCTN() {
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        productSummary.ctn = "TestCTN"
        product.ctn = "TestCTN"
        product.productPRXSummary = productSummary
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productFeatures)
    }
    
    func testProductFeaturesForNonHybrisForProductWithCTN() {
        MECConfiguration.shared.isHybrisAvailable = false
        let product = ECSPILProduct()
        let productSummary = PRXSummaryData()
        productSummary.ctn = "TestCTN"
        product.ctn = "TestCTN"
        product.productPRXSummary = productSummary
        mockECSService?.productList = [product]
        
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featuresDetails = PRXFeaturesDetails()
        let featuresAssetDetails = PRXFeaturesAssetDetails()
        
        featuresKeyBenefitArea.keyBenefitAreaName = "TestKeyBenefitAreaName"
        featuresDetails.featureCode = "TestFeatureCode"
        featuresDetails.featureLongDescription = "TestFeatureLongDescription"
        featuresAssetDetails.asset = "TestAsset"
        featuresAssetDetails.featureCode = "TestFeatureCode"
        
        featuresKeyBenefitArea.features = [featuresDetails]
        featuresData.assetDetails = [featuresAssetDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures)
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails)
        XCTAssertNotNil(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea)
        XCTAssertNil(productDetailsPresenter.fetchedProduct?.productFeatures?.featureHighlight)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.count, 1)
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.count, 1)
        
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.first?.asset, "TestAsset")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.assetDetails?.first?.featureCode, "TestFeatureCode")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.keyBenefitAreaName, "TestKeyBenefitAreaName")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.first?.featureCode, "TestFeatureCode")
        XCTAssertEqual(productDetailsPresenter.fetchedProduct?.productFeatures?.keyBenefitArea?.first?.features?.first?.featureLongDescription, "TestFeatureLongDescription")
    }
    
    func testProductFeaturesDefaultForProductWithCTN() {
        let expectation = self.expectation(description: "testProductFeatureErrorForProductWithCTN")
        productDetailsPresenter.fetchProductFeatures {
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct)
            XCTAssertNil(self.productDetailsPresenter.fetchedProduct?.productFeatures)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testProductFeaturesNumberOfBenefitAreasForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.keyBenefitArea = []
        
        for _ in 1...4 {
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfBenefitAreas(), 4)
    }
    
    func testProductFeaturesNumberOfBenefitAreasDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfBenefitAreas(), 0)
    }
    
    func testProductFeaturesFetchNumberOfFeaturesForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.keyBenefitArea = []
        
        for _ in 1...4 {
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        
        for i in 0..<(featuresData.keyBenefitArea?.count ?? 0) {
            if featuresData.keyBenefitArea?[i].features == nil {
                featuresData.keyBenefitArea?[i].features = []
            }
            if i % 2 == 0 {
                for _ in 1...2 {
                    let featureDetails = PRXFeaturesDetails()
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            } else {
                for _ in 1...3 {
                    let featureDetails = PRXFeaturesDetails()
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            }
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfFeaturesFor(benefitAreaIndex: 0), 2)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfFeaturesFor(benefitAreaIndex: 1), 3)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfFeaturesFor(benefitAreaIndex: 2), 2)
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfFeaturesFor(benefitAreaIndex: 3), 3)
    }
    
    func testProductFeaturesFetchNumberOfFeaturesDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfFeaturesFor(benefitAreaIndex: 2), 0)
    }
    
    func testProductFeaturesFetchBenefitAreaNameForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.keyBenefitArea = []
        
        for i in 1...4 {
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresKeyBenefitArea.keyBenefitAreaName = "TestBenefitAreaName\(i)"
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchNumberOfBenefitAreas(), 4)
        XCTAssertEqual(productDetailsPresenter.fetchBenefitAreaNameFor(benefitAreaIndex: 0), "TestBenefitAreaName1")
        XCTAssertEqual(productDetailsPresenter.fetchBenefitAreaNameFor(benefitAreaIndex: 1), "TestBenefitAreaName2")
        XCTAssertEqual(productDetailsPresenter.fetchBenefitAreaNameFor(benefitAreaIndex: 2), "TestBenefitAreaName3")
        XCTAssertEqual(productDetailsPresenter.fetchBenefitAreaNameFor(benefitAreaIndex: 3), "TestBenefitAreaName4")
    }
    
    func testProductFeaturesFetchBenefitAreaNameDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchBenefitAreaNameFor(benefitAreaIndex: 2), "")
    }
    
    func testProductFeaturesFeatureNameForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.keyBenefitArea = []
        
        for _ in 1...4 {
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        
        for i in 0..<(featuresData.keyBenefitArea?.count ?? 0) {
            if featuresData.keyBenefitArea?[i].features == nil {
                featuresData.keyBenefitArea?[i].features = []
            }
            if i % 2 == 0 {
                for j in 1...2 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionEven\(j)"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            } else {
                for k in 1...3 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionOdd\(k)"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            }
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchFeatureNameFor(benefitAreaIndex: 0, featureIndex: 0), "TestFeatureLongDescriptionEven1")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureNameFor(benefitAreaIndex: 0, featureIndex: 1), "TestFeatureLongDescriptionEven2")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureNameFor(benefitAreaIndex: 1, featureIndex: 1), "TestFeatureLongDescriptionOdd2")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureNameFor(benefitAreaIndex: 1, featureIndex: 0), "TestFeatureLongDescriptionOdd1")
    }
    
    func testProductFeaturesFeatureNameDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureNameFor(benefitAreaIndex: 2, featureIndex: 2), "")
    }
    
    func testProductFeaturesFeatureDescriptionForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.keyBenefitArea = []
        
        for _ in 1...4 {
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        
        for i in 0..<(featuresData.keyBenefitArea?.count ?? 0) {
            if featuresData.keyBenefitArea?[i].features == nil {
                featuresData.keyBenefitArea?[i].features = []
            }
            if i % 2 == 0 {
                for j in 1...2 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionEven\(j)"
                    featureDetails.featureGlossary = "TestFeatureGlossaryEven\(j)"
                    featureDetails.featureCode = "TestFeatureCodeEven\(j)"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            } else {
                for k in 1...3 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionOdd\(k)"
                    featureDetails.featureGlossary = "TestFeatureGlossaryOdd\(k)"
                    featureDetails.featureCode = "TestFeatureFeatureCodeOdd\(k)"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            }
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchFeatureDescriptionFor(benefitAreaIndex: 0, featureIndex: 0), "TestFeatureGlossaryEven1")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureDescriptionFor(benefitAreaIndex: 0, featureIndex: 1), "TestFeatureGlossaryEven2")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureDescriptionFor(benefitAreaIndex: 1, featureIndex: 1), "TestFeatureGlossaryOdd2")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureDescriptionFor(benefitAreaIndex: 1, featureIndex: 0), "TestFeatureGlossaryOdd1")
    }
    
    func testProductFeaturesFeatureDescriptionDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureDescriptionFor(benefitAreaIndex: 2, featureIndex: 2), "")
    }
    
    func testFetchFeatureAssetURLForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        featuresData.assetDetails = []
        featuresData.keyBenefitArea = []
        
        for i in 0..<4 {
            let featuresAsset = PRXFeaturesAssetDetails()
            featuresAsset.asset = i % 2 == 0 ? "TestFeatureAssetEven\(i)" : "TestFeatureAssetOdd\(i)"
            featuresAsset.extension = "TestExtension"
            featuresAsset.featureCode = i % 2 == 0 ? "TestFeatureCodeEven" : "TestFeatureCodeOdd"
            featuresData.assetDetails?.append(featuresAsset)
            let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
            featuresData.keyBenefitArea?.append(featuresKeyBenefitArea)
        }
        
        for i in 0..<(featuresData.keyBenefitArea?.count ?? 0) {
            if featuresData.keyBenefitArea?[i].features == nil {
                featuresData.keyBenefitArea?[i].features = []
            }
            if i % 2 == 0 {
                for j in 1...2 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionEven\(j)"
                    featureDetails.featureCode = "TestFeatureCodeEven"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            } else {
                for k in 1...3 {
                    let featureDetails = PRXFeaturesDetails()
                    featureDetails.featureLongDescription = "TestFeatureLongDescriptionOdd\(k)"
                    featureDetails.featureCode = "TestFeatureCodeOdd"
                    featuresData.keyBenefitArea?[i].features?.append(featureDetails)
                }
            }
        }
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNotNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0))
        XCTAssertEqual(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0), "TestFeatureAssetEven0?wid=220&hei=220&$pnglarge$&fit=fit,1")
        XCTAssertEqual(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 1, featureIndex: 1), "TestFeatureAssetOdd1?wid=220&hei=220&$pnglarge$&fit=fit,1")
    }
    
    func testFetchFeatureAssetURLWithVideoForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.asset = "TestImageFirstFeatureAsset"
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.asset = "TestImageSecondFeatureAsset"
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0), "TestImageFirstFeatureAsset?wid=220&hei=220&$pnglarge$&fit=fit,1")
    }
    
    func testNoProductFeatureAssetURLForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.asset = "TestImageFirstFeatureAsset"
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.asset = "TestImageSecondFeatureAsset"
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCodeDifferent"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0))
    }
    
    func testFetchProductAssetURLForNoAssetForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0))
    }
    
    func testFetchAssetURLForBlankAssetURLForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.asset = ""
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.asset = "TestImageSecondFeatureAsset"
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0), "TestImageSecondFeatureAsset?wid=220&hei=220&$pnglarge$&fit=fit,1")
    }
    
    func testFetchAssetURLForAllBlankAssetURLForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.asset = ""
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.asset = ""
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0))
    }
    
    func testFetchAssetURLForNilAssetForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.asset = "TestImageSecondAsset"
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertEqual(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0), "TestImageSecondAsset?wid=220&hei=220&$pnglarge$&fit=fit,1")
    }
    
    func testFetchAssetURLForAllNilAssetForProductWithCTN() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        
        let imageFirstFeaturesAsset = PRXFeaturesAssetDetails()
        imageFirstFeaturesAsset.extension = "TestImageFirstExtension"
        imageFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let imageSecondFeaturesAsset = PRXFeaturesAssetDetails()
        imageSecondFeaturesAsset.extension = "TestImageSecondExtension"
        imageSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoFirstFeaturesAsset = PRXFeaturesAssetDetails()
        videoFirstFeaturesAsset.asset = "TestVideoFirstFeatureAsset"
        videoFirstFeaturesAsset.extension = "flv"
        videoFirstFeaturesAsset.featureCode = "TestFeatureCode"
        
        let videoSecondFeaturesAsset = PRXFeaturesAssetDetails()
        videoSecondFeaturesAsset.asset = "TestVideoSecondFeatureAsset"
        videoSecondFeaturesAsset.extension = "mpeg"
        videoSecondFeaturesAsset.featureCode = "TestFeatureCode"
        
        featuresData.assetDetails = [videoFirstFeaturesAsset, imageFirstFeaturesAsset, imageSecondFeaturesAsset, videoSecondFeaturesAsset]
        
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featureDetails = PRXFeaturesDetails()
        featureDetails.featureCode = "TestFeatureCode"
        featuresKeyBenefitArea.features = [featureDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        
        featuresResponse.data = featuresData
        
        mockPRXHandler?.mockProductFeatures = featuresResponse
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 0, featureIndex: 0))
    }
    
    func testFetchAssetURLForDefaultForProductWithCTN() {
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        XCTAssertNil(productDetailsPresenter.fetchFeatureAssetURLFor(benefitAreaIndex: 2, featureIndex: 2))
    }
}

//MARK: Test Product Details Utility Extension methods
extension MECProductDetailsPresenterTests {
    
    func testIsExtensionOfTypeVideoUtility() {
        var testExtension = "ogg"
        XCTAssertTrue(testExtension.isExtensionOfTypeVideo())
        
        testExtension = "OGG"
        XCTAssertTrue(testExtension.isExtensionOfTypeVideo())
        
        testExtension = "oGg"
        XCTAssertTrue(testExtension.isExtensionOfTypeVideo())
        
        testExtension = "oggs"
        XCTAssertFalse(testExtension.isExtensionOfTypeVideo())
        
        testExtension = "jpg"
        XCTAssertFalse(testExtension.isExtensionOfTypeVideo())
        
        testExtension = ""
        XCTAssertFalse(testExtension.isExtensionOfTypeVideo())
    }
    
    func testAppendWithStringUtility() {
        var testText: String? = "First"
        testText?.appendWith(text: "Second", withPrefix: "Prefix")
        XCTAssertEqual(testText, "FirstPrefixSecond")
        
        testText = ""
        testText?.appendWith(text: "Second", withPrefix: "Prefix")
        XCTAssertEqual(testText, "Second")
        
        testText = "First"
        testText?.appendWith(text: "", withPrefix: "Prefix")
        XCTAssertEqual(testText, "First")
        
        testText = "First"
        testText?.appendWith(text: "", withPrefix: "")
        XCTAssertEqual(testText, "First")
        
        testText = ""
        testText?.appendWith(text: "", withPrefix: "")
        XCTAssertEqual(testText, "")
        
        testText = "First"
        testText?.appendWith(text: "Second", withPrefix: nil)
        XCTAssertEqual(testText, "FirstSecond")
        
        testText = nil
        testText?.appendWith(text: "Second", withPrefix: nil)
        XCTAssertNil(testText)
        
        testText = nil
        testText?.appendWith(text: "", withPrefix: nil)
        XCTAssertNil(testText)
    }
    
    func testRoundedOfFloatUtility() {
        var testValue: Float? = 4.5
        XCTAssertEqual(testValue?.rounded(digits: 1), 4.5)
        
        testValue = 4.5
        XCTAssertEqual(testValue?.rounded(digits: 2), 4.5)
        
        testValue = 4.5456
        XCTAssertEqual(testValue?.rounded(digits: 2), 4.55)
        
        testValue = 4.0051
        XCTAssertEqual(testValue?.rounded(digits: 1), 4.0)
        
        testValue = 4.0051
        XCTAssertEqual(testValue?.rounded(digits: 2), 4.01)
        
        testValue = 4.1351
        XCTAssertEqual(testValue?.rounded(digits: 0), 4.0)
        
        testValue = 4
        XCTAssertEqual(testValue?.rounded(digits: 1), 4.0)
        
        testValue = 4
        XCTAssertEqual(testValue?.rounded(digits: 0), 4.0)
        
        testValue = nil
        XCTAssertNil(testValue?.rounded(digits: 2))
    }
}

//MARK: Test Cart methods
extension MECProductDetailsPresenterTests {
    
    func testAddProductToCartSuccess() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")

        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock

        MECConfiguration.shared.oauthData = ECSOAuthData()
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, true)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
    
    func testAddProductToCartWithError() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")

        let productDetailsMock = MECMockProductDetailsDelegate()
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        productDetailsPresenter.productDetailDelegate = productDetailsMock

        MECConfiguration.shared.oauthData = ECSOAuthData()
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, false)
        XCTAssertNotNil(productDetailsMock.productAddedToCartError)
        XCTAssertEqual((productDetailsMock.productAddedToCartError as NSError?)?.code, 123)
    }
    
    func testAddProductToCartWithOAuthError() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")

        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock

        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockECSService?.shouldSendOauthError = true
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, true)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
    
    func testAddProductToCartWithOAuthErrorFailure() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, false)
        XCTAssertNotNil(productDetailsMock.productAddedToCartError)
        XCTAssertEqual((productDetailsMock.productAddedToCartError as NSError?)?.code, 100)
    }
    
    func testAddProductToCartWithCreateCartError() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, false)
        XCTAssertNotNil(productDetailsMock.productAddedToCartError)
        XCTAssertEqual((productDetailsMock.productAddedToCartError as NSError?)?.code, 100)
    }
    
    func testAddProductToCartWithCreateCartErrorFailure() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockECSService?.shoppingCartError = NSError(domain: "", code: 6023, userInfo: nil)
        mockECSService?.createShoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, false)
        XCTAssertNotNil(productDetailsMock.productAddedToCartError)
        XCTAssertEqual((productDetailsMock.productAddedToCartError as NSError?)?.code, 123)
    }
    
    func testAddProductToCartErrorPrority() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockECSService?.shouldSendOauthError = true
        mockECSService?.shoppingCartError = NSError(domain: "", code: 6023, userInfo: nil)
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, true)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
    
    func testAddProductToCartWithCreateCartErrorSuccess() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockECSService?.shoppingCartError = NSError(domain: "", code: 6023, userInfo: nil)
        mockECSService?.createShoppingCart = ECSPILShoppingCart()
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, true)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
    
    func testAddProductToCartWithNilProduct() {
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        MECConfiguration.shared.oauthData = ECSOAuthData()
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, false)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
    
    func testCreateCartOAuthFailure() {
        let product = ECSPILProduct()
        product.ctn = "TestCTN"
        mockECSService?.fetchedProduct = product
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        let productDetailsMock = MECMockProductDetailsDelegate()
        productDetailsPresenter.productDetailDelegate = productDetailsMock
        
        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockECSService?.shoppingCartError = NSError(domain: "", code: 6023, userInfo: nil)
        mockECSService?.shouldSendCreateCartOauthError = true
        productDetailsPresenter.addProductToCart()
        XCTAssertEqual(productDetailsMock.productAddedToCartSuccessfully, true)
        XCTAssertNil(productDetailsMock.productAddedToCartError)
    }
}

//MARK: Test Notify Me methods

extension MECProductDetailsPresenterTests {
    
    func testShouldDisplayNotifyMeSection() {
        MECConfiguration.shared.isHybrisAvailable = true
        let product = ECSPILProduct()
        let stock = ECSPILProductAvailability()
        let attributes = ECSPILAttributes()
        stock.quantity = 10
        stock.status = MECConstants.MECPILInStockKey
        attributes.availability = stock
        product.attributes = attributes
        mockECSService?.fetchedProduct = product
        
        productDetailsPresenter.loadProductDetailFor(productCTN: "TestCTN")
        
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        MECConfiguration.shared.isHybrisAvailable = false
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        stock.status = MECConstants.MECPILOutOfStock
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        MECConfiguration.shared.isHybrisAvailable = true
        XCTAssertTrue(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        stock.status = MECConstants.MECPILLowStockKey
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        stock.quantity = 0
        XCTAssertTrue(productDetailsPresenter.shouldDisplayNotifyMeSection())
    }
    
    func testShouldDisplayNotifyMeSectionWithDefaultValue() {
        MECConfiguration.shared.isHybrisAvailable = nil
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        MECConfiguration.shared.isHybrisAvailable = true
        XCTAssertTrue(productDetailsPresenter.shouldDisplayNotifyMeSection())
        
        MECConfiguration.shared.isHybrisAvailable = false
        XCTAssertFalse(productDetailsPresenter.shouldDisplayNotifyMeSection())
    }
}

//MARK: Test Utility methods

extension MECProductDetailsPresenterTests {
    
    func convertStringToDate(stringValue: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return dateFormatter.date(from: stringValue)
    }
}

//MARK: MECProductDetailsDelegate methods
class MECMockProductDetailsDelegate: NSObject, MECProductDetailsDelegate {
    var productDetailsSuccessCalled = false
    var productDetailsFailureCalled = false
    
    var productAddedToCartSuccessfully = false
    var productAddedToCartError: Error?
    
    func productDetailsDownloadSuccees() {
        productDetailsSuccessCalled = true
    }
    
    func productDetailsDownloadFailure() {
        productDetailsFailureCalled = true
    }
    
    func productAddedToShoppingCart() {
        productAddedToCartSuccessfully = true
    }
    func showError(error: Error?) {
        productAddedToCartError = error
    }
}
