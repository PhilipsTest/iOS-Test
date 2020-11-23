//
//  DeviceStoredConsentHandler.swift
//  AppInfra
//
/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

fileprivate typealias ConsentDataType = [String:Any]
fileprivate let CONSENTSTATUSKEY = "Status"
fileprivate let CONSENTVERSIONKEY = "Version"
fileprivate let CONSENTTIMESTAMPKEY = "Timestamp"
fileprivate let CONSENTLOCALEKEY = "Locale"
fileprivate let CONSENTTLA = "CAL"

fileprivate enum ConsentsActionType: String {
    case post = "Post"
    case fetch = "Fetch"
}

/**
 *  DeviceStoredConsentHandler is used for Local Storage of Consents.
 *  DeviceStoredConsentHandler stores the Consent Data in App Infra Secure Storage.
 *
 * - Since: 2018.1.0
 */

public class DeviceStoredConsentHandler: NSObject {
    
    //MARK Variable Declarations
    
    fileprivate var appInfra: AIAppInfraProtocol!
    public let cache = AICache<String, Bool>()
    public let versionCache = AICache<String, Int>()
    public let timestampCache = AICache<String, Date>()
    fileprivate var consentStoragePrefix: String {
        return "\(CONSENTTLA)_"
    }
    
    //MARK Default Methods
    
    private override init() {
        super.init()
    }
    
    @objc public convenience init(with appInfraHandler: AIAppInfraProtocol) {
        self.init()
        appInfra = appInfraHandler
    }
}

//MARK ConsentInteractorProtocol Implementation Methods

extension DeviceStoredConsentHandler: ConsentHandlerProtocol {
    
    public func fetchConsentTypeState(for consentType: String,
                                      completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        var consentVersion: Int?
        var consentState: ConsentStates = .inactive
        var consentTimeStamp :Date! = Date(timeIntervalSince1970: 0)
        // Consent Data fetch works on the below rules:
        // 1. While fetching/posting Consent Definition, if any error happens, success is returned with Consent Status as False.
        var consentValue = cache.object(forKey: consentType)
        
        if consentValue != nil {
            if consentValue == true{
                consentState = .active
            }
            let consentVersion = versionCache.object(forKey: consentType)
            let timestamp = timestampCache.object(forKey: consentType)
            if timestamp != nil {
                consentTimeStamp = timestamp
            }
            let consentStatusValue  = ConsentStatus(status: consentState, version: consentVersion ?? 0,timestamp:consentTimeStamp)
            completion(consentStatusValue, nil)
            return
        }
        do {
            guard let consentData = try appInfra.storageProvider.fetchValue(forKey: "\(consentStoragePrefix)\(consentType)") as? ConsentDataType else {
                let consentStatus = ConsentStatus(status: consentState, version: consentVersion ?? 0)
                completion(consentStatus,nil)
                return
            }
            if let version = consentData[CONSENTVERSIONKEY] as? Int{
                consentVersion = version
            }
            if let consentFetchStatus = consentData[CONSENTSTATUSKEY] as? Bool {
                consentState = consentFetchStatus == true ? .active : .rejected
            }
            
            if let date = consentData[CONSENTTIMESTAMPKEY] as? Date{
                consentTimeStamp = date
            }
            
        } catch {
        }
        
        consentValue = consentState == .active ? true : false
        cache.setObject(consentValue ?? false, forKey: consentType)
        versionCache.setObject(consentVersion ?? 0, forKey:consentType )
        timestampCache.setObject(consentTimeStamp ?? Date(timeIntervalSince1970: 0) , forKey: consentType)
        let consentStatus = ConsentStatus(status: consentState, version: consentVersion ?? 0,timestamp:consentTimeStamp)
        completion(consentStatus, nil)
    }
    
    public func storeConsentState(for consentType: String,
                                  withStatus status: Bool,
                                  withVersion version: Int,
                                  completion: @escaping (Bool, NSError?) -> Void) {
        
        var consentStorageData: ConsentDataType = [:]
        consentStorageData[CONSENTSTATUSKEY] = status
        consentStorageData[CONSENTVERSIONKEY] = version
        consentStorageData[CONSENTTIMESTAMPKEY] = appInfra.time.getUTCTime()
        consentStorageData[CONSENTLOCALEKEY] = appInfra.internationalization.getBCP47UILocale()
        do {
            try appInfra.storageProvider.storeValue(forKey: "\(consentStoragePrefix)\(consentType)",
                value: NSDictionary(dictionary: consentStorageData))
            
            cache.setObject(status, forKey: consentType)
            versionCache.setObject(version, forKey:consentType )
            timestampCache.setObject(appInfra.time.getUTCTime(), forKey: consentType)

        } catch let postError as NSError {
            appInfra.logging.log(.error,
                                 eventId: "\(eventId(for: .post, for: consentType))",
                message: postError.localizedDescription)
            completion(false, nil)
            return
        }
        completion(true, nil)
    }
}

//MARK Helper Methods

extension DeviceStoredConsentHandler {
    
    fileprivate func currentTimeStamp(from currentDate: Date) -> Double {
        return (currentDate.timeIntervalSince1970) * 1000
    }
    
    fileprivate func eventId(for loggingType: ConsentsActionType, for consentType: String) -> String {
        return "\(loggingType.rawValue) failed for type \(consentType)"
    }
    
    
}


public class AICache<KeyType: Hashable, ObjectType> {
    
    private let cache: NSCache<KeyWrapper<KeyType>, ObjectWrapper> = NSCache()
    
    public func object(forKey key: KeyType) -> ObjectType? {
        return cache.object(forKey: KeyWrapper(key))?.value as? ObjectType
    }
    
    public func setObject(_ obj: ObjectType, forKey key: KeyType) {
        return cache.setObject(ObjectWrapper(obj), forKey: KeyWrapper(key))
    }
    
    public func removeObject(forKey key: KeyType) {
        return cache.removeObject(forKey: KeyWrapper(key))
    }
    
    public func removeAllObjects() {
        return cache.removeAllObjects()
    }
    
}

private class ObjectWrapper {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
}

private class KeyWrapper<KeyType: Hashable>: NSObject {
    let key: KeyType
    init(_ key: KeyType) {
        self.key = key
    }
    
    override var hash: Int {
        return key.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? KeyWrapper<KeyType> else {
            return false
        }
        return key == other.key
    }
}


