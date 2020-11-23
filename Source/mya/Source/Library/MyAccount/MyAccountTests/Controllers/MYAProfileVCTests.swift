//
//  ProfileVCTests.swift
//  MyAccountTests
//
//  Created by leslie on 13/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsUIKitDLS
import AppInfra
import PlatformInterfaces
@testable import MyAccountDev

class MYAProfileVCTests: XCTestCase {
    
    var profileVC : MYAProfileVC?
    var appinfra:AIAppInfra?
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: UIDTheme(), applyNavigationBarStyling: true)
        let storyboard = UIStoryboard(name: "MYA", bundle: Bundle(for: MYAProfileVC.classForCoder()))
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? MYAProfileVC
        
        if (appinfra == nil) {
            appinfra = AIAppInfra.init(builder: nil)
            let myaDependencies = MYADependencies()
            myaDependencies.appInfra = appinfra
            let _ = MYAData.setup(myaDependencies)
        }
        MYAData.shared.profileMenuList = ["item1","item2","item3","item4","MYA_My_details"]
        _ = viewController?.view
        profileVC = viewController
    }
    
    func testTableViewData() {

        guard let profile = profileVC else {
            XCTAssert(false, "view controller is nil")
            return
        }
        guard let tableView = profile.tableView else {
            XCTAssert(false, "table view is nil")
            return
        }
        
        let no = profile.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(no, 5)
        
        
        let viewSectionName = profile.tableView(tableView, viewForHeaderInSection: 0)
        if let subviews = viewSectionName?.subviews {
            for view in subviews {
                let label = view as? UIDLabel
                var userInformation : Dictionary<String, AnyObject>?
                do {
                    userInformation = try MYAData.shared.userProvider?.userDetails([UserDetailConstants.GIVEN_NAME])
                } catch {
                    MYAData.shared.logger.log(.error, eventId:"MYAProfileVC" , message: error.localizedDescription)
                }
                if let userinfo = userInformation {
                    if let userName = userinfo[UserDetailConstants.GIVEN_NAME] as? String {
                        XCTAssertEqual(label?.text!,userName)
                    }
                }
            }
        }
        
        for index in 0..<no {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = profile.tableView(tableView, cellForRowAt: indexPath) as! MYAProfileCell
            XCTAssertEqual(cell.titleLabel.text, MYALocalizable(key: MYAData.shared.profileMenuList![index]))
        }
    }
    
    func testdidSelectRow() {
        let vc = MYAProfileVC()
        let delegate = DelegateMock()
        MYAData.shared.delegate = delegate
        vc.profileItems = ["test1","test2"]
        vc.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(delegate.ProfileDelegatesCalled)
        
        vc.tableView(UITableView(), didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertFalse(delegate.ProfileDelegatesCalled)
    }
}
