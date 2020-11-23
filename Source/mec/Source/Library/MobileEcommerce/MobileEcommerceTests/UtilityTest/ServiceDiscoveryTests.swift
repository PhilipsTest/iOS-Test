/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import XCTest
@testable import MobileEcommerceDev

class ServiceDiscoveryTests: XCTestCase {

    var sut: MECServiceDiscoveryUtility?
    var mockServiceDiscovery: ServiceDiscoveryMock?
    
    override func setUp() {
        super.setUp()
            
        sut = MECServiceDiscoveryUtility()
        let mockAppInfra = MockAppInfra()
        mockAppInfra.logging = MECMockLogger()
        mockAppInfra.tagging = MECMockTagger()
        mockServiceDiscovery = ServiceDiscoveryMock()
        
        mockAppInfra.serviceDiscovery = mockServiceDiscovery
        MECConfiguration.shared.sharedAppInfra = mockAppInfra
    }

    override func tearDown() {
        MECConfiguration.shared.sharedAppInfra = nil
        super.tearDown()
        
    }

    func testgetMECServiceURL() {
        
        mockServiceDiscovery?.serviceURL = "test.com"
        
        let expectation = self.expectation(description: "testgetMECServiceURL")
        sut?.getMECServiceURL(serviceKey: "baseurl", completionHandler: { (serviceURL, error) in
            
            XCTAssertEqual(serviceURL, "test.com")
            XCTAssertNil(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
  
}
