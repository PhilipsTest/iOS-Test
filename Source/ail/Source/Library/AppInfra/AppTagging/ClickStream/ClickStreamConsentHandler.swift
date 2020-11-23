/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

@objc open class ClickStreamConsentHandler: NSObject {
    
    //MARK Variable Declarations
    fileprivate var appInfra: AIAppInfraProtocol!
    
    fileprivate var CLICKSTREAMCONSENTTYPE = ""
    fileprivate var CLICKSTREAMVERSIONKEY: String {
        return "\(CLICKSTREAMCONSENTTYPE)_Version"
    }
    fileprivate var CLICKSTREAMLOCALEKEY: String {
        return "\(CLICKSTREAMCONSENTTYPE)_Locale"
    }
    fileprivate let CLICKSTREAMERRORMESSAGE = "Click Stream Key is unavailable in Consent Definition"
    
    fileprivate var CLICKSTREAMTIMESTAMP: String {
        return "\(CLICKSTREAMCONSENTTYPE)_Timestamp"
    }
    
    //MARK Default Methods
    private override init() {
        super.init()
    }
    
   @objc public convenience init(with appInfraHandler: AIAppInfraProtocol) {
        self.init()
        appInfra = appInfraHandler
        CLICKSTREAMCONSENTTYPE = appInfraHandler.tagging.getClickStreamConsentIdentifier()
    }
}

//MARK ConsentInteractorProtocol Implementation Methods
extension ClickStreamConsentHandler: ConsentHandlerProtocol {
    
    // Click Stream Consent Data fetch/store works on the below rules:
    // 1. Only Consent Definition which contains the CLICKSTREAMTYPE key,will be considered for Privacy Update. Any other keys will be discarded.
    // 2. If the Consent Definition Text doesnot contain the CLICKSTREAMTYPE key while fetch or store API calls,the app will crash.
    
    public func fetchConsentTypeState(for consentType: String,
                                                  completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        
        precondition(clickStreamConsentIsContainedIn(consentDefinitionType: consentType), CLICKSTREAMERRORMESSAGE)
        
        var consentVersion: Int?
        var timestamp: Date!
        let consentPrivacyStatus: ConsentStates = convertPrivacyStatusToConsentStatus(privacyStatus: appInfra.tagging.getPrivacyConsent())
        
        do {
            try consentVersion = appInfra.storageProvider.fetchValue(forKey: CLICKSTREAMVERSIONKEY) as? Int
        } catch {}
        
        try? timestamp = appInfra.storageProvider.fetchValue(forKey: CLICKSTREAMTIMESTAMP) as? Date
        
        let consentStatus = ConsentStatus(status: consentPrivacyStatus, version: consentVersion ?? 0, timestamp:timestamp ?? Date(timeIntervalSince1970: 0))
        completion(consentStatus, nil)
    }
    
    public func storeConsentState(for consentType: String,
                                  withStatus status: Bool,
                                  withVersion version: Int,
                                  completion: @escaping (Bool, NSError?) -> Void) {
        
        precondition(clickStreamConsentIsContainedIn(consentDefinitionType: consentType), CLICKSTREAMERRORMESSAGE)
        
        appInfra.tagging.setPrivacyConsent(convertConsentStatusToPrivacyStatus(consentStatus: status))
        do {
            try appInfra.storageProvider.storeValue(forKey: CLICKSTREAMVERSIONKEY,
                                                    value: NSNumber(value: version))
        } catch {}
        try? appInfra.storageProvider.storeValue(forKey: CLICKSTREAMLOCALEKEY,
                                                 value: NSString(string: appInfra.internationalization.getBCP47UILocale()))
    
        try? appInfra.storageProvider.storeValue(forKey: CLICKSTREAMTIMESTAMP,
                                                 value: appInfra.time.getUTCTime() as NSCoding)
        
        completion(true, nil)
    }
}

//MARK Helper Methods
extension ClickStreamConsentHandler {
    
    fileprivate func convertConsentStatusToPrivacyStatus(consentStatus: Bool) -> AIATPrivacyStatus {
        return consentStatus ? .optIn : .optOut
    }
    
    fileprivate func convertPrivacyStatusToConsentStatus(privacyStatus: AIATPrivacyStatus) -> ConsentStates {
        switch privacyStatus {
        case .optIn:
            return ConsentStates.active
        case .optOut:
            return ConsentStates.rejected
        case .unknown:
            return ConsentStates.inactive
        }
    }
    
    fileprivate func clickStreamConsentIsContainedIn(consentDefinitionType: String) -> Bool {
        return consentDefinitionType.localizedCaseInsensitiveCompare(CLICKSTREAMCONSENTTYPE) == .orderedSame
    }
}
