/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchAddressListTest: XCTestCase {

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

    func testFetchAddressSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        let expectation = self.expectation(description: "testFetchAddressSuccess")
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNotNil(addressList)
            XCTAssertTrue(addressList?.count == 2)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressSuccessInvalidData() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccessInvalid")
        let expectation = self.expectation(description: "testFetchAddressSuccess")
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual((error as NSError?)?.code, 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressSuccessEmptyList() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        
        let expectation = self.expectation(description: "testFetchAddressSuccessEmptyList")
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressFailedInvalidToken() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        restClient.errorData = NSError(domain: "error", code: 555, userInfo: [:])
        let expectation = self.expectation(description: "testFetchAddressFailedInvalidToken")
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code , 5009)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressFailedNoConfig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")

        let expectation = self.expectation(description: "testFetchAddressFailedNoConfig")
        ECSConfiguration.shared.baseURL = nil
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testFetchAddressFailedNoSiteId")
        ECSConfiguration.shared.siteId = nil
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5054)
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAddressFailedNoOuath() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testFetchAddressFailedNoOuath")
        ECSConfiguration.shared.hybrisToken = nil
        
        sut.fetchSavedAddresses{ (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5057)
            XCTAssert(error?.localizedDescription == "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

}
