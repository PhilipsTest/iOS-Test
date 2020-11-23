/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import Firebase

struct ABTestKeys {
    static let ABTestComponentName = "AIABTesting"
    static let ABTestCachKey = "philips.appinfra.abtest.precache"
    static let ABTestRestartKey = "philips.appinfra.abtest.appstart"
    static let ABTestUpdateKey = "philips.appinfra.abtest.appupdate"
    static let serverCacheIntervalTime : TimeInterval =  43200 // 12hrs or 43200 seconds default cache expiration time
    static let developerCacheIntervalTime : TimeInterval = 0 // this is developer mode testing
}

protocol ABTestingServerRequest {
    
    func getTestValueFromServer(_ successHandler:@escaping (Bool) -> Void, failureHandler: @escaping (Error) -> Void)
    
    func requestServerForAllKeys() -> [String]
    
    func requestServerValueforKey(key: String) -> String?
    
}

class AIABTestHelper : NSObject {
    
    var cacheStatus: AIABTestCacheStatus = .experiencesNotUpdated
    var cacheIntervalTime : TimeInterval = ABTestKeys.serverCacheIntervalTime
    private var abTestMemoryCache:[String:Any]?
    private var helperServerRequest : ABTestingServerRequest?
    var appinfra : AIAppInfra?
    
    public init(appInfra : AIAppInfra) {
        super.init()
        self.appinfra = appInfra
        abTestMemoryCache = [:]
        loadFromDiskCache()
    }
    
    public func setABTestingServerRequest(request: ABTestingServerRequest) {
        helperServerRequest =  request
    }
    
