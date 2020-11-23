/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

enum MECAddressSalutation: String, MECPopoverDataProtocol {
// swiftlint:disable identifier_name
    case mr = "mr."
    case ms = "ms."
// swiftlint:enable identifier_name
    func titleForItem() -> String {
        var title = ""
        switch self {
        case .mr:
            title = MECLocalizedString("mec_mr")
        case .ms:
            title = MECLocalizedString("mec_mrs")
        }
        return title
    }

    func valueForItem() -> String {
        return self.rawValue
    }
}

extension ECSRegion: MECPopoverDataProtocol {

    func titleForItem() -> String {
        return name ?? ""
    }
}

extension ECSRegion {

    func displayNameFromRegion(fetchedRegions: [ECSRegion]?) -> String? {
        guard name == nil else {
            return name
        }
        guard let regions = fetchedRegions, regions.count > 0 else {
            return nil
        }
        if let matchedRegion = regions.first(where: { $0.isocode == isocode }) {
            return matchedRegion.name
        }
        return isocodeShort
    }
}

extension ECSAddress {

    func constructShippingAddressDisplayString() -> String {
        var formattedAddress = ""
        let regionDisplayName = region?.name ?? region?.isocodeShort
        let countryDisplayName = country?.name ?? country?.isocode
        formattedAddress.appendWith(text: houseNumber, withSuffix: ", ")
        formattedAddress.appendWith(text: line1, withSuffix: ", \n")
        formattedAddress.appendWith(text: line2, withSuffix: ", \n")
        formattedAddress.appendWith(text: town, withSuffix: ", \n")
        formattedAddress.appendWith(text: regionDisplayName, withSuffix: " ")
        formattedAddress.appendWith(text: postalCode, withSuffix: ", ")
        formattedAddress.appendWith(text: countryDisplayName, withSuffix: nil)
        return formattedAddress
    }

    func constructFullName() -> String {
        var fullName = ""
        fullName.appendWith(text: firstName, withSuffix: nil)
        fullName.appendWith(text: lastName, withPrefix: " ")
        return fullName
    }
}

extension ECSDeliveryMode {

    func constructDeliveryModeDetails() -> String {
        var deliveryModeDetail = ""
        deliveryModeDetail.appendWith(text: deliveryCost?.formattedValue, withSuffix: nil)
        deliveryModeDetail.appendWith(text: deliveryModeDescription, withPrefix: " | ")
        return deliveryModeDetail
    }
}

extension ECSPayment {

    func constructCardDetails() -> String {
        guard !isNewPayment() else {
            return card?.name ?? ""
        }
        var cardDetail = ""
        cardDetail.appendWith(text: card?.name ?? card?.type, withPrefix: nil)
        cardDetail.appendWith(text: fetchCardNumber(), withPrefix: " ")
        return cardDetail
    }

    func fetchCardNumber() -> String? {
        return String(cardNumber?.suffix(8) ?? "")
    }

    func constructPaymentValidityDetails() -> String {
        var validityDetail = ""
        validityDetail.appendWith(text: expiryMonth, withPrefix: nil)
        validityDetail.appendWith(text: expiryYear, withPrefix: "/")
        return validityDetail.count > 0 ? "\(MECLocalizedString("mec_valid_until")) \(validityDetail)" : validityDetail
    }

    func isNewPayment() -> Bool {
        return paymentId == MECConstants.MECNewCardIdentifier
    }

    func fetchAccountHolderName() -> String? {
        return accountHolderName ?? billingAddress?.constructFullName()
    }
}

// MARK: - PIL Extensions

extension ECSPILAddress {

    func constructShippingAddressDisplayString() -> String {
        var formattedAddress = ""
        let regionDisplayName = region?.name ?? region?.isocodeShort
        let countryDisplayName = country?.name ?? country?.isocode
        formattedAddress.appendWith(text: houseNumber, withSuffix: ", ")
        formattedAddress.appendWith(text: line1, withSuffix: ", \n")
        formattedAddress.appendWith(text: line2, withSuffix: ", \n")
        formattedAddress.appendWith(text: town, withSuffix: ", \n")
        formattedAddress.appendWith(text: regionDisplayName, withSuffix: " ")
        formattedAddress.appendWith(text: postalCode, withSuffix: ", ")
        formattedAddress.appendWith(text: countryDisplayName, withSuffix: nil)
        return formattedAddress
    }

    func constructFullName() -> String {
        var fullName = ""
        fullName.appendWith(text: firstName, withSuffix: nil)
        fullName.appendWith(text: lastName, withPrefix: " ")
        return fullName
    }
}

extension ECSPILDeliveryMode {

    func constructDeliveryModeDetails() -> String {
        var deliveryModeDetail = ""
        deliveryModeDetail.appendWith(text: deliveryCost?.formattedValue, withSuffix: nil)
        deliveryModeDetail.appendWith(text: deliveryModeDescription, withPrefix: " | ")
        return deliveryModeDetail
    }
}
