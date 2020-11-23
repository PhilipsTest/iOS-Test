/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import Foundation

class IAPOCCPaymentAddressBaseInterface:IAPOCCBaseInterface {
    
    // address related
    var titleCode: String?
    var firstName: String?
    var lastName: String?
    var phone1: String?
    var phone2: String?
    var addressLine1: String?
    var addressLine2: String?
    var town: String?
    var postalCode: String?
    var countryCode: String?
    var defaultAddress: Bool?
    var addressID: String?
    var regionCode: String?
    var houseNumber: String?
    // MARK:
    // MARK: Address related private method
    
    func getAddressDictionary() -> [String: String] {
        var dict = [String: String]()
        
        if let pCode = self.postalCode {
            dict[IAPConstants.IAPOCCHeader.kPostalCodeKey] = pCode
        }
        
        if let aLine1 = self.addressLine1 {
            dict[IAPConstants.IAPOCCHeader.kAddressLine1] = aLine1
        }
        
        if let cTown = self.town {
            dict[IAPConstants.IAPOCCHeader.kTownKey] = cTown
        }
        
        if let fName = self.firstName {
            dict[IAPConstants.IAPOCCHeader.kFirstNameKey] = fName
        }
        
        if let lName = self.lastName {
            dict[IAPConstants.IAPOCCHeader.kLastNameKey] = lName
        }
        
        if let cCode = self.countryCode {
            dict[IAPConstants.IAPOCCHeader.kCountryCode] = cCode
        }
        
        if let line2 = self.addressLine2 {
            dict[IAPConstants.IAPOCCHeader.kAddressLine2] = line2
        }
        
        if let phone1 = self.phone1 {
            dict[IAPConstants.IAPOCCHeader.kPhone1] = phone1
        }
        
        if let phone2 = self.phone2 {
            dict[IAPConstants.IAPOCCHeader.kPhone2] = phone2
        }

        if let title = self.titleCode {
            dict[IAPConstants.IAPOCCHeader.kTitleCodeKey] = title
        }
        
        if let rCode = self.regionCode {
            dict[IAPConstants.IAPOCCHeader.kRegionCode] = rCode
        }
        if let hNumber = self.houseNumber {
            dict[IAPConstants.IAPOCCHeader.kHouseNumber] = hNumber
        }
        return dict
    }
    
}
