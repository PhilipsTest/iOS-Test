/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import Firebase

class AIABTestManager: NSObject, AIABTestProtocol {
    
    private var appinfra: AIAppInfra?
    private var aiAbTestHelper: AIABTestHelper?
    private var serverRequest: ABTestingServerRequest?
    let abTestIdentifier = "abTestConsent"
    // MARK: -
    // MARK: Initializer methods
    // MARK: -
    
    override init() {
        super.init()
    }
    
    public func setupAppInfra(appInfra: AIAppInfra) {
        appinfra = appInfra
        aiAbTestHelper = AIABTestHelper.init(appInfra: appInfra)
        setABTestingServerRequest(request: self.aiAbTestHelper!)
    }
    
    public func setABTestingServerRequest(request: ABTestingServerRequest) {
        serverRequest = request
        aiAbTestHelper?.setABTestingServerRequest(request: request)
    }
    
    // MARK: -
    // MARK: AIABTestProtocol methods
    // MARK: -
    
    /* When a server call becomes success then we update all key and its value in the in memory cache
     * Whatever error comes from server, we return error directly. Only no network error is mapped ti AI error code 3600
     */
    func updateCache(success successBlock: (() -> Void)?, error errorBlock: ((Error?) -> Void)? = nil) {
        
        if let internetReachable = appinfra?.restClient.isInternetReachable(), internetReachable {
            self.serverRequest?.getTestValueFromServer({ [weak self] (isSuccess:Bool) in
                guard isSuccess else {
                    return
                }
                if let keys = self?.serverRequest?.requestServerForAllKeys() {
                    self?.aiAbTestHelper?.mapFirebaseValueIntoMemoryCache(keys: keys)
                }
                self?.aiAbTestHelper?.cacheStatus = .experiencesUpdated
                successBlock?()
            }) { (error) in
                self.appinfra?.logging.log(.debug , eventId: ABTestKeys.ABTestComponentName, message: error.localizedDescription)
                errorBlock?(error)
            }
        }else {
            let error = NSError(domain: "AIABTestManager", code: Int(AIABTestErrorCode.noNetwork.rawValue) , userInfo: nil)
            errorBlock?(error)
        }
        
    }
    
    /* Always returned value is fetched from inMemory cache. If inMemory cache does not contain the value for a given key, default value is returned.
     * Also the AIABTestUpdateType defines whether variable is restart or update type.
     * If variable is update type, before returning the value we update it to disk cache. Disk cache contains appUpdate type variables only.
     * If varibale is restart type, before returning the value we check the varibale is stored in disk cache as appUpdate type. If it is so, that variable is removed from disk cache as application is asking this variable as restart type
     * The updation of the memory only happens if the key is not defined in server
     */
    func getTestValue(_ testName: String, defaultContent defaultValue: String, updateType: AIABTestUpdateType) -> String {
        var testValue: String? = aiAbTestHelper?.getTestValueFromCache(requestName: testName, defaultContent: defaultValue)
        if testValue != nil {
            if (testValue?.isEmpty)! {
                testValue = defaultValue
            }
        }else {
            testValue = defaultValue
        }
        // update both memory and persist/disk cache
        aiAbTestHelper?.updateMemoryCache(testName: testName, value: testValue!, updateType: updateType)
        if updateType == AIABTestUpdateType.appUpdate {
            aiAbTestHelper?.updateDiskCache(testName: testName, value: testValue!)
        }
        appinfra?.logging.log(.debug, eventId: ABTestKeys.ABTestComponentName , message: "getTestValue: \(testName) = \(String(describing: testValue))")
        return testValue!
    }
    
    /* This returns  in memory cahce status. It is of two values i.e. notUpdated or Updated.
     * Once all the values from firebase is mapped to AI inmemory cache, then the status is changed to updated state.
     */
    func getCacheStatus() -> AIABTestCacheStatus {
        guard let cacheStatus = aiAbTestHelper?.cacheStatus else {
            return AIABTestCacheStatus.experiencesNotUpdated
            //if the aiAbtestCacheStatus is not initlized then return eperience Not Update
        }
        return cacheStatus
    }
    
    /* This is to enable developer mode or not. By default its set to false.
     * It is recommended that in PROD environment application should not enable it.
     */
    func enableDeveloperMode(_ enable: Bool = false) {
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: enable)
        RemoteConfig.remoteConfig().configSettings = remoteConfigSettings
        if enable {
            aiAbTestHelper?.cacheIntervalTime = ABTestKeys.developerCacheIntervalTime
        }else {
            aiAbTestHelper?.cacheIntervalTime = ABTestKeys.serverCacheIntervalTime
        }
    }
    
    public func getABTestConsentIdentifier() -> String {
        return abTestIdentifier
    }
    
    func tagevent(withInfo eventName: String, params paramDict: [String : Any]?) {
        Analytics.logEvent(eventName, parameters: paramDict)
    }
}
