//
//  PPRProductListResponseTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PPRProductListResponseTests: XCTestCase {

     func testWithEmptyObject() {
        let response = PPRProductListResponse(data:[])
        XCTAssertTrue(response.success)
        XCTAssertTrue(response.data.isEmpty)
    }
    
    func testWithEmptyResponse() {
        let response = PPRProductListResponse.productListResponseFrom(prxResponse: PRXProductListResponse(), userUUID: nil)
        XCTAssertFalse(response.success)
        XCTAssertNotNil(response.data)
    }
    
    /* testWithArrayValues() {
        let prxListResponse = self.getPRXResponse()
        let response = PPRProductListResponse.productListResponseFrom(prxResponse: prxListResponse, userUUID: nil)
        XCTAssertTrue(response.success)
        XCTAssertNotNil(response.data)
        XCTAssertTrue(response.data?.count == 2)
    }*/
    
    fileprivate func getPRXResponse() -> PRXProductListResponse {
        let dict = PPRRegisteredProductListJSONObject().fakeRegisteredProductList()
        return PRXProductListResponse(withDictonary: dict)!
    }
}
