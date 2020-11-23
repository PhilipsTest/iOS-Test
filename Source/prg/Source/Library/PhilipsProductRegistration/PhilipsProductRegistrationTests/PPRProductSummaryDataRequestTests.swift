//
//  PPRProductSummaryDataRequestTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 25/01/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsPRXClient
@testable import PhilipsProductRegistrationDev

class PPRProductSummaryDataRequestTests: PPRBaseClassTests {
    
    var summaryDataJsonObject: PPRProductSummaryDataJSONObject?
    var summaryDataInfoTests: PRXProductSummaryDataInfoDataTests?
    let ctn  = PPRTestConstants.ctn
    let serialNum = PPRTestConstants.serialNum
    
    override func setUp() {
        super.setUp()
        summaryDataJsonObject = PPRProductSummaryDataJSONObject()
        summaryDataInfoTests = PRXProductSummaryDataInfoDataTests()
    }
    
//    func testSummaryDataRequestUrlForNLLocale() {
//        let locale = "nl_NL"
//        let summaryDataRequest = fakeSummaryDataRequest(locale)
//        summaryDataRequest.getRequestUrl(from:  self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
//            XCTAssertEqual(serviceURL, "https://www.philips.com/prx/product/B2C/\(locale)/CONSUMER/products/\(PPRTestConstants.ctn).summary")
//            self.verifySummarydataParameters(summaryDataRequest)
//        })
//    }
    
    func testSummaryDataRequestUrlForENLocale() {
        let locale = "en_US"
        let summaryDataRequest = fakeSummaryDataRequest(locale)        
        summaryDataRequest.getRequestUrl(from: self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            XCTAssertEqual(serviceURL, "https://www.philips.com/prx/product/DEFAULT/en_IN/CONSUMER/products/\(PPRTestConstants.ctn).summary")
            self.verifySummarydataParameters(summaryDataRequest)
        })
        
    }
    
    func testSummaryDataRequestWithNilResponse() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let summaryDataRequest = PRXProductSummaryDataRequest(product: productInfo)
        let response: PRXProductSummaryDataResponse = summaryDataRequest.getResponse(nil) as! PRXProductSummaryDataResponse
        self.verifySummarydataParameters(summaryDataRequest)
        XCTAssertFalse(response.success)
        XCTAssertNil(response.data)
    }
    
    func testSummaryDataRequestWithEmptyData() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let summaryDataRequest = PRXProductSummaryDataRequest(product: productInfo)
        let dict = NSDictionary(dictionary: ["success" : true , "data": NSDictionary()])
        let response: PRXProductSummaryDataResponse = summaryDataRequest.getResponse(dict) as! PRXProductSummaryDataResponse
        let responseData = response.data
        self.verifySummarydataParameters(summaryDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        summaryDataInfoTests?.verifyEmptyData(response.data!)
    }
    
    func testSummaryDataRequestWithSuccessWithDiffrentValueType() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let summaryDataRequest = PRXProductSummaryDataRequest(product: productInfo)
        let dict = summaryDataJsonObject!.fakeValidStructureWithDifferenValues()
        let response: PRXProductSummaryDataResponse = summaryDataRequest.getResponse(dict) as! PRXProductSummaryDataResponse
        let responseData = response.data
        self.verifySummarydataParameters(summaryDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        summaryDataInfoTests?.verifyInValidData(responseData!)
    }
    
    func testSummaryDataRequestWithValidResponse() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let summaryDataRequest = PRXProductSummaryDataRequest(product: productInfo)
        let dict = summaryDataJsonObject!.fakeValidSummaryResponse()
        let response: PRXProductSummaryDataResponse = summaryDataRequest.getResponse(dict) as! PRXProductSummaryDataResponse
        let responseData = response.data
        self.verifySummarydataParameters(summaryDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        summaryDataInfoTests?.verifyValidData(responseData!)
    }
    
    func verifySummarydataParameters(_ request: PRXProductSummaryDataRequest) {
        let metadataRequest = request
        XCTAssertNil(metadataRequest.getHeaderParam())
        XCTAssertNil(metadataRequest.getBodyParameters())
        XCTAssertTrue(metadataRequest.getRequestType() == GET)
    }
    
    fileprivate func fakeSummaryDataRequest(_ locale:String)->PRXProductSummaryDataRequest {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let summaryRequest = PRXProductSummaryDataRequest(product: productInfo)
        return summaryRequest
    }
}
