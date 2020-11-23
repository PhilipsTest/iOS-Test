/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSUpdateAddressTests: XCTestCase {

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

    func testUpdateAddressSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        let expectation = self.expectation(description: "testUpdateAddressSuccess")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertTrue(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidAddressId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        let expectation = self.expectation(description: "testUpdateAddressSuccess")
        
        address.addressID = nil
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Given address doesn't exist or belong to another user")
            XCTAssertEqual((error as NSError?)?.code,5021)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedNoConfig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        let expectation = self.expectation(description: "testUpdateAddressFailedNoConfig")
        
        ECSConfiguration.shared.baseURL = nil
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            XCTAssertEqual((error as NSError?)?.code,5050)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        let expectation = self.expectation(description: "testUpdateAddressFailedNoSiteId")
        
        ECSConfiguration.shared.siteId = nil
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertEqual((error as NSError?)?.code,5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedNoOuath() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        let expectation = self.expectation(description: "testUpdateAddressFailedNoOuath")
        
        ECSConfiguration.shared.hybrisToken = nil
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            XCTAssertEqual((error as NSError?)?.code,5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidTitleCode() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidTitleCode")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidTitleCode")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            XCTAssertEqual((error as NSError?)?.code,5006)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidRegion() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidRegion")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidRegion")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Region selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5014)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidCountry() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidCountryCode")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidCountry")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Country selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5015)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidZip() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPostalCode")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidZip")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "ZIP code selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5016)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidFirstName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidFirstName")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidFirstName")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            XCTAssertEqual((error as NSError?)?.code,5017)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)

    }
    
    func testUpdateAddressFailedInvalidLastName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidLastName")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidLastName")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            XCTAssertEqual((error as NSError?)?.code,5018)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedInvalidPhoneNumber() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPhoneNumber")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [:])
        let expectation = self.expectation(description: "testUpdateAddressFailedInvalidPhoneNumber")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Phone number selected is invalid")
            XCTAssertEqual((error as NSError?)?.code,5019)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateAddressFailedRandomError() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.errorData = NSError(domain: "Domain", code: 111, userInfo: [NSLocalizedDescriptionKey:"Random error"])
        let expectation = self.expectation(description: "testUpdateAddressFailedRandomError")
        sut.updateAddress(address: address) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertEqual(error?.localizedDescription, "Random error")
            XCTAssertEqual((error as NSError?)?.code,111)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
