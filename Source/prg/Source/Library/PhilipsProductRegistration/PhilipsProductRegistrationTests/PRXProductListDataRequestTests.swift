//
//  PRXProductListDataBuilderTest.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient
import PhilipsRegistration

@testable import PhilipsProductRegistrationDev

class PRXProductListDataRequestTests:PPRBaseClassTests {

    var registeredProductListJsonObj: PPRRegisteredProductListJSONObject?
    var productResultDataTests: PRXProductResultDataTests?
    lazy var  user: UserDataInterface = {
        return DIUserMock.sharedInstance
    }()
    
    override func setUp() {
        super.setUp()
        registeredProductListJsonObj = PPRRegisteredProductListJSONObject()
        productResultDataTests = PRXProductResultDataTests()
    }
    
    fileprivate func fakeProductListDataRequest() -> PRXProductListDataRequest{
        let productListDataRequest: PRXProductListDataRequest = PRXProductListDataRequest(user: self.user)
        return productListDataRequest
    }
    
    /*func testProductListBuilderUrl(){
        let productListDataRequest = self.fakeProductListDataRequest()
        productListDataRequest.getRequestUrl(from: self.appInfra, completionHandler: {(serviceURL, countryPrefError) -> Void in
            let headerParam = productListDataRequest.getHeaderParam()
            let param = productListDataRequest.getBodyParameters()
            XCTAssertNotNil(headerParam)
            XCTAssertNil(param)
            XCTAssertTrue(productListDataRequest.getRequestType() == GET)
            
            if let token = try? self.user.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN] as? String{
                XCTAssertEqual(headerParam?[PPRUserAccessToken] as? String, token)
            }
        })
    }
    
    func testProductListBuilderWithNilResponse() {
        let productListDataRequest = self.fakeProductListDataRequest()
        let response: PRXProductListResponse = productListDataRequest.getResponse(nil) as! PRXProductListResponse
        self.verifyParameters(productListDataRequest)
        XCTAssertTrue((response.stat) == nil)
        XCTAssertTrue((response.data) == nil)
    }*/
    
    /*func testProductListBuilderWithEmptyData() {
        let productListDataRequest = self.fakeProductListDataRequest()
        let dict = NSDictionary(dictionary: ["stat" : "ok" , "results": [],"result_count":0])
        let response: PRXProductListResponse = productListDataRequest.getResponse(dict) as! PRXProductListResponse
        let responseData = response.data
        self.verifyParameters(productListDataRequest)
        XCTAssertTrue(response.stat == "ok")
        XCTAssertNil(responseData)
    }*/
    /*
    func testProductListBuilderWithEmptyResponse() {
        let productListDataRequest = self.fakeProductListDataRequest()
        let dict:Dictionary = [:]
        let response: PRXProductListResponse = productListDataRequest.getResponse(dict) as! PRXProductListResponse
        let responseData = response.data
        self.verifyParameters(productListDataRequest)
        XCTAssertNil(response.stat)
        XCTAssertNil(responseData)
    } */

    
    /*func verifyParameters(_ request: PRXProductListDataRequest) {
        let productListRequest = request
        let headerParam = productListRequest.getHeaderParam()
        let param = productListRequest.getBodyParameters()
        XCTAssertNotNil(headerParam)
        XCTAssertNil(param)
        XCTAssertTrue(productListRequest.getRequestType() == GET)
        XCTAssertEqual(headerParam?[PPRUserAccessToken] as? String, try? self.user.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN] as? String)
    }

    
    func testProductListBuilderWithValidResponse() {
        let listDataBuilder = self.fakeProductListDataRequest()
        let dict = registeredProductListJsonObj!.fakeRegisteredProductList()
        let response: PRXProductListResponse = listDataBuilder.getResponse(dict) as! PRXProductListResponse
        let responseData = response.data
        XCTAssertTrue(response.stat == "ok")
        XCTAssertTrue(responseData != nil)
        productResultDataTests?.verifyValidData(responseData![0])
    }*/
}
