//
//  PIMConfigManagerTest.swift
//  PIMTests
//
//  Created by Philips on 4/2/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppInfra

class PIMConfigManagerTest: XCTestCase {
    var appInfra : AIAppInfra?
    var configManager:PIMConfigManager?

    override func setUp() {
        Bundle.loadSwizzler()
        appInfra = AIAppInfra(builder: nil)
        appInfra?.serviceDiscovery = PIMServiceDiscoveryMock()
//        configManager = PIMConfigManager((appInfra?.serviceDiscovery)!, PIMUserManager(appInfra!))
    }

    override func tearDown() {
        Bundle.deSwizzle()
    }

//    func testConfigManagerInit() {
//        XCTAssertNotNil(configManager,"Config Manager Not initialises")
//    }
//
//    func testDownloadServiceDiscoveryPass() {
//        configManager?.downloadSDServiceUrl(appInfra?.serviceDiscovery!,"userreg.janrainoidc.issuer")
//        XCTAssertTrue(PIMTestHelper.sharedInstance.testBool!)
//    }
//
//    func testDownloadServiceDiscoveryFailure() {
//        configManager?.downloadSDServiceUrl(appInfra?.serviceDiscovery!,"userreg.janrainoidc")
//        XCTAssertFalse(PIMTestHelper.sharedInstance.testBool!)
//    }

}
