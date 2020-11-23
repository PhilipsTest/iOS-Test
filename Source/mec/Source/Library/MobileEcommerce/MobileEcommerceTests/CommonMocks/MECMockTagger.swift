/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra
import PlatformInterfaces

class MECMockTagger:NSObject, AIAppTaggingProtocol {
    
    var inActionName: String!
    var inParamDict: [AnyHashable : Any]?
    var inPageName: String!
    
    func createInstance(forComponent componentId: String, componentVersion: String) -> AIAppTaggingProtocol {
        return self
    }
    
    func setPrivacyConsent(_ privacyStatus: AIATPrivacyStatus) {}
    
    func getPrivacyConsent() -> AIATPrivacyStatus {
        return AIATPrivacyStatus.unknown
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
        return ClickStreamConsentHandler(with: MockAppInfra())
    }
    
    func getClickStreamConsentIdentifier() -> String { return "" }
}

class MockAppIdentity: NSObject, AIAppIdentityProtocol {
    func getMicrositeId() -> String! {
        return "10000"
    }
    
    func getAppState() -> AIAIAppState {
        return .TEST
    }
    
    func getSector() -> String! {
        return "Test"
    }
    
    func getAppName() -> String! {
        return "TestApp"
    }
    
    func getLocalizedAppName() -> String! {
        return "TestApp"
    }
    
    func getAppVersion() -> String! {
        return "123"
    }
    
    func getServiceDiscoveryEnvironment() -> String! {
        return "TEST"
    }
}

class MockInternationalization: NSObject, AIInternationalizationProtocol {
    func getUILocale() -> Locale! {
        return Locale(identifier: "Test")
    }
    
    func getUILocaleString() -> String! {
        return "Test"
    }
    
    func getBCP47UILocale() -> String! {
        return "Test"
    }
}

class MockAppConfig: NSObject, AIAppConfigurationProtocol {
    
    var propertyFofKey: Any = ""
    var getPropertyForKeyError: NSError?
    
    func getPropertyForKey(_ key: String!, group: String!) throws -> Any {
        guard let fetchError = getPropertyForKeyError else {
            return propertyFofKey
        }
        throw fetchError
    }
    
    func setPropertyForKey(_ key: String!, group: String!, value: Any!) throws { }
    
    func getDefaultProperty(forKey key: String!, group: String!) throws -> Any {
        return propertyFofKey
    }
    
    func refreshCloudConfig(_ completionHandler: ((AIACRefreshResult, Error?) -> Void)!) { }
    
    func resetConfig() throws { }
}
