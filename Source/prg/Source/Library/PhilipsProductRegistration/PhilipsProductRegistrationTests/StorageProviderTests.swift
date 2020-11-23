//
//  StorageProviderTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PPRStorageProviderTests: PPRBaseClassTests {

    let fileName: String = "Testsing"

    func testStoringString() {
        let object = "Dummy"
        PPRStorageProvider.storeObject(object as? AnyObject, key: PPRStorageProviderConst.kStorageIndex)
        XCTAssertEqual(PPRStorageProvider.fetchObject(PPRStorageProviderConst.kStorageIndex) as? String, object)
        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
    }
    
    func testStoringArray() {
        let object = ["1","2","3"]
        PPRStorageProvider.storeObject(object as? AnyObject, key: PPRStorageProviderConst.kStorageIndex)
        let expected = PPRStorageProvider.fetchObject(PPRStorageProviderConst.kStorageIndex) as! Array<String>
        XCTAssertEqual(expected, object)
        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
    }
    
    func testStoringDict() {
        let object = ["1":"A","2":"B","3":"C"]
        PPRStorageProvider.storeObject(object as? AnyObject, key: PPRStorageProviderConst.kStorageIndex)
        let expected = PPRStorageProvider.fetchObject(PPRStorageProviderConst.kStorageIndex) as! [String:String]
        XCTAssertEqual(expected, object)
        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
    }
    
    func testFetchObjectNoFile() {
        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
        let expected = PPRStorageProvider.fetchObject(PPRStorageProviderConst.kStorageIndex)
        XCTAssertNil(expected)
    }
}
