/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev

class MECInterfaceTests: XCTestCase {
    
    var testInterface: MECInterface?
    var testLaunchInput: MECLaunchInput!
    override func setUp() {
        super.setUp()
        let testDependency = MECDependencies()
        let testSettings = MECSettings()
        testInterface = MECInterface(dependencies: testDependency, andSettings: testSettings)
        testLaunchInput = MECLaunchInput()
    }

    override func tearDown() {
        super.tearDown()
        resetLaunchInputValuesToDefault()
        testInterface = nil
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testInterfaceDefaultLaunch() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let testVC = testInterface?.instantiateViewController(testLaunchInput)
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECProductCatalogueViewController)
        XCTAssertNil(MECConfiguration.shared.sharedUDInterface)
    }
    
    func testInterfaceWithCatalogueLandingView() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        
        let flowConfiguration = MECFlowConfiguration(landingView: .mecProductListView)
        flowConfiguration.productCTNs = ["TestCTN1", "TestCTN2"]
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput)
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECProductCatalogueViewController)
        XCTAssertEqual((testVC as? MECProductCatalogueViewController)?.ctnList.count, 0)
    }
    
    func testInterfaceWithCategorizedCatalogueWithCTNLandingView() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecCategorizedProductListView)
        flowConfiguration.productCTNs = ["TestCTN1", "TestCTN2"]
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput)
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECProductCatalogueViewController)
        XCTAssertEqual((testVC as? MECProductCatalogueViewController)?.ctnList.count, 2)
        XCTAssertEqual((testVC as? MECProductCatalogueViewController)?.ctnList.contains("TestCTN2"), true)
    }
    
    func testInterfaceWithCategorizedCatalogueWithoutCTNLandingView() {
        let expectation = self.expectation(description: "testInterfaceWithCategorizedCatalogueWithoutCTNLandingView")
        
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecCategorizedProductListView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 8)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(testVC)
    }
    
    func testInterfaceWithProductDetailsWithCTNLandingView() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecProductDetailsView)
        flowConfiguration.productCTNs = ["TestCTN1", "TestCTN2"]
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput)
        (testVC as? MECProductDetailsViewController)?.presenter = MECProductDetailsPresenter()
        
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECProductDetailsViewController)
        XCTAssertEqual((testVC as? MECProductDetailsViewController)?.productCTN, "TestCTN1")
    }
    
    func testInterfaceWithProductDetailsWithoutCTNLandingView() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let expectation = self.expectation(description: "testInterfaceWithProductDetailsWithoutCTNLandingView")
        
        let flowConfiguration = MECFlowConfiguration(landingView: .mecProductDetailsView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 8)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(testVC)
    }
    
    func testInterfaceWithProductDetailsWithBlankCTNLandingView() {
        let expectation = self.expectation(description: "testInterfaceWithProductDetailsWithBlankCTNLandingView")
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecProductDetailsView)
        flowConfiguration.productCTNs = [""]
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 8)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(testVC)
    }
    
    func testInterfaceAppInfraInjection() {
        let mockAppInfra = MockAppInfra()
        mockAppInfra.logging = MECMockLogger()
        mockAppInfra.tagging = MECMockTagger()
        
        let mockDependency = MECDependencies()
        mockDependency.appInfra = mockAppInfra
        let mockSettings = MECSettings()
        _ = MECInterface(dependencies: mockDependency, andSettings: mockSettings)
        
        XCTAssertNotNil(MECConfiguration.shared.sharedAppInfra)
        XCTAssertNil(MECConfiguration.shared.sharedUDInterface)
        
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testInterfaceDataInterfaceInjection() {
        let mockDataInterface = MECMockUserDataInterface()
        
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let mockSettings = MECSettings()
        _ = MECInterface(dependencies: mockDependency, andSettings: mockSettings)
        
        XCTAssertNil(MECConfiguration.shared.sharedAppInfra)
        XCTAssertNotNil(MECConfiguration.shared.sharedUDInterface)
        
        MECConfiguration.shared.sharedUDInterface = nil
    }
    
    func testLaunchingWithNilLandingViewWithoutCompletionHandler() {
        testLaunchInput.flowConfiguration = nil
        let mockAppInfra = MockAppInfra()
        mockAppInfra.logging = MECMockLogger()
        mockAppInfra.tagging = MECMockTagger()
        let testDependency = MECDependencies()
        testDependency.appInfra = mockAppInfra
        let testSettings = MECSettings()
        testInterface = MECInterface(dependencies: testDependency, andSettings: testSettings)
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput)
        XCTAssertNil(testVC)
    }
    
    func testLaunchingWithNilLandingViewWithCompletionHandler() {
        let expectation = self.expectation(description: "testLaunchingWithNilLandingViewWithCompletionHandler")
        
        testLaunchInput.flowConfiguration = nil
        let mockAppInfra = MockAppInfra()
        mockAppInfra.logging = MECMockLogger()
        mockAppInfra.tagging = MECMockTagger()
        let testDependency = MECDependencies()
        testDependency.appInfra = mockAppInfra
        let testSettings = MECSettings()
        testInterface = MECInterface(dependencies: testDependency, andSettings: testSettings)
        
        let testVC = testInterface?.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 9)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(testVC)
    }
    
    func testLaunchWithOrderHistoryLandingView() {
        let mockAppInfra = MockAppInfra()
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput)
        (testVC as? MECOrderHistoryViewController)?.presenter = MECOrderHistoryPresenter()
        
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECOrderHistoryViewController)
    }
    
    func testLaunchWithOrderHistoryLandingViewWhenNotLoggedIn() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userNotLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let flowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, MECErrorCode.MECAuthentication)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECAuthentication)
        })
        XCTAssertNil(testVC)
    }
    
    func testLaunchWithShoppingCartLandingViewWhenNotLoggedIn() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userNotLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let flowConfiguration = MECFlowConfiguration(landingView: .mecShoppingCartView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, MECErrorCode.MECAuthentication)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECAuthentication)
        })
        XCTAssertNil(testVC)
    }
    
    func testLaunchWithShoppingCartLandingView() {
        let mockAppInfra = MockAppInfra()
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let flowConfiguration = MECFlowConfiguration(landingView: .mecShoppingCartView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput)
        (testVC as? MECOrderHistoryViewController)?.presenter = MECOrderHistoryPresenter()
        
        XCTAssertNotNil(testVC)
        XCTAssertTrue(testVC is MECBaseViewController)
        XCTAssertTrue(testVC is MECShoppingCartViewController)
    }
    
    func testLaunchWithOrderHistoryLandingViewWhenHybrisIsTurnedOff() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let flowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        testLaunchInput.flowConfiguration = flowConfiguration
        testLaunchInput.supportsHybris = false
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, MECErrorCode.MECHybrisDisabled)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECHybrisDisabled)
        })
        XCTAssertNil(testVC)
    }
    
    func testLaunchWithOrderHistoryLandingViewWhenInternetIsOff() {
        let mockAppInfra = MockAppInfra()
        (mockAppInfra.restClient as? RESTClientMock)?.isMockInternetReachable = false
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let flowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        testLaunchInput.flowConfiguration = flowConfiguration
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, MECErrorCode.MECNoInternetCode)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECNoNetworkDomain)
        })
        XCTAssertNil(testVC)
    }
    
    func testLaunchWithOrderHistoryLandingViewAndInternetCheckHasHighestPriority() {
        let mockAppInfra = MockAppInfra()
        (mockAppInfra.restClient as? RESTClientMock)?.isMockInternetReachable = false
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let mockDataInterface = MECMockUserDataInterface()
        mockDataInterface.loginState = .userNotLoggedIn
        let mockDependency = MECDependencies()
        mockDependency.userDataInterface = mockDataInterface
        let flowConfiguration = MECFlowConfiguration(landingView: .mecOrderHistoryView)
        testLaunchInput.flowConfiguration = flowConfiguration
        testLaunchInput.supportsHybris = false
        
        let interface = MECInterface(dependencies: mockDependency, andSettings: MECSettings())
        let testVC = interface.instantiateViewController(testLaunchInput, withErrorHandler: { (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, MECErrorCode.MECNoInternetCode)
            XCTAssertEqual(error?.domain, MECErrorDomain.MECNoNetworkDomain)
        })
        XCTAssertNil(testVC)
    }
}

extension MECInterfaceTests {
    
    func resetLaunchInputValuesToDefault() {
        testLaunchInput?.flowConfiguration = nil
        testLaunchInput?.bannerConfigDelegate = nil
        testLaunchInput?.bazaarVoiceClientID = nil
        testLaunchInput?.bazaarVoiceConversationAPIKey = nil
        testLaunchInput?.bazaarVoiceEnvironment = nil
        testLaunchInput?.blacklistedRetailerNames = nil
        testLaunchInput?.supportsRetailers = true
        testLaunchInput?.supportsHybris = true
        testLaunchInput = nil
    }
}
