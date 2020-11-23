/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

struct PIMConstants {
    //Request or response related constants
    struct Network {
        static let GROUP_NAME                          = "PIM"
        static let CLIENT_ID                           = "clientId"
        static let LEGACY_CLIENT_ID                    = "legacyClientId"
        static let MIGRATION_CLIENT_ID                 = "migrationClientId"
        static let REDIRECT_URI                        = "redirectUri"
        static let TAGGING_RSID                        = "rsids"
        static let ACCESS_TOKEN                        = "accessToken"
        static let APPLICATION_JSON                    = "application/json"
        static let APPLICATION_URL_ENCODED             = "application/x-www-form-urlencoded"
        static let AUTHORIZATION                       = "Authorization"
        static let ACCEPT                              = "Accept"
        static let ACCEPT_ENCODING                     = "Accept-Encoding"
        static let GZIP_ENCODING                       = "gzip"
        static let API_KEY                             = "apiKey"
        static let CONTENT_TYPE                        = "Content-Type"
        static let CONTENT_API_KEY                     = "Api-Key"
        static let CONTENT_API_VERSION                 = "Api-Version"
        static let MARKETING_OPTIN_API_KEY             = "marketingOptinApiKey"
    }
    
    struct UserCustomClaims {
        static let UUID                                = "uuid"
        static let SOCIAL_PROFILES                     = "social_profiles"
        static let RECEIVE_MARKETING_EMAIL             = "consent_email_marketing.opted_in"
        static let RECEIVE_MARKETING_EMAIL_TIMESTAMP   = "consent_email_marketing.timestamp"
        static let MIGRATION_KEY                       = "com.philips.migrator"
    }
    
    struct Parameters {
        static let ID_TOKEN_HINT                       = "id_token_hint"
        static let CLAIMS                              = "claims"
        static let MIGRATION_FLAG_VALUE                = "true"
    }
    
    struct LegacyJanrainKeys {
        static let JANRAIN_CAPTURE_USER                = "registration.captureUser"
        static let JANRAIN_ACCESS_TOKEN                = "access_token"
        static let JANRAIN_REFRESH_SECRET              = "refresh_secret"
        static let JANRAIN_KEYCHAIN_USER               = "capture_user"
        static let JANRAIN_CAPTURE_KEYCHAIN_IDENTIFIER = "capture_tokens.janrain"
    }
    
    struct ServiceIDs {
        static let GUEST_USER_URL                      = "userreg.landing.guestuser.marketingoptin"
        static let JANRAIN_BASE_URL                    = "userreg.janrain.api"
        static let JANRAIN_USER_PROFILE                = "userreg.janrainoidc.userprofile"
        static let JANRAIN_USER_MIGRATION              = "userreg.janrainoidc.migration"
        static let JANRAIN_USER_MARKETINGOPTIN         = "userreg.janrainoidc.marketingoptin"
    }
    
    struct TaggingKeys {
        static let PIL_SERVER                          = "PIL"
        static let MARKETING_OPTIN                     = "remarketingOptIn"
        static let MARKETING_OPTOUT                    = "remarketingOptOut"
        static let REFRESH_SESSION                     = "refresh_session"
        static let LOGOUT_SESSION                      = "logout"
        static let MIGRATION_SESSION                   = "migration"
        static let MARKETINGOPTIN_SESSION              = "marketing_optin"
    }
    
    struct AuthorizationKeys {
        static let PROMPT                              = "prompt"
        static let CLAIMS                              = "claims"
        static let UI_LOCALE                           = "ui_locales"
        static let CONSENTS                            = "consents"
        static let USER_INFO                           = "userinfo"
        static let ANALYTICS                           = "analytics"
        static let ANALYTICS_REPORT_SUITE              = "analytics_report_suite_id"
    }
    
    struct Keys {
        static let AUTH_FLOW_KEY                       = "com.flow"
    }
    
}
