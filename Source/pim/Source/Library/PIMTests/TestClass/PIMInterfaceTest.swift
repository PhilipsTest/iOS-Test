//
//  PIMTests.swift
//  PIMTests
//
//  Created by Shivam Singh on 2/27/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppInfra
@testable import AppAuth

class PIMInterfaceTest: XCTestCase {
    let pimAppDependencies = PIMDependencies()
    let appSettings = PIMSettings()
    var pimInterface : PIMInterface? = nil
    var appInfra : AIAppInfra?
    var migrator:FakeMigrator!
    var jrHandler:FakeJanrainUserHandler!
    
    override func setUp() {
        Bundle.loadSwizzler()
        appInfra = PIMAppInfraMock()
        pimAppDependencies.appInfra = appInfra
        appInfra?.restClient.reachabilityManager.startMonitoring()
    }
    
    func testInit() {
        pimInterface = PIMInterface(dependencies: pimAppDependencies, andSettings: appSettings)
        XCTAssertNotNil(appSettings,"PIMSettings is not initialized properly")
        XCTAssertNotNil(pimAppDependencies.appInfra,"AppInfra is not initialized")
        XCTAssertNotNil(pimInterface,"PIMInterface is not initialized")
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        PIMUserManager.clearMigrationUserFlag()
    }
    
    func initialiseMigrationAPIReqiredClasses() {
        migrator = FakeMigrator()
        jrHandler = FakeJanrainUserHandler()
         pimInterface = PIMInterface(dependencies: pimAppDependencies, settings: appSettings, migrator:migrator , janrainHandler: jrHandler)
    }
    
    func testMigrationNoNetworkErrorAPI() {
        self.initialiseMigrationAPIReqiredClasses()
        let expectation = XCTestExpectation(description: "Migration tester")
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 0), forKeyPath: "networkReachabilityStatus")
       
        
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error != nil, "JRUser not there error must be there")
            //XCTAssert(error?.code == PIMMappedError.noInternet.rawValue, "JRUser not there error must be there")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }
    
    func testMigrationAPUserLoggenIn() {
        self.initialiseMigrationAPIReqiredClasses()
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 1), forKeyPath: "networkReachabilityStatus")
        let manager = PIMSettingsManager.sharedInstance.pimUserManagerInstance()
        let url = URL(string: "http://www.google.com")
        let config = OIDServiceConfiguration(authorizationEndpoint: url!, tokenEndpoint: url!)
        let request = OIDAuthorizationRequest(configuration: config, clientId: "T##String", clientSecret: nil, scope: nil, redirectURL: nil, responseType: "code", state: nil, nonce: nil, codeVerifier: nil, codeChallenge: nil, codeChallengeMethod: nil, additionalParameters: nil)
        manager.authState = OIDAuthState(authorizationResponse: OIDAuthorizationResponse(request: request, parameters: ["":"" as NSCopying & NSObjectProtocol]))
        manager.oidcUser = PIMOIDCUserProfile(nil, userProfileJson: nil)
        
        PIMUserManager.setMigrationUserFlag()
        
        let expectation = XCTestExpectation(description: "Migration tester")
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error == nil, "If user is logged in than erro has to be nil")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }
    
    func testMigrationAPINoJRUser() {
        self.initialiseMigrationAPIReqiredClasses()
        let expectation = XCTestExpectation(description: "Migration tester")
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 1), forKeyPath: "networkReachabilityStatus")
        
        
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error != nil, "JRUser not there error must be there")
            XCTAssert(error?.code == PIMMappedError.PIMUserNotLoggedIn.rawValue, "JRUser not there error must be there")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }
    
    func testMigrationJanrainAPIErrorFlow() {
        self.initialiseMigrationAPIReqiredClasses()
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 1), forKeyPath: "networkReachabilityStatus")
        
        jrHandler.janRainUserExist = true
        jrHandler.error = NSError(domain: "network", code: 403, userInfo: [NSLocalizedDescriptionKey:"Something always goes wrong"])
        
        let expectation = XCTestExpectation(description: "Migration tester")
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error != nil, "Error has to be present")
            //XCTAssert(error?.code == PIMMappedError.PIMRefreshTokenFailed.rawValue, "JRUser not there error must be there")
            //XCTAssert(PIMSettingsManager.sharedInstance.isMigrationUser == false,"MIgration flag set has to be taken out as migration failed.")
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }
    
    func testMigrationAPIMigratorErrorFlow() {
        self.initialiseMigrationAPIReqiredClasses()
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 1), forKeyPath: "networkReachabilityStatus")
        
        jrHandler.janRainUserExist = true
        jrHandler.error = nil
        jrHandler.accessToken = "someaccesstoken"
        
        migrator.error = NSError(domain: "network", code: 403, userInfo: [NSLocalizedDescriptionKey:"Something always goes wrong"])
        migrator.user = nil
        PIMUserManager.clearMigrationUserFlag()
        let expectation = XCTestExpectation(description: "Migration tester")
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error != nil, "Error has to be present")
            //XCTAssert(PIMSettingsManager.sharedInstance.isMigrationUser == false,"MIgration flag set has to be taken out as migration failed.")
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }


    func testMigrationAPIHappyFlow() {
        self.initialiseMigrationAPIReqiredClasses()
        appInfra?.restClient.reachabilityManager.setValue(NSNumber(value: 1), forKeyPath: "networkReachabilityStatus")
        
        jrHandler.janRainUserExist = true
        jrHandler.error = nil
        jrHandler.accessToken = "someaccesstoken"
        
        migrator.error = nil
        migrator.user = PIMUserProfileResponse()
        
        let expectation = XCTestExpectation(description: "Migration tester")
        pimInterface?.migrateJanrainUserToPIM(completionHandler: {
            error in
            XCTAssert(error == nil, "Error has to be nil as user is present and migration succeeded")
            //XCTAssert(PIMSettingsManager.sharedInstance.isMigrationUser == true,"MIgration flag set has to be true as migration succeeded and user is via migration.")
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3)
    }

}

class FakeMigrator : PIMMigrator {
    var error:NSError?
    var user:PIMUserProfileResponse?
    
    override func migrateUserToPIM(token:String, completionHandler: @escaping (NSError?,PIMUserProfileResponse?) -> ()) {
        completionHandler(error,user)
    }
}

class FakeJanrainUserHandler : PIMJanrainHandler {
    var janRainUserExist: Bool = false
    var accessToken:String?
    var error:Error?
    
    override func doJanrainUserExists() -> Bool {
        return janRainUserExist
    }
    
    override func refreshUserJanrainAccessToken(completionHandler:@escaping (String?,Error?) -> ()) {
            completionHandler(accessToken,error)
    }
}
