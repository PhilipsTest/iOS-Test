/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECPaymentConfirmationViewControllerTests: XCTestCase {

    var sut: MECPaymentConfirmationViewController!
    var appInfra = MockAppInfra()
    var mockTagging = MECMockTagger()
    
    override func setUp() {
        super.setUp()
        sut = MECPaymentConfirmationViewController.instantiateFromAppStoryboard(appStoryboard: MECAppStoryboard.paymentConfirmation)
        MECConfiguration.shared.sharedAppInfra = appInfra
        MECConfiguration.shared.mecTagging = mockTagging
    }
    
    func testTrackPagename() {
        sut.viewWillAppear(true)
        XCTAssertEqual(mockTagging.inPageName, MECAnalyticPageNames.oredrConfirmationPage)
    }
    
    func testTrackOrderPurchaseWithOnlyProduct() {
        sut.orderDetail = orderDetail()
        sut.paymentStatus = .paymentSuccess
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view    
        sut.viewDidLoad()
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), "purchase")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "TestCategory;FirstCTN_First;10;100.00,TestCategory;FirstCTN_First;4;40.00")
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.promotion])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod])
    }
    
    func testTrackOrderPurchaseWithProductAndDeliveryMode() {
        sut.orderDetail = orderDetail()
        sut.orderDetail?.deliveryMode = ECSDeliveryMode()
        sut.orderDetail?.deliveryMode?.deliveryModeName = "Test Delivery mode"
        sut.paymentStatus = .paymentSuccess
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view
        sut.viewDidLoad()
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), "purchase")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "TestCategory;FirstCTN_First;10;100.00,TestCategory;FirstCTN_First;4;40.00")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod] as? String), "Test Delivery mode")
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.promotion])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode])
    }
    
    func testTrackOrderPurchaseWithProductAndVouchers() {
        sut.orderDetail = orderDetail()
        let voucher1 = ECSVoucher()
        voucher1.voucherCode = "TestVoucher1"
        let voucher2 = ECSVoucher()
        voucher2.voucherCode = "TestVoucher2"
        sut.orderDetail?.appliedVouchers = [voucher1, voucher2]
        sut.paymentStatus = .paymentSuccess
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view
        sut.viewDidLoad()
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), "purchase")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "TestCategory;FirstCTN_First;10;100.00,TestCategory;FirstCTN_First;4;40.00")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode] as? String), "TestVoucher1|TestVoucher2")
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.promotion])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod])
    }
    
    func testTrackOrderPurchaseWithProductAndOrderPromotioon() {
        sut.orderDetail = orderDetail()
        let promotion1 = ECSPromotion()
        promotion1.name = "TestPromotion1"
        let orderPromotion1 = ECSOrderPromotion()
        orderPromotion1.promotion = promotion1
        
        let promotion2 = ECSPromotion()
        promotion2.name = "TestPromotion2"
        let orderPromotion2 = ECSOrderPromotion()
        orderPromotion2.promotion = promotion2
        
        sut.orderDetail?.appliedOrderPromotions = [orderPromotion1, orderPromotion2]
        
        sut.paymentStatus = .paymentSuccess
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view
        sut.viewDidLoad()
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), "purchase")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "TestCategory;FirstCTN_First;10;100.00,TestCategory;FirstCTN_First;4;40.00")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.promotion] as? String), "TestPromotion1|TestPromotion2")
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode])
    }
    
    func testTrackOrderPurchaseWithAllData() {
        sut.orderDetail = orderDetail()
        
        let promotion1 = ECSPromotion()
        promotion1.name = "TestPromotion1"
        let orderPromotion1 = ECSOrderPromotion()
        orderPromotion1.promotion = promotion1

        let promotion2 = ECSPromotion()
        promotion2.name = "TestPromotion2"
        let orderPromotion2 = ECSOrderPromotion()
        orderPromotion2.promotion = promotion2
        
        sut.orderDetail?.appliedOrderPromotions = [orderPromotion1, orderPromotion2]
        
        let voucher1 = ECSVoucher()
        voucher1.voucherCode = "TestVoucher1"
        let voucher2 = ECSVoucher()
        voucher2.voucherCode = "TestVoucher2"
        sut.orderDetail?.appliedVouchers = [voucher1, voucher2]
        
        sut.orderDetail?.deliveryMode = ECSDeliveryMode()
        sut.orderDetail?.deliveryMode?.deliveryModeName = "Test Delivery mode"
        
        sut.paymentStatus = .paymentSuccess
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view
        sut.viewDidLoad()
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents] as? String), "purchase")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.productListKey] as? String), "TestCategory;FirstCTN_First;10;100.00,TestCategory;FirstCTN_First;4;40.00")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.promotion] as? String), "TestPromotion1|TestPromotion2")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod] as? String), "Test Delivery mode")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode] as? String), "TestVoucher1|TestVoucher2")
        XCTAssertEqual((mockTagging.inParamDict?[MECAnalyticsConstants.promotion] as? String), "TestPromotion1|TestPromotion2")
    }
    
    func testTrackOrderPurchaseWithAllDataOrderFailed() {
        sut.orderDetail = orderDetail()
        
        let promotion1 = ECSPromotion()
        promotion1.name = "TestPromotion1"
        let orderPromotion1 = ECSOrderPromotion()
        orderPromotion1.promotion = promotion1

        let promotion2 = ECSPromotion()
        promotion2.name = "TestPromotion2"
        let orderPromotion2 = ECSOrderPromotion()
        orderPromotion2.promotion = promotion2
        
        sut.orderDetail?.appliedOrderPromotions = [orderPromotion1, orderPromotion2]
        
        let voucher1 = ECSVoucher()
        voucher1.voucherCode = "TestVoucher1"
        let voucher2 = ECSVoucher()
        voucher2.voucherCode = "TestVoucher2"
        sut.orderDetail?.appliedVouchers = [voucher1, voucher2]
        
        sut.orderDetail?.deliveryMode = ECSDeliveryMode()
        sut.orderDetail?.deliveryMode?.deliveryModeName = "Test Delivery mode"
        
        sut.paymentStatus = .paymentPending
        MECConfiguration.shared.rootCategory = "TestCategory"
        _ = sut.view
        sut.viewDidLoad()
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.specialEvents])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.productListKey])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.promotion])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.voucherCode])
        XCTAssertNil(mockTagging.inParamDict?[MECAnalyticsConstants.deliveryMethod])
    }
    
