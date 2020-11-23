/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework
@testable import PhilipsUIKitDLS

class HomeViewControllerTests: XCTestCase {
    var homeViewController = AppframeworkHomeViewController()
    var popoverContent = PopAlertViewController()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: Constants.HOME_STORYBOARD_NAME, bundle: nil)
        homeViewController = (storyboard.instantiateViewController(withIdentifier: Constants.HOME_VIEWCONTROLLER_STORYBOARD_ID) as? AppframeworkHomeViewController)!
        homeViewController.loadView()
    }
    
     func testCheckForNil(){
        XCTAssertNotNil(homeViewController)
    }
}
