/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSCreateAddressFetchListTests: XCTestCase {

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

    func testCreateAddressSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccess")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testCreateAddressSuccess")

        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNotNil(addressList)
            XCTAssertTrue(addressList?.count == 2)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testCreateAddressFailedNoConfig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccess")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testCreateAddressFailedNoConfig")
        ECSConfiguration.shared.baseURL = nil
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert(error?.localizedDescription == "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccess")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testCreateAddressFailedNoSiteId")
        ECSConfiguration.shared.siteId = nil
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5054)
            XCTAssert(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedParsing() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccessInvalid")
        
        let expectation = self.expectation(description: "testCreateAddressFailedParsing")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5999)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedNoOuath() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "createAddressSuccess")
        restClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        
        let expectation = self.expectation(description: "testCreateAddressFailedNoOuath")
        ECSConfiguration.shared.hybrisToken = nil
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5057)
            XCTAssert(error?.localizedDescription == "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidTitleCode() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidTitleCode")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])

        let expectation = self.expectation(description: "testCreateAddressFailedInvalidTitleCode")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5006)
            XCTAssert(error?.localizedDescription == "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidRegion() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidRegion")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidRegion")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5014)
            XCTAssert(error?.localizedDescription == "Region selected is invalid")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidCountry() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidCountryCode")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidCountry")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5015)
            XCTAssert(error?.localizedDescription == "Country selected is invalid")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidZip() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPostalCode")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidZip")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5016)
            XCTAssert(error?.localizedDescription == "ZIP code selected is invalid")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)

    }
    
    func testCreateAddressFailedInvalidFirstName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidFirstName")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidFirstName")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5017)
            XCTAssert(error?.localizedDescription == "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidLastName() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidLastName")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidLastName")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5018)
            XCTAssert(error?.localizedDescription == "Please notice that the following characters are not allowed: \\\" < > ) ( * ^ % $ # @ ! & + , . ? /  : ; { } [ ] ` ~ =")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedInvalidPhoneNumber() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPhoneNumber")
        restClient.errorData = NSError(domain: "error", code: 100, userInfo: [:])
        
        let expectation = self.expectation(description: "testCreateAddressFailedInvalidPhoneNumber")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 5019)
            XCTAssert(error?.localizedDescription == "Phone number selected is invalid")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateAddressFailedRandomError() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressEmptyList")
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: [NSLocalizedDescriptionKey:"Random error"])
        
        let expectation = self.expectation(description: "testCreateAddressFailedRandomError")
        let address = ECSAddress()
        sut.createAddressWith(address: address) { (addressList, error) in
            XCTAssertNil(addressList)
            XCTAssertNotNil(error)
            XCTAssert((error as NSError?)?.code == 400)
            XCTAssert(error?.localizedDescription == "Random error")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
