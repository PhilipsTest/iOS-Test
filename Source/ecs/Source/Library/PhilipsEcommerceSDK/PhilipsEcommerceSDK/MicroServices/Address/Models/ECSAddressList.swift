/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSAddressList
@objcMembers class ECSAddressList: NSObject, Codable {
    var addresses: [ECSAddress]?
}

// MARK: - ECSAddress
@objcMembers public class ECSAddress: NSObject, Codable {

    /// Boolean which tells whether the address is billing address or not
    /// - Since: 1905.0.0
    public var billingAddress: Bool?

    /// Boolean which tells whether the address is default or not
    /// - Since: 1905.0.0
    public var defaultAddress: Bool?

    /// First name of the user,  following characters are not allowed: \") ( * ^ % $ # @ ! + , . ? /  : ; { } [ ] ` ~ =
    /// - Since: 1905.0.0
    public var firstName: String?

    /// Last name of the user, following characters are not allowed: \") ( * ^ % $ # @ ! + , . ? /  : ; { } [ ] ` ~ =
    /// - Since: 1905.0.0
    public var lastName: String?

    /// House number of the address
    /// - Since: 1905.0.0
    public var houseNumber: String?

    /// Formatted address string
    /// - Since: 1905.0.0
    public var formattedAddress: String?

    /// Line 1 of the address
    /// - Since: 1905.0.0
    public var line1: String?

    /// Line 2 of the address
    /// - Since: 1905.0.0
    public var line2: String?

    /// Phone number of the user
    /// - Since: 1905.0.0
    public var phone: String?

    /// First Alerternative phone number of the user
    /// - Since: 1905.0.0
    public var phone1: String?

    /// Second Alerternative phone number of the user
    /// - Since: 1905.0.0
    public var phone2: String?

    /// Postal code of the area, please provide valid postal code while creating this object as its used to calculate the TAX
    /// - Since: 1905.0.0
    public var postalCode: String?

    /// Boolean which tells whether the address is shipping address or not
    /// - Since: 1905.0.0
    public var shippingAddress: Bool?

    /// Localize salutation title, this value is display string need not be set while creating the object
    /// - Since: 1905.0.0
    public var title: String?

    /// salutation code, valid codes are ms. and mr. This field is mandatory which gets updated in server
    /// - Since: 1905.0.0
    public var titleCode: String?

    /// Town
    /// - Since: 1905.0.0
    public var town: String?
    public var visibleInAddressBook: Bool?

    /// Unique address id of the address which will be present in saved address
    /// - Since: 1905.0.0
    public var addressID: String?

    /// Country of the user
    /// - Since: 1905.0.0
    public var country: ECSCountry?

    /// Region of the user
    /// - Since: 1905.0.0
    public var region: ECSRegion?

    static let encoder = JSONEncoder()

    enum CodingKeys: String, CodingKey {
        case addressID = "id"
        case billingAddress, defaultAddress, title, titleCode, town, region, country
        case firstName, formattedAddress, houseNumber, phone2, postalCode
        case lastName, line1, phone, phone1, shippingAddress, visibleInAddressBook
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return addressParameter[key]
    }

    var addressParameter: [String: String] {
        let inDict = try? JSONSerialization.jsonObject(with: ECSAddress.encoder.encode(self))
        guard let addressDict = inDict as? [String: Any] else { return [:] }
        var dict = addressDict

        if let region = dict["region"] as? [String: String],
            let regionISO = region["isocode"] {
            dict["region.isocode"] = regionISO
            dict.removeValue(forKey: "region")
        }

        if let country = dict["country"] as? [String: String],
            let countryISO = country["isocode"] {
            dict["country.isocode"] = countryISO
            dict.removeValue(forKey: "country")
        }

        dict.removeValue(forKey: "id")
        dict.removeValue(forKey: "shippingAddress")
        dict.removeValue(forKey: "billingAddress")
        dict.removeValue(forKey: "visibleInAddressBook")
        dict.removeValue(forKey: "defaultAddress")

        return dict as? [String: String] ?? [:]
    }
}

// MARK: - ECSRegionList
@objcMembers class ECSRegionList: NSObject, Codable {
    var regions: [ECSRegion]?
}

// MARK: - ECSRegion
@objcMembers public class ECSRegion: NSObject, Codable {

    /// Country ISO code
    /// - Since: 1905.0.0
    public var countryISO: String?

    /// shorthand ISO code of the region
    /// - Since: 1905.0.0
    public var isocodeShort: String?

    /**
     ISO code of the region, this field must be set as this gets updated in server
    
      Example iso code for New York is US-NY
     - Since: 1905.0.0
    */
    public var isocode: String?

    /// Region name
    /// - Since: 1905.0.0
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case countryISO = "countryIso"
        case isocode, isocodeShort, name
    }
}

// MARK: - ECSCountry
@objcMembers public  class ECSCountry: NSObject, Codable {

    /**
     ISO code of the country
    
     example US for United States and DE for Germany, this field must be set as this gets updated in server
    - Since: 1905.0.0
     **/
    public var isocode: String?

    /// Country name
    /// - Since: 1905.0.0
    public var name: String?
}
