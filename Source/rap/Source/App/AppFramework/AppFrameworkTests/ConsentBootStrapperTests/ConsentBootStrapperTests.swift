/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import AppFramework

class ConsentBootStrapperTests: XCTestCase {
    
    func testConsentDefinitionCreations() {
        let consentBootStrapper = ConsentBootstrapper.sharedInstance
        XCTAssertNotEqual(consentBootStrapper.consentDefinitions.count, 0)
    }
}
