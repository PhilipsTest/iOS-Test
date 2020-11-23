/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchRetailersTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockProductCTN = "HX3631/06"
    var mockServiceDiscovery: ServiceDiscoveryMock!

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        mockServiceDiscovery = ServiceDiscoveryMock()
        mockServiceDiscovery.microserviceURL = "https://testURL.com"
        mockAppInfra.serviceDiscovery = mockServiceDiscovery
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        mockServiceDiscovery = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }
    
    func testFetchRetailerSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailerSuccess")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersSuccessWithEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailersSuccessWithEntries")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNil(error)
            XCTAssertEqual(retailerList?.wrbresults?.ctn, self.mockProductCTN)
        XCTAssertNotNil(retailerList?.retailerList)
        XCTAssertEqual(retailerList?.retailerList?.count, 6)
            XCTAssertEqual(retailerList?.wrbresults?.onlineStoresForProduct?.ctn, self.mockProductCTN)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailerWithBlankRetailerList() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersWithBlankRetailer")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailerWithBlankRetailerList")
        ecsService.fetchRetailerDetailsFor(productCtn: "HX3631/03") { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNil(error)
            XCTAssertEqual(retailerList?.wrbresults?.ctn, "HX3631/03")
            XCTAssertNil(retailerList?.retailerList)
            XCTAssertNil(retailerList?.wrbresults?.onlineStoresForProduct?.ctn)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchFetchRetailersWithInvalidCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailerInvalidCTN")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchFetchRetailersWithInvalidCTN")
        ecsService.fetchRetailerDetailsFor(productCtn: "a") { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 404)
            XCTAssertEqual(error?.localizedDescription, "Missing product number.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchFetchRetailersWithBlankCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailerInvalidCTN")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchFetchRetailersWithBlankCTN")
        ecsService.fetchRetailerDetailsFor(productCtn: "") { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 5006)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailersWithInvalidJson")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithoutLoggingIn() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.hybrisToken = nil
        
        let expectation = self.expectation(description: "testFetchRetailersWithoutLoggingIn")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNotNil(retailerList?.wrbresults?.onlineStoresForProduct)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchRetailersWithNilAppInfra")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailerWithNilSiteID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        let expectation = self.expectation(description: "testFetchRetailerWithNilSiteID")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNotNil(retailerList?.wrbresults?.onlineStoresForProduct)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        let expectation = self.expectation(description: "testFetchRetailersWithUncaughtError")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersForNonHybris() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.rootCategory = nil
        
        let expectation = self.expectation(description: "testFetchRetailersForNonHybris")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNil(error)
            XCTAssertNotNil(retailerList?.wrbresults?.onlineStoresForProduct)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersForHybris() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailersList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchRetailersForHybris")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNotNil(retailerList)
            XCTAssertNil(error)
            XCTAssertNotNil(retailerList?.wrbresults?.onlineStoresForProduct)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithNoResponse() {
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailersWithNoResponse")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithServiceDiscoveryURLFailure() {
        mockServiceDiscovery.error = NSError(domain: "", code: 123, userInfo: nil)
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchRetailersWithServiceDiscoveryURLFailure")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithServiceDiscoveryURLNotFound() {
        mockServiceDiscovery.microserviceURL = nil
        mockServiceDiscovery.service?.error = NSError(domain: "", code: 123, userInfo: nil)
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchRetailersWithServiceDiscoveryURLNotFound")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailersWithServiceDiscoveryURLNotFoundAndNoServiceError() {
        mockServiceDiscovery.microserviceURL = nil
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchRetailersWithServiceDiscoveryURLNotFoundAndNoServiceError")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailerDetailsForProductWithInvalidErrorFormat() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailerInvalidError")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailerDetailsForProductWithInvalidErrorFormat")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertNotEqual((error as NSError?)?.code, 404)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchRetailerDetailsForProductWithBlankErrorMessage() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchRetailerInvalidCTNWithoutMessage")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchRetailerDetailsForProductWithBlankErrorMessage")
        ecsService.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (retailerList, error) in
            XCTAssertNil(retailerList)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 404)
            XCTAssertEqual(error?.localizedDescription, "")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
