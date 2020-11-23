//
//  InAppPurchaseStateTests.swift
//  AppFramework
//
//  Created by Philips on 1/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import InAppPurchase
import AppInfra

@testable import PhilipsRegistration
@testable import AppFramework

class InAppPurchaseStateTests: XCTestCase {
    
    var inAppPurchaseStateObj:InAppPurchaseState!
    private var mock: IAPInterfaceMock!
    private var mockDependency:IAPDependencies = IAPDependencies()

    override func setUp() {
        super.setUp()
        DIUserMock.sharedInstance.swizzleDIUserInstance()
        inAppPurchaseStateObj = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.InAppPurchase) as! InAppPurchaseState
        mockDependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        mockDependency.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        self.mock = IAPInterfaceMock(dependencies: mockDependency, andSettings: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        DIUserMock.sharedInstance.deswizzleDIUserInstance()
        UserDefaults.standard.set(0, forKey: Constants.BADGE_COUNT)
        UserDefaults.standard.synchronize()
    }
    
    func testSetupIAPHandler() {
        XCTAssertNotNil(InAppPurchaseState.inAppPurchaseHandler)
        XCTAssertNotNil(inAppPurchaseStateObj.inAppHandler)
    }

    func testSetUpIAPLaunchInput(){
        inAppPurchaseStateObj.setupIAPLaunchInput()
        XCTAssertNotNil(inAppPurchaseStateObj.inAppPurchaseLaunchInput, "InAppPurchaseLaunchInput is not intialized properly")
    }

    func testErrorThrownOnProductCountAPI(){
        self.mock.mockProductCount = 5
        self.mock.error = NSError(domain: "DummyDomain", code: 123, userInfo: [:])
        inAppPurchaseStateObj.inAppHandler = self.mock
        _ = DIUserMock.mockDIUser(with: true)
        inAppPurchaseStateObj.refreshIAPCartCount()
        XCTAssert(UserDefaults.standard.integer(forKey: Constants.BADGE_COUNT) == 0, "Product count is not properly updated in Bar Button")
    }
    
    func testProductCountWithoutLogin(){
        _ = DIUserMock.mockDIUser(with: false)
        XCTAssertNotNil(inAppPurchaseStateObj.refreshIAPCartCount())
    }
    
    func testGetViewControllerForShop(){
        self.mock.viewController = UIViewController()
        inAppPurchaseStateObj.inAppHandler = self.mock
        XCTAssertNotNil(inAppPurchaseStateObj.getViewController(), "ViewController is Nil")
    }
    
    func testIAPReturnNilControl(){
        self.mock.viewController = nil
        self.mock.error = NSError(domain: "DummyDomain", code: 123, userInfo: [:])
        inAppPurchaseStateObj.inAppHandler = self.mock
        XCTAssertNil(inAppPurchaseStateObj.getViewController(), "ViewController is Not Nil")
    }
    
    func testFlowUserRelaunchedApp(){
        _ = DIUserMock.mockDIUser(with: true)
        let inAppPurchaseObjectOnReLaunch = InAppPurchaseState()
        XCTAssertNotNil(inAppPurchaseObjectOnReLaunch, "inAppPurchaseObjectOnReLaunch is Nil")
    }

    func testDidUpdateCartCount(){
        self.mock.mockProductCount = 5
        inAppPurchaseStateObj.inAppHandler = mock
        inAppPurchaseStateObj.didUpdateCartCount()
        
        if UserDataInterfaceInstance.sharedInstance.userDataInterface?.loggedInState() == UserLoggedInState.userLoggedIn {
            XCTAssertEqual(UserDefaults.standard.integer(forKey: Constants.BADGE_COUNT), 5)
        }
    }

    func testUpdateCartIconVisibility(){
        XCTAssertNotNil(inAppPurchaseStateObj.updateCartIconVisibility(false))
    }
    
    func testGetVersion(){
        XCTAssertNotNil(inAppPurchaseStateObj.getVersion())
    }
    
    func testInAppPurchaseCatalogueView(){
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            try nextState =  Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.HamburgerMenu), forEventId: "Shopping")
        }
          catch {
            
        }
        if let state = nextState{
            self.mock.viewController = UIViewController()
            self.mock.error = nil
            (state as? InAppPurchaseCatalogueViewState)?.inAppHandler = self.mock
            
            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNotNil(state.getViewController(),"Controller is nil")
        }
    }
    
    func testInAppPurchaseCatalogueNilView(){
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            try nextState =  Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.HamburgerMenu), forEventId: "Shopping")
        }
        catch {}

        if let state = nextState{
            self.mock.viewController = nil
            self.mock.error = NSError(domain: "DummyDomain", code: 123, userInfo: [:])
            (state as? InAppPurchaseCatalogueViewState)?.inAppHandler = self.mock

            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNil(state.getViewController(),"Controller is not nil")
        }
    }
    
    func testInAppPurchaseOrderHistoryView(){
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            try nextState =  Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.Settings), forEventId: "Order History")
        }
        catch { }

        if let state = nextState{
            self.mock.viewController = UIViewController()
            self.mock.error = nil
            (state as? InAppPurchaseOrderHistoryState)?.inAppHandler = self.mock
            
            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNotNil(state.getViewController(),"Controller is nil")
        }
    }
    
    func testInAppPurchaseOrderHistoryNilView(){
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            try nextState =  Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.Settings), forEventId: "Order History")
        }
        catch { }
        if let state = nextState{
            self.mock.viewController = nil
            self.mock.error = NSError(domain: "DummyDomain", code: 123, userInfo: [:])
            (state as? InAppPurchaseOrderHistoryState)?.inAppHandler = self.mock

            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNil(state.getViewController(),"Controller is not nil")
        }
    }

    func testInAppPurchaseCartView(){
        
        let nextState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.InAppPurchaseCart)
       
        if let state = nextState{
            self.mock.viewController = UIViewController()
            self.mock.error = nil
            (state as? InAppPurchaseCartState)?.inAppHandler = self.mock
            
            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNotNil(state.getViewController(),"Controller is nil")
        }
    }
    
    func testInAppPurchaseCartNilView(){
        // Testing Catalogue,Order, History Controller when user is logged in
        let nextState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.InAppPurchaseCart)
        
        if let state = nextState{
            self.mock.viewController = nil
            self.mock.error = NSError(domain: "DummyDomain", code: 123, userInfo: [:])
            (state as? InAppPurchaseCartState)?.inAppHandler = self.mock
            
            // Swizzle DIUser.getinstance.isloggedin with always true
            _ = DIUserMock.mockDIUser(with: true)
            XCTAssertNil(state.getViewController(),"Controller is not nil")
        }
    }
}
