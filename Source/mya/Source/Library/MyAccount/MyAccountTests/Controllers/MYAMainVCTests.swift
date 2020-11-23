//
//  MYAMainVCTests.swift
//  MyAccount
//
//  Created by leslie on 16/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import AppInfra
@testable import MyAccountDev

class MYAMainVCTests: XCTestCase {
    var mainVC:MYAMainVC!
    var appinfra:AIAppInfra?
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        
        let storyboard = UIStoryboard(name: "MYA", bundle: Bundle(for: MYAMainVC.classForCoder()))
        let viewController = storyboard.instantiateViewController(withIdentifier: "MYAProfile")
        
        if (appinfra == nil) {
            appinfra = AIAppInfra.init(builder: nil)
            let myaDependencies = MYADependencies()
            myaDependencies.appInfra = appinfra
            let _ = MYAData.setup(myaDependencies)
        }
        
        _ = viewController.view
        mainVC = viewController as! MYAMainVC
    }
    
    func testMoveToController(){
        //Test Profile
        var controller =  mainVC.moveToController(at: 0)
        let value = controller?.isKind(of: MYAProfileVC.self)
        if let isProfileViewPresent = value{
            XCTAssertTrue(isProfileViewPresent,"The Presented View is not Profile View")
        }
        // Test Settings
       controller =  mainVC.moveToController(at: 1)
        let isSettingViewPresent = controller?.isKind(of: MYASettingsVC.self)
        if let isSettingViewPresent = isSettingViewPresent{
            XCTAssertTrue(isSettingViewPresent,"The Presented View is not Profile View")
        }
        // Checking Error Condtion
        controller = mainVC.moveToController(at: 3)
        XCTAssertNil(controller,"The Controller is not nil.Some Garbage controller is there")
        
        //Checking Third Tab
        MYAData.shared.additionalTabConfig = MYATabConfig(tabName: "Test Tab", controller: UIViewController())
        mainVC?.viewDidLoad()
        controller =  mainVC?.moveToController(at: 2)
        let isThirdTabPresent = controller?.isKind(of: UIViewController.self)
        if let isThirdTabPresent = isThirdTabPresent{
            XCTAssertTrue(isThirdTabPresent,"The Presented View is not Third Tab")
        }
    }
    
    func testViewDidLoad() {
        mainVC.viewDidLoad()
        XCTAssertEqual(mainVC.title, MYALocalizable(key: "MYA_My_account"))
        XCTAssertEqual(mainVC.selectedIndex, 0)
    }
    
    func testconfigureTabControl() {
        mainVC.configureTabControl()
        XCTAssertNotNil(mainVC.tabControl.delegate)
    }
    
    
}
