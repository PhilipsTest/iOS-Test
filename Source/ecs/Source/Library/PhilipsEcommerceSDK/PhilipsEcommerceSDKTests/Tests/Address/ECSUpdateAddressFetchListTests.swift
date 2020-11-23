/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSUpdateAddressFetchListTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var restClient: RESTClientMock!
    var sut: ECSServices!
    var address: ECSAddress!
    
    override func setUp() {
        mockAppInfra = MockAppInfra()
        restClient = RESTClientMock()
        address = ECSAddress()
        address.addressID = "123"
        
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
        address = nil
        
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }

    func testUpdateAddressFetchListSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListSuccess")
        
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertTrue(resultList?.count == 2)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidAddressId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidAddressId")
        
        address.addressID = nil
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Given address doesn't exist or belong to another user")
            XCTAssertEqual((error as NSError?)?.code,5021)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedNoConfig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedNoConfig")
        
        ECSConfiguration.shared.baseURL = nil
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            XCTAssertEqual((error as NSError?)?.code,5050)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testUpdateAddressFetchListFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedNoSiteId")
        
        ECSConfiguration.shared.siteId = nil
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertEqual((error as NSError?)?.code,5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedNoOuath() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedNoOuath")
        
        ECSConfiguration.shared.hybrisToken = nil
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            XCTAssertEqual((error as NSError?)?.code,5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidTitleCode() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidTitleCode")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidTitleCode")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            XCTAssertEqual((error as NSError?)?.code,5006)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidRegion() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidRegion")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidRegion")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Region selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5014)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidCountry() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidCountryCode")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidCountry")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Country selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5015)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidZip() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPostalCode")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidZip")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "ZIP code selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5016)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
    }
    
    func testUpdateAddressFetchListFailedInvalidFirstName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidFirstName")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidFirstName")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            XCTAssertEqual((error as NSError?)?.code,5017)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidLastName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidLastName")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidLastName")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            XCTAssertEqual((error as NSError?)?.code,5018)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedInvalidPhoneNumber() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPhoneNumber")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedInvalidPhoneNumber")
        sut.updateAddressWith(address: address) { (resultList, error) in
            XCTAssertNil(resultList)
            XCTAssertEqual(error?.localizedDescription, "Phone number selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5019)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFetchListFailedRandomError() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [NSLocalizedDescriptionKey:"Random error"])
        
        let expectation = self.expectation(description: "testUpdateAddressFetchListFailedRandomError")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Random error")
            XCTAssertEqual((error as NSError?)?.code,111)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
