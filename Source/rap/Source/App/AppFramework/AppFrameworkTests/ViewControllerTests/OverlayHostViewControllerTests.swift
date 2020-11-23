/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class OverlayHostViewControllerTests: XCTestCase {

    func testFactoryMethodReturnsNilWhenNoViewControllerIsProvided() {
        XCTAssertNil(OverlayHostViewController.wrap(nestedViewController: nil, overlayStoryBoardID: Overlays.SHOP))
    }

    func testFactoryMethodProvidesWrappedViewController() {
        let testVC = UIViewController()
        let testId = "TEST_VIEW"
        testVC.view.restorationIdentifier = testId

        let overlayHostViewController = OverlayHostViewController.wrap(nestedViewController: testVC, overlayStoryBoardID: Overlays.SHOP)
        overlayHostViewController?.loadViewIfNeeded()

        XCTAssertTrue((overlayHostViewController?.view.subviews.contains { view in view.restorationIdentifier == testId })!)
    }

}
