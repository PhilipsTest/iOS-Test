//
//  PIMMigrationAuthRequestTest.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/13/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev

class PIMMigrationAuthRequestTest: XCTestCase {

    let url: String = "https://abc.com/migrationauth"
    var pimMigrationAuthRequest: PIMMigrationAuthRequest!
    
    override func setUp() {
        super.setUp()
        pimMigrationAuthRequest = PIMMigrationAuthRequest(url: URL(string: url)!)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testObjectInitilization() {
        XCTAssertNotNil(pimMigrationAuthRequest)
    }
    
    func testGetURL() {
        XCTAssertNotNil(pimMigrationAuthRequest.getURL())
    }

    func testMethodType() {
        XCTAssertEqual(pimMigrationAuthRequest.getMethodType(), PIMMethodType.GET.rawValue)
    }
    
    func testGetHeaderContent() {
        var headerDictExpected:[String:String] = [:]
        headerDictExpected["Content-Type"] = "application/x-www-form-urlencoded"
        
        let headerDictReceived = pimMigrationAuthRequest.getHeaderContent()!
        XCTAssertNotNil(headerDictReceived)
        XCTAssertEqual(headerDictReceived, headerDictExpected)
    }
    
    func testGetBodyContent() {
        let bodyContent = pimMigrationAuthRequest.getBodyContent()
        XCTAssertNil(bodyContent)
    }

}
