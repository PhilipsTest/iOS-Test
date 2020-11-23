//
//  UserDataInterface.swift
//  PlatformInterfaces
//
//  Created by Nikilesh on 2/14/18.
//  Copyright © 2018 Philips.All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import UIKit
import Foundation

/**
 * confirm to this protocol for getting or updating user details.
 * - Since 2018.1.0
 */
@objc public protocol UserDataInterface {
    
    /**
     * To check whether current access token is OIDC token or not.
     * - Since 2019.3.0
     */
    @objc func isOIDCToken() -> Bool
    
    /**
     * Call this method to logout currently logged in user. User will be logged out of both Janrain and HSDP (if config provided) backends.
     * This is an **asynchronous** call. Please implement appropriate `UserDataInterfaceDelegate` callbacks to be informed about success or failure of this action.
     * - Since 2018.1.0
     */
    @objc func logoutSession()
    
    /**
     * Call this method to refresh session/tokens of currently logged in user. Both Janrain and HSDP sessions will be refreshed.
     * This is an **asynchronous** call. Please implement appropriate `UserDataInterfaceDelegate` callbacks to be informed about success or failure of this action.
     * - Since 2018.1.0
     */
    @objc func refreshSession()
    
    /**
     * Call this method to Refetch logged in user's latest profile from server. This is an **asynchronous** call. Please implement appropriate `UserDetailsDelegate` callbacks to be informed about success or failure of this action.
     * discussion This is an expensive request given that user profile could be very big that includes large size profile image etc. Therefore, it is highly encouraged to call this only when it is must to display latest prfile details to user.
     * - Since 2018.1.0
     */
    @objc func refetchUserDetails()
    
    /**
     * Call this method to update user details. It will not be applicable for new UR(PIM) component.
     * This is an **asynchronous** call. Please implement appropriate `UserDataInterfaceDelegate` callbacks to be informed about success or failure of this action.
     * refer the userDetailsConstants.swift file for all the properties that can be updatable.
     *  - Parameter fields : "Accepts a dictionary which hold user details(with key and their respective values) which is to be updated"
     *  - Since 2018.1.0
     */
    @objc func updateUserDetails(_ fields: Dictionary<String, AnyObject>)
    
    /**
     * Call this method to update receive marketing email.
     * This is an **asynchronous** call. Please implement appropriate `UserDataInterfaceDelegate` callbacks to be informed about success or failure of this action. As a result callback this will call `RefetchUserDetailsDelegate`
     *  - Parameter receiveMarketingEmail : "Accepts a dictionary which hold user details(with key and their respective values) which is to be updated"
     *  - Since 1903
     */
    @objc func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool)
    
    /**
     * Call this method to get user details .
     * if a null input is given all the userdeatils are returned.
     * - Parameter fields : give an array of keys for which you need respective user details.
     * - Return : Dictionary which holds these values for this keys
     * - Since 2018.1.0
     */
    @objc func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject>
    
    /**
     *  Handles hsdp login if the user is not loggedin to hsdp and have configured for skiphsdplogin to true
     *  @param completion returns hsdpLoginSuccess as true or false based on login return
     *  @since 1804.0
     */
    @objc func authorizeLoginToHSDP(withCompletion completion: @escaping (_ success: Bool, _ error: Error?) -> Void)
    
    /**
     * Call this method to check if the logged in state
     * - Return : UserLoggedInState according to user is logged in or not
     * - Since 1804.0
     */
    @objc func loggedInState() -> UserLoggedInState
    
    /**
     * Access Token of user from HSDP Backend. **Sensitive field**. Should not be retrieved if not required. Do not store this access token. Request from DIUser eveytime you need to use it.
     * - Return : HSDP access token in string
     * - Since 2018.1.0
     */
    @objc var hsdpAccessToken: String? { get }
    
    /**
     * Unique identifier of user in HSDP Backend.It is Different from UUID returned from jainrain. These UUIDs are not exchangable.
     * - Return : HSDP UUID access token in string
     * - Since 2018.1.0
     */
    @objc var hsdpUUID: String? { get }
    
    /// Add a listener to get callbacks for user logout and refreshLoginSession.
    /// Adding a listener more than once will not have any effect.
    /// - Parameter listener: listener Object of the class that wants to get the callbacks and implements specified protocols.
    /// - Since 2018.1.0
    @objc func addUserDataInterfaceListener(_ listener: UserDataDelegate)
  
    /// Removes object from list of listeners once it does not need to be informed about user logout and refreshLoginSession. Removes an object that was not added will not
    /// have any effect.
    /// - Parameter listener: listener Object that was listening for user authentication activities.
    ///- Since 2018.1.0
    @objc func removeUserDataInterfaceListener(_ listener: UserDataDelegate)
    
    /**
    * Call this method to launch guest user. This is right now supported in UDI only.
    * - Parameter sourceID :This is unique for each application and should be aligned with backend
    * - Return : Optional UIViewController instance which can be launched by navigation stack
    * - Since 2005.0.0
    */
    @objc optional func instantiateWithGuestUser(_ sourceID: String) -> UIViewController?
}

