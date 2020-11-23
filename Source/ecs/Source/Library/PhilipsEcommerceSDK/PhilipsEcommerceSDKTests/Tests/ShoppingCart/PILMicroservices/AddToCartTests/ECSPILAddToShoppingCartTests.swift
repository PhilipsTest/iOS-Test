/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSPILAddToShoppingCartTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var restClient: RESTClientMock!
    var serviceDiscovery: ServiceDiscoveryMock!
    var mockRestClient: RESTClientMock!
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        restClient = RESTClientMock()
        mockAppInfra.restClient = restClient
        mockRestClient = RESTClientMock()
        serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
    }
    
    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        restClient = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }
    
    //MARK: - Success test cases -
    
    func testPILAddToCartSuccessForGerman() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartGermany")
        mockAppInfra.restClient = mockRestClient

        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartSuccessForGerman")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNotNil(cart)
            
            XCTAssertEqual(cart?.data?.attributes?.pricing?.total?.formattedValue, "179,99 €")
            XCTAssertEqual(cart?.data?.attributes?.pricing?.tax?.formattedValue, "28,74 €")
            XCTAssertEqual(cart?.data?.attributes?.items?.first?.ctn, "HR2098/30")
            
            XCTAssertEqual(cart?.data?.attributes?.deliveryAddress?.houseNumber, "23")
            XCTAssertEqual(cart?.data?.attributes?.deliveryMode?.deliveryModeId, "DHL_STANDARD")
            XCTAssertEqual(cart?.data?.attributes?.applicableDeliveryModes?.count, 1)
            
            XCTAssertEqual(cart?.data?.attributes?.notifications?.count, 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartSuccessQuantityMoreThanStock() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "AddToCartSuccessWithProductMoreQuantityThanStock")
        mockAppInfra.restClient = mockRestClient

        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILCreateCartSuccessQuantityMoreThanStock")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 1) { (cart, error) in
            XCTAssertNotNil(cart)
            
            XCTAssertEqual(cart?.data?.attributes?.pricing?.total?.formattedValue, "2,689.55 $")
            XCTAssertEqual(cart?.data?.attributes?.pricing?.tax?.formattedValue, "0.00 $")
            XCTAssertEqual(cart?.data?.attributes?.items?.first?.ctn, "HD9240/94")
            
            XCTAssertEqual(cart?.data?.attributes?.deliveryAddress?.houseNumber, "")
            XCTAssertEqual(cart?.data?.attributes?.deliveryMode?.deliveryModeId, "UPS_COLLECTION_POINT")
            XCTAssertEqual(cart?.data?.attributes?.applicableDeliveryModes?.count, nil)
            
            XCTAssertEqual(cart?.data?.attributes?.notifications?.count, 1)
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.notificationId, "maxOrderQuantityExceeded")
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.notificationMessage, "Unfortunately the quantity you chose exceeded the maximum order quantity for this product. The quantity in your cart has been reduced to the maximum order quantity.")
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.orderBlocking, false)
            
            
            XCTAssertEqual(cart?.data?.attributes?.promotions?.appliedOrderPromotions?.first?.promotionCode, "ECS_PIL_Order_Promotion")
            XCTAssertEqual(cart?.data?.attributes?.promotions?.appliedProductPromotions?.first?.promotionCode, "ECS_PIL_Product_Promotion")
            
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartSuccessOrderThresholdReached() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "UpdateCartWithQuantityMoreOrderThresholdCrossed")
        mockAppInfra.restClient = mockRestClient

        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartSuccessOrderThresholdReached")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 1) { (cart, error) in
            XCTAssertNotNil(cart)
            
            XCTAssertEqual(cart?.data?.attributes?.pricing?.total?.formattedValue, "8.254,54 €")
            XCTAssertEqual(cart?.data?.attributes?.pricing?.tax?.formattedValue, "1.138,56 €")
            XCTAssertEqual(cart?.data?.attributes?.items?.first?.ctn, "HR3657/90")
            
            XCTAssertEqual(cart?.data?.attributes?.deliveryAddress?.houseNumber, "23 A")
            XCTAssertEqual(cart?.data?.attributes?.deliveryMode?.deliveryModeId, nil)
            XCTAssertEqual(cart?.data?.attributes?.applicableDeliveryModes?.count, 1)
            
            XCTAssertEqual(cart?.data?.attributes?.notifications?.count, 1)
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.notificationId, "thresholdExceeded")
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.notificationMessage, "<b>Order cannot exceed €2300</b>,-  Please lower your order value to proceed to check out.")
            XCTAssertEqual(cart?.data?.attributes?.notifications?.first?.orderBlocking, true)
            
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartSuccessUSWithAppliedVoucher() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUS")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILCreateCartSuccessUSWithAppliedVoucher")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 1) { (cart, error) in
            //                XCTAssertNotNil(cart)
            //
            //                XCTAssertEqual(cart?.data?.attributes?.pricing?.total?.formattedValue, "283.03 $")
            //                XCTAssertEqual(cart?.data?.attributes?.pricing?.tax?.formattedValue, "23.07 $")
            //                XCTAssertEqual(cart?.data?.attributes?.items?.first?.ctn, "HD9240/94")
            //
            //                XCTAssertEqual(cart?.data?.attributes?.deliveryAddress?.houseNumber, "")
            //    //            XCTAssertEqual(cart?.data?.attributes?.deliveryMode?.deliveryModeId, "UPS_COLLECTION_POINT")
            //                XCTAssertEqual(cart?.data?.attributes?.applicableDeliveryModes?.count, 2)
            //
            //                XCTAssertEqual(cart?.data?.attributes?.notifications?.count, 0)
            //
            //                XCTAssertEqual(cart?.data?.attributes?.promotions?.appliedOrderPromotions?.first?.promotionCode, "ECS_PIL_Order_Promotion")
            //                XCTAssertEqual(cart?.data?.attributes?.promotions?.appliedProductPromotions?.first?.promotionCode, "ECS_PIL_Product_Promotion")
            //                XCTAssertEqual(cart?.data?.attributes?.appliedVouchers?.first?.voucherCode, "ECS-_PIL-_Vou-cher-TZ8S-5XZ5-S7E7")
            //
            //                XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    //MARK: - Common error test cases -
    func testPILAddToCartFailureWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILCreateCartFailureWithNilAppInfra")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartSiteIDNil() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILCreateCartWithoutSiteID")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartSiteIdInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcdc"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "abc") { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
        }
    }
    
    func testPILAddToCartWithoutSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        
        let expectation = self.expectation(description: "testPILCreateCartWithoutSiteID")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartEmptyVersion() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "searchProductMissingAPIVersion")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "The required API version header is missing")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_VERSION.rawValue)
        }
    }
    
    func testPILAddToCartForInvalidVersion() {
        mockAppInfra.mockConfig.apiKey = ""
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_VERSION.rawValue)
        }
    }
    
    func testPILAddToCartForNoAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = nil
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
        }
    }
    
    func testPILAddToCartForBlankAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = ""
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
        }
    }
    
    func testPILAddToCartForInvalidAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = "2o93hr2l3"
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Invalid API key")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
        }
    }
    
    func testPILAddToCartLanguageCodeEmpty() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "testLanguage"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
        }
    }
    
    func testPILAddToCartLanguageCodeNil() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = nil
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
        }
    }
    
    func testPILAddToCartLanguageCodeInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
        }
    }
    
    func testPILAddToCartCountryCodeEmpty() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "testLanguage"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
        }
    }
    
    func testPILAddToCartCountryCodeInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testSiteID"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "abcd"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
        }
    }
    
    func testPILAddToCartCountryCodeNil() {
           let sut = ECSServices(appInfra: mockAppInfra)
           ECSConfiguration.shared.locale = "de_DE"
           ECSConfiguration.shared.baseURL = "test.com"
           ECSConfiguration.shared.siteId = "testSiteID"
           ECSConfiguration.shared.country = nil
           ECSConfiguration.shared.hybrisToken = "abcd"
           restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
           sut.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (products, error) in
               XCTAssertNil(products)
               XCTAssertNotNil(error)
               XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
               XCTAssertEqual(error?.localizedDescription, "Please set the locale")
           }
       }
    
    func testPILAddToCartForFailureNoInternet() {
        restClient.responseData = nil
        restClient.errorData = NSError(domain: "no internet", code: 100, userInfo: [NSLocalizedDescriptionKey: "No internet error"])
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.hybrisToken = "abc"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        sut.addECSProductToShoppingCart(ctn: "abc") { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "No internet error")
        }
    }
    
    func testPILAddToCartFailureWithServiceDiscoveryError() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testsite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "Abc"
        serviceDiscovery.microserviceURL = nil
        serviceDiscovery.error = NSError(domain: "abc", code: 100, userInfo: [NSLocalizedDescriptionKey: "SD error"])
        sut.addECSProductToShoppingCart(ctn: "abc") { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 100)
            XCTAssertEqual(error?.localizedDescription, "SD error")
        }
    }
    
    func testPILAddToCartServiceDiscoveryNilURL() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testsite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.hybrisToken = "Abc"
        serviceDiscovery.microserviceURL = nil
        sut.addECSProductToShoppingCart(ctn: "abc") { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
        }
    }
    
    func testPILAddToCartFailure() {
        mockRestClient.errorData = NSError(domain: "", code: 444, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILCreateCartFailure")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 444)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartJsonParsingFailure() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "cartInvalidJsonResponse")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILCreateCartJsonParsingFailure")
        ecsService.addECSProductToShoppingCart(ctn: "HR2098/30", quantity: 1) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual(error?.getErrorCode(), 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartFailureWithNilBaseURL() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "Test Site Id"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testPILCreateCartFailureWithNilBaseURL")
        serivces.addECSProductToShoppingCart(ctn: "abc") { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSBaseURLNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartIncorrectContentType() {
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
        ECSConfiguration.shared.baseURL = "test URL"
        
        let expectation = self.expectation(description: "testPILAddToCartIncorrectContentType")
        serivces.addECSProductToShoppingCart(ctn: "abc") { (shoppingCart, error) in
            XCTAssertNil(shoppingCart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_UNSUPPORTED_MEDIA_TYPE.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
        
    //MARK: - API specific error test cases -
    
    func testPILAddToCartOutOfStockProduct() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartProductIsOutOfStock")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartOutOfStockProduct")
        ecsService.addECSProductToShoppingCart(ctn: "abc") { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Product cannot be shipped as it is out of stock")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_STOCK_EXCEPTION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartQuantityAsZero() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartProductIsOutOfStock")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartQuantityAsZero")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 0) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Quantity must be greater than zero")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_QUANTITY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartQuantityNegative() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartProductIsOutOfStock")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartQuantityNegative")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: -3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Quantity must be greater than zero")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_QUANTITY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartInvalidProductId() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartProductIsOutOfStock")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartQuantityNegative")
        ecsService.addECSProductToShoppingCart(ctn: "a b c", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide valid CTN")
            XCTAssertEqual(error?.getErrorCode(), 6005)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartCTNWith_() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartAddProductCTNWith_")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartCTNWith_")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide valid CTN")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartWithoutLogin() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testPILAddToCartWithoutLogin")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSOAuthNotCalled.rawValue)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartExpiredHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartHybrisTokenExpired")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartExpiredHybrisToken")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartBearerNotAddedInToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartBearerNotAddedInToken")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartExpiredHybrisToken")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_AUTHORIZATION_accessToken.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartOnNoCart() {
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "AddToCartWhenNoCartIsPresent")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartOnNoCart")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_BAD_REQUEST_cartId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
    }
    
    func testPILAddToCartProductNotFoundInSite() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartAddProductCTNWith_")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartProductNotFoundInSite")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide valid CTN")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPILAddToCartMultipleProductsAreProvided() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartAddingProductIdNotBelongToSite")
        mockAppInfra.restClient = mockRestClient
        mockRestClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"

        let expectation = self.expectation(description: "testPILAddToCartMultipleProductsAreProvided")
        ecsService.addECSProductToShoppingCart(ctn: "abc", quantity: 3) { (cart, error) in
            XCTAssertNil(cart)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide valid CTN")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
