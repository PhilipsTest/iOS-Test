/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation
import AppInfra

class MockAppInfra: AIAppInfra {
    
    var mockLogger: MockLogger!
    var mockIdentity: MockAppIdentity!
    var mockConfig: MockAppConfig!
    
    override init() {
        super.init()
        mockLogger = MockLogger()
        mockIdentity = MockAppIdentity()
        mockConfig = MockAppConfig()
        self.logging = mockLogger
        self.appIdentity = mockIdentity
        self.appConfig = mockConfig
    }
    
    deinit {
        mockLogger = nil
        mockIdentity = nil
        mockConfig = nil
    }
}

class MockAppIdentity: NSObject, AIAppIdentityProtocol {
    
    var appState: AIAIAppState = .STAGING
    
    func getMicrositeId() -> String! {
        return ""
    }
    
    func getAppState() -> AIAIAppState {
        return appState
    }
    
    func getSector() -> String! {
        return ""
    }
    
    func getAppName() -> String! {
        return ""
    }
    
    func getLocalizedAppName() -> String! {
        return ""
    }
    
    func getAppVersion() -> String! {
        return ""
    }
    
    func getServiceDiscoveryEnvironment() -> String! {
        return ""
    }
}
