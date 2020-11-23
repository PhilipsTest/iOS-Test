//
//  PIMMigrationRequestTest.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/13/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev

class PIMMigrationRequestTest: XCTestCase {
    
    let accessToken: String = "12345"
    let url: String = "https://abc.com/migration"
    var pimMigrationRequest: PIMMigrationRequest!
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        pimMigrationRequest = PIMMigrationRequest(withAccessToken: accessToken, url: url)
    }

    override func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
        pimMigrationRequest = nil
    }
    
    func testObjectInitilization() {
        XCTAssertNotNil(pimMigrationRequest)
    }

    func testGetURL() {
        XCTAssertNotNil(pimMigrationRequest.getURL())
    }

    func testMethodType() {
        XCTAssertEqual(pimMigrationRequest.getMethodType(), PIMMethodType.POST.rawValue)
    }
    
    func testGetHeaderContent() {
        var headerDictExpected:[String:String] = [:]
        headerDictExpected["Content-Type"] = "application/json"
        headerDictExpected["Accept"] = "application/json"
        headerDictExpected["Api-Key"] = "durhrkq6ezqcvmqf6mq77ev48fuubdbj"
        headerDictExpected["Api-Version"] = "1";
        
        let headerDictReceived = pimMigrationRequest.getHeaderContent()!
        XCTAssertNotNil(headerDictReceived)
        XCTAssertEqual(headerDictReceived, headerDictExpected)
    }
    
    func testGetBodyContent() {
        let bodyContent = pimMigrationRequest.getBodyContent()
        XCTAssertNotNil(bodyContent)
        
        let bodyContentReceived = String(decoding: bodyContent!, as: UTF8.self)
        let expectedContent = "{\"data\": {\"accessToken\":\"\(accessToken)\"}}"
        XCTAssertEqual(bodyContentReceived, expectedContent)
    }

}
