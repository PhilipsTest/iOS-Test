//
//  MYAErrorTests.swift
//  MyAccountTests
//
//  Created by leslie on 20/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import MyAccountDev

class MYAErrorTests: XCTestCase {
    
   func testMYAError() {
        XCTAssertEqual(MYAError.userNotLoggedIn.rawValue , 1001)
        XCTAssertEqual(MYAError.userNotLoggedIn.error().code, 1001)
    }
}
