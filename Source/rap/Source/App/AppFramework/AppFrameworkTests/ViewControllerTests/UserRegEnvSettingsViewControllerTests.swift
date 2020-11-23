/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class UserRegEnvSettingsViewControllerTests: XCTestCase {
    var userRegEnvSettingsViewController = UserRegEnvSettingsViewController()
    
    func testCreatetableView(){
        userRegEnvSettingsViewController.createtableView()

        XCTAssertNotNil(userRegEnvSettingsViewController.tableViewItems.count)
        XCTAssertNotNil(userRegEnvSettingsViewController.view)
    }
}
