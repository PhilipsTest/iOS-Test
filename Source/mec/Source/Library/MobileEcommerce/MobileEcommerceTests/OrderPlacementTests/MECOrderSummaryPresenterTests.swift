/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECOrderSummaryPresenterTests: XCTestCase {
    
    var orderSummaryPresenter: MECOrderSummaryPresenter?
    var mockECSService: MockECSService?
    var mockServiceDiscovery: ServiceDiscoveryMock?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        mockServiceDiscovery = ServiceDiscoveryMock()
        appInfra.serviceDiscovery = mockServiceDiscovery
        
        let mockDataBus = MECDataBus()
        orderSummaryPresenter = MECOrderSummaryPresenter(with: mockDataBus)
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        MECConfiguration.shared.isHybrisAvailable = true
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
        MECConfiguration.shared.sharedAppInfra = appInfra
    }

    override func tearDown() {
        super.tearDown()
        orderSummaryPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testSubmitOrderWithCVVSuccess() {
        let mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = "TestOrderID"
        
        mockECSService?.submitOrderDetail = mockOrderDetail
        orderSummaryPresenter?.submitOrder(with: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(orderDetail)
            XCTAssertEqual(orderDetail?.orderID, "TestOrderID")
        })
    }
    
    func testSubmitOrderWithCVVOAuthFailure() {
        let mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = "TestOrderID"
        
        mockECSService?.submitOrderDetail = mockOrderDetail
        mockECSService?.shouldSendOauthError = true
        
        orderSummaryPresenter?.submitOrder(with: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(orderDetail)
            XCTAssertEqual(orderDetail?.orderID, "TestOrderID")
        })
    }
    
    func testSubmitOrderWithCVVFailure() {
        mockECSService?.submitOrderError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "submit order failed"])
        
        orderSummaryPresenter?.submitOrder(with: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:submitOrder:Hybris:submit order failed:123")
        })
    }
    
    func testSetPaymentSuccess() {
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentStatus = true
        
        orderSummaryPresenter?.setPayment(payment: mockPayment, completionHandler: { (success, error) in
            XCTAssertNil(error)
            XCTAssertTrue(success)
        })
    }
    
    func testSetPaymentOAuthFailure() {
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentStatus = true
        mockECSService?.shouldSendOauthError = true
        
        orderSummaryPresenter?.setPayment(payment: mockPayment, completionHandler: { (success, error) in
            XCTAssertNil(error)
            XCTAssertTrue(success)
        })
    }
    
    func testSetPaymentFailure() {
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        
        mockECSService?.setPaymentError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Set payment API failed"])
        
        orderSummaryPresenter?.setPayment(payment: mockPayment, completionHandler: { (success, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertFalse(success)
            
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:setPaymentDetail:Hybris:Set payment API failed:123")
        })
    }
    
    func testPayForOrderWithCVVSuccess() {
        let mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = "TestOrderID"
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentStatus = true
        mockECSService?.submitOrderDetail = mockOrderDetail
        orderSummaryPresenter?.dataBus?.paymentsInfo?.selectedPayment = mockPayment
        
        orderSummaryPresenter?.payForOrderWith(cvv: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(orderDetail)
            XCTAssertEqual(orderDetail, orderDetail)
        })
    }
    
    func testPayForOrderWithCVVSetPaymentFailure() {
        let mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = "TestOrderID"
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock Payment Error"])
        mockECSService?.submitOrderDetail = mockOrderDetail
        
        orderSummaryPresenter?.dataBus?.paymentsInfo?.selectedPayment = mockPayment
        
        orderSummaryPresenter?.payForOrderWith(cvv: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(orderDetail)
            XCTAssertEqual(error?.code, 123)
            XCTAssertEqual(error?.localizedDescription, "Mock Payment Error")
        })
    }
    
    func testPayForOrderWithCVVSubmitOrderFailure() {
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentStatus = true
        mockECSService?.submitOrderError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock Submit Order Error"])
        
        orderSummaryPresenter?.dataBus?.paymentsInfo?.selectedPayment = mockPayment
        
        orderSummaryPresenter?.payForOrderWith(cvv: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(orderDetail)
            XCTAssertEqual(error?.code, 123)
            XCTAssertEqual(error?.localizedDescription, "Mock Submit Order Error")
        })
    }
    
    func testPayForOrderWithCVVWithoutSavedPayment() {
        let mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = "TestOrderID"
        let mockPayment = ECSPayment()
        mockPayment.paymentId = "TestPaymentID"
        mockECSService?.setPaymentStatus = true
        mockECSService?.submitOrderDetail = mockOrderDetail
        
        orderSummaryPresenter?.payForOrderWith(cvv: "Test", completionHandler: { (orderDetail, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(orderDetail)
            XCTAssertEqual(error?.code, 111)
        })
    }
    
    func testmakePaymentSuccess() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = "1234"
        selectedPayment.billingAddress = ECSAddress()
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        
        let pay = ECSPaymentProvider()
        pay.paymentProviderURL = "test.com"
        mockECSService?.paymentProvider = pay
        mockECSService?.shouldSendOauthError = true
        
        orderSummaryPresenter?.makePayment(for: ECSOrderDetail(), completionHandler: { (provider, error) in
            XCTAssertEqual(provider?.paymentProviderURL, "test.com")
            XCTAssertNil(error)
        })
    }
    
    func testmakePaymentSuccessOauthError() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = "1234"
        selectedPayment.billingAddress = ECSAddress()
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        
        let pay = ECSPaymentProvider()
        pay.paymentProviderURL = "test.com"
        mockECSService?.paymentProvider = pay
        mockECSService?.shouldSendOauthError = true
        
        orderSummaryPresenter?.makePayment(for: ECSOrderDetail(), completionHandler: { (provider, error) in
            XCTAssertEqual(provider?.paymentProviderURL, "test.com")
            XCTAssertNil(error)
        })
    }

    func testmakePaymentFailureNoBillingAddress() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = "1234"
        selectedPayment.billingAddress = nil
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        
        mockECSService?.error = NSError(domain: "", code: 100, userInfo: nil)
        
        orderSummaryPresenter?.makePayment(for: ECSOrderDetail(), completionHandler: { (provider, error) in
            XCTAssertNil(provider)
            XCTAssertNil(error)
        })
    }
    
    func testmakePaymentFailure() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = "1234"
        selectedPayment.billingAddress = ECSAddress()
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        
        mockECSService?.error = NSError(domain: "", code: 100, userInfo: nil)
        
        orderSummaryPresenter?.makePayment(for: ECSOrderDetail(), completionHandler: { (provider, error) in
            XCTAssertNil(provider)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 100)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:makePaymentFor:Hybris:The operation couldn’t be completed. ( error 100.):100")
        })
    }
    
    func testnumberOfProductInCartEmptuCart() {
        XCTAssertEqual(orderSummaryPresenter?.numberOfProductInCart(), 0)
    }
    
    func testnumberOfProductInCart() {
        orderSummaryPresenter?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(orderSummaryPresenter?.numberOfProductInCart(), 2)
    }
    
    func testtotalTaxEmptuCart() {
        XCTAssertEqual(orderSummaryPresenter?.totalTax(), "")
    }
    
    func testtotalTax() {
        orderSummaryPresenter?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(orderSummaryPresenter?.totalTax(), "10 $")
    }
    
    func testtotalPriceEmptyCart() {
        XCTAssertEqual(orderSummaryPresenter?.totalPrice(), "")
    }
    
    func testtotalPrice() {
        orderSummaryPresenter?.dataBus?.shoppingCart = getShoppingCart()
        XCTAssertEqual(orderSummaryPresenter?.totalPrice(), "100 $")
    }
    
    func testisFirstTimePaymentTrue() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = MECConstants.MECNewCardIdentifier
        
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        
        XCTAssertEqual(orderSummaryPresenter?.isFirstTimePayment(), true)
    }
    
    func testisFirstTimePaymentFalse() {
        let selectedPayment = ECSPayment()
        selectedPayment.paymentId = "1234"
        let payment = MECPaymentsInfo()
        payment.selectedPayment = selectedPayment
        orderSummaryPresenter?.dataBus?.paymentsInfo = payment
        XCTAssertEqual(orderSummaryPresenter?.isFirstTimePayment(), false)
    }
    
    func testgetFAQUrlSuccess() {
        mockServiceDiscovery?.serviceURL = "test.com"
        orderSummaryPresenter?.getFAQUrl(completionHandler: { (url) in
            XCTAssertEqual(self.mockServiceDiscovery?.serviceKey, "iap.faq")
            XCTAssertNotNil(url)
            XCTAssertEqual(url, "test.com")
        })
    }
    
    func testgetFAQUrlFailure() {
        mockServiceDiscovery?.serviceURL = nil
        orderSummaryPresenter?.getFAQUrl(completionHandler: { (url) in
            XCTAssertNil(url)
        })
    }
    
    func testgetPrivacyURLSuccess() {
        mockServiceDiscovery?.serviceURL = "test.com"
        orderSummaryPresenter?.getPrivacyURL(completionHandler: { (url) in
            XCTAssertEqual(self.mockServiceDiscovery?.serviceKey, "iap.privacyPolicy")
            XCTAssertNotNil(url)
            XCTAssertEqual(url, "test.com")
        })
    }
    
    func testgetPrivacyURLFailure() {
        mockServiceDiscovery?.serviceURL = nil
        orderSummaryPresenter?.getPrivacyURL(completionHandler: { (url) in
            XCTAssertNil(url)
        })
    }
    
    func testgetTermsURLSuccess() {
        mockServiceDiscovery?.serviceURL = "test.com"
        orderSummaryPresenter?.getTermsURL(completionHandler: { (url) in
            XCTAssertEqual(self.mockServiceDiscovery?.serviceKey, "iap.termOfUse")
            XCTAssertNotNil(url)
            XCTAssertEqual(url, "test.com")
        })
    }
    
    func testgetTermsURLFailure() {
        mockServiceDiscovery?.serviceURL = nil
        orderSummaryPresenter?.getTermsURL(completionHandler: { (url) in
            XCTAssertNil(url)
        })
    }
    
    func testshouldShowPrivacySuccess() {
        mockServiceDiscovery?.serviceURL = "test.com"
        orderSummaryPresenter?.shouldShowPrivacy(completionHandler: { (showPrivacy) in
            XCTAssertTrue(showPrivacy)
        })
    }
    
    func testshouldShowPrivacyFailure() {
        mockServiceDiscovery?.serviceURL = nil
        orderSummaryPresenter?.shouldShowPrivacy(completionHandler: { (showPrivacy) in
            XCTAssertFalse(showPrivacy)
        })
    }
    
    /**********************************************************************************************************************/
    
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
        attributes.pricing =  pricing
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [ECSPILItem(),ECSPILItem()]
        cart.data?.attributes?.pricing?.total = totalPriceWithTax
        cart.data?.attributes?.pricing?.tax = totalTax
        cart.data?.attributes?.units = 50
        return cart
    }
    
}
