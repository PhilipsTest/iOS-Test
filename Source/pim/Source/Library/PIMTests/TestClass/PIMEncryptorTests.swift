//
//  PIMEncryptorTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/14/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev

class PIMEncryptorTests: XCTestCase {
    
    var pimEncryptor: PIMAESEncryptor!
    let key = PIMDefaults.userSubUUIDKey + ".UserProfile.."
    
    override func setUp() {
        super.setUp()
        do {
            pimEncryptor = try PIMAESEncryptor(keyString: key)
        } catch {}
    }

    override func tearDown() {
        super.tearDown()
    }

    func testObjectInitializationSuccess() {
        XCTAssertNotNil(pimEncryptor)
    }

    func testEncryptData() {
        do {
            let rawData = Data("rawdatainput".utf8)
            let encryptedData = try pimEncryptor.encrypt(rawData)
            XCTAssertNotNil(encryptedData)
        } catch {}
    }
    
    func testDecryptData() {
        do {
            let rawData = Data("rawdatainput".utf8)
            let encryptedData = try pimEncryptor.encrypt(rawData)
            let decryptedData = try pimEncryptor.decrypt(encryptedData)
            XCTAssertEqual(rawData, decryptedData)
        } catch {}
    }

}
