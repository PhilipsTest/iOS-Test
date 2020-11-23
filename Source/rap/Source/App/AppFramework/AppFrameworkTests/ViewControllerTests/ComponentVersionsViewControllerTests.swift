/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework
import PhilipsUIKitDLS

class ComponentVersionsViewControllerTests: XCTestCase {
    
    var componentVersionsViewController: ComponentVersionsViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: Constants.COMPONENTVERSION_STORYBOARD_NAME, bundle: nil)
        componentVersionsViewController = (storyboard.instantiateViewController(withIdentifier: Constants.COMPONENT_VIEWCONTROLLER_STORYBOARD_ID) as? ComponentVersionsViewController)!
        componentVersionsViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        componentVersionsViewController = nil
        super.tearDown()
    }
    
    func testNumberOfSectionsInTableViewDelegate(){
        XCTAssertEqual(componentVersionsViewController.numberOfSections(in: componentVersionsViewController.tableView), 1)
    }
    
    func testHeaderForSectionContainsTitle() {
        let sectionHeaderView = componentVersionsViewController.tableView(componentVersionsViewController.tableView, viewForHeaderInSection: 0) as! SectionHeaderView
        XCTAssertFalse((sectionHeaderView.headerLabel.text?.isEmpty)!)
    }

    func testToggleSingleItemUpdatesNumberOfRowsInSection() {
        let unexpandedCount = componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0)

        // tapping once
        componentVersionsViewController.tableView(componentVersionsViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0), unexpandedCount + 1)

        // tapping twice
        componentVersionsViewController.tableView(componentVersionsViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0), unexpandedCount)
    }

    func testOnlyOneExpandedItemIsAllowed() {
        let unexpandedCount = componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(getComponentNameAtRow(1), "InAppPurchase")

        // expand first component
        componentVersionsViewController.tableView(componentVersionsViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0), unexpandedCount + 1)

        XCTAssertNotEqual(getComponentNameAtRow(1), "InAppPurchase")

        // expand second component
        componentVersionsViewController.tableView(componentVersionsViewController.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))
        XCTAssertEqual(componentVersionsViewController.tableView(componentVersionsViewController.tableView, numberOfRowsInSection: 0), unexpandedCount + 1)

        XCTAssertEqual(getComponentNameAtRow(1), "InAppPurchase")
    }

    func getComponentNameAtRow(_ row: Int) -> String? {
        let cell = componentVersionsViewController.tableView(componentVersionsViewController.tableView, cellForRowAt: IndexPath(row: row, section: 0)) as! ComponentVersionsCustomTableViewCell
        return cell.componentVersionsTitleLabel?.text?.components(separatedBy: " - ").first
    }
}
