/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth
import PlatformInterfaces
import AppInfra
import CommonCrypto


protocol UDIRefreshSession {
    func refreshSessionStatus(_ authStateResponse:OIDAuthState, _ isRefreshed: Bool, _ error: Error?)
}

class PIMUserManager: UDIRefreshSession {
    
    var oidcUser: PIMOIDCUserProfile?
    var authState: OIDAuthState?
    var appInfra: AIAppInfra
    var restClient: AIRESTClientProtocol
    
    private let authStateKeyConstant =  ".AuthState"
    //Needs to be 32 character
    private let userProfileKeyConstant = ".UserProfile.."
    
    private var refreshCompletionHandler:((_ isRefreshed: Bool, _ error: Error?) -> ())?
    private var refreshCount:Int = 0
    
    init(_ appInfraInstance: AIAppInfra) {
        appInfra = appInfraInstance
        restClient = PIMSettingsManager.sharedInstance.restClientInterface()!
        if let activeSubUUID = PIMDefaults.getSubUUID() {
            authState = fetchAuthStateFromStorage(activeSubUUID)
            self.instantiateOIDCUser(activeSubUUID: activeSubUUID)
        }
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "usermanager initialised")
    }
    
    // Invokes a request to fetch user profile.
    // On success: user profile, appauth and uuid will be saved. User profile will be returned as callback
    // On error: error would be returned
    func requestUserProfile(_ oidState: OIDAuthState, completion:@escaping (_ userProfile: PIMUserProfileResponse?,_ error: Error?) -> Void) {
        
        let restClient = PIMRestClient(self.restClient)
        let userProfileRequest = UserProfileRequest(oidState)
        
        restClient.invokeRequest(userProfileRequest) { [weak self] (response, data, error) in
            if let profileError = error, let inResponse = response {
                let parsedError = PIMErrorBuilder.parsePIMError(error: profileError, networkResponse: inResponse) ?? profileError
                completion(nil, parsedError)
            }else {
                do {
                    if let receivedData = data {
                        let jsonData = try? JSONSerialization.data(withJSONObject:receivedData)
                        let userDetails = try JSONDecoder().decode(PIMUserProfileResponse.self, from: jsonData!)
                        guard let subUUID = userDetails.sub else {
                            completion(nil, NSError(domain: "", code: PIMMappedError.PIMMigrationFailedError.rawValue, userInfo: nil))
                            return
                        }
                        PIMDefaults.saveSubUUID(subUUID)
                        self?.saveAuthStateToStorage(oidState, subUUID)
                        self?.saveUserProfileToStorage(receivedData, subUUID)
                        completion(userDetails, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
    
    func updateMarketingOptinConsent(_ consentGiven: Bool, _ completion:@escaping (_ isUpdated: Bool, _ error: Error?) -> Void) {
        guard let authStatePresent = authState else {
            let error = PIMErrorBuilder.buildPIMError(code: .PIMUserNotLoggedIn, message: "User not logged in", domain: "com.PIM.NoUserError")
            completion(false, error)
            return
        }
        PIMSettingsManager.sharedInstance.getPIMSDURL(forKey: PIMConstants.ServiceIDs.JANRAIN_USER_MARKETINGOPTIN, completionHandler: { (inURL, inError) in
            
            guard inError == nil else {
                completion(false, inError)
                return
            }
            guard let urlString = inURL else {
                completion(false, PIMErrorBuilder.getNoSDURLError())
                return
            }
            
            let marketingURL = URL(string: urlString)!
            let updateOptinRequest = MarketingOptinRequest(consentGiven, oidAuthState: authStatePresent, optinURL: marketingURL)
            let restClient = PIMRestClient(self.restClient)
            restClient.invokeRequest(updateOptinRequest) { (response, data, error) in

                if let optinError = error, let inResponse = response  {
                    let parsedError = PIMErrorBuilder.parsePIMError(error: optinError, networkResponse: inResponse) ?? PIMErrorBuilder.buildPIMMarketingOptinError()
                    PIMUtilities.tagUDIError(.technicalError, inError: parsedError, errorType: PIMConstants.TaggingKeys.MARKETINGOPTIN_SESSION, serverName: nil)
                    completion(false, parsedError)
                }
                PIMUtilities.tagEvent(consentGiven ? PIMConstants.TaggingKeys.MARKETING_OPTIN : PIMConstants.TaggingKeys.MARKETING_OPTOUT)
                
                self.requestUserProfile(authStatePresent) { (userProfile, error) in
                    guard userProfile != nil && error == nil else {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
            }
        }, replacement: nil)
    }
    
    func logoutSession(_ completion:@escaping (_ error: NSError?) -> Void) {
        
        guard let authStatePresent = authState else {
            let error = PIMErrorBuilder.buildUDIUserNotLoggedInError()
            completion(error)
            return
        }
        let restClient = PIMRestClient(self.restClient)
        let logoutRequest = LogoutRequest(authStatePresent)
        
        restClient.invokeLogoutRequest(logoutRequest) { [weak self] (data, response, inError) in
            if let logoutError = inError {
                PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "user log out failed \(logoutError.localizedDescription)")
                PIMUtilities.tagUDIError(.technicalError, inError: logoutError as NSError, errorType: PIMConstants.TaggingKeys.LOGOUT_SESSION, serverName: nil)
                let error = PIMErrorBuilder.buidNetworkError(httpCode: (logoutError as NSError?)?.code ?? PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue)
                completion(error)
                return
            }
            self?.clearUserDataOnLogout()
            completion(nil)
        }
    }
    
    func getUserLoggedInState() -> UserLoggedInState {
        guard authState != nil && oidcUser != nil else {
            return UserLoggedInState.userNotLoggedIn
        }
        return UserLoggedInState.userLoggedIn
    }
    
    
    func refreshAccessToken(_ completion:@escaping (_ isRefreshed: Bool, _ error: Error?) -> Void) {
        
        guard let authStatePresent = authState else {
            let error = PIMErrorBuilder.buildUDIUserNotLoggedInError()
            completion(false, error)
            return
        }
        self.refreshCount = 0;
        self.refreshCompletionHandler = completion;
        self.performRefresh(authStatePresent)
    }
    
    private func performRefresh(_ authState:OIDAuthState) {
        let authManager = PIMAuthManager()
        authManager.refreshAccessToken(authState, delegate: self)
    }
    
    func refreshSessionStatus(_ authStateResponse:OIDAuthState, _ isRefreshed: Bool, _ error: Error?) {
        if error == nil {
            self.authState = authStateResponse
            if let activeSubUUID = PIMDefaults.getSubUUID() {
                self.clearAuthStateFromStorage(activeSubUUID)
                self.saveAuthStateToStorage(authStateResponse, activeSubUUID)
                self.instantiateOIDCUser(activeSubUUID: activeSubUUID)
            }
        } else {
            PIMUtilities.tagUDIError(.technicalError, inError: error! as NSError, errorType: PIMConstants.TaggingKeys.REFRESH_SESSION, serverName: nil)
            if (true == self.shouldRetryTheRefresh(error: error!)) {
                //Auth state will not be nil as its checked before coming to this.
                self.performRefresh(self.authState!)
                return;
            }
        }
        self.refreshCompletionHandler?(isRefreshed,error)
        self.refreshCompletionHandler = nil;
    }
    
    
    private func shouldRetryTheRefresh(error:Error) -> Bool {
        var shouldRetry = true
        // Other than server and network error dont retry refresh
        let errorCodes = [PIMMappedError.PIMServerError.rawValue,PIMMappedError.PIMOIDErrorCodeServerError.rawValue,PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue,PIMMappedError.PIMOIDErrorCodeOAuthServerError.rawValue,PIMMappedError.PIMOIDErrorCodeOAuthAuthorizationServerError.rawValue]
        if ((self.refreshCount >= 2) || (!errorCodes.contains((error as NSError).code)))  {
            self.refreshCount = 0;
            shouldRetry = false
            return shouldRetry;
        }
        
        self.refreshCount += 1;
        return shouldRetry
    }

    
}

extension PIMUserManager {
    
    private func instantiateOIDCUser(activeSubUUID:String) {
        let userDetailsJson = fetchUserProfileFromStorage(activeSubUUID)
        oidcUser = PIMOIDCUserProfile(authState, userProfileJson: userDetailsJson)
    }
    
    // Note: iOS using using secure storage for the Auth state and encrypted data storage for the user profile
    func saveAuthStateToStorage(_ oidState: OIDAuthState,_ sub:String?) {
        do{
            let aKey = PIMDefaults.userSubUUIDKey + authStateKeyConstant
            try self.appInfra.storageProvider.storeValue(forKey: aKey , value: oidState)
            authState = oidState
        }catch{
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "saving appauth to storage failed: \(error.localizedDescription)")
        }
    }
    
    func saveUserProfileToStorage(_ userProfile:Any,_ sub:String?) {
        guard let profileData = try? JSONSerialization.data(withJSONObject:userProfile)  else {
            return
        }
        do {
            let aKey = PIMDefaults.userSubUUIDKey + userProfileKeyConstant
            let aes = try PIMAESEncryptor(keyString: aKey)
            let encryptedData: Data = try aes.encrypt(profileData)
            try appInfra.storageProvider.storeData(toFile:"PIM/UserDetails/uuid_\(sub ?? "")", type:"pim", data:encryptedData)
            oidcUser = PIMOIDCUserProfile(authState, userProfileJson: profileData)
        } catch {
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "saving user profile to storage failed: \(error.localizedDescription)")
        }
    }
    
    @objc func fetchAuthStateFromStorage(_ sub: String) -> OIDAuthState? {
        let aKey = PIMDefaults.userSubUUIDKey + authStateKeyConstant
        let authState = try? self.appInfra.storageProvider.fetchValue(forKey: aKey)
        return authState as? OIDAuthState
    }
    
    func fetchUserProfileFromStorage(_ sub: String) -> Data? {
        do {
            let encryptedData = try? appInfra.storageProvider.fetchData(fromFile:"PIM/UserDetails/uuid_\(sub)", type: "pim")
            if encryptedData != nil {
                let aKey = PIMDefaults.userSubUUIDKey + userProfileKeyConstant
                let aes = try PIMAESEncryptor(keyString: aKey)
                let userProfile: Data = try aes.decrypt(encryptedData as! Data)
                return userProfile
            }
        }catch {
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "user profile fetching failed \(error.localizedDescription)")
        }
        return nil
    }
    
    func clearUserProfileFromStorage(_ sub: String) {
        do {
            try appInfra.storageProvider.removeFile(fromPath: "PIM/UserDetails/uuid_\(sub)", type: "pim")
        }catch {
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMUserManager", message: "clear user profile from storage failed \(error.localizedDescription)")
        }
    }
    
    func clearAuthStateFromStorage(_ sub: String) {
        appInfra.storageProvider.removeValue(forKey: authStateKeyConstant)
    }
    
    func clearUserDataOnLogout() {
        guard let activeSubUUID = PIMDefaults.getSubUUID() else {
            return
        }
        clearAuthStateFromStorage(activeSubUUID)
        clearUserProfileFromStorage(activeSubUUID)
        PIMDefaults.clearSubUUID()
        PIMUserManager.clearMigrationUserFlag()
        authState = nil
        oidcUser = nil
    }
    
}

//Migration helper methods
extension PIMUserManager {
    
    class func setMigrationUserFlag() {
        UserDefaults.standard.set(PIMConstants.Parameters.MIGRATION_FLAG_VALUE, forKey: PIMConstants.UserCustomClaims.MIGRATION_KEY)
        UserDefaults.standard.synchronize()
    }
    
    class func clearMigrationUserFlag() {
        UserDefaults.standard.set(nil, forKey: PIMConstants.UserCustomClaims.MIGRATION_KEY)
        UserDefaults.standard.synchronize()
    }
    
    class func isUserMigratedFromJR() -> Bool {
        var wasJRUSer = false
        let flag = UserDefaults.standard.string(forKey: PIMConstants.UserCustomClaims.MIGRATION_KEY)
        
        if flag == PIMConstants.Parameters.MIGRATION_FLAG_VALUE {
            wasJRUSer = true
        }
        
        return wasJRUSer
    }
    
}
