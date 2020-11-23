/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework
@testable import AppInfra

class CTNUtilitiesTest: XCTestCase {

    func testGetDefaultCTNs(){
        assert(forCountry: "NL", expectCtns: ["HX6064/33"])
    }

    func testGetCTNsForUS(){
        assert(forCountry: "US",
               expectCtns: [
                "HD8645/47",
                "HD9980/20",
                "HX8918/10",
                "HD9240/94",
                "SCF782/10",
                "HX8332/11",
                "SCF251/03",
                "DIS359/03",
                "DIS362/03",
                "CA6702/00",
                "CA6700/47",
                "SCD393/03",
                "BRE394/60",
                "DIS363/03",
                "DIS364/03"])
    }

    func testGetCTNsForIndia(){
        assert(forCountry: "IN", expectCtns: ["HX6311/07"])
    }

    func testGetCTNsForHK(){
        assert(forCountry: "HK", expectCtns: ["HX6322/04"])
    }

    func testGetCTNsForMO(){
        assert(forCountry: "MO", expectCtns: ["HX6322/04"])
    }

    func testGetCTNsForCN(){
        // Currently separately hardcoded in Configure.plist
        assert(forCountry: "CN", expectCtns: ["HX6721/33"])
    }

    func assert(forCountry homeCountryCode: String, expectCtns expectedCTNs: [String]) {
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.setHomeCountry(homeCountryCode)
        let ctns = CTNUtilities.getProductCTNsForHomeCountry()
        XCTAssertEqual(ctns!, expectedCTNs)
    }
}
