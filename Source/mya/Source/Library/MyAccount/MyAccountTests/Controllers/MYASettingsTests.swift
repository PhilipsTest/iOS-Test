//
//  SettingsTests.swift
//  MyAccountTests
//
//  Created by leslie on 08/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsUIKitDLS
import AppInfra
@testable import MyAccountDev

class MYASettingsTests: XCTestCase {
    var settingsVC:MYASettingsVC?
    var appinfra:AIAppInfra?
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: UIDTheme(), applyNavigationBarStyling: true)
        let storyboard = UIStoryboard(name: "MYA", bundle: Bundle(for: MYASettingsVC.classForCoder()))
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        
        
        if (appinfra == nil) {
            appinfra = AIAppInfra.init(builder: nil)
            let myaDependencies = MYADependencies()
            myaDependencies.appInfra = appinfra
            let _ = MYAData.setup(myaDependencies)
        }
        _ = viewController.view
        
        settingsVC = viewController as? MYASettingsVC
        var settingsItems = [String]()
        if let dynamicProfileItems = try? MYAData.shared.config(forKey: "settings.menuItems") as! [String] {
            settingsItems = dynamicProfileItems
        }
        else {
            settingsItems = ["MYA_Country"]
        }
        settingsVC?.settingsItems = settingsItems
    }
    
    func testTableViewData() {
        guard let settings = settingsVC else {
            XCTAssert(false, "settings is nil")
            return
        }
        
        let no = settings.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(no, settings.settingsItems.count)
        
        for index in 0..<settings.settingsItems.count {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = settings.tableView((settingsVC?.tableView)!, cellForRowAt: indexPath) as! MYASettingsCell
            XCTAssertEqual(MYALocalizable(key: settings.settingsItems[indexPath.row]), cell.titleLabel.text)
        }
        
        let view = settingsVC?.tableView((settingsVC?.tableView)!, viewForHeaderInSection: 0)
        XCTAssertNotNil(view)
    }
    
    func testdidSelectRow() {
        let vc = MYASettingsVCTest()
        let delegate = DelegateMock()
        MYAData.shared.delegate = delegate
        vc.settingsItems = ["test1","test2","MYA_Country"]
        vc.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(delegate.settingsDelegateCalled)
        
        vc.tableView(UITableView(), didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertFalse(delegate.settingsDelegateCalled)
        
        vc.tableView(UITableView(), didSelectRowAt: IndexPath(row: 2, section: 0))
        XCTAssertFalse(vc.displayLogoutCalled)
        
    }
    
    func testlogout() {
        let vc = MYASettingsVCTest()
        vc.logout(AnyObject.self)
        XCTAssertTrue(vc.displayLogoutCalled)
    }
    
    func testdisplayLogout() {
        let vc = MYASettingsVCTest()
        vc.displayLogout(withTitle: "test", withMessage: "message")
        XCTAssertTrue(vc.alertPresented)
        if let alert = vc.alert {
            XCTAssertEqual(alert.title, "test")
            XCTAssertEqual(alert.message, "message")
        }
    }
    
    
    func testvalueForSettingsItem() {
        let vc = MYASettingsVCTest()
        let delegate = DelegateMock()
        MYAData.shared.delegate = delegate
        let country = MYAData.shared.dependency.appInfra.serviceDiscovery.getHomeCountry()
        XCTAssertEqual(country, vc.valueForSettingsItem(key: "MYA_Country"))
        
        XCTAssertNil(vc.valueForSettingsItem(key: "inv"))
    }
}

class MYASettingsVCTest: MYASettingsVC {
    var displayLogoutCalled = false
    var alertPresented = false
    var alert:UIDAlertController?
    override func displayLogout(withTitle title: String, withMessage message: String) {
        displayLogoutCalled = true
        super.displayLogout(withTitle: title, withMessage: message)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        alertPresented = true
        alert = viewControllerToPresent as? UIDAlertController
    }
}


