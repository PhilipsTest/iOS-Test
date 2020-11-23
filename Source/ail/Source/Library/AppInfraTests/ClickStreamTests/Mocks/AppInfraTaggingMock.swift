/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PlatformInterfaces

class AppInfraTaggingMock: NSObject {
    
    fileprivate var taggingStatus: AIATPrivacyStatus = .unknown
}

extension AppInfraTaggingMock: AIAppTaggingProtocol {
    
    func getClickStreamConsentHandler() -> ConsentHandlerProtocol {
        return ClickStreamConsentHandler(with: AIAppInfra(builder: nil))
    }
    func getClickStreamConsentIdentifier() -> String { return "AIL_ClickStream" }
    
    func createInstance(forComponent componentId: String,
                        componentVersion: String) -> AIAppTaggingProtocol { return self }
    
    func setPrivacyConsent(_ privacyStatus: AIATPrivacyStatus) {
        taggingStatus = privacyStatus
    }
    
    func getPrivacyConsent() -> AIATPrivacyStatus {
        return taggingStatus
    }
    
    func trackPage(withInfo pageName: String, paramKey key: String?, andParamValue value: Any?) {}
    
    func trackPage(withInfo pageName: String, params paramDict: [AnyHashable : Any]?) {}
    
    func trackAction(withInfo actionName: String, paramKey key: String?, andParamValue value: Any?) {}
    
    func trackAction(withInfo actionName: String, params paramDict: [AnyHashable : Any]?) {}
    
    func trackVideoStart(_ videoName: String) {}
    
    func trackVideoEnd(_ videoName: String) {}
    
    func trackSocialSharing(_ socialMedia: AIATSocialMedia, withItem sharedItem: String) {}
    
    func setPreviousPage(_ pageName: String) {}
    
    func trackTimedActionStart(_ action: String?, data: [AnyHashable : Any]?) {}
    
    func trackTimedActionEnd(_ action: String?,
                             logic block: ((TimeInterval, TimeInterval, NSMutableDictionary?) -> Bool)? = nil) {}
    
    func trackLinkExternal(_ url: String?) {}
    
    func trackFileDownload(_ filename: String?) {}
    
    func setPrivacyConsentForSensitiveData(_ consent: Bool) {}
    
    func getPrivacyConsentForSensitiveData() -> Bool { return false }
    
    func getTrackingIdentifier() -> String { return "" }
}
