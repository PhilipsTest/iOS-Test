//
//  TaggingUtilitiesTest.swift
//  AppFramework
//
//  Created by Philips on 3/30/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework
@testable import AppInfra

class TaggingUtilitiesTest: XCTestCase {
    var postedNotification: NSNotification?

    override func setUp() {
        super.setUp()
        ADBMock.sharedInstance.swizzleADBTrackState()
        ADBMock.sharedInstance.swizzleADBTrackAction()
        ADBMock.sharedInstance.taggingParameterDict.removeAll()
        ADBMock.sharedInstance.actionParameterDict.removeAll()
    }
    
    func testTrackPageWithInfo(){
        TaggingUtilities.trackPageWithInfo(page: "firstDummyPage", params:nil)
        TaggingUtilities.trackPageWithInfo(page: "secoundDummyPage", params:nil)

        // Checking the Dictonary which is finally going to ADBMobile for tagging Via Reference App > Appinfra
        XCTAssertNotNil(ADBMock.sharedInstance.taggingParameterDict)
        //Checking the dictonary contains key
        XCTAssertTrue(containKeys("previousPageName", dictonary:ADBMock.sharedInstance.taggingParameterDict))
        //Checking the value of the key previousPageName in  dictonary is equal to firstDummyPage
        XCTAssertEqual(ADBMock.sharedInstance.taggingParameterDict["previousPageName"] as? String, "firstDummyPage")
    }

    func testTrackPageWithKeyValue(){
        TaggingUtilities.trackPageWithInfo(page: "dummy", key: "test", value: "test")

        // Checking the Dictonary which going to ADBMobile for taggin Via Reference App > Appinfra
        XCTAssertNotNil(ADBMock.sharedInstance.taggingParameterDict)
        //Checking the dictonary contains key
        XCTAssertTrue(containKeys("test", dictonary:ADBMock.sharedInstance.taggingParameterDict))
    }
    
    func testTrackActionWithInfo(){
        ADBMock.sharedInstance.swizzleADBTrackAction()
        TaggingUtilities.trackActionWithInfo(key: "dummy", params:nil)

        // Checking the Dictonary which going to ADBMobile for taggin Via Reference App > Appinfra
        XCTAssertNotNil(ADBMock.sharedInstance.actionParameterDict)
    }

    func testTrackActionWithKeyValue(){
        
        TaggingUtilities.trackActionWithInfo(action: "dummy", key: "test", value: "dummy")
        
        // Checking the Dictonary which going to ADBMobile for taggin Via Reference App > Appinfra
        XCTAssertNotNil(ADBMock.sharedInstance.actionParameterDict)
        //Checking the dictonary contains key
        XCTAssertTrue(containKeys("test", dictonary: ADBMock.sharedInstance.actionParameterDict))
    }
    
    func containKeys(_ key:String , dictonary : [String:AnyObject]) ->Bool{
        let keyExists = dictonary[key] != nil
        return keyExists
    }
    
    func testReceiveTaggingPage(){
        let mockInfoDict:[String: String] = [UnitTestConstants.AILPAGENAMEKEY: UnitTestConstants.SCREENTOTAG]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAilTaggingNotification), object: nil, userInfo: mockInfoDict)
    }
    
    func testReceiveTaggingAction(){
        let mockInfoDict:[String: String] = [UnitTestConstants.AILACTIONNAMEKEY: UnitTestConstants.ACTIONTOTAG]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAilTaggingNotification), object: nil, userInfo: mockInfoDict)
    }
    
    func testJSONStringfy(){
        let mockJsonObject: NSMutableDictionary = NSMutableDictionary()
        mockJsonObject.setValue("MockValue", forKey: "MockKey")
        let mockJsonStringExpected = "{\"MockKey\":\"MockValue\"}"
        XCTAssertEqual(TaggingUtilities.JSONStringify(jsonObject: mockJsonObject),mockJsonStringExpected)
    }
}
