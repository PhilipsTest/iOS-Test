/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsPRXClient
@testable import MobileEcommerceDev

class MECPRXHandlerTests: XCTestCase {
    
    var mockPRXRequestManager: MockPRXRequestManager?
    var prxHandler: MECPRXHandler?

    override func setUp() {
        super.setUp()
        mockPRXRequestManager = MockPRXRequestManager()
        prxHandler = MECPRXHandler()
    }

    override func tearDown() {
        super.tearDown()
        mockPRXRequestManager = nil
        prxHandler = nil
    }
}

//MARK: Fetch PRX Product Specs Unit test cases
extension MECPRXHandlerTests {
    
    func testPRXFetchProductSpecsForProduct() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        let specChapter = PRXSpecificationsChapterItem()
        
        specChapters.chapters = [specChapter]
        specResponse.data = specChapters
        specResponse.success = true
        
        mockPRXRequestManager?.prxResponse = specResponse
        
        let expectation = self.expectation(description: "testPRXFetchProductSpecsForProduct")
        prxHandler?.fetchProductSpecsFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.data.chapters.count, 1)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductSpecsForProductWithSuccessFalse() {
        let specResponse = PRXSpecificationsResponse()
        let specChapters = PRXSpecificationsChapter()
        let specChapter = PRXSpecificationsChapterItem()
        
        specChapters.chapters = [specChapter]
        specResponse.data = specChapters
        specResponse.success = false
        
        mockPRXRequestManager?.prxResponse = specResponse
        
        let expectation = self.expectation(description: "testPRXFetchProductSpecsForProductWithSuccessFalse")
        prxHandler?.fetchProductSpecsFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNil(response)
            XCTAssertNotEqual(response?.data.chapters.count, 1)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductSpecsForProductWithError() {
        mockPRXRequestManager?.prxError = NSError(domain: "", code: 123, userInfo: nil)
        
        let expectation = self.expectation(description: "testPRXFetchProductSpecsForProductWithError")
        prxHandler?.fetchProductSpecsFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNil(response)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductSpecsRequestForProduct() {
        let expectation = self.expectation(description: "testPRXFetchProductSpecsRequestForProduct")
        prxHandler?.fetchProductSpecsFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNotNil(self.mockPRXRequestManager?.prxRequest)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getCtn(), "TestCTN")
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getSector(), B2C)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getCatalog(), CONSUMER)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXRequestManager() {
        let mockAppInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        let prxRequestManager = prxHandler?.fetchPRXRequestManager()
        XCTAssertNotNil(prxRequestManager?.dependencies.appInfra)
        XCTAssertEqual(prxRequestManager?.dependencies.parentTLA, "MEC")
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testPRXRequestManagerWithoutAppInfra() {
        let prxRequestManager = prxHandler?.fetchPRXRequestManager()
        XCTAssertNil(prxRequestManager?.dependencies.appInfra)
        XCTAssertEqual(prxRequestManager?.dependencies.parentTLA, "MEC")
    }
}

//MARK: Fetch PRX Product Features Unit test cases
extension MECPRXHandlerTests {
    
    func testPRXFetchProductFeaturesForProduct() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featuresDetails = PRXFeaturesDetails()
        let featuresAssetDetails = PRXFeaturesAssetDetails()
        let featuresHighlights = PRXFeaturesHighlight()
        
