//
//  PPRTagging.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

internal extension PPRProductRegistrationUIHelper {
    func trackProductRegistrationStart() {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRSpecialEvents, andParamValue: PPRTagging.kPPRStart)
    }
}

internal extension PPRBaseViewController {
    func trackPage(name: String) {
        PPRInterfaceInput.sharedInstance.tagging.trackPage(withInfo: name, params: nil)
    }
}

internal extension PPRWelcomeViewController {
    func trackPageName() {
        self.trackPage(name: PPRTagging.kPPRBenefitsScreen)
    }
}

internal extension PPRRegisterProductsViewController {
    func trackPageName() {
        self.trackPage(name: PPRTagging.kPPRProductsScreen)
    }
    
    func trackProductRegistrationSuccess() {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRSpecialEvents, andParamValue: PPRTagging.kPPRSuccess)
    }
    
    func trackAppNotification(title:String ,selected:String ) {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, params:[PPRTagging.kPPRAppNotification:"\(title)",PPRTagging.kPPRAppNotificationResponse:"\(selected)"])
    }
    
    func trackRequiredPurchaseDate() {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRSpecialEvents, andParamValue: PPRTagging.kPPRRequiredPurchaseDate)
    }
    
    func trackProductAlreadyRegistered() {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRSpecialEvents, andParamValue: PPRTagging.kPPRProductAlreadyRegistered)
    }
    
    func trackRequiredSerialNumber() {
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRSpecialEvents, andParamValue: PPRTagging.kPPRRequiredSerialNumber)
    }
    
    func trackError(error: PPRError) {
        let message = getErrorMessageFromPPRError(error: error)
        
        PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRError, andParamValue: message)
    }
    
    private func getErrorMessageFromPPRError(error: PPRError) -> String {
        switch error {
        case PPRError.NO_INTERNET_CONNECTION: return "No internet connection!"
        case PPRError.PARAMETER_INVALID: return "Authentication failure!"
        case PPRError.ACCESS_TOKEN_INVALID: return "Authentication failure!"
        case PPRError.CTN_NOT_EXIST: return "Product not found!"
        case PPRError.INPUT_VALIDATION_FAILED: return "Communication error!"
        case PPRError.INTERNAL_SERVER_ERROR: return "Communication error!"
        case PPRError.REQUEST_TIME_OUT: return "Network Error!"
        case PPRError.INVALID_SERIAL_NUMBER: return "Invalid serial number!"
        case PPRError.REQUIRED_PURCHASE_DATE: return "Invalid purchase date!"
        case PPRError.USER_NOT_LOGGED_IN: return "user not loggedin"
        case PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE: return " Invalid serial number and Invalid purchase date!"
        case PPRError.CTN_NOT_ENTERED: return "Missing CTN"
        case PPRError.PRODUCT_ALREADY_REGISTERD: return "Product registered"
        case PPRError.INVALID_PURCHASE_DATE: return "Invalid Purchase date"
        default: return "Communication error!"
        }
    }
}


internal extension PPRSuccessViewController {
    func trackPageName() {
        self.trackPage(name: PPRTagging.kPPRSuccessScreen)
    }
    
    func trackProductModelName() {
        if let prodcutCtn = self.product?.ctn {
            PPRInterfaceInput.sharedInstance.tagging.trackAction(withInfo: PPRTagging.kPPRSendData, paramKey: PPRTagging.kPPRProductModelName, andParamValue: prodcutCtn)
        }
    }
}

internal extension PPRFindSerialNumberViewController {
    func trackPageName() {
        self.trackPage(name: PPRTagging.kPPRSerialNumber)
    }
}