    /* First step load all the saved app-update variables from disk cache to in-memory cache*/
    func loadFromDiskCache() {
        let preCache = UserDefaults.standard.object(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        if preCache != nil {
            abTestMemoryCache = preCache
        }
        cacheStatus = .experiencesNotUpdated
    }
    
    func isAppUpdated() -> Bool {
        let defaults: UserDefaults? = UserDefaults.standard
        let currentAppVersion: String = self.currentAppVersion()
        let previousAppVersion: String? = (defaults?.object(forKey: ABTestKeys.ABTestUpdateKey) as? String)
        
        guard previousAppVersion != nil else {
            return true // first launch
        }
        return !(previousAppVersion == currentAppVersion) // return false i.e same version else app updated
    }
    
    func currentAppVersion() -> String {
        let currentAppVersion = appinfra?.appIdentity.getAppVersion()
        return currentAppVersion ?? ""
    }
    
    func saveCurrentAppVersionAsUpdated() {
        let defaults: UserDefaults? = UserDefaults.standard
        defaults?.set(currentAppVersion(), forKey: ABTestKeys.ABTestUpdateKey)
        defaults?.synchronize()
    }
    
    func getTestValueFromCache(requestName: String, defaultContent: String) -> String? {
        guard let abTestCachevalue = abTestMemoryCache else {
            return nil
        }
        guard let abtestCacheValueForKey = abTestCachevalue[requestName] as? [String:Any]  else {
            return nil
        }
        guard (abtestCacheValueForKey["value"] != nil) && (abtestCacheValueForKey["type"] != nil) else {
            return nil
        }
        return abtestCacheValueForKey["value"] as? String
    }
    
    /* Update in-memory cache with proper dictionary format
     * If varibale type is apprestart type and it was before appupdatetype, then remove that property from disk cache
     */
    func updateMemoryCache(testName: String, value content: String, updateType: AIABTestUpdateType) {
        let experience = ["value": content, "type": Int(updateType.rawValue), "version": currentAppVersion()] as [String:Any]
        appinfra?.logging.log(.debug, eventId: "AIABTestHelper", message: "updating MemoryCache with", dictionary: experience)
        if let abtestCacheValueForKey = abTestMemoryCache?[testName] as? [String:Any] {
            // TODO: check nil check is needed or add check in next else.. optimize the below code
            if (abtestCacheValueForKey["value"] != nil) && updateType == AIABTestUpdateType.appStart {
                //value is already there in cache ignoring the new value
            }else {
                abTestMemoryCache?[testName] = experience
            }
        }else {
            abTestMemoryCache?[testName] = experience
        }
        
        //remove from disk if it is already saved as appupdate variable
        if updateType == AIABTestUpdateType.appStart {
            removeFromDiskCache(testName: testName)
        }
    }
    
    /* Updating persistent cache for tests of type app update by storing it in user default*/
    func updateDiskCache(testName: String, value content: String) {
        let userDefaults: UserDefaults? = UserDefaults.standard
        var diskCache = userDefaults?.object(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        if diskCache == nil {
            diskCache = [String: Any]()
        }
        let experience = ["value": content, "type": Int(AIABTestUpdateType.appUpdate.rawValue), "version": currentAppVersion()] as [String : Any]
        diskCache?[testName] = experience
        userDefaults?.set(diskCache, forKey: ABTestKeys.ABTestCachKey)
        userDefaults?.synchronize()
    }
    
    func removeFromDiskCache(testName: String) {
        let userDefaults: UserDefaults? = UserDefaults.standard
        var diskCache = userDefaults?.object(forKey: ABTestKeys.ABTestCachKey) as? [String:Any]
        diskCache?.removeValue(forKey: testName)
        userDefaults?.set(diskCache, forKey: ABTestKeys.ABTestCachKey)
        userDefaults?.synchronize()
    }
}
extension AIABTestHelper : ABTestingServerRequest {
    
    func getTestValueFromServer(_ successHandler:@escaping (Bool) -> Void, failureHandler: @escaping (Error) -> Void) {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: cacheIntervalTime , completionHandler: { [weak self] (remoteConfigFetchStatus, error) in
            guard error == nil else {
                failureHandler(error!)
                return
            }
            self?.appinfra?.logging.log(.debug, eventId: "AIABTestManager" , message: "RemoteConfigFetchStatus From Firebase \(remoteConfigFetchStatus.rawValue)")
            RemoteConfig.remoteConfig().activateFetched()
            guard remoteConfigFetchStatus == RemoteConfigFetchStatus.success else {
                successHandler(false)
                return
            }
            successHandler(true)
        })
    }
    
    func checkKeyInMemoryCache(abtestKey: String) -> Bool{
        guard ((abTestMemoryCache?[abtestKey]) != nil) else {
            return false
        }
        return true
    }
    
    func requestServerForAllKeys() -> [String] {
        let keys = RemoteConfig.remoteConfig().allKeys(from: RemoteConfigSource.remote , namespace: NamespaceGoogleMobilePlatform)
        return keys
    }
    
    func requestServerValueforKey(key: String) -> String? {
        return RemoteConfig.remoteConfig()[key].stringValue
    }
    
    /* Mapping firebase values into in-memory cache.
     * First check if that firebase key is present in in-memory cache or not
     * If present, check for variable type. If it is apprestart type, update that and for appupdate type, dont do anything. That appupdate type varibale will only be updated on application update
     * If not present, save in in-memory cache with varibale type as apprestart type
     * Also at the end, save current version as appupdate if application is updated
     */
    func mapFirebaseValueIntoMemoryCache(keys: [String]) {
        for key in keys {
            if checkKeyInMemoryCache(abtestKey: key) {
                // if type is apprestart for an existing key, we need to update in memory cache everytime
                // TODO: needs to be refreshed on appstart everytime or not
                if var abtestCacheValueForKey = abTestMemoryCache?[key] as? [String:Any] {
                    if (abtestCacheValueForKey["type"] as? AIABTestUpdateType) == AIABTestUpdateType.appStart {
                        let valueOfKey = abtestCacheValueForKey["value"] as? String
                        abtestCacheValueForKey["value"] = helperServerRequest?.requestServerValueforKey(key: key) ?? valueOfKey
                    } else {
                        // if app is updated but user has not requested for this key, then we sould save the experience as apprestart type.
                        if isAppUpdated() {
                            let valueOfKey = abtestCacheValueForKey["value"]
                            abtestCacheValueForKey["value"] = helperServerRequest?.requestServerValueforKey(key: key) ?? valueOfKey
                            abtestCacheValueForKey["type"] = AIABTestUpdateType.appStart
                            abtestCacheValueForKey["version"] = currentAppVersion()
                            abTestMemoryCache?[key] = abtestCacheValueForKey
                        }
                    }
                }
            } else {
                // update in memory cache by default for all new keys received, this is valid in case of fresh app installation or new keys received from Firebase
                let valueOfKey = helperServerRequest?.requestServerValueforKey(key: key) ?? ""
                self.updateMemoryCache(testName: key, value: valueOfKey, updateType: AIABTestUpdateType.appStart)
            }
        }
        if isAppUpdated() {
            saveCurrentAppVersionAsUpdated()
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: ABTestKeys.ABTestRestartKey)
        userDefaults.synchronize()
    }
}
