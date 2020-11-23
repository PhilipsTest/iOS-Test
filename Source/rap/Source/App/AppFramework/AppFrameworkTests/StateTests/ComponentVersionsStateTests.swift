/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class ComponentVersionsStateTests: XCTestCase {

    var componentVersionsState: ComponentVersionsState!

    override func setUp() {
        componentVersionsState = ComponentVersionsState()
        super.setUp()
    }

    override func tearDown() {
        componentVersionsState = nil
        super.tearDown()
    }

    func testProvidesValidViewController() {
        XCTAssertNotNil(componentVersionsState.getViewController())
    }

    func testIdentifiesAsCorrectState() {
        XCTAssertEqual(componentVersionsState.stateId, AppStates.ComponentVersions)
    }
}
