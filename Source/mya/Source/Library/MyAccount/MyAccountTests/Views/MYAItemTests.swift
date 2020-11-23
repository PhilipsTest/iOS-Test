//
//  MYAItemTests.swift
//  MyAccountTests
//
//  Created by leslie on 16/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import MyAccountDev

class MYAItemTests: XCTestCase {
    
   func testInitWithTitle() {
        let item = MYAItem(title: "test")
        XCTAssertEqual(item.title, "test")
        XCTAssertEqual(item.description, "test")
    }
    
    func testInitWithTitleValue() {
        let item = MYAItem(title: "test", value: "value")
        XCTAssertEqual(item.title, "test")
        XCTAssertEqual(item.value, "value")
    }
    
    func testInitWithDictionary() {
        let items = MYAItem.items(withDictionary: ["test":"value"])
        XCTAssertEqual(items[0].title, "test")
        XCTAssertEqual(items[0].value, "value")
    }
}
