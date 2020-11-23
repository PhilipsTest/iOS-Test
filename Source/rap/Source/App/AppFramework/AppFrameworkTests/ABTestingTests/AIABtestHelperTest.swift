//
//  AIABtestHelperTest.swift
//  AppFrameworkTests
//
//  Created by philips on 8/17/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
import AppInfra
import Firebase
@testable import AppFramework

class AIABtestHelperTest: XCTestCase {
    
    var appinfra : AIAppInfra?
    var abtestManager : AIABTestManager?
    
    override func setUp() {
        super.setUp()
        self.abtestManager = AIABTestManager()
        let appinfraBuilder = AIAppInfraBuilder()
        appinfraBuilder.abtest = self.abtestManager
        appinfra = AIAppInfra(builder: appinfraBuilder)
        abtestManager?.setupAppInfra(appInfra: appinfra!)
    }
    
    func setFireBaseMockAndCallUpdateCache(request : ABTestingServerRequest) {
        abtestManager?.setABTestingServerRequest(request: request)
        appinfra?.abtest.updateCache(success: nil , error: nil)
    }
    
    func testGetCacheStatusBeforeUpdateandWithoutTest() {
        let cacheStatus = appinfra?.abtest.getCacheStatus()
        XCTAssertEqual(cacheStatus, AIABTestCacheStatus.experiencesNotUpdated)
    }
    
    func testGetCacheStatusBeforeUpdateandWithTest() {
        let cacheStatus = appinfra?.abtest.getCacheStatus()
        XCTAssertEqual(cacheStatus, AIABTestCacheStatus.experiencesNotUpdated)
        let testValue = appinfra?.abtest.getTestValue("dummy", defaultContent: "DummyValue", updateType: .appStart)
        XCTAssertEqual(testValue, "DummyValue")
        XCTAssertEqual(cacheStatus, AIABTestCacheStatus.experiencesNotUpdated)
    }
    
