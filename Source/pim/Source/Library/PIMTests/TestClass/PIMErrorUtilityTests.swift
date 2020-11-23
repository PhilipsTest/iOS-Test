//
//  PIMErrorUtilityTests.swift
//  PIMTests
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder
//

import XCTest
@testable import PIMDev
@testable import AppInfra
@testable import AppAuth


class PIMErrorUtilityTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBuildAuthErrorMethod() {
        let aError = NSError(domain: "", code:OIDErrorCode.networkError.rawValue, userInfo:[NSLocalizedDescriptionKey:""])
        let returnedError = PIMErrorBuilder.buildAuthStateError(fromError:aError)
        
        XCTAssert(returnedError.code == PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue)
        XCTAssert(returnedError.localizedDescription == "PIM_Error_Msg".localiseString(args: PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue))
    }
    
    func testUserNotLoggedinError() {
        let inError = PIMErrorBuilder.buildUserNotLoggedInError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.Janrain")
        XCTAssertTrue(inError.code == PIMMappedError.PIMUserNotLoggedIn.rawValue)
    }
    
    func testUDIUserNotLoggedinError() {
        let inError = PIMErrorBuilder.buildUDIUserNotLoggedInError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.NoUserError")
        XCTAssertTrue(inError.code == PIMMappedError.PIMUserNotLoggedIn.rawValue)
    }
    
   func testBuildPIMMigrationError() {
        let inError = PIMErrorBuilder.buildPIMMigrationError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.Migration.RedirectionFailed")
        XCTAssertTrue(inError.code == PIMMappedError.PIMMigrationFailedError.rawValue)
    }
    
   func testBuildPIMmarketingoptinError() {
        let inError = PIMErrorBuilder.buildPIMMarketingOptinError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.UpdateMarketingOptinFailed")
        XCTAssertTrue(inError.code == PIMMappedError.PIMMarketingOptinError.rawValue)
    }
    
    
    func testBuildJRRefreshTokenError() {
        let inError = PIMErrorBuilder.buildJRRefreshTokenError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.JRRefreshTokenFailed")
        XCTAssertTrue(inError.code == PIMMappedError.PIMRefreshTokenFailed.rawValue)
    }
    
    func testBuildRedirectionError() {
        let inError = PIMErrorBuilder.buildRedirectionError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.Login.RedirectionFailed")
        XCTAssertTrue(inError.code == PIMMappedError.PIMNoRequestForRedirection.rawValue)
    }
    
    func testbuildRedirectionURLError() {
        let inError = PIMErrorBuilder.buildRedirectionURLError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.Login.RedirectionFailed")
        XCTAssertTrue(inError.code == PIMMappedError.PIMInvalidRedirectionURL.rawValue)
    }
    
    func testBuildInvalidRefreshTokenError() {
        let inError = PIMErrorBuilder.buildInvalidRefreshTokenError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.Migration.InvalidOrNoJRToken")
        XCTAssertTrue(inError.code == PIMMappedError.PIMInvalidRefreshToken.rawValue)
    }
    
    func testNoSDURLError() {
        let inError = PIMErrorBuilder.getNoSDURLError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.ServiceDiscoveryURLNotPresent")
        XCTAssertTrue(inError.code == PIMMappedError.PIMSDDownloadError.rawValue)
    }
    
    func testBuildNetworkError() {
        let inError = PIMErrorBuilder.buidNetworkError(httpCode: -1001)
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.NetworkError")
        XCTAssertTrue(inError.code == -1001)
    }
    
    func testGetOIDCDownloadError() {
        let inError = PIMErrorBuilder.getOIDCDownloadError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.ConfigDownloadError")
        XCTAssertTrue(inError.code == PIMMappedError.PIMOIDCDownloadError.rawValue)
    }
    
    func testBuildDiscoveryError() {
        let inError = PIMErrorBuilder.buildDiscoveryError()
        XCTAssertNotNil(inError)
        XCTAssertTrue(inError.domain == "com.PIM.OIDDiscoveryError")
        XCTAssertTrue(inError.code == PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue)
    }

}
