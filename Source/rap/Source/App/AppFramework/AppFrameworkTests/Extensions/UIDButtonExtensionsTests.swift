/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsUIKitDLS

@testable import AppFramework

class UIDButtonExtensionsTests: XCTestCase {

    func testLocalizedTitlePropertySetsNormalTitle() {
        let button = UIDButton()
        let testKey = "test"

        button.localizedTitle = testKey

        XCTAssertEqual(button.title(for: .normal), testKey)
        XCTAssertEqual(button.localizedTitle, testKey)
    }
}
