/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class OverlayViewControllerTests: XCTestCase {

    var overlayViewController: OverlayViewController! = nil
    var overlayDelegate: TestOverlayDelegate! = nil
    let storyboard = UIStoryboard(name: Overlays.STORYBOARD, bundle: nil)

    override func setUp() {
        super.setUp()
        overlayViewController = storyboard.instantiateViewController(withIdentifier: Overlays.SHOP) as! OverlayViewController
        overlayDelegate = TestOverlayDelegate()
        overlayViewController.delegate = overlayDelegate
        overlayViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        overlayViewController = nil
        overlayDelegate = nil
        super.tearDown()
    }

    func testDismissIsPropagatedToDelegate() {
        overlayViewController.dismissOverlay()
        XCTAssertTrue(overlayDelegate.dismissWasCalled)
    }
}

class TestOverlayDelegate: OverlayDelegate {

    private(set) var dismissWasCalled = false

    func dismissOverlay() {
        dismissWasCalled = true;
    }
}
