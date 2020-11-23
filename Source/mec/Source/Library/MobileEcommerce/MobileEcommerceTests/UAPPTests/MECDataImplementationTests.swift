/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PlatformInterfaces
import PhilipsEcommerceSDK

class CartUpdate: NSObject, MECCartUpdateProtocol {
    func didUpdateCartCount(cartCount: Int) {
    }

    func shouldShowCart(_ shouldShow: Bool) {
    }
}

class MECDataImplementationTests: XCTestCase {
    
    var sut: MECDataImplementation!
    var delegate =  CartUpdate()
    var appInfra = MockAppInfra()
    var appConfig = MockAppConfig()
    var ecsService: MockECSService?
    var utility =  MockUtility()
    var mockTagging: MECMockTagger?
    
    
    override func setUp() {
        super.setUp()
        sut = MECDataImplementation()
        appInfra.appConfig = appConfig
        ecsService = MockECSService(propositionId: "", appInfra: appInfra)
        
        MECConfiguration.shared.sharedAppInfra = appInfra
        MECConfiguration.shared.ecommerceService = ecsService
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        MECConfiguration.shared.supportsHybris = false
        MECConfiguration.shared.cartUpdateDelegate = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.sharedUDInterface = nil
        MECConfiguration.shared.oauthData = nil
        MECConfiguration.shared.isHybrisAvailable = nil
    }
    
