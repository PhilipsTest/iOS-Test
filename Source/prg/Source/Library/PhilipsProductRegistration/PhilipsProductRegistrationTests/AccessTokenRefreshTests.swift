//
//  AccessRefreshTokenTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsRegistration

@testable import PhilipsProductRegistrationDev

class AccessTokenRefreshTests: XCTestCase {
    
    func testRefreshFailed() {
        let accessTokenRefresh = AccessTokenRefresh()
        let userInterfaceMock = UserDataInterfaceMock()
        userInterfaceMock.isUserLogged = true
        userInterfaceMock.isAccessTokenRefreshed = false
 
        let expect = self.expectation(description: "RefreshToken")
        accessTokenRefresh.refresh(user: userInterfaceMock) { (success) in
            XCTAssertFalse(success)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: PPRTestConstants.Timeout, handler: nil)
    }
    
    func testRefreshSuccess() {
        let accessTokenRefresh = AccessTokenRefresh()
        let userD = UserDataInterfaceMock()
        userD.isAccessTokenRefreshed = true
        userD.isUserLogged = true
        let expect = self.expectation(description: "RefreshToken")
        accessTokenRefresh.refresh(user: userD) { (success) in
            XCTAssertTrue(success)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: PPRTestConstants.Timeout, handler: nil)
    }
    
    func testRefreshWithUserNotLoggedIn() {
        let accessTokenRefresh = AccessTokenRefresh()
        let userD = UserDataInterfaceMock()
        userD.isAccessTokenRefreshed = true
        userD.isUserLogged = false
        let expect = self.expectation(description: "RefreshToken")
        accessTokenRefresh.refresh(user: userD) { (success) in
            XCTAssertFalse(success)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: PPRTestConstants.Timeout, handler: nil)
    }
}
