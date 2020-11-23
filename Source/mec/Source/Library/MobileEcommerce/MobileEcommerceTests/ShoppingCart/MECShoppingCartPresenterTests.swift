/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
import PhilipsEcommerceSDK
import BVSDK
@testable import MobileEcommerceDev
import PlatformInterfaces

class MECShoppingCartPresenterTests: XCTestCase {

    var sut: MECShoppingCartPresenter?
    var mockService: MockECSService?
    var bazaarVoiceHandler = MockBazaarVoiceHandler()
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        sut = MECShoppingCartPresenter()
        let appInfra = MockAppInfra()
        sut?.bazaarVoiceHandler = bazaarVoiceHandler
        bazaarVoiceHandler.reviewAndRatingStatistics = bulkReviews()
        mockService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockService
        MECConfiguration.shared.sharedAppInfra = appInfra
        
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
        
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.oauthData = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.cartUpdateDelegate = nil
        super.tearDown()
    }

    func testInit() {
        sut = MECShoppingCartPresenter()
        XCTAssertNotNil(sut?.dataBus)
    }
    
    func testNumberOfProductInCartDataBusNil() {
        sut?.dataBus = nil
        XCTAssertEqual(sut?.numberOfProductInCart(), 0)
    }
    
    func testNumberOfProductInCartShoppingCartNil() {
        XCTAssertEqual(sut?.numberOfProductInCart(), 0)
    }
    
    func testNumberOfProductInCartShoppingCart() {
        let entry1 = ECSPILItem()
        let entry2 = ECSPILItem()
        let cart = getShoppingCart()
        cart.data?.attributes?.items = [entry1, entry2]
        sut?.dataBus?.shoppingCart = cart
        XCTAssertEqual(sut?.numberOfProductInCart(), 2)
    }
    
    func testtotalTaxEmptyCart() {
        XCTAssertEqual(sut?.totalTax(), "")
    }
    
    func testtotalTax() {
        sut?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(sut?.totalTax(), "10 $")
    }
    
    func testTotalPriceEmptyCart() {
        XCTAssertEqual(sut?.totalPrice(), "")
    }
    
    func testTotalPrice() {
        sut?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(sut?.totalPrice(), "100 $")
    }
    
    func testFetchShoppingCart() {
        mockService?.shoppingCart = getShoppingCart()
        MECConfiguration.shared.oauthData = ECSOAuthData()
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })
        XCTAssertNotNil(sut?.dataBus?.shoppingCart)
        XCTAssertEqual(sut?.totalPrice(), "100 $")
        XCTAssertEqual(sut?.totalTax(), "10 $")
    }
    
    func testFetchShoppingCartWithRating() {
        mockService?.shoppingCart = getShoppingCart()
        MECConfiguration.shared.oauthData = ECSOAuthData()
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })

        XCTAssertNotNil(sut?.dataBus?.shoppingCart)
        XCTAssertEqual(sut?.totalPrice(), "100 $")
        XCTAssertEqual(sut?.totalTax(), "10 $")

        XCTAssertEqual(sut?.averageRatingForProduct(ctn: "FirstCTN_First"), 3.9)
        XCTAssertEqual(sut?.averageRatingForProduct(ctn: "SecondCTN_Second"), 4.2)
        XCTAssertEqual(sut?.averageRatingForProduct(ctn: "ThirdCTN_Third"), 4.2)
    }

    func testFetchShoppingCartWithoutProduct() {
        
        mockService?.shoppingCart = getShoppingCart()
        mockService?.shoppingCart?.data?.attributes?.items = []
        MECConfiguration.shared.oauthData = ECSOAuthData()
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })

        XCTAssertNotNil(sut?.dataBus?.shoppingCart)
        XCTAssertEqual(sut?.totalPrice(), "100 $")
        XCTAssertEqual(sut?.totalTax(), "10 $")
    }
    
    func testFetchShoppingCartFailure() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        MECConfiguration.shared.oauthData = ECSOAuthData()
        mockService?.shoppingCartError = NSError(domain: "", code: 100, userInfo: nil)
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })
        XCTAssertNil(sut?.dataBus?.shoppingCart)
        XCTAssertTrue(mockDelegate.showErrorCalled)
    }
    
    
    func testFetchShoppingCartFailureOauthError() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        mockService?.oauthError = NSError(domain: "", code: 100, userInfo: nil)
        mockService?.shouldSendOauthError = true
        
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })
        XCTAssertNil(sut?.dataBus?.shoppingCart)
        XCTAssertTrue(mockDelegate.showErrorCalled)
    }
    
    func testFetchShoppingCartActualMethodFailureOauthError() {
        mockService?.oauthError = NSError(domain: "", code: 100, userInfo: nil)
        mockService?.shouldSendOauthError = true
        
        sut?.fetchMECShoppingCart(completionHandler: { (cart, error) in
            XCTAssertNotNil(cart)
            XCTAssertNil(error)
        })
    }
    
    func testAverageRatingForProductInValidCTN() {
        sut?.cartProductReviews = bulkReviews()
        XCTAssertEqual(sut?.averageRatingForProduct(ctn: "FirstCTN_First"), 3.9)
    }
    
    func testAverageRatingForProductNilCTN() {
           sut?.cartProductReviews = bulkReviews()
           XCTAssertEqual(sut?.averageRatingForProduct(ctn: nil), 0.0)
    }
    
    func testAverageRatingForProductValidCTN() {
        sut?.cartProductReviews = bulkReviews()
        XCTAssertEqual(sut?.averageRatingForProduct(ctn: "SecondCTN_Second"), 4.2)
    }
    
    func testtotalNumberOfReviewsForProductInValidCTN() {
        sut?.cartProductReviews = bulkReviews()
        XCTAssertEqual(sut?.totalNumberOfReviewsForProduct(ctn: "FirstCTN_First"), 200)
    }
    
    func testtotalNumberOfReviewsForProductNilCTN() {
        sut?.cartProductReviews = bulkReviews()
        XCTAssertEqual(sut?.totalNumberOfReviewsForProduct(ctn: nil), 0)
    }
    
    func testisCartLoadedFalse() {
        XCTAssertEqual(sut?.isCartLoaded(), false)
    }
    
    func testisCartLoadedTrue() {
        sut?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(sut?.isCartLoaded(), true)
    }
    
    func testtotalNumberOfReviewsForProductValidCTN() {
        sut?.cartProductReviews = bulkReviews()
        XCTAssertEqual(sut?.totalNumberOfReviewsForProduct(ctn: "SecondCTN_Second"), 100)
    }
    
    func testTotalCartQuantityCartNil() {
        XCTAssertEqual(sut?.totalCartQuantity(), 0)
    }
    
    func testTotalCartQuantity() {
        let cart = getShoppingCart()
        cart.data?.attributes?.units = 10
        sut?.dataBus?.shoppingCart = cart
        XCTAssertEqual(sut?.totalCartQuantity(), 10)
    }
    
    func testdiscountPercentageEntryNil() {
        XCTAssertEqual(sut?.discountPercentage(for: nil), nil)
    }
    
    func testdiscountPercentageEqualValue() {
        let price = ECSPILPrice()
        price.value = 100
        price.formattedValue = "100 $"
        
        let entry = ECSPILItem()
        entry.discountPrice = price
        XCTAssertEqual(sut?.discountPercentage(for: entry), nil)
    }
    
    func testdiscountPercentageTest1() {
        let price = ECSPILPrice()
        price.value = 100
        price.formattedValue = "100 $"
        
        let basePrice = ECSPILPrice()
        basePrice.value = 50
        basePrice.formattedValue = "50 $"
        
        let entry = ECSPILItem()
        entry.discountPrice = basePrice
        entry.price = price
        XCTAssertEqual(sut?.discountPercentage(for: entry), "-50.00%")
    }
    
    func testdiscountPercentageTest2() {
        let price = ECSPILPrice()
        price.value = 100
        price.formattedValue = "100 $"
        
        let entry = ECSPILItem()
        entry.discountPrice = nil
        entry.price = price
        XCTAssertEqual(sut?.discountPercentage(for: entry), nil)
    }
    
    func testdiscountPercentageTest3() {
        let price = ECSPILPrice()
        price.value = 100
        price.formattedValue = "100 $"
        
        let basePrice = ECSPILPrice()
        basePrice.value = 0
        basePrice.formattedValue = "0"
        
        let entry = ECSPILItem()
        entry.discountPrice = basePrice
        entry.price = price
        XCTAssertEqual(sut?.discountPercentage(for: entry), "-100.00%")
    }
    
    func testdiscountPercentageTest4() {
        let price = ECSPILPrice()
        price.value = 0
        price.formattedValue = "0 $"
        
        let basePrice = ECSPILPrice()
        basePrice.value = 100
        basePrice.formattedValue = "100 $"
        
        let entry = ECSPILItem()
        entry.discountPrice = basePrice
        XCTAssertEqual(sut?.discountPercentage(for: entry), nil)
    }
    
    func testcartProductEntryAtIndexEmptyCart() {
        sut?.dataBus?.shoppingCart = ECSPILShoppingCart()
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 2), nil)
    }
    
    func testcartProductEntryAtIndexNilCart() {
        sut?.dataBus?.shoppingCart = nil
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 2), nil)
    }
    
    func testcartProductEntryAtIndexValid() {
        let entry1 = ECSPILItem()
        let entry2 = ECSPILItem()
        let entry3 = ECSPILItem()
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [entry1, entry2, entry3]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 2), entry3)
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 1), entry2)
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 0), entry1)
    }
    
    func testcartProductEntryAtIndexOutOfBound() {
        let entry1 = ECSPILItem()
        let entry2 = ECSPILItem()
        let entry3 = ECSPILItem()
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [entry1, entry2, entry3]
        sut?.dataBus?.shoppingCart = cart
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: 12), nil)
    }
    
    func testcartProductEntryAtIndexMinus() {
        let entry1 = ECSPILItem()
        let entry2 = ECSPILItem()
        let entry3 = ECSPILItem()
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [entry1, entry2, entry3]
        sut?.dataBus?.shoppingCart = cart
        XCTAssertEqual(sut?.cartProductEntryAtIndex(productIndex: -1), nil)
    }
    
    func testgetStockStatusMessageOutOfStock() {
        let stock = ECSPILProductAvailability()
        stock.status = "OUT_OF_STOCK"
        let entry = ECSPILItem()
        entry.availability = stock
        XCTAssertNotNil(sut?.getStockStatusMessage(entry: entry))
    }
    
    func testgetStockStatusMessageEntryNil() {
        XCTAssertEqual(sut?.getStockStatusMessage(entry: nil), nil)
    }
    
    func testgetStockStatusMessageStockLessThanQuantity() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 6
        let entry = ECSPILItem()
        entry.quantity = 7
        entry.availability = stock
        XCTAssertEqual(sut?.getStockStatusMessage(entry: entry), NSAttributedString(string:"Only 6 products left"))
    }
    
    func testgetStockStatusMessageStockLessThan5() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 4
        let entry = ECSPILItem()
        entry.quantity = 1
        entry.availability = stock
        XCTAssertEqual(sut?.getStockStatusMessage(entry: entry), NSAttributedString(string: "Only 4 products left"))
    }
    
    func testgetStockStatusMessage() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 6
        let entry = ECSPILItem()
        entry.quantity = 1
        entry.availability = stock
        XCTAssertEqual(sut?.getStockStatusMessage(entry: entry), nil)
    }
    
    func testgetStockStatusMessage1() {
        let entry = ECSPILItem()
        entry.quantity = 1
        entry.availability = nil
        XCTAssertNotNil(sut?.getStockStatusMessage(entry: entry))
    }
    
    func testshouldEnableCheckoutQuantityLessThanStock() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 6
        let entry = ECSPILItem()
        entry.quantity = 4
        entry.availability = stock
        
        let stock1 = ECSPILProductAvailability()
        stock1.status = "IN_STOCK"
        stock1.quantity = 100
        let entry1 = ECSPILItem()
        entry1.quantity = 99
        entry1.availability = stock1
        
        let cart = getShoppingCart()
        cart.data?.attributes?.items = [entry, entry1]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.shouldEnableCheckout(), true)
    }
    
    func testshouldEnableCheckou_quantityGreaterThanStock() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 6
        let entry = ECSPILItem()
        entry.quantity = 7
        entry.availability = stock
        
        let stock1 = ECSPILProductAvailability()
        stock1.status = "IN_STOCK"
        stock1.quantity = 100
        let entry1 = ECSPILItem()
        entry1.quantity = 99
        entry1.availability = stock1
        
        let cart = getShoppingCart()
        cart.data?.attributes?.items = [entry, entry1]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.shouldEnableCheckout(), false)
    }
    
    func testshouldEnableCheckou_quantityEqualThanStock() {
        let stock = ECSPILProductAvailability()
        stock.status = "IN_STOCK"
        stock.quantity = 7
        let entry = ECSPILItem()
        entry.quantity = 7
        entry.availability = stock
        
        let stock1 = ECSPILProductAvailability()
        stock1.status = "IN_STOCK"
        stock1.quantity = 100
        let entry1 = ECSPILItem()
        entry1.quantity = 99
        entry1.availability = stock1
        
        let cart = getShoppingCart()
        cart.data?.attributes?.items = [entry, entry1]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.shouldEnableCheckout(), true)
    }
    
    func testshouldEnableCheckou_OutOfStock() {
        let stock = ECSPILProductAvailability()
        stock.status = "OUT_OF_STOCK"
        stock.quantity = 6
        let entry = ECSPILItem()
        entry.quantity = 4
        entry.availability = stock
        
        let stock1 = ECSPILProductAvailability()
        stock1.status = "IN_STOCK"
        stock1.quantity = 100
        let entry1 = ECSPILItem()
        entry1.quantity = 99
        
        let cart = getShoppingCart()
        cart.data?.attributes?.items = [entry, entry1]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.shouldEnableCheckout(), false)
    }
    
    func testshouldShowApplyVoucher() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 1
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertEqual(sut?.shouldShowApplyVoucher(), true)
    }
    
    func testshouldShowApplyVoucherFalse() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 0
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertEqual(sut?.shouldShowApplyVoucher(), false)
    }
    
    func testshouldShowApplyVoucherInvalid() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = "0"
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertEqual(sut?.shouldShowApplyVoucher(), false)
    }
    
    func testShouldShowApplyVoucherError() {
        let appConfig = MockAppConfig()
        appConfig.getPropertyForKeyError = NSError(domain: "", code: 123, userInfo: nil)
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertEqual(sut?.shouldShowApplyVoucher(), false)
    }
    
    func testisVoucherAlreadyAppliedAppliedVoucherId() {
        let voucher1 = ECSPILAppliedVoucher()
        voucher1.voucherCode = "abcd"
        
        let voucher2 = ECSPILAppliedVoucher()
        voucher2.voucherCode = "1234"
        
        let cart = getShoppingCart()
        cart.data?.attributes?.appliedVouchers = [voucher1, voucher2]
        
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertEqual(sut?.isVoucherAlreadyApplied(voucherId: "abcd"), true)
        XCTAssertEqual(sut?.isVoucherAlreadyApplied(voucherId: "lmno"), false)
    }
    
    func testCheckAndRemoveAutoApplyVoucher() {
        MECConfiguration.shared.voucherCode = "OldCode"
        sut?.checkAndRemoveAutoApplyVoucher(voucherId: "NewCode")
        XCTAssertNotNil(MECConfiguration.shared.voucherCode)
        XCTAssertEqual(MECConfiguration.shared.voucherCode, "OldCode")
        
        MECConfiguration.shared.voucherCode = "NewCode"
        sut?.checkAndRemoveAutoApplyVoucher(voucherId: "NewCode")
        XCTAssertNil(MECConfiguration.shared.voucherCode)
        
        MECConfiguration.shared.voucherCode = "newCode"
        sut?.checkAndRemoveAutoApplyVoucher(voucherId: "NewCode")
        XCTAssertNotNil(MECConfiguration.shared.voucherCode)
        XCTAssertEqual(MECConfiguration.shared.voucherCode, "newCode")
        
        MECConfiguration.shared.voucherCode = nil
        sut?.checkAndRemoveAutoApplyVoucher(voucherId: "NewCode")
        XCTAssertNil(MECConfiguration.shared.voucherCode)
    }
    
    func testdeleteProductAtIndexOutOfBound() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        let mockCart = getShoppingCart()
        mockService?.shoppingCart = mockCart
        
        let mockCart1 = getShoppingCart()
        sut?.dataBus?.shoppingCart = mockCart1
        sut?.deleteProductAtIndex(productIndex: 4)
        
        XCTAssertNotEqual(sut?.dataBus?.shoppingCart, mockCart)
        XCTAssertFalse(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testdeleteProductAtIndexSuccess() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        let mockCart1 = getShoppingCart()
        mockService?.shoppingCart = mockCart1
        
        let mockCart = getShoppingCart()
        mockCart.data?.attributes?.items = [ECSPILItem(),ECSPILItem(),ECSPILItem()]
        sut?.dataBus?.shoppingCart = mockCart
        
        sut?.deleteProductAtIndex(productIndex: 1)
        
        XCTAssertEqual(sut?.dataBus?.shoppingCart, mockCart1)
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testdeleteProductAtIndexSuccessTracking() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        let mockCart1 = getShoppingCart()
        mockService?.shoppingCart = mockCart1
        
        let mockCart = getShoppingCart()
        let entry = ECSPILItem()
        mockCart.data?.attributes?.items = [ECSPILItem(),entry,ECSPILItem()]
        sut?.dataBus?.shoppingCart = mockCart
        let mockTag = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTag
        sut?.deleteProductAtIndex(productIndex: 1)
        
        XCTAssertEqual(sut?.dataBus?.shoppingCart, mockCart1)
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
        
    }
    
    func testupdateShoppingCartSuccess() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        let mockCart = getShoppingCart()
        mockService?.shoppingCart = mockCart
        
        sut?.updateShoppingCart(quantity: 1, entry: ECSPILItem())
        
        XCTAssertEqual(sut?.dataBus?.shoppingCart, mockCart)
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testupdateShoppingCartError() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        
        mockService?.shoppingCartError = NSError(domain: "", code: 100, userInfo: nil)
        sut?.updateShoppingCart(quantity: 1, entry: ECSPILItem())
        
        XCTAssertTrue(mockDelegate.showErrorCalled)
        XCTAssertEqual(mockDelegate.errorShowed?.code, 100)
        XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
        XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:updateShoppingCart:Hybris:The operation couldn’t be completed. ( error 100.):100")
    }
    
    func testupdateShoppingCartSuccessOAuthError() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        
        let mockCart = getShoppingCart()
        mockService?.shoppingCart = mockCart
        
        mockService?.shouldSendOauthError = true
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "1234"
        mockService?.refreshAuthData = oauthData
        
        sut?.updateShoppingCart(quantity: 1, entry: ECSPILItem())
        
        XCTAssertEqual(sut?.dataBus?.shoppingCart, mockCart)
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    } 
    
    func testapplyVoucherToCartSuccess() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        mockService?.shoppingCart = getShoppingCart()
        sut?.dataBus = MECDataBus()
        sut?.dataBus?.shoppingCart = getShoppingCart()
        mockService?.voucherList = [ECSVoucher(),ECSVoucher()]
        let mockTag = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTag
        
        sut?.applyVoucherToCart(voucherId: "abc", completion: { (success, error) in })
        XCTAssertEqual((mockTag.inParamDict?[MECAnalyticsConstants.voucherCode] as? String), "abc")
        XCTAssertEqual((mockTag.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), MECAnalyticsConstants.voucherCodeApplied)
        XCTAssertEqual((mockTag.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "Retailer;FirstCTN_First;2;200.00,Retailer;SecondCTN_Second;4;400.00,Retailer;ThirdCTN_Third;6;600.00")
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testapplyVoucherToCartUnknowError() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        mockService?.voucherError = NSError(domain: "error", code: 9999, userInfo: [NSLocalizedDescriptionKey: "Apply voucher failed"])
        mockService?.shoppingCart = getShoppingCart()
        
        sut?.applyVoucherToCart(voucherId: "abc", completion: { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:applyVoucher:Hybris:Apply voucher failed:9999")
        })
    }
    
    func testapplyVoucherToCartSuccessWithOauthError() {
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        mockService?.shoppingCart = getShoppingCart()
        mockService?.voucherList = [ECSVoucher(),ECSVoucher()]

        mockService?.shouldSendOauthError = true
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "1234"
        mockService?.refreshAuthData = oauthData

        sut?.applyVoucherToCart(voucherId: "abc", completion: { (success, error) in })
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testdeleteVoucher() {
        let voucher1 = ECSPILAppliedVoucher()
        voucher1.voucherCode = "abcd"
        let voucher2 = ECSPILAppliedVoucher()
        voucher2.voucherCode = "lmno"

        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate

        let cart = getShoppingCart()
        cart.data?.attributes?.appliedVouchers = [voucher1, voucher2]
        mockService?.shoppingCart = getShoppingCart()
        sut?.dataBus?.shoppingCart = cart
        mockService?.voucherList = [ECSVoucher(),ECSVoucher()]
        sut?.deleteVoucher(at: 0, completion: { (success, error) in })
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testdeleteVoucherOauthErrorSuccess() {
        let voucher1 = ECSPILAppliedVoucher()
        voucher1.voucherCode = "abcd"
        let voucher2 = ECSPILAppliedVoucher()
        voucher2.voucherCode = "lmno"

        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate

        let cart = getShoppingCart()
        cart.data?.attributes?.appliedVouchers = [voucher1, voucher2]
        mockService?.shoppingCart = getShoppingCart()
        sut?.dataBus?.shoppingCart = cart
        mockService?.voucherList = [ECSVoucher(),ECSVoucher()]

        mockService?.shouldSendOauthError = true
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "1234"
        mockService?.refreshAuthData = oauthData
        sut?.deleteVoucher(at: 0, completion: { (success, error) in })
        XCTAssertTrue(mockDelegate.shoppingCartLoadedCalled)
    }
    
    func testdeleteVoucherUnknowError() {
        let voucher1 = ECSPILAppliedVoucher()
        voucher1.voucherCode = "abcd"
        let voucher2 = ECSPILAppliedVoucher()
        voucher2.voucherCode = "lmno"
        
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        
        let cart = getShoppingCart()
        cart.data?.attributes?.appliedVouchers = [voucher1, voucher2]
        mockService?.shoppingCart = getShoppingCart()
        sut?.dataBus?.shoppingCart = cart
        mockService?.voucherError = NSError(domain: "error", code: 9999, userInfo: [NSLocalizedDescriptionKey: "Delete voucher failed"])
        sut?.deleteVoucher(at: 0, completion: { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 9999)
            XCTAssertFalse(mockDelegate.shoppingCartLoadedCalled)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:removeVoucher:Hybris:Delete voucher failed:9999")
        })
    }
    
    func testdeleteVoucherOutOfBound() {
        let voucher1 = ECSPILAppliedVoucher()
        voucher1.voucherCode = "abcd"
        let voucher2 = ECSPILAppliedVoucher()
        voucher2.voucherCode = "lmno"
        
        let mockDelegate = MockShoppingCartDelegate()
        sut?.shoppingCartDelegate = mockDelegate
        
        let cart = getShoppingCart()
        cart.data?.attributes?.appliedVouchers = [voucher1, voucher2]
        mockService?.shoppingCart = getShoppingCart()
        sut?.dataBus?.shoppingCart = cart
        sut?.deleteVoucher(at: 3, completion: { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
            XCTAssertFalse(mockDelegate.shoppingCartLoadedCalled)
        })
    }
    
    func testfetchSavedAddressesSuccess() {
        mockService?.savedAddresses = [getAddress(), getAddress()]
        sut?.fetchSavedAddresses(completionHandler: { (addressList, error) in
            XCTAssertEqual(addressList?.count, 2)
            XCTAssertNil(error)
        })
    }
    
    func testfetchSavedAddressesOauthErrorSuccess() {
        mockService?.savedAddresses = [getAddress(), getAddress()]
        
        mockService?.shouldSendOauthError = true
        let oauthData = ECSOAuthData()
        oauthData.refreshToken = "1234"
        mockService?.refreshAuthData = oauthData
        
        sut?.fetchSavedAddresses(completionHandler: { (addressList, error) in
            XCTAssertEqual(addressList?.count, 2)
            XCTAssertNil(error)
        })
    }
    
    func testfetchSavedAddressesUnknowError() {
        mockService?.savedAddressesError = NSError(domain: "", code: 111, userInfo: [NSLocalizedDescriptionKey: "fetch address failed"])
        
        sut?.fetchSavedAddresses(completionHandler: { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 111)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchSavedAddresses:Hybris:fetch address failed:111")
        })
    }
        
    func testprepareCartProductString() {
        let cart = getShoppingCart()
        XCTAssertEqual(sut?.preparePILCartEntryListString(entries: cart.data?.attributes?.items), "Retailer;FirstCTN_First;2;200.00,Retailer;SecondCTN_Second;4;400.00,Retailer;ThirdCTN_Third;6;600.00")
        
        let entry = ECSPILItem()
        entry.quantity = 2
        entry.discountPrice = ECSPILPrice()
        entry.discountPrice?.value = 100.0
        entry.ctn = "FirstCTN_First"
        
        XCTAssertEqual(sut?.preparePILCartEntryListString(entries: [entry], updatedQuantity: 4), "Retailer;FirstCTN_First;4;400.00")
        XCTAssertEqual(sut?.preparePILCartEntryListString(entries: [entry], updatedQuantity: 20), "Retailer;FirstCTN_First;20;2000.00")
        XCTAssertEqual(sut?.preparePILCartEntryListString(entries: [entry]), "Retailer;FirstCTN_First;2;200.00")
    }
    
    func testCartProductList() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [ECSPILItem(), ECSPILItem()]
        sut?.dataBus?.shoppingCart = cart
        
        XCTAssertNotNil(sut?.cartProductList())
        XCTAssertEqual(sut?.cartProductList()?.count, 2)
        
        cart.data?.attributes?.items = []
        XCTAssertNotNil(sut?.cartProductList())
        XCTAssertEqual(sut?.cartProductList()?.count, 0)
        
        cart.data?.attributes?.items = nil
        XCTAssertNil(sut?.cartProductList())
    }
