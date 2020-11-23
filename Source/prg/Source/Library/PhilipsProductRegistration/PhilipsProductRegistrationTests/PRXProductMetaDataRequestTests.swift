//
//  PRXProductMetaDataRequestTest.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient
@testable import PhilipsProductRegistrationDev

class PRXProductMetaDataRequestTests: PPRBaseClassTests {

    var metaDataJsonObject: PPRProductMetaDataJSONObject?
    var metaDataInfoTests: PRXProductMetaDataInfoDataTests?
    let ctn  = PPRTestConstants.ctn
    let serialNum = PPRTestConstants.serialNum
    
    override func setUp() {
        super.setUp()
        metaDataJsonObject = PPRProductMetaDataJSONObject()
        metaDataInfoTests = PRXProductMetaDataInfoDataTests()
    }
    
    /*
    func testMetaDataRequestUrlForNLLocale() {
        let locale = "nl_NL"
        let metaDataRequest = fakeMetaDataRequest(locale)
        metaDataRequest.getRequestUrlFromAppInfra(appInfra: self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            XCTAssertEqual(metaDataUrl, "https://www.philips.com/prx/registration/B2C/\(locale)/CONSUMER/products/\(PPRTestConstants.ctn).metadata")
            self.verifyMetadataParameters(metaDataRequest)
        })

        
    }
    
    func testMetaDataRequestUrlForENLocale() {
        let locale = "en_US"
        let metaDataRequest = fakeMetaDataRequest(locale)
        metaDataRequest.getRequestUrlFromAppInfra(appInfra: self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            XCTAssertEqual(metaDataUrl, "https://www.philips.com/prx/registration/B2C/\(locale)/CONSUMER/products/\(PPRTestConstants.ctn).metadata")
        self.verifyMetadataParameters(metaDataRequest)
        })
    } */
    
    func testMetaDataRequestWithNilResponse() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let metaDataRequest = PRXProductMetaDataRequest(product: productInfo)
        let response: PRXProductMetaDataResponse = metaDataRequest.getResponse(nil) as! PRXProductMetaDataResponse
        self.verifyMetadataParameters(metaDataRequest)
        XCTAssertFalse(response.success)
        XCTAssertNil(response.data)
    }
    
    func testMetaDataRequestWithEmptyData() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let metaDataRequest = PRXProductMetaDataRequest(product: productInfo)
        let dict = NSDictionary(dictionary: ["success" : true , "data": NSDictionary()])
        let response: PRXProductMetaDataResponse = metaDataRequest.getResponse(dict) as! PRXProductMetaDataResponse
        let responseData = response.data
        self.verifyMetadataParameters(metaDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        metaDataInfoTests?.verifyEmptyData(response.data!)
    }
    
    func testMetaDataRequestWithSuccessWithDiffrentValueType() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let metaDataRequest = PRXProductMetaDataRequest(product: productInfo)
        let dict = metaDataJsonObject!.fakeValidStructureWithDifferenValues()
        let response: PRXProductMetaDataResponse = metaDataRequest.getResponse(dict) as! PRXProductMetaDataResponse
        let responseData = response.data
        self.verifyMetadataParameters(metaDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        metaDataInfoTests?.verifyInValidData(responseData!)
    }
    
    func testMetaDataRequestWithValidResponse() {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let metaDataRequest = PRXProductMetaDataRequest(product: productInfo)
        let dict = metaDataJsonObject!.fakeValidResponse(with: true, isSerialNumberRequired: true)
        let response: PRXProductMetaDataResponse = metaDataRequest.getResponse(dict) as! PRXProductMetaDataResponse
        let responseData = response.data
        self.verifyMetadataParameters(metaDataRequest)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(responseData)
        metaDataInfoTests?.verifyValidData(responseData!)
    }
    
    func verifyMetadataParameters(_ request: PRXProductMetaDataRequest) {
        let metadataRequest = request
        XCTAssertNil(metadataRequest.getHeaderParam())
        XCTAssertNil(metadataRequest.getBodyParameters())
        XCTAssertTrue(metadataRequest.getRequestType() == GET)
    }
    
    fileprivate func fakeMetaDataRequest(_ locale:String)->PRXProductMetaDataRequest {
        let productInfo = PPRProductObject.fakeProductWith(ctn, serialNumber: serialNum, purchaseDate: Date())
        let metaDataRequest = PRXProductMetaDataRequest(product: productInfo)
//        metaDataRequest.setLocaleMatchResult(locale)
        return metaDataRequest
    }
}
