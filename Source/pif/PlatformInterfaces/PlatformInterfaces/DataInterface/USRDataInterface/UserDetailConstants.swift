//
//  UserDetailConstants.swift
//  PlatformInterfaces
//
//  Created by Nikilesh on 2/14/18.
//  Copyright © 2018 Philips.All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation

@objc public class UserDetailConstants: NSObject {
    @objc public static let GIVEN_NAME                      = "given_name"
    @objc public static let FAMILY_NAME                     = "family_name"
    @objc public static let GENDER                          = "gender"
    @objc public static let EMAIL                           = "email"
    @objc public static let MOBILE_NUMBER                   = "phone_number"
    @objc public static let BIRTHDAY                        = "birthdate"
    @objc public static let RECEIVE_MARKETING_EMAIL         = "consent_email_marketing.opted_in"
    @objc public static let ACCESS_TOKEN                    = "access_token"
    @objc public static let UUID                            = "uuid"
    @objc public static let ID_TOKEN                        = "id_token" // only supported in PIM
    @objc public static let TOKEN_TYPE                      = "token_type" // only supported in PIM
    @objc public static let ACCESS_TOKEN_EXPIRATION_TIME    = "expires_in" // only supported in PIM
    @objc public static let USER_ERROR_DOMAIN               = "URError Domain"
}

@objc public enum UserDetailError: NSInteger {
    case InvalidFields = 1000
    case NotLoggedIn   = 1001
}

/**
 An enum that allows to return the state of the user while logging in.
 
 - userNotLoggedIn:          Informs the state of the user as not logged in.
 - pendingTnC:                  Informs that the terms and conditions acceptance is pending for the user.
 - pendingVerification:       Informs that the verification is pending for the user.
 - pendingHSDPLogin:      Informs that HSDP login is pending for the user.
 - userLoggedIn:                Informs that the user is successfully logged in.
 *
 * @since 1804.0
 */
@objc public enum UserLoggedInState: NSInteger {
    case userNotLoggedIn
    case pendingTnC
    case pendingVerification
    case pendingHSDPLogin
    case userLoggedIn
}
