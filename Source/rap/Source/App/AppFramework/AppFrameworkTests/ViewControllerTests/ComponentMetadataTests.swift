/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class ComponentMetadataTests: XCTestCase {

    func testFormattedNameAndVersion() {
        let componentData = ComponentMetadata(name: "ComponentName", version: "1.0.0", description: "Component Description")
        XCTAssertEqual(componentData.formattedNameAndVersion() , "ComponentName - 1.0.0")
    }

    func testUnknownVersion() {
        let componentData = ComponentMetadata(name: "ComponentName", version: nil, description: "Component Description")
        XCTAssertEqual(componentData.formattedNameAndVersion() , "ComponentName - Not Available")
    }

    func testDescription() {
        let componentData = ComponentMetadata(name: "ComponentName", version: nil, description: "Component Description")
        XCTAssertEqual(componentData.description , "Component Description")
    }
}
