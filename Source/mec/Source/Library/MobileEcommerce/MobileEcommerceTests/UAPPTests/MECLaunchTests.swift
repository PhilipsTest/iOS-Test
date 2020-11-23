/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev

class MECLaunchTests: XCTestCase {
    
    var testLaunchInput: MECLaunchInput?

    override func setUp() {
        super.setUp()
        testLaunchInput = MECLaunchInput()
    }

    override func tearDown() {
        super.tearDown()
        resetLaunchInputValuesToDefault()
    }
    
    func testInitSetsDefaultLandingView() {
        XCTAssertNotNil(testLaunchInput?.flowConfiguration)
        XCTAssertNotNil(MECConfiguration.shared.flowConfiguration)
        XCTAssertEqual(MECConfiguration.shared.flowConfiguration?.landingView, .mecProductListView)
        XCTAssertNil(MECConfiguration.shared.flowConfiguration?.productCTNs)
    }
    
    func testFlowConfigurationFromLaunchInput() {
        let testFlowConfiguration = MECFlowConfiguration(landingView: .mecProductDetailsView)
        testFlowConfiguration.productCTNs = ["TestCTN1", "TestCTN2", "TestCTN3"]
        testFlowConfiguration.productCTNs?.append("TestCTN4")
        testLaunchInput?.flowConfiguration = testFlowConfiguration
        
        XCTAssertEqual(MECConfiguration.shared.flowConfiguration?.landingView, .mecProductDetailsView)
        XCTAssertNotNil(MECConfiguration.shared.flowConfiguration?.productCTNs)
        XCTAssertEqual(MECConfiguration.shared.flowConfiguration?.productCTNs?.count, 4)
        XCTAssertEqual(MECConfiguration.shared.flowConfiguration?.productCTNs?.contains("TestCTN2"), true)
        
        testFlowConfiguration.productCTNs = nil
        testLaunchInput?.flowConfiguration = testFlowConfiguration
        
        XCTAssertEqual(MECConfiguration.shared.flowConfiguration?.landingView, .mecProductDetailsView)
        XCTAssertNil(MECConfiguration.shared.flowConfiguration?.productCTNs)
    }
    
    func testBannerConfigDelegateDefaultFromLaunchInput() {
        XCTAssertNil(testLaunchInput?.bannerConfigDelegate)
        XCTAssertNil(MECConfiguration.shared.bannerConfigDelegate)
    }
    
    func testBannerConfigDelegateCustomFromLaunchInput() {
        let mockBannerConfigDelegate = MECMockBannerConfigDelegate()
        testLaunchInput?.bannerConfigDelegate = mockBannerConfigDelegate
        let mockView = testLaunchInput?.bannerConfigDelegate?.viewForBannerInProductListScreen()
        
        XCTAssertNotNil(MECConfiguration.shared.bannerConfigDelegate)
        XCTAssertTrue(MECConfiguration.shared.bannerConfigDelegate === mockBannerConfigDelegate)
        XCTAssertEqual(mockView?.tag, 999)
    }
    
    func testBlacklistedRetailerNamesDefaultFromLaunchInput() {
        XCTAssertNil(testLaunchInput?.blacklistedRetailerNames)
        XCTAssertNil(MECConfiguration.shared.blacklistedRetailerNames)
    }
    
    func testBlacklistedRetailerNamesCustomFromLaunchInput() {
        testLaunchInput?.blacklistedRetailerNames = ["TestRetailer1", "TestRetailer2"]
        
        XCTAssertEqual(MECConfiguration.shared.blacklistedRetailerNames?.count, 2)
        XCTAssertEqual(MECConfiguration.shared.blacklistedRetailerNames?.contains("TestRetailer2"), true)
        
        testLaunchInput?.blacklistedRetailerNames = nil
        XCTAssertNil(MECConfiguration.shared.blacklistedRetailerNames)
    }
    
    func testSupportsHybrisDefaultFromLaunchInput() {
        XCTAssertEqual(testLaunchInput?.supportsHybris, true)
        XCTAssertTrue(MECConfiguration.shared.supportsHybris)
    }
    
    func testSupportsHybrisCustomFromLaunchInput() {
        testLaunchInput?.supportsHybris = false
        
        XCTAssertFalse(MECConfiguration.shared.supportsHybris)
    }
    
    func testSupportsRetailersDefaultFromLaunchInput() {
        XCTAssertEqual(testLaunchInput?.supportsRetailers, true)
        XCTAssertTrue(MECConfiguration.shared.supportsRetailers)
    }
    
    func testSupportsRetailersCustomFromLaunchInput() {
        testLaunchInput?.supportsRetailers = false
        
        XCTAssertFalse(MECConfiguration.shared.supportsRetailers)
    }
    
    func testBazaarVoiceClientIDDefaultFromLaunchInput() {
        XCTAssertNil(testLaunchInput?.bazaarVoiceClientID)
        XCTAssertNil(MECConfiguration.shared.bazaarVoiceClientID)
    }
    
    func testBazaarVoiceClientIDCustomFromLaunchInput() {
        testLaunchInput?.bazaarVoiceClientID = "TestBazaarVoiceClientID"
        
        XCTAssertNotNil(MECConfiguration.shared.bazaarVoiceClientID)
        XCTAssertEqual(MECConfiguration.shared.bazaarVoiceClientID, MECConfiguration.shared.bazaarVoiceClientID)
    }
    
    func testBazaarVoiceConversationAPIKeyDefaultFromLaunchInput() {
        XCTAssertNil(testLaunchInput?.bazaarVoiceConversationAPIKey)
        XCTAssertNil(MECConfiguration.shared.bazaarVoiceConversationAPIKey)
    }
    
    func testBazaarVoiceConversationAPIKeyCustomFromLaunchInput() {
        testLaunchInput?.bazaarVoiceConversationAPIKey = "TestBazaarVoiceConversationAPIKey"
        
        XCTAssertNotNil(MECConfiguration.shared.bazaarVoiceConversationAPIKey)
        XCTAssertEqual(MECConfiguration.shared.bazaarVoiceConversationAPIKey, "TestBazaarVoiceConversationAPIKey")
    }
    
    func testBazaarVoiceEnvironmentDefaultFromLaunchInput() {
        XCTAssertNil(testLaunchInput?.bazaarVoiceEnvironment)
        XCTAssertNil(MECConfiguration.shared.bazaarVoiceEnvironment)
    }
    
    func testBazaarVoiceEnvironmentCustomFromLaunchInput() {
        testLaunchInput?.bazaarVoiceEnvironment = .staging
        
        XCTAssertNotNil(MECConfiguration.shared.bazaarVoiceEnvironment)
        XCTAssertEqual(MECConfiguration.shared.bazaarVoiceEnvironment, .staging)
    }
}

extension MECLaunchTests {
    
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
