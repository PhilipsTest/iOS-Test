/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import libPhoneNumber_iOS

protocol MECAddressValidator: NSObjectProtocol {
    var validationMessage: String? { get set }
    var englishValidationMessage: String? { get set }
    func fetchValidatationDetailsFor(textFieldText: String?, locale: String) -> String?
}

class MECBlankFieldValidator: NSObject, MECAddressValidator {
    var validationMessage: String?
    var englishValidationMessage: String?

    func fetchValidatationDetailsFor(textFieldText: String?, locale: String) -> String? {
        return textFieldText?.isEmpty == true ? validationMessage : nil
    }
}

class MECAddressPhoneFieldValidator: NSObject, MECAddressValidator {
    var validationMessage: String?
    var englishValidationMessage: String?

    func fetchValidatationDetailsFor(textFieldText: String?, locale: String) -> String? {
        let phoneUtil = NBPhoneNumberUtil()
        let phoneNumber: NBPhoneNumber? = try? phoneUtil.parse(textFieldText, defaultRegion: locale)
        return !phoneUtil.isValidNumber(phoneNumber) ? validationMessage : nil
    }
}

class MECAddressValidationFactory: NSObject {

    static func fetchValidatorFor(validationType: String) -> MECAddressValidator? {
        switch validationType {
        case MECConstants.MECAddressValidationBlankType:
            return MECBlankFieldValidator()
        case MECConstants.MECAddressValidationPhoneType:
            return MECAddressPhoneFieldValidator()
        default:
            return nil
        }
    }
}