        featuresKeyBenefitArea.features = [featuresDetails]
        featuresData.assetDetails = [featuresAssetDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        featuresData.featureHighlight = [featuresHighlights]
        featuresResponse.data = featuresData
        featuresResponse.success = true
        
        mockPRXRequestManager?.prxResponse = featuresResponse
        
        let expectation = self.expectation(description: "testPRXFetchProductFeaturesForProduct")
        prxHandler?.fetchProductFeaturesFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.data?.assetDetails?.count, 1)
            XCTAssertEqual(response?.data?.keyBenefitArea?.count, 1)
            XCTAssertEqual(response?.data?.keyBenefitArea?.first?.features?.count, 1)
            XCTAssertEqual(response?.data?.featureHighlight?.count, 1)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductFeaturesForProductWithSuccessFalse() {
        let featuresResponse = PRXFeaturesResponse()
        let featuresData = PRXFeaturesData()
        let featuresKeyBenefitArea = PRXFeaturesKeyBenefitArea()
        let featuresDetails = PRXFeaturesDetails()
        let featuresAssetDetails = PRXFeaturesAssetDetails()
        let featuresHighlights = PRXFeaturesHighlight()
        
        featuresKeyBenefitArea.features = [featuresDetails]
        featuresData.assetDetails = [featuresAssetDetails]
        featuresData.keyBenefitArea = [featuresKeyBenefitArea]
        featuresData.featureHighlight = [featuresHighlights]
        featuresResponse.data = featuresData
        featuresResponse.success = false
        
        mockPRXRequestManager?.prxResponse = featuresResponse
        
        let expectation = self.expectation(description: "testPRXFetchProductFeaturesForProductWithSuccessFalse")
        prxHandler?.fetchProductFeaturesFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNil(response)
            XCTAssertNotEqual(response?.data?.assetDetails?.count, 1)
            XCTAssertNotEqual(response?.data?.keyBenefitArea?.count, 1)
            XCTAssertNotEqual(response?.data?.keyBenefitArea?.first?.features?.count, 1)
            XCTAssertNotEqual(response?.data?.featureHighlight?.count, 1)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductFeaturesForProductWithError() {
        mockPRXRequestManager?.prxError = NSError(domain: "", code: 123, userInfo: nil)
        
        let expectation = self.expectation(description: "testPRXFetchProductFeaturesForProductWithError")
        prxHandler?.fetchProductFeaturesFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNil(response)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPRXFetchProductFeaturesRequestForProduct() {
        let expectation = self.expectation(description: "testPRXFetchProductFeaturesRequestForProduct")
        prxHandler?.fetchProductFeaturesFor(CTN: "TestCTN", requestManager: mockPRXRequestManager, completionHandler: { (response) in
            XCTAssertNotNil(self.mockPRXRequestManager?.prxRequest)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getCtn(), "TestCTN")
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getSector(), B2C)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getCatalog(), CONSUMER)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
}

//MARK: Fetch CDLS Data Unit test cases
extension MECPRXHandlerTests {
    
    func testFetchCDLSDetailforProduct() {
        let cdlsDetailsPhone1 = PRXCDLSDetails()
        cdlsDetailsPhone1.content = "cdlsDetailsPhone1Content"
        cdlsDetailsPhone1.phoneNumber = "cdlsDetailsPhone1PhoneNumber"
        
        let cdlsDetailsPhone2 = PRXCDLSDetails()
        cdlsDetailsPhone2.content = "cdlsDetailsPhone2Content"
        cdlsDetailsPhone2.phoneNumber = "cdlsDetailsPhone2PhoneNumber"
        
        let cdlsDetailsChat = PRXCDLSDetails()
        cdlsDetailsChat.content = "cdlsDetailsChatContent"
        cdlsDetailsChat.phoneNumber = "cdlsDetailsChatPhoneNumber"
        
        let cdlsDetailsSocial = PRXCDLSDetails()
        cdlsDetailsSocial.content = "cdlsDetailsSocialContent"
        cdlsDetailsSocial.phoneNumber = "cdlsDetailsSocialPhoneNumber"
        
        let cdlsData = PRXCDLSData()
        cdlsData.contactPhone = [cdlsDetailsPhone1, cdlsDetailsPhone2]
        cdlsData.contactSocial = [cdlsDetailsSocial]
        cdlsData.contactChat = [cdlsDetailsChat]
        
        let cdlsResponse = PRXCDLSResponse()
        cdlsResponse.success = true
        cdlsResponse.data = cdlsData
        
        mockPRXRequestManager?.prxResponse = cdlsResponse
        
        prxHandler?.fetchCDLSDetailfor(category: "TestCategory", requestManager: mockPRXRequestManager, completionHandler: { (cdlsResponse) in
            XCTAssertNotNil(cdlsResponse)
            XCTAssertEqual(cdlsResponse?.data?.contactChat?.count, 1)
            XCTAssertEqual(cdlsResponse?.data?.contactPhone?.count, 2)
            XCTAssertEqual(cdlsResponse?.data?.contactSocial?.count, 1)
            XCTAssertNil(cdlsResponse?.data?.contactEmail)
            XCTAssertEqual(cdlsResponse?.data?.contactChat?.first?.phoneNumber, "cdlsDetailsChatPhoneNumber")
            XCTAssertEqual(cdlsResponse?.data?.contactPhone?.last?.content, "cdlsDetailsPhone2Content")
            XCTAssertNil(cdlsResponse?.data?.contactPhone?.last?.label)
        })
    }
    
    func testFetchCDLSDetailforProductWithSuccessFalse() {
        let cdlsDetailsPhone1 = PRXCDLSDetails()
        cdlsDetailsPhone1.content = "cdlsDetailsPhone1Content"
        cdlsDetailsPhone1.phoneNumber = "cdlsDetailsPhone1PhoneNumber"
        
        let cdlsDetailsPhone2 = PRXCDLSDetails()
        cdlsDetailsPhone2.content = "cdlsDetailsPhone2Content"
        cdlsDetailsPhone2.phoneNumber = "cdlsDetailsPhone2PhoneNumber"
        
        let cdlsDetailsChat = PRXCDLSDetails()
        cdlsDetailsChat.content = "cdlsDetailsChatContent"
        cdlsDetailsChat.phoneNumber = "cdlsDetailsChatPhoneNumber"
        
        let cdlsDetailsSocial = PRXCDLSDetails()
        cdlsDetailsSocial.content = "cdlsDetailsSocialContent"
        cdlsDetailsSocial.phoneNumber = "cdlsDetailsSocialPhoneNumber"
        
        let cdlsData = PRXCDLSData()
        cdlsData.contactPhone = [cdlsDetailsPhone1, cdlsDetailsPhone2]
        cdlsData.contactSocial = [cdlsDetailsSocial]
        cdlsData.contactChat = [cdlsDetailsChat]
        
        let cdlsResponse = PRXCDLSResponse()
        cdlsResponse.success = false
        cdlsResponse.data = cdlsData
        
        mockPRXRequestManager?.prxResponse = cdlsResponse
        
        prxHandler?.fetchCDLSDetailfor(category: "TestCategory", requestManager: mockPRXRequestManager, completionHandler: { (cdlsResponse) in
            XCTAssertNil(cdlsResponse)
        })
    }
    
    func testFetchCDLSDetailforProductWithError() {
        mockPRXRequestManager?.prxError = NSError(domain: "", code: 123, userInfo: nil)
        
        prxHandler?.fetchCDLSDetailfor(category: "TestCategory", requestManager: mockPRXRequestManager, completionHandler: { (cdlsResponse) in
            XCTAssertNil(cdlsResponse)
        })
    }
    
    func testFetchCDLSDetailforProductRequest() {
        prxHandler?.fetchCDLSDetailfor(category: "TestCategory", requestManager: mockPRXRequestManager, completionHandler: { (cdlsResponse) in
            XCTAssertNotNil(self.mockPRXRequestManager?.prxRequest)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getSector(), B2C)
            XCTAssertEqual(self.mockPRXRequestManager?.prxRequest.getCatalog(), CARE)
        })
    }
}
