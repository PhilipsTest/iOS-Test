/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchRegionTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var restClient: RESTClientMock!
    var sut: ECSServices!
    
    override func setUp() {
        super.setUp()
        
        mockAppInfra = MockAppInfra()
        restClient = RESTClientMock()
        mockAppInfra.restClient = restClient
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test_rootCategory"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.hybrisToken = "testHybrisToken"
        ECSConfiguration.shared.baseURL = "testCaseURL"
    }

    override func tearDown() {
        mockAppInfra = nil
        restClient = nil
        sut = nil
        
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        super.tearDown()
    }

    func testFetchRegionSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchRegionListSuccess")
        let expectation = self.expectation(description: "testFetchRegionSuccess")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertEqual(regionList?.count, 57)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRegionSuccessInvalidJson() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchRegionListSuccessInvalidJson")
        let expectation = self.expectation(description: "testFetchRegionSuccess")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertNil(regionList)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssert((error as NSError?)?.code == 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRegionSuccessWithoutAuthentication() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchRegionListSuccess")
        ECSConfiguration.shared.hybrisToken = nil
        let expectation = self.expectation(description: "testFetchRegionSuccess")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertEqual(regionList?.count, 57)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRegionFailedEmptyCountryCode() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchRegionListSuccess")
        let expectation = self.expectation(description: "testFetchRegionFailedEmptyCountryCode")
        sut.fetchRegionsFor(countryISO: "") { (regionList, error) in
            XCTAssertEqual(error?.localizedDescription, "Please provide valid country code")
            XCTAssertEqual((error as NSError?)?.code, 5059)
            XCTAssertNil(regionList)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedNoConfig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccess")
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testCreateAddressFailedNoConfig")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            XCTAssertEqual((error as NSError?)?.code, 5050)
            XCTAssertNil(regionList)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidCountryCode() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchRegionInvalidCountryCode")
        restClient.errorData = NSError(domain: "error", code: 11, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidCountryCode")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            XCTAssertEqual((error as NSError?)?.code, 5006)
            XCTAssertNil(regionList)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedRandomError() {
        
        restClient.errorData = NSError(domain: "error", code: 11, userInfo: [NSLocalizedDescriptionKey: "Random error"])
        let expectation = self.expectation(description: "testCreateAddressFailedRandomError")
        sut.fetchRegionsFor(countryISO: "US") { (regionList, error) in
            XCTAssertEqual(error?.localizedDescription, "Random error")
            XCTAssertEqual((error as NSError?)?.code, 11)
            XCTAssertNil(regionList)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}