/**
 * Use this delegate to receive callbacks on user logout
 * - Since 2018.1.0
 */
@objc public protocol LogoutSessionDelegate {
    
    /**
     * Called when logout is success
     * - Since 2018.1.0
     */
    @objc optional func logoutSessionSuccess()
    
    /**
     * Called when logout is failure
     * - Return : error
     * - Since 2018.1.0
     */
    @objc optional func logoutSessionFailed(_ error: Error)
}

/**
 * Use this delegate to receive callbacks on user refresh session
 * - Since 2018.1.0
 */
@objc public protocol RefreshSessionDelegate {
    
    /**
     * Called when Refresh login session is success
     * - Since 2018.1.0
     */
    @objc optional func refreshSessionSuccess()
    
    /**
     * Called when Refresh login session is failed
     * - Return : error
     * - Since 2018.1.0
     */
    @objc optional func refreshSessionFailed(_ error: Error)
    
    /**
     * Called when Refresh login session is Failed and user is logged out
     * - Since 2018.1.0
     */
    @objc optional func forcedLogout()
}

/**
 * Use this delegate to receive callbacks on user details (update and refetch)
 * - Since 2018.1.0
 */
@objc public protocol RefetchUserDetailsDelegate {
    
    /**
     * Called when update is success for allowed userfields.
     * - Since 2018.1.0
     */
    @objc optional func updateUserDetailsSuccess()
    
    /**
     * Called when update is failed for userdetails.
     * - Since 2018.1.0
     */
    @objc optional func updateUserDetailsFailed(_ error: Error)
    
    /**
     * Called when refetch of user information is success
     * - Since 2018.1.0
     */
    @objc optional func refetchUserDetailsSuccess()
    
    /**
     * Called when refetch of user information is failed
     * - Since 2018.1.0
     */
    @objc optional func refetchUserDetailsFailed(_ error: Error)
}

/**
 * Use this delegate to receive callbacks on logoutSessionDelegate, refreshSessionDelegate and userDetailsDelegate
 * - Since 1903.0
 */
@objc public protocol UserDataDelegate: LogoutSessionDelegate, RefreshSessionDelegate, RefetchUserDetailsDelegate {
    
}


/**
 * Use this delegate to handle HSDP requests.
 * - Since 1906.0.0
 */
@objc public protocol HSDPUserDetailsProtocol {
    
    /**
     * Call to refresh HSDP session
     * - Since 1906.0.0
     */
    @objc optional func refreshHSDPSession()
    
      /// Add a listener to get callbacks for user  HSDP refreshLoginSession.
      /// Adding a listener more than once will not have any effect.
      /// - Parameter listener: listener Object of the class that wants to get the callbacks and implements specified protocols.
      /// - Since 1906.0.0
      @objc func addHSDPUserDataInterfaceListener(_ listener: HSDPRefreshSessionResultDelegate)
    
      /// Removes object from list of listeners once it does not need to be informed about user HSDP refreshLoginSession. Removes an object that was not added will not
      /// have any effect.
      /// - Parameter listener: listener Object that was listening for user HSDP activities.
      ///- Since 1906.0.0
      @objc func removeHSDPUserDataInterfaceListener(_ listener: HSDPRefreshSessionResultDelegate)
    
}


/**
 * Use this delegate to receive callbacks on user logout
 * - Since 1906.0.0
 */
@objc public protocol HSDPRefreshSessionResultDelegate {
    
    /**
     * Called when HSDP refresh is success
     * - Since 1906.0.0
     */
    @objc optional func refreshHSDPSessionSucceed()
    
    /**
     * Called when HSDP refresh session failed is failure
     * - Return : error
     * - Since 1906.0.0
     */
    @objc optional func refreshHSDPSessionFailed(_ error: Error)
    
    /**
     * Called when HSDP refresh session failed is failure
     * - Return : error
     * - Since 1906.0.0
     */
    @objc optional func hsdpUserSessionInvalid(_ error: Error)

}