//    func testOrderedProductList() {
//        let detail = orderDetail()
//        let productlist = detail.orderedProductList()
//
//        XCTAssertEqual(detail.entries?.count, productlist?.count)
//        XCTAssertEqual(detail.entries?.first?.product?.ctn, productlist?.first?.product?.ctn)
//    }
//
//    func testOrderedProductListNilProduct() {
//        let detail = ECSOrderDetail()
//        detail.entries = [ECSEntry(), ECSEntry(), ECSEntry()]
//
//        let productlist = detail.orderedProductList()
//
//        XCTAssertEqual(detail.entries?.count, productlist?.count)
//        XCTAssertEqual(detail.entries?.first?.product?.ctn, productlist?.first?.product?.ctn)
//        XCTAssertNil(productlist?.first?.product?.ctn)
//    }
    
    func orderDetail() -> ECSOrderDetail {
        let orderDetail = ECSOrderDetail()
        orderDetail.orderID = "123"
        let entry1 = ECSEntry()
        entry1.product = ECSProduct()
        entry1.product?.ctn = "FirstCTN_First"
        entry1.quantity = 10
        entry1.basePrice = ECSPrice()
        entry1.basePrice?.value = 10
        
        let entry2 = ECSEntry()
        entry2.product = ECSProduct()
        entry2.product?.ctn = "FirstCTN_First"
        entry2.quantity = 4
        entry2.product?.price = ECSPrice()
        entry2.product?.price?.value = 10
        
        orderDetail.entries = [entry1, entry2];
        
        return orderDetail
    }
    
    override func tearDown() {
        super.tearDown()
        MECConfiguration.shared.rootCategory = nil
    }
}
