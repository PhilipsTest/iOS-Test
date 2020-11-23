/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
import Foundation
@testable import MobileEcommerceDev

class Tagging: MECAnalyticsTracking  {
    
}

class TaggingHelperTests: XCTestCase {

    var sut: Tagging?
    var taggingMock: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        
        let mockAppInfra = MockAppInfra()
        mockAppInfra.logging = MECMockLogger()
        
        taggingMock = MECMockTagger()
        let mockServiceDiscvoovery = ServiceDiscoveryMock()
        mockAppInfra.appIdentity = MockAppIdentity()
        mockAppInfra.internationalization = MockInternationalization()
        mockAppInfra.serviceDiscovery = mockServiceDiscvoovery

        MECConfiguration.shared.sharedAppInfra = mockAppInfra
        MECConfiguration.shared.mecTagging = taggingMock
        
        sut = Tagging()
        
    }

    override func tearDown() {
        MECConfiguration.shared.sharedAppInfra = nil
        super.tearDown()
    }

    func testTrackExitLink() {
        sut?.trackExitLink(exitURL: URL(string: "www.test.com")!)
        XCTAssertEqual(taggingMock?.inActionName, "sendData")
        XCTAssert((taggingMock?.inParamDict?["exitLinkName"] as? String) == "www.test.com?origin=15_global_Test_TestApp-app_TestApp-app")
    }
    
    func testTrackExitLinkWithQueryItemInURL() {
        sut?.trackExitLink(exitURL: URL(string: "www.test.com?test")!)
        XCTAssertEqual(taggingMock?.inActionName, "sendData")
        XCTAssert((taggingMock?.inParamDict?["exitLinkName"] as? String) == "www.test.com?test&origin=15_global_Test_TestApp-app_TestApp-app")
    }
    
    func testTrackAction() {
        sut?.trackAction(parameterData: [:], action: "testAction")
        XCTAssertEqual(taggingMock?.inActionName, "testAction")
    }
    
    func testTrackPage() {
        sut?.trackPage(pageName: "testPage")
        XCTAssertEqual(taggingMock?.inPageName, "testPage")
    }
}
