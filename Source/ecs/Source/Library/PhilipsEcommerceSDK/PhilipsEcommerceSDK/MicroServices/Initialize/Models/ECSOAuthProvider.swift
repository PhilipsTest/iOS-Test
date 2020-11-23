/* Copyright (c) Koninklijke Philips N.V., 2019
  * All rights are reserved. Reproduction or dissemination
  * in whole or in part is prohibited without the prior written
  * consent of the copyright holder.
  */

import Foundation

/**
This enum holds all the supported Clinet Ids for User Authentication to use ECS Microservices.
 Currently both OIDC and Janrain Login uses same client ID
- Since: 2002.0.0
*/
public enum ECSOAuthClientID: String {

    /**
    * Client ID for janrain
    - Since: 2002.0.0
    */
    case JANRAIN = "inApp_client" // Add new cases, if a different Client ID will be added, eg: OIDC
}

/**
This enum holds all the supported Grant types for User Authentication to use ECS Microservices
- Since: 2002.0.0
*/
public enum ECSOAuthGrantType: String {

    /**
    * This case sets the Grant type for Janrain type login
    - Since: 2002.0.0
    */
    case JANRAIN = "janrain"

    /**
    * This case sets the Grant type for oidc type login
    - Since: 2002.0.0
    */
    case OIDC = "oidc"
}

/// This class provides information needed for OAuth
@objcMembers public class ECSOAuthProvider: NSObject {

    /// Access token which needs for OAuth with Hybris
    /// - Since: 1905.0.0
    public var token: String!

    /// Client id which is registered in Hybris
    /// - Since: 1905.0.0
    public var clientID: ECSOAuthClientID!

    /// Client secret
    /// - Since: 1905.0.0
    public var clientSecret: String!

    /// Grant type
    /// - Since: 2002.0.0
    public var grantType: ECSOAuthGrantType!

    /**
     This class has to be created by calling this init method
     
     - Parameters:
        - token: Access token needed for Hybris OAuth/Refresh OAuth. **This parameter is mandatory**
        - clientID: Client id which should be used for Hybris OAuth with Janrain/OIDC. Default value is JanrainClientID
        - clientSecret: Client Secret which should be used for Hybris OAuth with Janrain/OIDC.
                        Default value is set inside ECS
        - grantType: Grant type which should be used for Hybris OAuth with Janrain/OIDC. Default value is Janrain Grant Type.
     - Since: 1905.0.0
    */
    public init(token: String,
                clientID: ECSOAuthClientID = .JANRAIN,
                clientSecret: String = "",
                grantType: ECSOAuthGrantType = .JANRAIN) {
        self.token = token
        self.clientID = clientID
        self.clientSecret = clientSecret.count > 0 ? clientSecret : ECSUtility.fetchDefaultClientSecret()
        self.grantType = grantType
        super.init()
    }

    func verifyOAuthData() -> Error? {
        return (token.count > 0 &&
            clientID.rawValue.count > 0 &&
            clientSecret.count > 0) ? nil :
            ECSHybrisError(with: .ECSOAuthDetailError).hybrisError
    }
}
