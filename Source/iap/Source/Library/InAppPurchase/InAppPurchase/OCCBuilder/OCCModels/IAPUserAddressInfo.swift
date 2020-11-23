/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

class IAPUserAddress {

    var addressId: String!
    var firstName: String!
    var lastName: String!
    var addressLine1: String!
    var addressLine2: String!
    var postalCode: String!
    var town: String!
    var countryIsoCode: String!
    var countryName: String!
    var defaultAddress: Bool! = false
    var titleCode: String!
    var phone1: String!
    var phone2: String!
    var formattedAddress: String!
    var regionCode: String!
    var regionName: String!
    var houseNumber: String!
    
    convenience init(inDict: [String: AnyObject]) {
        self.init()

        self.addressId         = inDict[IAPConstants.IAPUserAddressKeys.kIdKey] as? String ?? ""
        self.firstName         = inDict[IAPConstants.IAPUserAddressKeys.kFirstNameKey] as? String ?? ""
        self.lastName          = inDict[IAPConstants.IAPUserAddressKeys.kLastNameKey] as? String ?? ""
        let address1           = inDict[IAPConstants.IAPUserAddressKeys.kLine1Key] as? String ?? ""
        self.addressLine1      = address1.replacingOccurrences(of: "null", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        if let lastchar = self.addressLine1.last {
            if [","].contains(lastchar) {
                self.addressLine1 = String(self.addressLine1.dropLast())
            }}
        self.postalCode        = inDict[IAPConstants.IAPUserAddressKeys.kPostalCodeKey] as? String ?? ""

        if let townValue = inDict[IAPConstants.IAPUserAddressKeys.kTownKey] as? String {
            self.town              = townValue
        }

        if let line2 = inDict[IAPConstants.IAPUserAddressKeys.kLine2Key] as? String {
            self.addressLine2      = line2
        }

        if let houseNumber = inDict[IAPConstants.IAPUserAddressKeys.kHouseNumber] as? String {
            self.houseNumber = houseNumber
        }

        if let countryDict     = inDict[IAPConstants.IAPUserAddressKeys.kCountryKey] as? [String: AnyObject] {
            self.countryIsoCode = countryDict[IAPConstants.IAPUserAddressKeys.kIsoCodeKey] as? String
            self.countryName = countryDict[IAPConstants.IAPUserAddressKeys.kNameKey] as? String
        }
        
        if let title = inDict[IAPConstants.IAPUserAddressKeys.kTitleCodeKey] as? String {
            self.titleCode         = title
        }
        
        if let phone = inDict[IAPConstants.IAPUserAddressKeys.kPhone1Key] as? String {
            self.phone1 = phone.replaceCharacter(" ", withCharacter: "")
        }

        if let phone2 = inDict[IAPConstants.IAPUserAddressKeys.kPhone2Key] as? String {
            self.phone2 = phone2.replaceCharacter(" ", withCharacter: "")
        } else {
            self.phone2 = ""
        }
        
        if let regionDict     = inDict[IAPConstants.IAPUserAddressKeys.kRegionKey] as? [String: AnyObject] {
            self.regionName = regionDict[IAPConstants.IAPUserAddressKeys.kNameKey] as? String
            self.regionCode = regionDict[IAPConstants.IAPUserAddressKeys.kIsoCodeKey] as? String
        }
        
        if let address = inDict[IAPConstants.IAPUserAddressKeys.kFormattedAddressKey] as? String {
            self.formattedAddress = address.replacingOccurrences(of: "null", with: "")
        } else {
            if nil != self.addressLine2 {
                guard nil != self.regionName else { self.formattedAddress = self.createFormattedString(); return }
                self.formattedAddress = self.createFormattedStringWithRegion()
            } else {
                guard nil != self.regionName else { self.formattedAddress = self.createFormattedString(); return }
                self.formattedAddress = self.createFormattedStringWithRegion()
            }
        }
    }

    convenience init(address: IAPUserAddress!) {
        self.init()
        if let addressId = address.addressId {
            self.addressId = addressId
        }
        if let firstName = address.firstName {
            self.firstName = firstName
        }
        if let houseNumber = address.houseNumber {
            self.houseNumber = houseNumber
        }
        if let lastName = address.lastName {
            self.lastName = lastName
        }
        if let addressLine1 = address.addressLine1 {
            self.addressLine1 = addressLine1
        }
        if let addressLine2 = address.addressLine2 {
            self.addressLine2 = addressLine2
        }
        if let postalCode = address.postalCode {
            self.postalCode = postalCode
        }
        if let town = address.town {
            self.town = town
        }
        if let countryIsoCode = address.countryIsoCode {
            self.countryIsoCode = countryIsoCode
        }
        if let countryName = address.countryName {
            self.countryName = countryName
        }
        if let defaultAddress = address.defaultAddress {
            self.defaultAddress = defaultAddress
        }
        if let titleCode = address.titleCode {
            self.titleCode = titleCode
        }
        if let phone1 = address.phone1 {
            self.phone1 = phone1
        }
        if let phone2 = address.phone2 {
            self.phone2 = phone2
        }
        if let formattedAddress = address.formattedAddress {
            self.formattedAddress = formattedAddress
        }
        if let regionCode = address.regionCode {
            self.regionCode = regionCode
        }
        if let regionName = address.regionName {
            self.regionName = regionName
        }
    }
}

class IAPUserAddressInfo {
    var address: [IAPUserAddress] = [IAPUserAddress]()
    
