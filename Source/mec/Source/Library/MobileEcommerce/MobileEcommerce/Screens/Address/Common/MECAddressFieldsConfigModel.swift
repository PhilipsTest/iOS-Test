/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

enum MECAddressTextFieldInputType: Int {
    case stringType
    case integerType
    case dropDownType
}

enum MECAddressScreenType: Int {
    case addFirstAddress
    case addAddress
    case editAddress
    case addBillingAddress
    case editBillingAddress
}

// MARK: - MECAddressFieldsConfigModel
class MECAddressFieldsConfigModel: NSObject, Codable {
    var addressFields: [MECAddressFieldConfig]?

    enum CodingKeys: String, CodingKey {
        case addressFields = "AddressFields"
    }

    func isRegionSupported(for country: String) -> Bool {
        var isRegionSupported = false
        if let regionField = addressFields?.first(where: { $0.identifier == MECConstants.MECAddressStateKey }),
            let unsupportedLocales = regionField.unsupportedLocales,
            unsupportedLocales.count > 0 {
            isRegionSupported = !unsupportedLocales.contains(where: { return $0.lowercased() == country.lowercased() })
        }
        return isRegionSupported
    }
}

// MARK: - MECAddressFieldConfig
class MECAddressFieldConfig: NSObject, Codable {
    var identifier: String?
    var isEditable: Bool?
    var inputType: Int?
    var validation: [MECAddressFieldValidationModel]?
    var unsupportedLocales: [String]?

    enum CodingKeys: String, CodingKey {
        case identifier = "Identifier"
        case isEditable = "Editable"
        case inputType = "InputType"
        case validation = "ValidationError"
        case unsupportedLocales = "UnsupportedLocales"
    }
}

// MARK: - MECAddressFieldValidationModel
class MECAddressFieldValidationModel: NSObject, Codable {
    var validationType: String?
    var validationMessage: String?

    enum CodingKeys: String, CodingKey {
        case validationType = "ValidationType"
        case validationMessage = "ErrorValidationMessage"
    }
}
