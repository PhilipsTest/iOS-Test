/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev
import BVSDK
import PhilipsPRXClient

class MECProductCataloguePresenterTests: XCTestCase {
    
    var sut: MECProductCataloguePresenter!
    var mockDelegate: MockProductCatalogueDelegate?
    var mockService: MockECSService?
    var mockbazaarVoice : MockBazaarVoiceHandler?
    var mockServiceDiscovery: ServiceDiscoveryMock?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        sut = MECProductCataloguePresenter()
        
        mockDelegate = MockProductCatalogueDelegate()
        mockbazaarVoice = MockBazaarVoiceHandler()
        mockService = MockECSService(propositionId: "TEST", appInfra: MockAppInfra())
        sut?.productCatalogueDelegate = mockDelegate
        sut?.bazaarVoiceHandler = mockbazaarVoice
        MECConfiguration.shared.ecommerceService = mockService
        
        let appinfra = MockAppInfra()
        mockServiceDiscovery = ServiceDiscoveryMock()
        appinfra.serviceDiscovery = mockServiceDiscovery
        let mockAppIdentity = MockAppIdentity()
        appinfra.appIdentity = mockAppIdentity
        MECConfiguration.shared.sharedAppInfra = appinfra
        
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        mockService = nil
        MECConfiguration.shared.ecommerceService = nil
        mockbazaarVoice = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
        super.tearDown()
    }
    
    func testloadProductListHybrisWithoutFilterSuccess() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListHybrisWithoutFilterSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 4)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadProductListHybrisWithFilterThreashold() {
        let prod = ECSPILProduct()
        prod.ctn = "HD1234/10"

        let products = ECSPILProducts()
        products.products = Array(repeating: prod, count: 100)
        sut.productFetchOffset = 100

        mockService?.products = products

        MECConfiguration.shared.isHybrisAvailable = true

        sut?.loadProductList(withCTNs: ["HD1234/40", "HD1234/40"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testLoadProductListHybrisWithFilterThreashold")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertTrue(self.mockDelegate!.emptyRequestThresholdReachedCalled)
            XCTAssertFalse(self.mockDelegate!.showErrorCalled)
            XCTAssertFalse(self.mockDelegate!.productListLoadedCalled)
            XCTAssertEqual(self.sut.productFetchOffset, 250)
            XCTAssertFalse(self.sut.isAllProductsDownloaded)

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadProductListHybrisWithFilterNoThreashold() {
        let prod = ECSPILProduct()
        prod.ctn = "HD1234/10"

        let products = ECSPILProducts()
        products.products = Array(repeating: prod, count: 50)
        sut.productFetchOffset = 100

        mockService?.products = products

        MECConfiguration.shared.isHybrisAvailable = true

        sut?.loadProductList(withCTNs: ["HD1234/40", "HD1234/10"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testLoadProductListHybrisWithFilterNoThreashold")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            XCTAssertFalse(self.mockDelegate!.emptyRequestThresholdReachedCalled)
            XCTAssertFalse(self.mockDelegate!.showErrorCalled)
            XCTAssertTrue(self.mockDelegate!.productListLoadedCalled)
            XCTAssertEqual(self.sut.productFetchOffset, 50)
            XCTAssertFalse(self.sut.isAllProductsDownloaded)

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListHybrisWithoutFilterSuccessWithReview() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        
        let rev1 = BVReviewStatistic()
        rev1.averageOverallRating = NSNumber(value: 3.0)
        rev1.totalReviewCount = NSNumber(integerLiteral: 10)
        let bazaarRev1 = BVProductStatistics()
        bazaarRev1.nativeReviewStatistics = rev1
        bazaarRev1.productId = "HD1234/10"
        bazaarRev1.reviewStatistics = rev1
        
        let rev2 = BVReviewStatistic()
        rev2.averageOverallRating = NSNumber(value: 4.0)
        rev2.totalReviewCount = NSNumber(integerLiteral: 20)
        let bazaarRev2 = BVProductStatistics()
        bazaarRev2.nativeReviewStatistics = rev2
        bazaarRev2.productId = "HD1234/20"
        bazaarRev2.reviewStatistics = rev2
        
        let rev3 = BVReviewStatistic()
        rev3.averageOverallRating = NSNumber(value: 3.0)
        rev3.totalReviewCount = NSNumber(integerLiteral: 10)
        let bazaarRev3 = BVProductStatistics()
        bazaarRev3.nativeReviewStatistics = rev3
        bazaarRev3.productId = "AB1234/10"
        bazaarRev3.reviewStatistics = rev3
        mockbazaarVoice?.reviewAndRatingStatistics = [bazaarRev1, bazaarRev2, bazaarRev3]
        
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListHybrisWithoutFilterSuccessWithReview")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.totalNumberOfReviews?.intValue, 10)
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.totalNumberOfReviews?.intValue, 20)
            XCTAssertNil(self.sut?.productAtIndex(index: 2)?.totalNumberOfReviews?.intValue)
            XCTAssertNil(self.sut?.productAtIndex(index: 3)?.totalNumberOfReviews?.intValue)
            
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.averageRating?.floatValue, 3.0)
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.averageRating?.floatValue, 4.0)
            XCTAssertNil(self.sut?.productAtIndex(index: 2)?.averageRating)
            XCTAssertNil(self.sut?.productAtIndex(index: 3)?.averageRating)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListHybrisWithFilterSuccess() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListHybrisWithFilterSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 2)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertNil(self.sut?.productAtIndex(index: 10))
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.fetchProductCTN(), "HD1234/10")
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.fetchProductCTN(), "HD1234/40")
            XCTAssertEqual(self.sut.productFetchOffset, 50)
            XCTAssertEqual(self.sut.isAllProductsDownloaded, true)
            XCTAssertEqual(self.sut.isDataFetching, false)
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadProductListHybrisWithNoProducts() {
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testLoadProductListHybrisWithNoProducts")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertEqual(self.sut.productFetchOffset, 50)
            XCTAssertEqual(self.sut.isAllProductsDownloaded, true)
            XCTAssertEqual(self.sut.isDataFetching, false)
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadProductListHybrisFilterWithNoProducts() {
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testLoadProductListHybrisFilterWithNoProducts")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertEqual(self.sut.productFetchOffset, 50)
            XCTAssertEqual(self.sut.isAllProductsDownloaded, true)
            XCTAssertEqual(self.sut.isDataFetching, false)
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListHybrisWithoutFilterFailure() {
        
        mockService?.error = NSError(domain: "domain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Tese error"])
        MECConfiguration.shared.isHybrisAvailable = true
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListHybrisWithoutFilterFailure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertNil(self.sut?.productAtIndex(index: 0))
            XCTAssertFalse(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertTrue(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertEqual(self.mockDelegate?.errorReceived?.localizedDescription, "Tese error")
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProducts:Hybris:Tese error:123")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListHybrisWithFilterFailure() {
        mockService?.error = NSError(domain: "domain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Tese error"])
        MECConfiguration.shared.isHybrisAvailable = true
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListHybrisWithFilterFailure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertNil(self.sut?.productAtIndex(index: 0))
            XCTAssertFalse(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertTrue(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertEqual(self.mockDelegate?.errorReceived?.localizedDescription, "Tese error")
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProducts:Hybris:Tese error:123")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListRetailerSuccess() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/40"
        mockService?.productList = [prod1, prod2]
        
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 2)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.fetchProductCTN(), "HD1234/10")
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.fetchProductCTN(), "HD1234/40")
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListRetailerSuccessWithEmpty() {
        
        mockService?.productList = nil
        mockService?.error = NSError(domain: "no product", code: 100, userInfo: nil)
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerSuccessWithEmpty")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertNil(self.sut?.productAtIndex(index: 0))
            XCTAssertFalse(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertTrue(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListRetailerSuccessWithMoreProduct() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/40"
        mockService?.productList = [prod1, prod2]
        
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 2)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.fetchProductCTN(), "HD1234/10")
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.fetchProductCTN(), "HD1234/40")
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertEqual(self.sut?.shouldLoadMoreProducts(), true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListRetailerSuccessWith50Product() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/40"
        mockService?.productList = [prod1, prod2]
        
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 2)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertEqual(self.sut?.productAtIndex(index: 0)?.fetchProductCTN(), "HD1234/10")
            XCTAssertEqual(self.sut?.productAtIndex(index: 1)?.fetchProductCTN(), "HD1234/40")
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertFalse(self.sut.shouldLoadMoreProducts())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testloadProductListRetailerSuccessWithProductCase1() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/40"
        mockService?.productList = []
        
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12",
                                        "HD1234/10","HD1234/40", "HD124/12", "HX4356/09", "abc123/12"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertFalse(self.sut.shouldLoadMoreProducts())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testloadProductListRetailerFailure() {
        
        mockService?.error = NSError(domain: "domain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Tese error"])
        MECConfiguration.shared.isHybrisAvailable = false
        
        sut?.loadProductList(withCTNs: ["HD1234/10","HD1234/40"], filter: ECSPILProductFilter())
        let expectation = self.expectation(description: "testloadProductListRetailerFailure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertNil(self.sut?.productAtIndex(index: 0))
            XCTAssertFalse(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertTrue(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertEqual(self.mockDelegate?.errorReceived?.localizedDescription, "Tese error")
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchBulkRatingsForCTNList:PRX:Tese error:123")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadMoreProductSuccess() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadMoreProducts()
        let expectation = self.expectation(description: "testLoadMoreProductSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 4)
            XCTAssertNotNil(self.sut?.productAtIndex(index: 0))
            XCTAssertTrue(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertFalse(self.mockDelegate?.showErrorCalled ?? true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testLoadMoreProductFailure() {
        
        mockService?.error = NSError(domain: "domain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Tese error"])
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadMoreProducts()
        let expectation = self.expectation(description: "testLoadMoreProductFailure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut?.numberOfProducts(), 0)
            XCTAssertNil(self.sut?.productAtIndex(index: 0))
            XCTAssertFalse(self.mockDelegate?.productListLoadedCalled ?? false)
            XCTAssertTrue(self.mockDelegate?.showErrorCalled ?? true)
            XCTAssertEqual(self.mockDelegate?.errorReceived?.localizedDescription, "Tese error")
            
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchProducts:Hybris:Tese error:123")
            
            expectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testShouldLoadMoreProductsNonHybrisCase1() {
        MECConfiguration.shared.isHybrisAvailable = false
        sut.isProductSearchInProgress = true
        XCTAssertFalse(sut.shouldLoadMoreProducts())
    }
    
    func testShouldLoadMoreProductsNonHybrisCase2() {
        MECConfiguration.shared.isHybrisAvailable = false
        sut.isProductSearchInProgress = true
        XCTAssertFalse(sut.shouldLoadMoreProducts())
    }
    
    func testshouldLoadMoreProductsCase3() {
        MECConfiguration.shared.isHybrisAvailable = false
        sut.isDataFetching = true
        XCTAssertFalse(sut.shouldLoadMoreProducts())
    }
    
    func testShouldLoadMoreProductsHybrisCase1() {
        sut.isAllProductsDownloaded = true
        
        MECConfiguration.shared.isHybrisAvailable = true
        XCTAssertFalse(sut.shouldLoadMoreProducts())
    }
    
    func testShouldLoadMoreProductsHybrisCase2() {
        sut.isAllProductsDownloaded = false
        
        MECConfiguration.shared.isHybrisAvailable = true
        XCTAssertTrue(sut.shouldLoadMoreProducts())
    }
    
    func testShouldLoadMoreProductsHybrisCase3() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HD1234/10"
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: ["HD1234/10", "HD1234/20", "HD1234/30", "HD1234/40"], filter: ECSPILProductFilter())
        
        XCTAssertFalse(sut.shouldLoadMoreProducts())
    }
    
    func testShouldLoadMoreProductsHybrisCase4() {
        let prod = ECSPILProduct()
        prod.ctn = "HD1234/10"
        
        let products = ECSPILProducts()
        products.products = Array(repeating: prod, count: 50)
        mockService?.products = products
        
        MECConfiguration.shared.isHybrisAvailable = true
        
        sut?.loadProductList(withCTNs: ["HD1234/10", "HD1234/20", "HD1234/30", "HD1234/40"], filter: ECSPILProductFilter())
        
        XCTAssertFalse(sut.shouldLoadMoreProducts())
        XCTAssertFalse(sut.isAllProductsDownloaded)
        XCTAssertEqual(sut.productFetchOffset, 50)
    }
    
    func testSearchProductSuccess() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HX1234/10"
        let summary1 = PRXSummaryData()
        summary1.productTitle = "abcd"
        prod1.productPRXSummary = summary1
        
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let summary2 = PRXSummaryData()
        summary2.productTitle = "HXABC"
        prod2.productPRXSummary = summary2
        
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let summary3 = PRXSummaryData()
        summary3.productTitle = "abcd"
        prod3.productPRXSummary = summary3
        
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        let summary4 = PRXSummaryData()
        summary4.productTitle = "abcd"
        prod4.productPRXSummary = summary4
        
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        MECConfiguration.shared.isHybrisAvailable = true
        sut.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        sut.searchProduct(searchText: "HX")
        
        XCTAssertNotNil(sut.productAtIndex(index: 0))
        XCTAssertNil(sut.productAtIndex(index: 3))
        XCTAssertEqual(sut.numberOfProducts(), 2)
    }
    
    func testSearchProductSuccessEmptySearchText() {
        let prod1 = ECSPILProduct()
        prod1.ctn = "HX1234/10"
        let summary1 = PRXSummaryData()
        summary1.productTitle = "abcd"
        prod1.productPRXSummary = summary1
        
        let prod2 = ECSPILProduct()
        prod2.ctn = "HD1234/20"
        let summary2 = PRXSummaryData()
        summary2.productTitle = "HXABC"
        prod2.productPRXSummary = summary2
        
        let prod3 = ECSPILProduct()
        prod3.ctn = "HD1234/30"
        let summary3 = PRXSummaryData()
        summary3.productTitle = "abcd"
        prod3.productPRXSummary = summary3
        
        let prod4 = ECSPILProduct()
        prod4.ctn = "HD1234/40"
        let summary4 = PRXSummaryData()
        summary4.productTitle = "abcd"
        prod4.productPRXSummary = summary4
        
        
        let products = ECSPILProducts()
        products.products = [prod1, prod2, prod3, prod4]
        mockService?.products = products
        MECConfiguration.shared.isHybrisAvailable = true
        sut.loadProductList(withCTNs: [], filter: ECSPILProductFilter())
        sut.searchProduct(searchText: "")
        
        XCTAssertNotNil(sut.productAtIndex(index: 0))
        XCTAssertEqual(sut.numberOfProducts(), 4)
    }
    
    func testCancelProductSearch() {
        sut.cancelProductSearch()
        let expectation = self.expectation(description: "testCancelProductSearch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockDelegate!.productSearchCompletedCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testfetchPrivacyURL() {
        mockServiceDiscovery?.serviceURL = "test.com"
        sut.fetchPrivacyURL { (url, error) in
            XCTAssertEqual(url, "test.com")
            XCTAssertEqual(self.mockServiceDiscovery?.serviceKey, "iap.privacyPolicy")
        }
    }
}

