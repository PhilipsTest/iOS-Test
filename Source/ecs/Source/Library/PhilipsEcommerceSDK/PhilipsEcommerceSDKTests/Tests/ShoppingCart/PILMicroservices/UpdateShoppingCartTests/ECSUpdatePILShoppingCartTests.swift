/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSUpdatePILShoppingCartTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockProductEntry: ECSPILItem!

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockProductEntry = ECSPILItem()
        mockProductEntry.entryNumber = "0"
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        mockProductEntry = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testUpdateECSShoppingCartSuccess() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartGermany")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartSuccess")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 1)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.first?.entryNumber, "0")
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.first?.quantity, 1)
            XCTAssertEqual(shoppingCart?.data?.attributes?.units, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartItemsDeleteSuccess() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithNoItems")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartItemsDeleteSuccess")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 0) { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items)
            XCTAssertEqual(shoppingCart?.data?.attributes?.items?.count, 0)
            XCTAssertEqual(shoppingCart?.data?.attributes?.units, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartSuccessWithNotificationMessage() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithQuantityMoreOrderThresholdCrossed")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartSuccessWithNotificationMessage")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items)
            XCTAssertNotEqual(shoppingCart?.data?.attributes?.items?.count, 0)
            XCTAssertNotEqual(shoppingCart?.data?.attributes?.units, 0)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications)
            XCTAssertEqual(shoppingCart?.data?.attributes?.notifications?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationId)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationMessage)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.orderBlocking)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailure() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailure")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureForNonHybris() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureForNonHybris")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutSiteId() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutSiteId")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithBlankSiteId() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithBlankSiteId")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithWrongSiteId() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithWrongSiteId")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutLanguage() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.language = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutLanguage")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithBlankLanguage() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithBlankLanguage")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithWrongLanguage() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "fetchProductPILCTNInvalidCountryLanguageError")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutCountry() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.country = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutCountry")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithBlankCountry() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithBlankCountry")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithWrongCountry() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithWrongCountry")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutAppInfra() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutAppInfra")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSAppInfraNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutBaseURL() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutBaseURL")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSBaseURLNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutCallingOAuth() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutCallingOAuth")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSOAuthNotCalled.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutPassingOAuthToken() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartBearerNotAddedInToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutPassingOAuthToken")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithInvalidAccessToken() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartHybrisTokenExpired")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidAccessToken")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNegativeQuantity() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNegativeQuantity")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: -1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NEGATIVE_QUANTITY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
//    func testUpdateECSShoppingCartFailureFromServerWithNegativeQuantity() {
//        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
//        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithNegativeQuantity")
//        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
//        mockAppInfra.restClient = mockRestClient
//        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
//
//        let ecsService = ECSServices(appInfra: mockAppInfra)
//        ECSConfiguration.shared.locale = "de_DE"
//        ECSConfiguration.shared.siteId = "test"
//        ECSConfiguration.shared.hybrisToken = "Test token"
//        ECSConfiguration.shared.baseURL = "https://test.com"
//
//        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureFromServerWithNegativeQuantity")
//        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
//            XCTAssertNil(shoppingCart)
//            XCTAssertNotNil(error)
//            XCTAssertEqual(error?.getErrorCode(), 123)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 2, handler: nil)
//    }
    
    func testUpdateECSShoppingCartFailureWithInvalidQuantity() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithInvalidFormatQuantity")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidQuantity")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_quantity.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithUpdatingOutOfStockProduct() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartProductIsOutOfStock")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithUpdatingOutOfStockProduct")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_STOCK_EXCEPTION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)

    }
    
    func testUpdateECSShoppingCartFailureWithInvalidJsonResponse() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartInvalidJsonResponse")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidJsonResponse")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutEntryNumber() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        mockProductEntry.entryNumber = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutEntryNumber")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSUnknownIdentifierError.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNilEntryNumber() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithNoEntryNumber")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNilEntryNumber")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
//    func testUpdateECSShoppingCartFailureWithInvalidFormatEntryNumber() {
//        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
//        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithInvalidFormatEntryNumber")
//        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
//        mockAppInfra.restClient = mockRestClient
//        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
//
//        let ecsService = ECSServices(appInfra: mockAppInfra)
//        ECSConfiguration.shared.locale = "de_DE"
//        ECSConfiguration.shared.siteId = "test"
//        ECSConfiguration.shared.hybrisToken = "Test token"
//        ECSConfiguration.shared.baseURL = "https://test.com"
//
//        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidFormatEntryNumber")
//        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
//            XCTAssertNil(shoppingCart)
//            XCTAssertNotNil(error)
//            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_quantity.rawValue)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 2, handler: nil)
//    }
    
    func testUpdateECSShoppingCartFailureWithEntryNumberMoreThanActualEntries() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithEntryNumberMoreThanEntries")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithEntryNumberMoreThanActualEntries")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_itemId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNegativeEntryNumber() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithNegativeEntryNumber")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNegativeEntryNumber")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_BAD_REQUEST.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithQuantityMoreThanActualStock() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithQuantityMoreOrderThresholdCrossed")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithQuantityMoreThanActualStock")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNotNil(shoppingCart)
            XCTAssertNil(error)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.items)
            XCTAssertNotEqual(shoppingCart?.data?.attributes?.items?.count, 0)
            XCTAssertNotEqual(shoppingCart?.data?.attributes?.units, 0)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications)
            XCTAssertEqual(shoppingCart?.data?.attributes?.notifications?.count, 1)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationId)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.notificationMessage)
            XCTAssertNotNil(shoppingCart?.data?.attributes?.notifications?.first?.orderBlocking)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithoutAPIKey() {
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.apiKey = nil
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithoutAPIKey")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithInvalidAPIKey() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidAPIKey")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNilAPIKey() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNilAPIKey")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNilAPIVersion() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoVersionError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNilAPIVersion")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithInvalidAPIVersion() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidVersionError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidAPIVersion")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithInvalidCartID() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithWrongCartId")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithInvalidCartID")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_cartId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithNoCartCreated() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "AddToCartWhenNoCartIsPresent")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithNoCartCreated")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_BAD_REQUEST_cartId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithMissingCartID() {
        serviceDiscoveryMock.microserviceURL = "https://test.com/microservices"
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithNoEntryNumber")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithMissingCartID")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithMissingServiceDiscoveryURL() {
        serviceDiscoveryMock.microserviceURL = nil
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithMissingServiceDiscoveryURL")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithServiceDiscoveryServiceError() {
        serviceDiscoveryMock.microserviceURL = nil
        serviceDiscoveryMock.service?.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithServiceDiscoveryServiceError")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateECSShoppingCartFailureWithServiceDiscoveryError() {
        serviceDiscoveryMock.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        let ecsService = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testUpdateECSShoppingCartFailureWithServiceDiscoveryError")
        ecsService.updateECSShoppingCart(cartItem: mockProductEntry, quantity: 1) { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
