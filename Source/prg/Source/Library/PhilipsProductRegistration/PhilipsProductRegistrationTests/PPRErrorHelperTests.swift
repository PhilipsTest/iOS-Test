//
//  PPRErrorHelperTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PPRErrorHelperTests: XCTestCase {
    
    var errorHelper: PPRErrorHelper?
    let timeOut: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        self.errorHelper = PPRErrorHelper()
    }
    
    func testCreateCustomError() {
        let error = self.errorHelper?.createCustomError(domain: "Custom error", code: 1000, userInfo: Dictionary())
        XCTAssertTrue(error?.code == 1000)
        XCTAssertEqual(error?.domain,"Custom error")
        XCTAssert(error?.userInfo.isEmpty == true)
    }
    
    func testCreateCustomErrorWithPPRError() {
        let expectedError = PPRError.PARAMETER_INVALID
        let actualError = self.errorHelper?.createCustomError(error: expectedError)
        self.verifyError(actualError!, expectedError: expectedError)
    }
    
    func testHandleErrorWithParameterInvalid() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 400,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.PARAMETER_INVALID)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithAccessTokenExpired() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 403,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.ACCESS_TOKEN_INVALID)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithInvalidSerialNumber() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 505,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INVALID_SERIAL_NUMBER)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithInvalidAccessToken() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.ACCESS_TOKEN_INVALID.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.ACCESS_TOKEN_INVALID)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithInvalidProduct() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.CTN_NOT_EXIST.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.CTN_NOT_EXIST)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithInvalidation() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.INPUT_VALIDATION_FAILED.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INPUT_VALIDATION_FAILED)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithNoInternet() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.NO_INTERNET_CONNECTION.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.NO_INTERNET_CONNECTION)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithRquestTimeout() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.REQUEST_TIME_OUT.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.REQUEST_TIME_OUT)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithPurchasedateRequired() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.REQUIRED_PURCHASE_DATE.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.REQUIRED_PURCHASE_DATE)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithUserNotLoggedIn() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.USER_NOT_LOGGED_IN.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.USER_NOT_LOGGED_IN)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithSerailNumAndPurchaseRequired() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithCTNNotEntered() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.CTN_NOT_ENTERED.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.CTN_NOT_ENTERED)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithProductAlredyRegistered() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.PRODUCT_ALREADY_REGISTERD.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.PRODUCT_ALREADY_REGISTERD)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithInvalidPurchasedate() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: PPRError.INVALID_PURCHASE_DATE.rawValue,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INVALID_PURCHASE_DATE)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }

    func testHandleErrorWithUnknown() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 1000,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.UNKNOWN)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorWithNegitiveErrorCode() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: -1000,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.UNKNOWN)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorInternalServerError() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 500,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INTERNAL_SERVER_ERROR)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testHandleErrorInvalidInputError() {
        let expect = self.expectation(description: "HandleError")
        self.errorHelper?.handleError(statusCode: 422,failure: { (error) in
            self.verifyError(error!, expectedError: PPRError.INPUT_VALIDATION_FAILED)
            expect.fulfill()
        })
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    fileprivate func verifyError(_ actualError: NSError, expectedError: PPRError) {
        XCTAssertTrue(actualError.code == expectedError.rawValue)
        XCTAssertEqual(actualError.domain, expectedError.domain)
        XCTAssertEqual(actualError.userInfo["PPRError"] as? String, expectedError.domain)
    }
}
