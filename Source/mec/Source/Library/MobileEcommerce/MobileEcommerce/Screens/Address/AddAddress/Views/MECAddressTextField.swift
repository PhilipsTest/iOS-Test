/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECAddressTextField: UIDTextField, MECAnalyticsTracking {
    @IBInspectable var addressTextFieldIdentifier: String?
    var validators: [MECAddressValidator]? = []

    override var text: String? {
        didSet {
            guard let text = text, text.count > 0 else {
                return
            }
            configureAppearance()
        }
    }
}

extension MECAddressTextField {

    @discardableResult func validateAndReturnValidationResult(locale: String) -> Bool {
        var isInvalid = false
        if let validators = validators,
            validators.count > 0 {
            for validator in validators {
                if let fieldValidationMessage = validator.fetchValidatationDetailsFor(textFieldText: text, locale: locale),
                    fieldValidationMessage.count > 0 {
                    validationMessage = fieldValidationMessage
                    trackUserError(errorMessage: validator.englishValidationMessage)
                    setValidationView(true, animated: false)
                    isInvalid = true
                    break
                } else {
                    setValidationView(false, animated: false)
                }
            }
        }
        return isInvalid
    }

    func configureAppearance() {
        if state.contains(.disabled) {
            backgroundColor = theme?.textBoxDefaultDisabledBackground
            textColor = theme?.textBoxDefaultDisabledText
        } else {
            backgroundColor = theme?.textBoxDefaultBackground
            textColor = theme?.textBoxDefaultText
        }
    }
}