    convenience init (inDict: [String: AnyObject]) {
        self.init()
        if let addressDictionary = inDict[IAPConstants.IAPUserAddressKeys.kAddressKey] as? [[String: AnyObject]] {
            self.address = addressDictionary.map { (IAPUserAddress(inDict: $0)) }
        }
    }
}

extension IAPUserAddressInfo {
    func mergeDefaultAddress(_ inDefaultAddress: IAPUserAddress?) {
        guard inDefaultAddress != nil else {
            self.markFirstAddressAsDefault()
            return }
        guard let objectToChange = self.address.filter( {$0.addressId == inDefaultAddress!.addressId} ).first else {
            self.markFirstAddressAsDefault()
            return }
        objectToChange.defaultAddress = true
    }

    func markFirstAddressAsDefault() {
        guard let firstAddress = self.address.first else { return }
        firstAddress.defaultAddress = true
    }
}

extension IAPUserAddress {
    
    func fetchHouseNumber() -> String {
        if let inHouseNumber = self.houseNumber, inHouseNumber.count > 0 {
            return "\(inHouseNumber), "
        }
        return ""
    }
    
    func getDisplayTextForAddress(_ isFormmatedAddressViewForOrderPage: Bool)-> NSMutableAttributedString {
        let formattedFontSize:CGFloat = UIDFontSizeSmall

        let nameString      = self.firstName+" "+self.lastName+"\n"
        // Commented the code for hybris issue to work for html string issue
        // let addressString   = self.formattedAddress.replaceCharacter(", ", withCharacter: ",\n")
        var addressString = self.createFormattedString()
        
        if isFormmatedAddressViewForOrderPage {
            addressString = "\(fetchHouseNumber())\(addressString)"
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = IAPConstants.IAPUserAddressKeys.kAddressLineSpacingCosntant
        
        let nameFont = UIFont(uidFont: .book, size: formattedFontSize)
        let nameColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        var nameAttribute : [NSAttributedString.Key: AnyObject]?
        if let nameFontAttribute = nameFont {
            nameAttribute = [.paragraphStyle: style,
                             .font: nameFontAttribute,
                             .foregroundColor: nameColor!]
        }
        let stringToBeReturned = NSMutableAttributedString(string: nameString, attributes: nameAttribute)
        let addressInfoFont = UIFont(uidFont: .book, size: UIDFontSizeSmall)
        let addressInfoColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        var addressInfoAttribute: [NSAttributedString.Key: AnyObject]?
        if let addressFontAttribute = addressInfoFont {
            addressInfoAttribute = [.paragraphStyle: style,
                                    .font: addressFontAttribute,
                                    .foregroundColor: addressInfoColor!]
        }
        let addressAttributedString = NSMutableAttributedString(string: addressString,
                                                                attributes:addressInfoAttribute)
        stringToBeReturned.append(addressAttributedString)
        
        guard let countryName = self.countryName else { return stringToBeReturned }
        let countryNameString = NSMutableAttributedString(string: "\n" + countryName, attributes: addressInfoAttribute)
        stringToBeReturned.append(countryNameString)
        return stringToBeReturned
    }

    func createFormattedString()-> String {
        guard let line2 = self.addressLine2 , line2.length > 0 else {
            return String(format:"%@,\n%@,\n%@ %@,", self.addressLine1, self.town, getStateCode(), self.postalCode)
        }
        return String(format:"%@,\n%@,\n%@,\n%@ %@,", self.addressLine1, self.addressLine2, self.town, getStateCode(), self.postalCode)
    }
    
    func getStateCode() -> String {
        if (self.regionCode != nil){
            let regionArr = self.regionCode.components(separatedBy: "-")
             if(regionArr.count == 2){
                return regionArr[1]
                }
          }
        return ""
    }

    func createFormattedStringWithRegion()->String {
        guard let line2 = self.addressLine2 , line2.length > 0 else {
            return String(format: "%@,\n%@,\n%@ %@", self.addressLine1, self.regionName, self.town, self.postalCode)
        }
        return String(format: "%@,\n%@,\n%@,\n%@ %@", self.addressLine1, self.addressLine2, self.regionName, self.town, self.postalCode)
    }
}
