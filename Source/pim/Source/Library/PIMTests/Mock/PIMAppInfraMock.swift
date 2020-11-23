//
//  PIMAppInfraMock.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 4/30/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import AppInfra
import PlatformInterfaces

class PIMAppInfraMock: AIAppInfra {
    
    override init() {
        super.init()
        self.time = MockAITime()
        self.logging = MockLogger()
        self.tagging = MockTagger()
        self.appConfig = MockAppConfig()
        self.appIdentity = MockAppIdentity()
        self.restClient = PIMRESTClientMock()
        self.storageProvider = MockStorageProvider()
        self.serviceDiscovery = PIMServiceDiscoveryMock()
    }
    
    deinit {
        self.logging = nil
        self.tagging = nil
        self.appConfig = nil
        self.appIdentity = nil
        self.restClient = nil
        self.storageProvider = nil
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

class MockLogger: NSObject, AILoggingProtocol {
    
    var logLevel: AILogLevel?
    var logEventID: String?
    var logMessage: String?
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return self
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {
        logLevel = level
        logEventID = eventId
        logMessage = message
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {}
}

class MockTagger:NSObject, AIAppTaggingProtocol {
    
    var inActionName: String!
    var inParamDict: [AnyHashable : Any]?
    var inPageName: String!
    
    func createInstance(forComponent componentId: String, componentVersion: String) -> AIAppTaggingProtocol {
        return self
    }
    
    func setPrivacyConsent(_ privacyStatus: AIATPrivacyStatus) {}
    
    func getPrivacyConsent() -> AIATPrivacyStatus {
        return AIATPrivacyStatus.optIn
    }
    
    func trackPage(withInfo pageName: String, paramKey key: String?, andParamValue value: Any?) {
        inPageName = pageName
    }
    
    func trackPage(withInfo pageName: String, params paramDict: [AnyHashable : Any]?) {
        inPageName = pageName
        inParamDict = paramDict
    }
    
    func trackAction(withInfo actionName: String, paramKey key: String?, andParamValue value: Any?) {
        inActionName = actionName
        inParamDict = [key: value ?? ""]
    }
    
    func trackAction(withInfo actionName: String, params paramDict: [AnyHashable : Any]?) {
        inActionName = actionName
        inParamDict = paramDict
    }
    
    func trackVideoStart(_ videoName: String) {}
    
    func trackVideoEnd(_ videoName: String) {}
    
    func trackSocialSharing(_ socialMedia: AIATSocialMedia, withItem sharedItem: String) {}
    
    func setPreviousPage(_ pageName: String) {}
    
    func trackTimedActionStart(_ action: String?, data: [AnyHashable : Any]?) {}
    
    func trackTimedActionEnd(_ action: String?, logic block: ((TimeInterval, TimeInterval, NSMutableDictionary?) -> Bool)? = nil) {}
    
    func trackLinkExternal(_ url: String?) {}
    
    func trackFileDownload(_ filename: String?) {}
    
    func setPrivacyConsentForSensitiveData(_ consent: Bool) {}
    
    func getPrivacyConsentForSensitiveData() -> Bool { return false }
    
    func getTrackingIdentifier() -> String { return "" }
    
    func getClickStreamConsentHandler() -> ConsentHandlerProtocol {
        return ClickStreamConsentHandler(with: PIMAppInfraMock())
    }
    
    func getClickStreamConsentIdentifier() -> String { return "" }
}

class MockAppConfig: NSObject, AIAppConfigurationProtocol {
    
    var propertyForKey: Any = "durhrkq6ezqcvmqf6mq77ev48fuubdbj"
    
    func getPropertyForKey(_ key: String!, group: String!) throws -> Any {
        return propertyForKey
    }
    
    func setPropertyForKey(_ key: String!, group: String!, value: Any!) throws { }
    
    func getDefaultProperty(forKey key: String!, group: String!) throws -> Any {
        return propertyForKey
    }
    
    func refreshCloudConfig(_ completionHandler: ((AIACRefreshResult, Error?) -> Void)!) { }
    
    func resetConfig() throws { }
}

class MockStorageProvider: NSObject, AIStorageProviderProtocol {
    
    var storedValue: NSDictionary?
    var storeError: NSError?
    var fetchedValue: NSDictionary?
    var fetchError: NSError?
    
    func storeValue(forKey key: String, value object: NSCoding) throws {
        guard let storeError = storeError else {
            storedValue = [key: object]
            return
        }
        throw storeError
    }
    
    func fetchValue(forKey key: String) throws -> Any {
        guard let fetchError = fetchError else {
            return fetchedValue as Any
        }
        throw fetchError
    }
    
    func removeValue(forKey key: String) {}
    
    func loadData(_ data: NSCoding) throws -> Data {
        return Data()
    }
    
    func parseData(_ data: Data) throws -> Any {
        return Data()
    }
    
    func deviceHasPasscode() -> Bool {
        return false
    }
    
    func getDeviceCapability() -> String {
        return ""
    }
    
    func storeData(toFile filePath: String, type: String, data: Any) throws {}
    
    func fetchData(fromFile filePath: String, type: String) throws -> Any { return Data() }
    
    func removeFile(fromPath filePath: String, type: String) throws {}
}

class MockAITime: NSObject, AITimeProtocol {
    
    func getUTCTime() -> Date! {
        return Date()
    }

    func refreshTime() {
        
    }
    
    func isSynchronized() -> Bool {
        return true
    }
}
