//
//  PPRError.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

/// enum for Errors in Product Registration.
/// - Since: 1.0.0
@objc public enum PPRError:Int {
    /// No internet connection available.
    /// - Since: 1.0.0
    case NO_INTERNET_CONNECTION = -1009
    /// Invalid input parameters.
    /// - Since: 1.0.0
    case PARAMETER_INVALID = 400
    /// User access token is invalid.
    /// - Since: 1.0.0
    case ACCESS_TOKEN_INVALID = 403
    /// Entered CTN doesn't exist.
    /// - Since: 1.0.0
    case CTN_NOT_EXIST = 404
    /// Input paramteres validation failed.
    /// - Since: 1.0.0
    case INPUT_VALIDATION_FAILED = 422
    /// Internal server error.
    /// - Since: 1.0.0
    case INTERNAL_SERVER_ERROR = 500
    /// Server request timed out.
    /// - Since: 1.0.0
    case REQUEST_TIME_OUT = 504
    /// Input serial number is invalid.
    /// - Since: 1.0.0
    case INVALID_SERIAL_NUMBER
    /// Date of purchase of the product is required.
    /// - Since: 1.0.0
    case REQUIRED_PURCHASE_DATE
    /// Input serial number and purchase date is wrong.
    /// - Since: 1.0.0
    case INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE
    /// User data interface is Nil.
    /// - Since: 1903.0
    case USER_DATA_INTERFACE_NIL
    /// Service url is Nil.
    /// - Since: 1903.0
    case SERVICE_URL_NOT_PRESENT
    /// No valid user logged in.
    /// - Since: 1.0.0
    case USER_NOT_LOGGED_IN = 1001
    /// CTN is not entered. It's mandatory.
    /// - Since: 1.0.0
    case CTN_NOT_ENTERED
    /// Product is already registered.
    /// - Since: 1.0.0
    case PRODUCT_ALREADY_REGISTERD
    /// Invalid purchase date entered.
    /// - Since: 1.0.0
    case INVALID_PURCHASE_DATE
    /// Unknown error occured.
    /// - Since: 1.0.0
    case UNKNOWN
    
    var domain: String {
        switch self {
        case .NO_INTERNET_CONNECTION:return LocalizableString(key: "PRG_No_Internet_Title")
        case .PARAMETER_INVALID:return LocalizableString(key: "PRG_Authentication_Fail_Title")
        case .ACCESS_TOKEN_INVALID:return LocalizableString(key: "PRG_Authentication_Fail_Title")
        case .CTN_NOT_EXIST:return LocalizableString(key: "PRG_Product_Not_Found_Title")
        case .INPUT_VALIDATION_FAILED:return LocalizableString(key: "PRG_Communication_Err_Title")
        case .INTERNAL_SERVER_ERROR:return LocalizableString(key: "PRG_Communication_Err_Title")
        case .REQUEST_TIME_OUT:return LocalizableString(key: "PRG_Network_Err_Title")
        case .INVALID_SERIAL_NUMBER:return LocalizableString(key: "PRG_Invalid_SerialNum_Title")
        case .REQUIRED_PURCHASE_DATE:return LocalizableString(key: "PRG_Req_Purchase_Date_Title")
        case .USER_DATA_INTERFACE_NIL:return "User Data Interface dependency is null"
        case .SERVICE_URL_NOT_PRESENT:return "Service Url not present"
        case .USER_NOT_LOGGED_IN:return "user not loggedin"
        case .INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE:return "\(LocalizableString(key: "PRG_Invalid_SerialNum_Title")) & \(LocalizableString(key: "PRG_Req_Purchase_Date_Title"))"
        case .CTN_NOT_ENTERED:return LocalizableString(key: "PRG_Missing_Ctn_Title ")
        case .PRODUCT_ALREADY_REGISTERD:return LocalizableString(key: "PRG_Already_Registered_title")
        case .INVALID_PURCHASE_DATE:return LocalizableString(key: "PRG_Invalid_Date_Title")
        case .UNKNOWN:return LocalizableString(key: "PRG_Communication_Err_Title")
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .NO_INTERNET_CONNECTION:return LocalizableString(key: "PRG_No_Internet_ErrorMsg")
        case .PARAMETER_INVALID:return LocalizableString(key: "PRG_Authentication_ErrMsg")
        case .ACCESS_TOKEN_INVALID:return LocalizableString(key: "PRG_Authentication_ErrMsg")
        case .CTN_NOT_EXIST:return LocalizableString(key: "PRG_Product_Not_Found_ErrMsg")
        case .INPUT_VALIDATION_FAILED:return LocalizableString(key: "PRG_Unable_Connect_Server_ErrMsg")
        case .INTERNAL_SERVER_ERROR:return LocalizableString(key: "PRG_Unable_Connect_Server_ErrMsg")
        case .REQUEST_TIME_OUT:return LocalizableString(key: "PRG_Network_ErrMsg")
        case .INVALID_SERIAL_NUMBER:return LocalizableString(key: "PRG_Invalid_SerialNum_ErrMsg")
        case .REQUIRED_PURCHASE_DATE:return LocalizableString(key: "PRG_Invalid_SerialNum_ErrMsg")
        case .USER_DATA_INTERFACE_NIL:return "User Data Interface dependency is null"
        case .SERVICE_URL_NOT_PRESENT:return "Service Url not present"
        case .USER_NOT_LOGGED_IN:return "user not loggedin"
        case .INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE:return "\(LocalizableString(key: "PRG_Invalid_SerialNum_ErrMsg")) & \(LocalizableString(key: "PRG_Invalid_SerialNum_ErrMsg"))"
        case .CTN_NOT_ENTERED:return LocalizableString(key: "PRG_Missing_Ctn_ErrMsg ")
        case .PRODUCT_ALREADY_REGISTERD:return LocalizableString(key: "PRG_Already_Registered_ErrMsg")
        case .INVALID_PURCHASE_DATE:return LocalizableString(key: "PRG_Invalid_Date_ErrMsg")
        case .UNKNOWN:return LocalizableString(key: "PRG_Unable_Connect_Server_ErrMsg")
        }
    }
}
