/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSMakePaymentRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockAccessToken = "Test token"
    var mockBaseURL = "https://www.testecs.com"
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
    }
    
    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
    }

    func addressObject() -> ECSAddress {
        let address = ECSAddress()
        address.addressID = "123"
        address.firstName = "name"
        address.lastName = "last"
        address.houseNumber = "123"
        address.line1 = "address1"
        address.phone = "1234"
        address.postalCode = "123"
        address.titleCode = "Mr."
        address.town = "testTown"
        let country = ECSCountry()
        country.isocode = "US"
        address.country = country
        
        return address
    }
    
    func testMakePaymentRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSMakePaymentMicroService()
        let order = ECSOrderDetail()
        order.orderID = "123"
        
        testMicro.makePayment(for: order, billingAddress: addressObject()) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("firstName=name"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("lastName=last"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("houseNumber=123"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("line1=address1"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("phone=1234"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("postalCode=123"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("titleCode=Mr."))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("country.isocode=US"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("town=testTown"))
        
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString,
                       String(format:"%@/pilcommercewebservices/v2/%@/users/current/orders/%@/pay", mockBaseURL, mockSiteID, "123"))
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        
    }
    
    func testMakePaymentRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSMakePaymentMicroService()
        let order = ECSOrderDetail()
        order.orderID = nil
        
        testMicro.makePayment(for: order, billingAddress: addressObject()) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
}
