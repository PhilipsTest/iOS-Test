//
//  PPRErrorHelper.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

class PPRErrorHelper {
    
    func handleError(statusCode: Int, failure: PPRFailure) {
        switch statusCode {
        case PPRError.NO_INTERNET_CONNECTION.rawValue:
            failure(self.createCustomError(error: .NO_INTERNET_CONNECTION))
        case PPRError.PARAMETER_INVALID.rawValue:
            failure(self.createCustomError(error: .PARAMETER_INVALID))
        case PPRError.ACCESS_TOKEN_INVALID.rawValue:
            failure(self.createCustomError(error: .ACCESS_TOKEN_INVALID))
        case PPRError.CTN_NOT_EXIST.rawValue:
            failure(self.createCustomError(error: .CTN_NOT_EXIST))
        case PPRError.INPUT_VALIDATION_FAILED.rawValue:
            failure(self.createCustomError(error: .INPUT_VALIDATION_FAILED))
        case PPRError.INTERNAL_SERVER_ERROR.rawValue:
            failure(self.createCustomError(error: .INTERNAL_SERVER_ERROR))
        case PPRError.REQUEST_TIME_OUT.rawValue:
            failure(self.createCustomError(error: .REQUEST_TIME_OUT))
        case PPRError.INVALID_SERIAL_NUMBER.rawValue:
            failure(self.createCustomError(error: .INVALID_SERIAL_NUMBER))
        case PPRError.REQUIRED_PURCHASE_DATE.rawValue:
            failure(self.createCustomError(error: .REQUIRED_PURCHASE_DATE))
        case PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue:
            failure(self.createCustomError(error: .INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE))
        case PPRError.USER_NOT_LOGGED_IN.rawValue:
            failure(self.createCustomError(error: .USER_NOT_LOGGED_IN))
        case PPRError.CTN_NOT_ENTERED.rawValue:
            failure(self.createCustomError(error: .CTN_NOT_ENTERED))
        case PPRError.PRODUCT_ALREADY_REGISTERD.rawValue:
            failure(self.createCustomError(error: .PRODUCT_ALREADY_REGISTERD))
        case PPRError.INVALID_PURCHASE_DATE.rawValue:
            failure(self.createCustomError(error: .INVALID_PURCHASE_DATE))
        default:
            failure(self.createCustomError(error: .UNKNOWN))
        }
    }
    
    func createCustomError(error:PPRError)->NSError {
        return createCustomError(domain: error.domain,
                                 code: error.rawValue,
                                 userInfo: ["PPRError" as String :error.domain as AnyObject,"NSLocalizedDescription" :error.localizedDescription as AnyObject])
    }
    
    func createCustomError(domain: String,
                                   code: Int,
                                   userInfo: [String:Any])->NSError
    {
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
