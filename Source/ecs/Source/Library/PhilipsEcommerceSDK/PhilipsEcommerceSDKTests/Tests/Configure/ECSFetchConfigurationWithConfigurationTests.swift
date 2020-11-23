/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchConfigurationWithConfigurationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.locale = nil
    }

    func testconfigureECSWithConfigurationECSSuccess() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        let expectation = self.expectation(description: "configureECSWithConfigurationECSSuccess")
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNil(error, "error")
            XCTAssertNotNil(config, "error")
            XCTAssert(ECSConfiguration.shared.rootCategory == "Tuscany_Campaign")
            XCTAssert(ECSConfiguration.shared.siteId == "US_Tuscany")
            XCTAssertEqual(config?.isHybrisAvailable, true)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testconfigureECSWithConfigurationFailedNoAppinfra() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigNetFalse")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.appInfra = nil
        let expectation = self.expectation(description: "configureECSWithConfigurationFailedNet")
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNotNil(error, "error")
            XCTAssert(error?.localizedDescription == "Please provide app infra object")
            XCTAssertNil(config, "error")
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testconfigureECSWithConfigurationFailedNet() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigNetFalse")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        let expectation = self.expectation(description: "configureECSWithConfigurationFailedNet")
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNotNil(error, "error")
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertNotNil(config, "error")
            XCTAssertNil(config?.rootCategory)
            XCTAssertEqual(config?.isHybrisAvailable, false)
            XCTAssertNotNil(config?.locale)
            XCTAssertEqual(config?.locale, "en_US")
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testconfigureECSWithConfigurationLanguageNotSupported() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigFailLanguage")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        let expectation = self.expectation(description: "configureECSWithConfigurationLanguageNotSupported")
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNotNil(error, "error")
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertNotNil(config, "error")
            XCTAssertNil(config?.rootCategory)
            XCTAssertNotNil(config?.locale)
            XCTAssertEqual(config?.locale, "en_US")
            XCTAssertEqual(config?.isHybrisAvailable, false)
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testconfigureECSWithConfigurationNoHybris() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        let expectation = self.expectation(description: "configureECSWithConfigurationNoHybris")
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNotNil(error, "error")
            XCTAssertNotNil(config, "error")
            XCTAssertNil(config?.rootCategory)
            XCTAssertNotNil(config?.locale)
            XCTAssertEqual(config?.isHybrisAvailable, false)
            XCTAssertEqual(config?.locale, "en_US")
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testconfigureECSWithConfigurationServiceDiscoveryError() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        serviceDiscovery.error = NSError(domain: "Service discovery", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Unexpected error occured"])
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        let expectation = self.expectation(description: "configureECSWithConfigurationServiceDiscoveryError")
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        sut.configureECSWithConfiguration(completionHandler: { (config, error) in
            XCTAssertNotNil(error, "error")
            XCTAssertNil(config, "error")
            XCTAssert(error?.localizedDescription == "Unexpected error occured")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testConfigureECSWithConfigurationSuccessInvalidJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccessInvalidJson")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testConfigureECSWithConfigurationSuccessInvalidJson")
        sut.configureECSWithConfiguration { (config, error) in
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssert((error as NSError?)?.code == 5999)
            XCTAssertNotNil(config)
            XCTAssertEqual(config?.isHybrisAvailable, false)
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testConfigureECSWithConfigurationFailedServiceNil() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        serviceDiscovery.service = nil
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccessInvalidJson")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testConfigureECSWithConfigurationFailedServiceNil")
        sut.configureECSWithConfiguration { (config, error) in
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssert((error as NSError?)?.code == 5055)
            XCTAssertNil(config)
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testConfigureECSWithConfigurationEmptyResponse() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = "https://acc.us.pil.shop.philips.com"
        restClient.responseData = nil
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        let sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        
        let expectation = self.expectation(description: "testConfigureECSWithConfigurationEmptyResponse")
        sut.configureECSWithConfiguration { (config, error) in
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssert((error as NSError?)?.code == 5999)
            XCTAssertNotNil(config)
            XCTAssertEqual(config?.isHybrisAvailable, false)
            XCTAssert(ECSConfiguration.shared.rootCategory == nil)
            XCTAssert(ECSConfiguration.shared.siteId == nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