    func testUpdateCache() {
        var cacheStatus = appinfra?.abtest.getCacheStatus()
        XCTAssertEqual(cacheStatus, AIABTestCacheStatus.experiencesNotUpdated)
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"get100"] )
        abtestManager?.setABTestingServerRequest(request: firebaseMock)
        appinfra?.abtest.updateCache(success: {
            cacheStatus = self.appinfra?.abtest.getCacheStatus()
            XCTAssertEqual(cacheStatus, AIABTestCacheStatus.experiencesUpdated)
        } , error: nil)
    }
    
    func testUpdateCacheWithError() {
        let firebaseMock = FirebaseRequestMock.init(testValue: false , keys: ["get_restart"], keyValue: ["get_restart":"get100"] )
        abtestManager?.setABTestingServerRequest(request: firebaseMock)
        appinfra?.abtest.updateCache(success: nil, error:{ returnedError in
            let error = returnedError as NSError?
            XCTAssertEqual(error?.code, 1000)
        })
    }
    
    func testGetValueForTestsForAppRestart() {
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"get100"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        let testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appStart)
        XCTAssertEqual(testValue, "get100")
    }
    
    func testGetValueForTestForAppUpdate() {
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update100"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_update", defaultContent: "defaultValue", updateType: .appUpdate )
        XCTAssertEqual(testValue, "update100")
        let UserExperience = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        let testExperience = UserExperience?["get_update"] as? [String:Any]
        testValue = testExperience?["value"] as? String
        let type : Int = testExperience?["type"] as! Int
        XCTAssertEqual(testValue, "update100")
        XCTAssertEqual(type, Int(AIABTestUpdateType.appUpdate.rawValue) )
        UserDefaults.standard.removeObject(forKey: ABTestKeys.ABTestCachKey)
    }
    
    func testGetValueForTestValueNotTheirInFireBase() {
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update100"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        let testValue = appinfra?.abtest.getTestValue("get_Value", defaultContent: "defaultValue", updateType: .appStart )
        XCTAssertEqual(testValue, "defaultValue")
    }
    
    func testGetValueForTestWithOutCallingUpdateCache() {
        let testValue = appinfra?.abtest.getTestValue("get_Value", defaultContent: "defaultValue", updateType: .appStart )
        XCTAssertEqual(testValue, "defaultValue")
    }
    
    func testGetValueWhenAppupdates() {
        let appindentityMock = AppIndentityMock()
        appinfra?.appIdentity = appindentityMock
        var firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update100"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_update", defaultContent: "defaultValue", updateType: .appUpdate )
        XCTAssertEqual(testValue, "update100")
        appindentityMock.appVersion = "1805"
        appinfra?.appIdentity = appindentityMock
        firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update200"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        testValue = appinfra?.abtest.getTestValue("get_update", defaultContent: "defaultValue", updateType: .appUpdate )
        XCTAssertEqual(testValue, "update200")
        let UserExperience = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        let testExperience = UserExperience?["get_update"] as? [String:Any]
        testValue = testExperience?["value"] as? String
        let type : Int = testExperience?["type"] as! Int
        XCTAssertEqual(testValue, "update200")
        XCTAssertEqual(type, Int(AIABTestUpdateType.appUpdate.rawValue) )
        UserDefaults.standard.removeObject(forKey: ABTestKeys.ABTestCachKey)
    }
    
    func testGetValueWhenAppUpdatesValuesIsChangedInServerButAppNotUpdated() {
        var firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update100"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_update", defaultContent: "defaultValue", updateType: .appUpdate )
        XCTAssertEqual(testValue, "update100")
        firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_update"], keyValue: ["get_update":"update200"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        testValue = appinfra?.abtest.getTestValue("get_update", defaultContent: "defaultValue", updateType: .appUpdate )
        XCTAssertEqual(testValue, "update100")
        let UserExperience = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        let testExperience = UserExperience?["get_update"] as? [String:Any]
        testValue = testExperience?["value"] as? String
        let type : Int = testExperience?["type"] as! Int
        XCTAssertEqual(testValue, "update100")
        XCTAssertEqual(type, Int(AIABTestUpdateType.appUpdate.rawValue) )
        UserDefaults.standard.removeObject(forKey: ABTestKeys.ABTestCachKey)
    }
    
    func testGetValueWhenAppIsNotRestartedButTheValueIsChangedinServer() {
        var firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"restart100"])
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appStart )
        XCTAssertEqual(testValue, "restart100")
        firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"restart200"] )
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appStart )
        XCTAssertEqual(testValue, "restart100")
    }
    
    func testGetValueWhenUpdateTypeIsChangedFromAppRestartToAppUpdate() {
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"restart100"])
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appStart)
        XCTAssertEqual(testValue, "restart100")
        let userExper = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        XCTAssertNil(userExper)
        testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appUpdate)
        XCTAssertEqual(testValue, "restart100")
        let UserExperience = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        let testExperience = UserExperience?["get_restart"] as? [String:Any]
        testValue = testExperience?["value"] as? String
        let type : Int = testExperience?["type"] as! Int
        XCTAssertEqual(testValue, "restart100")
        XCTAssertEqual(type, Int(AIABTestUpdateType.appUpdate.rawValue) )
        UserDefaults.standard.removeObject(forKey: ABTestKeys.ABTestCachKey)
    }
    
    func testGetValueWhenUpdateTypeIsChangedFromAppUpdateToAppRestart() {
        let firebaseMock = FirebaseRequestMock.init(testValue: true, keys: ["get_restart"], keyValue: ["get_restart":"restart100"])
        setFireBaseMockAndCallUpdateCache(request: firebaseMock)
        var testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appUpdate)
        XCTAssertEqual(testValue, "restart100")
        let UserExperience = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        let testExperience = UserExperience?["get_restart"] as? [String:Any]
        testValue = testExperience?["value"] as? String
        let type : Int = testExperience?["type"] as! Int
        XCTAssertEqual(testValue, "restart100")
        XCTAssertEqual(type, Int(AIABTestUpdateType.appUpdate.rawValue) )
        testValue = appinfra?.abtest.getTestValue("get_restart", defaultContent: "defaultValue", updateType: .appStart)
        XCTAssertEqual(testValue, "restart100")
        let userExper = UserDefaults.standard.value(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        XCTAssertEqual(userExper?.count, 0)
    }
    
    func testIsInternetReachable() {
        let restClientmock = AppInfraRestClientMock()
        restClientmock.internetReachable = false
        appinfra?.restClient = restClientmock
        appinfra?.abtest.updateCache(success: nil, error: { (returnedError) in
            let error = returnedError as NSError?
            XCTAssertEqual(error?.code, Int(AIABTestErrorCode.noNetwork.rawValue) )
        })
    }
}