    func testInitialzeEcommerceSupoportHybrisFalseConfigError() {
        swizzleCreateInstance()
        ecsService = MockECSService(appInfra: MECConfiguration.shared.sharedAppInfra)
        MECConfiguration.shared.supportsHybris = false
        
        let config = ECSConfig()
        config.locale = "en_US"
        ecsService?.config = config
        ecsService?.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"error occured"])
        MockUtility.service = ecsService
        
        sut.initializeEcommerceSDK { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testInitialzeEcommerceSupoportHybrisTrueConfigError() {
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        sut.initializeEcommerceSDK { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
        }
    }
    
    func testInitialzeEcommercesecondTimeCall() {
        swizzleCreateInstance()
        ecsService = MockECSService(appInfra: MECConfiguration.shared.sharedAppInfra)
        MECConfiguration.shared.supportsHybris = false
        
        let config = ECSConfig()
        config.locale = "en_US"
        ecsService?.config = config
        ecsService?.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"error occured"])
        MockUtility.service = ecsService
        
        sut.initializeEcommerceSDK { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testAddCartUpdateDelegate() {
        XCTAssertNil(MECConfiguration.shared.cartUpdateDelegate)
        sut.addCartUpdateDelegate(delegate)
        XCTAssertNotNil(MECConfiguration.shared.cartUpdateDelegate)
    }

    func testRemoveCartUpdateDelegate() {
        sut.removeCartUpdateDelegate(CartUpdate())
        XCTAssertNil(MECConfiguration.shared.cartUpdateDelegate)
    }
    
    func testisHybrisAvailableSupportHybrisTrue() {
        MECConfiguration.shared.supportsHybris = true
    }
    
    func testisHybrisAvailableSupportHybrisFalse() {
        MECConfiguration.shared.supportsHybris = false
        sut.isHybrisAvailable { (support, error) in
            XCTAssertFalse(support)
            XCTAssertNotNil(error)
        }
    }
    
    func testisHybrisAvailableTrue() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"

        ecsService?.config = config
        MockUtility.service = ecsService
        sut.isHybrisAvailable { (support, error) in
            XCTAssertTrue(support)
            XCTAssertEqual(MECConfiguration.shared.locale, "TestLocale")
            XCTAssertEqual(MECConfiguration.shared.rootCategory, "TestRootCategory")
            XCTAssertEqual(MECConfiguration.shared.isHybrisAvailable, true)

            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testIsHybrisAvailableWithoutInternet() {
        (appInfra.restClient as? RESTClientMock)?.isMockInternetReachable = false
        sut.isHybrisAvailable { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, -1009)
        }
    }
    
    func testFetchCartCountWithoutInternet() {
        (appInfra.restClient as? RESTClientMock)?.isMockInternetReachable = false
        sut.fetchCartCount { (cartCount, error) in
            XCTAssertEqual(cartCount, 0)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, -1009)
        }
    }
    
    func testFetchCartCountWithFalseSupportsHybris() {
        MECConfiguration.shared.supportsHybris = false
        sut.fetchCartCount { (cartCount, error) in
            XCTAssertEqual(cartCount, 0)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 5055)
        }
    }
    
    func testisHybrisAvailableFalse() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = false
        let config = ECSConfig()
        config.locale = "TestLocale"
        
        MockUtility.service = ecsService
        ecsService?.config = config
        ecsService?.error = NSError(domain: "", code: 100, userInfo: nil)
        MockUtility.service = ecsService
        
        sut.isHybrisAvailable { (support, error) in
            XCTAssertFalse(support)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 100)
            XCTAssertEqual(MECConfiguration.shared.locale, "TestLocale")
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:configureECSWithConfiguration:Hybris:The operation couldn’t be completed. ( error 100.):100")
            self.deSwizzleCreateInstance()
        }
    }

    func testFetchCartCountWithoutUserInterface() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"

        ecsService?.config = config
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertEqual(error?.code, MECErrorCode.MECAuthentication)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountUserNotLoggedIn() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"

        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertEqual(error?.code, 100)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountCartError() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"
        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        ecsService?.shoppingCartError = NSError(domain: "", code: 99, userInfo: nil)
        
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertEqual(error?.code, 99)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountCartNoCartError() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"
        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        ecsService?.shoppingCartError = NSError(domain: "", code: 6023, userInfo: nil)
        
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    
    func testFetchCartCountCartSuccess() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"
        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        ecsService?.shoppingCart = getShoppingCart()
        
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 50)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountCartSuccessOauthError() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"
        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        ecsService?.shoppingCart = getShoppingCart()
        ecsService?.shouldSendOauthError = true
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 50)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountCartSuccessTotalUnitNil() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MECConfiguration.shared.isHybrisAvailable = true
        
        let config = ECSConfig()
        config.catalogID = "TestcatalogID"
        config.locale = "TestLocale"
        config.rootCategory = "TestRootCategory"
        ecsService?.config = config
        
        let mockuserData = MECMockUserDataInterface()
        mockuserData.loginState = .userLoggedIn
        mockuserData.details = [MECConstants.MECAccessToken: "1234"]
        MECConfiguration.shared.sharedUDInterface = mockuserData
        
        let cart = getShoppingCart()
        cart.data?.attributes?.units = nil
        ecsService?.shoppingCart = cart
        
        let oauthData = ECSOAuthData()
        ecsService?.oAuthData = oauthData
        MockUtility.service = ecsService
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testFetchCartCountECSServiceNil() {
        swizzleCreateInstance()
        MECConfiguration.shared.supportsHybris = true
        MockUtility.service = nil
        
        sut.fetchCartCount { (count, error) in
            XCTAssertEqual(count, 0)
            XCTAssertNil(error)
            self.deSwizzleCreateInstance()
        }
    }
    
    func testResetSavedUserDataForSameEmail() {
        MECConfiguration.shared.isHybrisAvailable = true
        let mockOAuth = ECSOAuthData()
        mockOAuth.accessToken = "Test Access Token"
        MECConfiguration.shared.oauthData = mockOAuth
        let testEmail = "TestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        let mockUserDataInterface = MECMockUserDataInterface()
        mockUserDataInterface.loginState = .userLoggedIn
        mockUserDataInterface.details = [UserDetailConstants.EMAIL: testEmail]
        mockStorageProvider?.fetchedValue = [MECConstants.MECUSEROAUTHEMAILDATASAVEKEY: testEmail]
        MECConfiguration.shared.sharedUDInterface = mockUserDataInterface
        
        MECConfiguration.shared.resetSavedUserData()
        XCTAssertNil(MECConfiguration.shared.isHybrisAvailable)
        XCTAssertNotNil(MECConfiguration.shared.oauthData)
        XCTAssertEqual(MECConfiguration.shared.oauthData?.accessToken, "Test Access Token")
    }
    
    func testResetSavedUserDataForDifferentEmail() {
        MECConfiguration.shared.isHybrisAvailable = true
        let mockOAuth = ECSOAuthData()
        mockOAuth.accessToken = "Test Access Token"
        MECConfiguration.shared.oauthData = mockOAuth
        let savedTestEmail = "TestEmail"
        let newTestEmail = "NewTestEmail"
        let mockStorageProvider = MECConfiguration.shared.sharedAppInfra?.storageProvider as? MockStorageProvider
        let mockUserDataInterface = MECMockUserDataInterface()
        mockUserDataInterface.loginState = .userLoggedIn
        mockUserDataInterface.details = [UserDetailConstants.EMAIL: newTestEmail]
        mockStorageProvider?.fetchedValue = [MECConstants.MECUSEROAUTHEMAILDATASAVEKEY: savedTestEmail]
        MECConfiguration.shared.sharedUDInterface = mockUserDataInterface
        
        MECConfiguration.shared.resetSavedUserData()
        XCTAssertNil(MECConfiguration.shared.isHybrisAvailable)
        XCTAssertNil(MECConfiguration.shared.oauthData)
    }
    
    func testFetchConfigValueForKeyUtility() {
        let mockConfig = MockAppConfig()
        mockConfig.propertyFofKey = "TestValue"
        appInfra.appConfig = mockConfig
        
        XCTAssertEqual(MECUtility.fetchConfigValueForKey("Test") as? String, "TestValue")
        
        mockConfig.getPropertyForKeyError = NSError(domain: "", code: 123, userInfo: nil)
        XCTAssertNil(MECUtility.fetchConfigValueForKey("Test"))
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
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.pricing?.total = totalPriceWithTax
        cart.data?.attributes?.pricing?.tax = totalTax
        cart.data?.attributes?.units = 50
        return cart
    }
    
    func swizzleCreateInstance() {
        let originalSelector = #selector(MECUtility.createECSService)
        let swizzledSelector = #selector(MockUtility.serviceObject)
        if let originalMethod = class_getClassMethod(MECUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(MockUtility.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzleCreateInstance() {
        let originalSelector = #selector(MECUtility.createECSService)
        let swizzledSelector = #selector(MockUtility.serviceObject)
        if let originalMethod = class_getClassMethod(MECUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(MockUtility.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }}
