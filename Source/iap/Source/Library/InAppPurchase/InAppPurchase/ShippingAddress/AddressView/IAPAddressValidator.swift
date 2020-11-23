/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import libPhoneNumber_iOS

enum Salutation: String {
    case mr = "mr."
    case ms = "ms."

    func getLocalizedText() -> String? {
        switch self {
        case .mr:
            return IAPLocalizedString("iap_mr")
        case .ms:
            return IAPLocalizedString("iap_mrs")
        }
    }
}

class IAPAddressValidator: NSObject {

    func showPhoneNumberFieldError(_ textField: UITextField, country: String?) {
        guard let tempTextFld = textField as? UIDTextField, let text = tempTextFld.text else {
            return
        }
        let isValid = isValidMobileNumber(text, country: country)
        if isValid == false {
            tempTextFld.setValidationView(true)
            tempTextFld.validationMessage = IAPLocalizedString("iap_phone_error") ?? ""
        } else {
            tempTextFld.setValidationView(false)
        }
    }

    func showTextFieldError(_ textField: UITextField) {
        guard let inTextField = textField as? UIDTextField else {
            return
        }
        if inTextField.validate(false) {
            inTextField.setValidationView(false)
        } else {
            inTextField.setValidationView(true)
            inTextField.validationMessage = getErrorValidationMessage(textFieldTag: inTextField.tag)
        }
    }
    
    func getErrorValidationMessage(textFieldTag: Int) -> String {
        let errorValidationMessageDict: NSDictionary = [1: "iap_first_name_error",
                                                        2: "iap_last_name_error",
                                                        3: "iap_email_error",
                                                        4: "iap_phone_error",
                                                        5: "iap_houseNumber_error",
                                                        6: "iap_address_error",
                                                        7: "iap_address_error",
                                                        8: "iap_town_error",
                                                        9: "iap_postal_code_error",
                                                        11: "iap_country_error"]
        guard let validationErrorKey = errorValidationMessageDict[textFieldTag] as? String,
            let validationErrorMsg = IAPLocalizedString(validationErrorKey) else {
                return ""
        }
        return validationErrorMsg
    }

    func isValidMobileNumber(_ mobileNo: String?, country: String?) -> Bool {
        guard let mobileNumber = mobileNo else { return false }
        let phoneUtil = NBPhoneNumberUtil()
        let anError: Error? = nil
        let localeCode = country ?? IAPConfiguration.sharedInstance.locale
        let countryCode = localeCode?.iapCountryCode
        let phoneNumber: NBPhoneNumber? = try? phoneUtil.parse(mobileNumber, defaultRegion: countryCode)
        if anError == nil {
            return phoneUtil.isValidNumber(phoneNumber)
        } else {
            return false
        }
    }
}
