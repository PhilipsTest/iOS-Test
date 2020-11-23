/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSDeleteAddressRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockAccessToken = "Test token"
    var mockBaseURL = "https://www.testecs.com"
    var addressId = "123"
    
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

    func testDeleteAddressRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "testSetDeliveryAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSDeleteAddressMicroService()
        let address = ECSAddress()
        address.addressID = addressId
        testMicro.deleteAddress(savedAddress: address) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.DELETE.rawValue)
        XCTAssertEqual(url?.absoluteString, String(format:"%@/pilcommercewebservices/v2/%@/users/current/addresses/%@",mockBaseURL, mockSiteID, addressId))
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(addressId) == true)
    }
    
    func testDeleteAddressRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "testSetDeliveryAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSDeleteAddressMicroService()
        let address = ECSAddress()
        address.addressID = nil
        testMicro.deleteAddress(savedAddress: address) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
}