/**************************************************************************************************************************/
    
    func getShoppingCart() -> ECSPILShoppingCart {
        let totalPriceWithTax = ECSPILPrice()
        totalPriceWithTax.formattedValue = "100 $"
        totalPriceWithTax.value = 100.0
        
        let totalTax = ECSPILPrice()
        totalTax.formattedValue = "10 $"
        totalTax.value = 10.0
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        let pricing = ECSPILPricing()
        attributes.pricing = pricing
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.pricing?.total = totalPriceWithTax
        cart.data?.attributes?.pricing?.tax = totalTax
        cart.data?.attributes?.units = 12
        
        let entry1 = ECSPILItem()
        entry1.quantity = 2
        entry1.price = totalPriceWithTax
        entry1.ctn = "FirstCTN_First"
        
        let entry2 = ECSPILItem()
        entry2.quantity = 4
        entry2.discountPrice = totalPriceWithTax
        entry2.ctn = "SecondCTN_Second"
        
        let entry3 = ECSPILItem()
        entry3.quantity = 6
        entry3.discountPrice = totalPriceWithTax
        entry3.ctn = "ThirdCTN_Third"
        
        cart.data?.attributes?.items = [entry1, entry2, entry3]
        
        return cart
    }
    
    func getAddress() -> ECSAddress {
        let address = ECSAddress()
        return address
    }
    
    func bulkReviews() -> [BVProductStatistics] {
        let firstBulkReviewStatistics = BVProductStatistics()
        let firstReviewStatistics = BVReviewStatistic()
        firstReviewStatistics.averageOverallRating = 3.9
        firstReviewStatistics.totalReviewCount = 200
        firstBulkReviewStatistics.reviewStatistics = firstReviewStatistics
        firstBulkReviewStatistics.productId = "FirstCTN_First"
        
        let secondBulkReviewStatistics = BVProductStatistics()
        let secondReviewStatistics = BVReviewStatistic()
        secondReviewStatistics.averageOverallRating = 4.2
        secondReviewStatistics.totalReviewCount = 100
        secondBulkReviewStatistics.reviewStatistics = secondReviewStatistics
        secondBulkReviewStatistics.productId = "SecondCTN_Second"
        
        let thirdBulkReviewStatistics = BVProductStatistics()
        let thirdReviewStatistics = BVReviewStatistic()
        thirdReviewStatistics.averageOverallRating = 4.2
        thirdReviewStatistics.totalReviewCount = 100
        thirdBulkReviewStatistics.reviewStatistics = thirdReviewStatistics
        thirdBulkReviewStatistics.productId = "ThirdCTN_Third"
        
        return [firstBulkReviewStatistics, secondBulkReviewStatistics, thirdBulkReviewStatistics]
    }
    
    func testCartChangesAreNotifiedToListeners() {
        let mockCartUpdateListener = MockCartUpdateListener()
        MECConfiguration.shared.cartUpdateDelegate = mockCartUpdateListener
        mockService?.shoppingCart = getShoppingCart()
        MECConfiguration.shared.oauthData = ECSOAuthData()
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })
        XCTAssertEqual(mockCartUpdateListener.cartCount, 12)
        
        mockService?.shoppingCart?.data?.attributes = nil
        sut?.fetchShoppingCart(completionHandler: { (_, _) in })
        XCTAssertEqual(mockCartUpdateListener.cartCount, 0)
    }
}

class MockCartUpdateListener: NSObject, MECCartUpdateProtocol {
    
    var cartCount = -1
    func didUpdateCartCount(cartCount: Int) {
        self.cartCount = cartCount
    }
    
    func shouldShowCart(_ shouldShow: Bool) { }
}
