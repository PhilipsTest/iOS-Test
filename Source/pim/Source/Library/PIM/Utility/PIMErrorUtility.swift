/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

public enum PIMMappedError: Int {
    
    /* Mapped OIDErrorCode */
    /**
    Indicates a problem parsing an OpenID Connect Service Discovery document.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeInvalidDiscoveryDocument                    = 7000
    
    /**
    Indicates the user manually canceled the OAuth authorization code flow.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeUserCanceledAuthorizationFlow               = 7001
    
    /**
    Indicates an OAuth authorization flow was programmatically cancelled.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeProgramCanceledAuthorizationFlow            = 7002
    
    /**
    Indicates a network error or server error occurred.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeNetworkError                                = 7003
    
    /**
    Indicates a server error occurred.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeServerError                                 = 7004
    
    /**
    Indicates a problem occurred deserializing the response/JSON.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeJSONDeserializationError                    = 7005
    
    /**
    Indicates a problem occurred constructing the token response from the JSON.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeTokenResponseConstructionError              = 7006
    
    /**
    UIApplication.openURL: returned NO when attempting to open the authorization
    request in mobile Safari.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeSafariOpenError                             = 7007
    
    /**
    NSWorkspace.openURL returned NO when attempting to open the authorization
    request in the default browser.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeBrowserOpenError                            = 7008
    
    /**
    Indicates a problem when trying to refresh the tokens.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeTokenRefreshError                           = 7009
    
    /**
    Indicates a problem occurred constructing the registration response from the JSON.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeRegistrationResponseConstructionError       = 7010
    
    /**
    Indicates a problem occurred deserializing the response/JSON.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeJSONSerializationError                      = 7011
    
    /**
    AppAuth ID Token did not parse.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeIDTokenParsingError                         = 7012
    
    /**
    The ID Token did not pass validation (e.g. issuer, audience checks).
    - Since: 1904.0
    */
    case PIMOIDErrorCodeIDTokenFailedValidationError                = 7013
    
    /* Mapped OIDErrorCodeOAuth */
    /**
    Oauth invalid request.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidRequest                         = 7100
    
    /**
    Unauthorized client.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthUnauthorizedClient                     = 7101
    
    /**
    Indicates Oauth access denied.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAccessDenied                           = 7102
    
    /**
    Unsupported response type.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthUnsupportedResponseType                = 7103
    
    /**
    Invalid scope.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidScope                           = 7104
    
    /**
    Oauth server error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthServerError                            = 7105
    
    /**
    Server temporarily unavailable.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTemporarilyUnavailable                 = 7106
    
    /**
    Invalid client.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidClient                          = 7107
    
    /**
    Invalid grant type.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidGrant                           = 7108
    
    /**
    Unsupported grant type.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthUnsupportedGrantType                   = 7109
    
    /**
    Invalid redirect URI.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidRedirectURI                     = 7110
    
    /**
    Invalid client metadata.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthInvalidClientMetadata                  = 7111
    
    /**
    An authorization error occurring on the client rather than the server
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthClientError                            = 7112
    
    /**
    Some other error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthOther                                  = 7113
    
    /* Mapped OIDErrorCodeOAuthToken */
    /**
    Indicates invalid token request.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenInvalidRequest                    = 7200
    
    /**
    Indicates invalid client
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenInvalidClient                     = 7201
    
    /**
    Indicates invalid grant.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenInvalidGrant                      = 7202
    
    /**
    Indicates unauthorized client.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenUnauthorizedClient                = 7203
    
    /**
    Indicates unsupported grant type.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenUnsupportedGrantType              = 7204
    
    /**
    Indicates invalid scope.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenInvalidScope                      = 7205
    
    /**
    Indicates clinet error occured not server error.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenClientError                       = 7206
    
    /**
    Indicates some other error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthTokenOther                             = 7207
    
    /* Mapped OIDErrorCodeOAuthRegistration */
    /**
    Indicates invalid registration request.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthRegistrationInvalidRequest             = 7300
    
    /**
    Indicates invalid redirect URI.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthRegistrationInvalidRedirectURI         = 7301
    
    /**
    Indicates invalid client metadata.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthRegistrationInvalidClientMetadata      = 7302
    
    /**
    Indicates client error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthRegistrationClientError                = 7303
    
    /**
    Indicates some unknown error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthRegistrationOther                      = 7304
    
    /* Mapped OIDErrorCodeOAuthAuthorization */
    /**
    Indicates invalid authorization request.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationInvalidRequest            = 7400
    
    /**
    Indicates unauthorized client.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationUnauthorizedClient        = 7401
    
    /**
    Indicates authorization access denied.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationAccessDenied              = 7402
    
    /**
    Indicates unsupported response type.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationUnsupportedResponseType   = 7403
    
    /**
    Indicates invalid scope.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationAuthorizationInvalidScope = 7404
    
    /**
    Indicates authorization server error occured.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationServerError               = 7405
    
    /**
    Indicates authorization server temporarily unavailable.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationTemporarilyUnavailable    = 7406
    
    /**
    Indicates an authorization error occurring on the client rather than the server. For example,
    due to a state mismatch or client misconfiguration. Should be treated as an unrecoverable
    authorization error.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationClientError               = 7407
    
    /**
    Indicates an OAuth error as per RFC6749, but the error code was not in our
    list. It could be a custom error code, or one from an OAuth extension.
    We assume such errors are not transient.
    - Since: 1904.0
    */
    case PIMOIDErrorCodeOAuthAuthorizationOther                     = 7408
    
    /* CIM General erros mapped */
    /**
    Indicates migration from legacy UR to UDI failed
    - Since: 1904.0
    */
    case PIMMigrationFailedError    = 7500
    
    /**
    Indicates updating marketing optin error.
    - Since: 1904.0
    */
    case PIMMarketingOptinError     = 7501
    
    /**
    Indicates UDI service discovery download error.
    - Since: 1904.0
    */
    case PIMSDDownloadError         = 7600
    
    /**
    Indicates failed to download OIDC urls.
    - Since: 1904.0
    */
    case PIMOIDCDownloadError       = 7601
    
    /**
    Indicates UDI refresh token is invalid.
    - Since: 1904.0
    */
    case PIMInvalidRefreshToken     = 7602
    
    /**
    Indicates UDI refresh token api failed.
    - Since: 1904.0
    */
    case PIMRefreshTokenFailed      = 7603
    
    /**
    Indicates UDI access token is expired.
    - Since: 1904.0
    */
    case PIMAccessTokenExpired      = 7604
    
    /**
    Indicates no request for redirection.
    - Since: 1904.0
    */
    case PIMNoRequestForRedirection = 7605
    
    /**
    Indicates invalid redirect URL.
    - Since: 1904.0
    */
    case PIMInvalidRedirectionURL   = 7606
    
    /**
    Indicates any server error happened.
    - Since: 1904.0
    */
    case PIMServerError             = 7607
    
    /**
    Indicates nvalid fields passed to get user details.
    - Since: 1904.0
    */
    case PIMInvalidFields           = 1000
    
    /**
    Indicates user is not logged in.
    - Since: 1904.0
    */
    case PIMUserNotLoggedIn         = 1001
}
