/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchPILShoppingCartTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ECSConfiguration.shared.baseURL = "https://test.com"
    }

    override func tearDown() {
        super.tearDown()
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testFetchECSShoppingCartSuccess() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartGermany")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccess")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions)
            XCTAssertNotNil(shoppingCart?.data?.cartID)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.count, 0)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.applicableDeliveryModes)
            XCTAssertEqual(shoppingCart?.data?.attributes?.applicableDeliveryModes?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications)
            XCTAssertEqual(shoppingCart?.data?.attributes?.notifications?.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithNotificationMessage() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "AddToCartSuccessWithProductMoreQuantityThanStock")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithNotificationMessage")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications)
            XCTAssertEqual(shoppingCart?.data?.attributes?.notifications?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationId)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationMessage)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.orderBlocking)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithAppliedOrderPromotion() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithAppliedOrderPromotion")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.first?.promotionCode)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.first?.message)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithPotentialOrderPromotion() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "DeleteProductFromCartSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithPotentialOrderPromotion")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.potentialOrderPromotions)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.potentialOrderPromotions?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.potentialOrderPromotions?.first?.promotionCode)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.potentialOrderPromotions?.first?.message)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithProductPromotion() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithProductPromotion")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedProductPromotions)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.potentialProductPromotions)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.appliedProductPromotions?.count, 1)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.potentialProductPromotions?.count, 0)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedProductPromotions?.first?.promotionCode)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedProductPromotions?.first?.consumedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithVoucher() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUS")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithVoucher")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions)
            XCTAssertNotNil(shoppingCart?.data?.cartID)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions)
            XCTAssertEqual(shoppingCart?.data?.attributes?.promotions?.appliedOrderPromotions?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.applicableDeliveryModes)
            XCTAssertEqual(shoppingCart?.data?.attributes?.applicableDeliveryModes?.count, 2)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications)
            XCTAssertEqual(shoppingCart?.data?.attributes?.notifications?.count, 0)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.appliedVouchers)
            XCTAssertEqual(shoppingCart?.data?.attributes?.appliedVouchers?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.appliedVouchers?.first?.voucherCode)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.appliedVouchers?.first?.name)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.appliedVouchers?.first?.voucherDescription)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.appliedVouchers?.first?.value)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessDeliveryAddress() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessDeliveryAddress")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.deliveryAddress)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.deliveryAddress?.firstName)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.deliveryAddress?.line1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartWithNoDeliveryAddressForOCCCarts() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartNoDeliveryAddress")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartWithNoDeliveryAddressForOCCCarts")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNil(shoppingCart?.data?.attributes?.deliveryAddress)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessDeliveryModes() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessDeliveryModes")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.applicableDeliveryModes)
            XCTAssertEqual(shoppingCart?.data?.attributes?.applicableDeliveryModes?.count, 2)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.applicableDeliveryModes?.first?.deliveryModeName)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessItems() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessItems")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items?.first?.ctn)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items?.first?.title)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items?.first?.image)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items?.first?.price)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.first?.entryNumber, "0")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartSuccessWithoutItems() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithNoItems")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartSuccessWithoutItems")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailure() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailure")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureForWrongJsonFormat() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartInvalidJsonResponse")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureForWrongJsonFormat")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartWithNilAppinfra() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartWithNilAppinfra")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSAppInfraNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNilSiteID() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNilSiteID")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingSiteID() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingSiteID")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectSiteID() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectSiteID")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNilBaseURL() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNilBaseURL")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSBaseURLNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureForNonHybris() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureForNonHybris")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNilLanguage() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.language = nil
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNilLanguage")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingLanguage() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingLanguage")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectLanguage() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectLanguage")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNilCountry() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.country = nil
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNilCountry")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingCountry() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingCountry")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectCountry() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectCountry")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNilAPIKey() {
        let mockAppInfra = MockAppInfra()
        mockAppInfra.mockConfig.apiKey = nil
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNilAPIKey")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingAPIKey() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingAPIKey")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectAPIKey() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectAPIKey")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingAPIVersion() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingAPIVersion")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectAPIVersion() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectAPIVersion")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithNoCartCreated() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "AddToCartWhenNoCartIsPresent")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithNoCartCreated")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_BAD_REQUEST_cartId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectContentType() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartUnsupportedBodyType")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectContentType")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_UNSUPPORTED_MEDIA_TYPE.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithIncorrectRequestHeaderAcceptType() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartInvalidMimeType")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithIncorrectRequestHeaderAcceptType")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_ACCEPTABLE_contentType.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithoutPassingOAuthToken() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartBearerNotAddedInToken")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithoutPassingOAuthToken")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithoutCallingOAuth() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = nil
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithoutCallingOAuth")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSOAuthNotCalled.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithExpiredAccessToken() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartHybrisTokenExpired")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithExpiredAccessToken")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithServiceDiscoveryError() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithServiceDiscoveryError")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithServiceDiscoveryNilUrl() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithServiceDiscoveryNilUrl")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithServiceDiscoveryServiceError() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        serviceDiscovery.service?.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithServiceDiscoveryServiceError")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithInvalidCartID() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithWrongCartId")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        
        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithInvalidCartID")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_cartId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSShoppingCartFailureWithMissingCartID() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithNoEntryNumber")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"

        let expectation = self.expectation(description: "testFetchECSShoppingCartFailureWithMissingCartID")
        serivces.fetchECSShoppingCart { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
