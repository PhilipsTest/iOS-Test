//
//  TermsAndPrivacyViewControllerTest.swift
//  AppFramework
//
//  Created by Philips on 9/27/17.
//  Copyright © 2017 Philips. All rights reserved.
//


import XCTest
@testable import AppFramework

class TermsAndPrivacyViewControllerTest: XCTestCase {
    var termsAndPrivacyViewControllerTest: TermsAndPrivacyViewController?
    
    
    override func setUp() {
        super.setUp()
        let termAndCondition:UINavigationController?
        let storyBoard = UIStoryboard(name: Constants.TERMS_AND_PRIVACY_STORYBOARD_NAME, bundle: nil)
        termAndCondition = storyBoard.instantiateViewController(withIdentifier: Constants.TERMS_AND_PRIVACY_STORYBOARD_ID) as? UINavigationController
        termsAndPrivacyViewControllerTest = termAndCondition?.viewControllers.first as? TermsAndPrivacyViewController
    }
    
    override func tearDown() {
        termsAndPrivacyViewControllerTest = nil
        super.tearDown()
    }
    
    func testTermsAndViewControllerNilCheck(){
         UserDefaults.standard.set(Constants.TERMS_AND_CONDITION_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
        termsAndPrivacyViewControllerTest?.loadViewIfNeeded()
        XCTAssertNotNil(termsAndPrivacyViewControllerTest)
    }
    
    func testTermsAndConditionPrivacyPolicyLaunch(){
         UserDefaults.standard.set(Constants.PRIVACY_POLICY_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
        termsAndPrivacyViewControllerTest?.loadViewIfNeeded()
    }
    func testTermsAndConditionDefaultLaunch(){
        UserDefaults.standard.set("DefaultMock", forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
        termsAndPrivacyViewControllerTest?.loadViewIfNeeded()
    }
    
    func testTermsAndConditionLaunchWithTitle() {
        UserDefaults.standard.set(Constants.PRIVACY_POLICY_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
        givenPrivacyNoticeVC(withString: "Sample title")
        whenViewControllerViewIsLoaded()
        thenPrivacyNoticeVCNavigationItem(expectedString: "Sample title")
    }
    
    func testTermsAndConditionLaunchWithoutTitle() {
        UserDefaults.standard.set(Constants.PRIVACY_POLICY_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
        givenPrivacyNoticeVC(withString: nil)
        whenViewControllerViewIsLoaded()
        thenPrivacyNoticeVCNavigationItem(expectedString: "Privacy policy")
    }
    
    private func whenViewControllerViewIsLoaded() {
        termsAndPrivacyViewControllerTest?.loadViewIfNeeded()
    }
    
    private func givenPrivacyNoticeVC(withString: String?) {
        termsAndPrivacyViewControllerTest?.titleString = withString
    }
    
    private func thenPrivacyNoticeVCNavigationItem(expectedString: String) {
        XCTAssertTrue(termsAndPrivacyViewControllerTest?.navigationItem.title == expectedString)
    }
    
    func testDismissButtonPressed(){
        XCTAssert(((termsAndPrivacyViewControllerTest?.dismissButtonPressed()) != nil))
    }
    
}
