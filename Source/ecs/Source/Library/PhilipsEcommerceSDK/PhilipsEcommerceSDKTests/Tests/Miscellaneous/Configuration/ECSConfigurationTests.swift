/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSConfigurationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testInitEcommerceWithAppConfigPropositionID() {
        let mockAppInfra = MockAppInfra()
        let propositionID = "IAP_MOB_DKA"
        mockAppInfra.mockConfig?.propositionID = propositionID
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSConfiguration.shared.propositionId, propositionID)
        
        mockAppInfra.mockConfig?.propositionID = nil
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.propositionId)
        
        mockAppInfra.mockConfig?.propositionID = 123
        let services = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.propositionId)
        
        services.propositionId = "IAP_MOB_OHC"
        XCTAssertEqual(ECSConfiguration.shared.propositionId, "IAP_MOB_OHC")
    }
    
    func testInitEcommerceWithAppConfigPropositionIDError() {
        let mockAppInfra = MockAppInfra()
        let error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.mockConfig?.getPropertyError = error
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.propositionId)
    }
    
    func testInitEcommerceWithApiKey() {
        let mockAppInfra = MockAppInfra()
        let apiKey = "TestAPIKey"
        mockAppInfra.mockConfig?.apiKey = apiKey
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSConfiguration.shared.apiKey, apiKey)
        
        mockAppInfra.mockConfig?.apiKey = nil
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.apiKey)
        
        mockAppInfra.mockConfig?.apiKey = ""
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSConfiguration.shared.apiKey, "")
        
        mockAppInfra.mockConfig?.apiKey = 123
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.apiKey)
    }
    
    func testInitEcommerceWithAppConfigAPIKeyError() {
        let mockAppInfra = MockAppInfra()
        let error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.mockConfig?.getPropertyError = error
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertNil(ECSConfiguration.shared.apiKey)
    }
    
    func testInitEcommerceInvalidatesAllData() {
        ECSConfiguration.shared.locale = "TestLocale"
        ECSConfiguration.shared.rootCategory = "TestRootCategory"
        ECSConfiguration.shared.siteId = "TestSiteID"
        let mockAppInfra = MockAppInfra()
        let propositionID = "IAP_MOB_DKA"
        mockAppInfra.mockConfig?.propositionID = propositionID
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSConfiguration.shared.propositionId, propositionID)
        XCTAssertNil(ECSConfiguration.shared.locale)
        XCTAssertNil(ECSConfiguration.shared.rootCategory)
        XCTAssertNil(ECSConfiguration.shared.siteId)
    }
    
    func testPopulateLanguageAndCountryValues() {
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.populateLanguageAndCountryValues()
        XCTAssertEqual(ECSConfiguration.shared.country, "US")
        XCTAssertEqual(ECSConfiguration.shared.language, "en")
        
        ECSConfiguration.shared.locale = "en/US"
        ECSConfiguration.shared.populateLanguageAndCountryValues()
        XCTAssertNil(ECSConfiguration.shared.country)
        XCTAssertNil(ECSConfiguration.shared.language)
        
        ECSConfiguration.shared.locale = ""
        ECSConfiguration.shared.populateLanguageAndCountryValues()
        XCTAssertNil(ECSConfiguration.shared.country)
        XCTAssertNil(ECSConfiguration.shared.language)
        
        ECSConfiguration.shared.locale = "enUS_"
        ECSConfiguration.shared.populateLanguageAndCountryValues()
        XCTAssertEqual(ECSConfiguration.shared.country, "")
        XCTAssertEqual(ECSConfiguration.shared.language, "enUS")
        
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.populateLanguageAndCountryValues()
        XCTAssertNil(ECSConfiguration.shared.country)
        XCTAssertNil(ECSConfiguration.shared.language)
    }
    
    func testFetchPILAPIKeyForAllEnvironments() {
        let mockAppInfra = MockAppInfra()
        mockAppInfra.mockConfig.apiKey = "TestAPIKey"
        
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSUtility.fetchPILAPIKey(), "TestAPIKey")
        
        mockAppInfra.mockConfig.apiKey = nil
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSUtility.fetchPILAPIKey(), "")
        
        mockAppInfra.mockConfig.apiKey = ""
        _ = ECSServices(appInfra: mockAppInfra)
        XCTAssertEqual(ECSUtility.fetchPILAPIKey(), "")
    }
}
