/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCPaymentAndAddressBaseInterfaceBuilder: IAPOCCBaseInterfaceBuilder {
    //address related
    var firstName:String!
    var lastName:String!
    var isDefault:Bool = false
    var addressLine1:String!
    var addressLine2:String!
    var phone1:String!
    var phone2:String!
    var postalCode:String!
    var countryISOCode:String!
    var town:String!
    var titleCode:String!
    var addressID:String!
    var regionCode:String!
    var houseNumber: String!

    func withTitleCode(_ inTitleCode:String)-> Self {
        self.titleCode = inTitleCode
        return self
    }

    func withFirstName(_ inFirstName:String)-> Self {
        self.firstName = inFirstName
        return self
    }

    func withLastName(_ inLastName:String)-> Self {
        self.lastName = inLastName
        return self
    }

    func withPhone1(_ inPhoneNumber:String)-> Self {
        self.phone1 = inPhoneNumber
        return self
    }
    
    func withPhone2(_ inPhoneNumber:String)-> Self {
        self.phone2 = inPhoneNumber
        return self
    }

    func withAddressLine1(_ inLine1:String)-> Self {
        self.addressLine1 = inLine1
        return self
    }

    func withAddressLine2(_ inLine2:String)-> Self {
        self.addressLine2 = inLine2
        return self
    }

    func withTown(_ inTown:String)-> Self {
        self.town = inTown
        return self
    }

    func withPostalCode(_ inCode:String)-> Self {
        self.postalCode = inCode
        return self
    }

    func withCountryCode(_ inCountryCode:String)-> Self {
        self.countryISOCode = inCountryCode
        return self
    }
    
    func withRegionCode(_ inRegionCode:String)-> Self {
        self.regionCode = inRegionCode
        return self
    }

    func initialiseBuilder(with address:IAPUserAddress) {
        if let name = address.firstName {
            self.firstName = name
        }
        if let name = address.lastName {
            self.lastName = name
        }

        if let line1 = address.addressLine1 {
            self.addressLine1 = line1
        }

        if let countryCode = address.countryIsoCode {
            self.countryISOCode  = countryCode
        }

        if let regionCode = address.regionCode {
            self.regionCode  = regionCode
        }

        if let pcode = address.postalCode {
            self.postalCode = pcode
        }

        if let town = address.town {
            self.town = town
        }

        if let phoneNumber = address.phone1 {
            self.phone1 = phoneNumber
        }

        if let phoneNumber = address.phone2 {
            self.phone2  = phoneNumber
        }

        if let addressLine = address.addressLine2 {
            self.addressLine2 = addressLine
        }

        if let titleCode = address.titleCode {
            self.titleCode = titleCode
        }
        if let houseNumber = address.houseNumber {
            self.houseNumber = houseNumber
        }
    }
    
    // MARK:
    // MARK: Method to initialise the interface with address
    // MARK:
    func initialiseInterfaceforAddress(_ occInterface:IAPOCCPaymentAddressBaseInterface) {
        // address related
        if let fName = self.firstName {
            occInterface.firstName = fName
        }
        
        if let lName = self.lastName {
            occInterface.lastName = lName
        }
        
        if let townName = self.town {
            occInterface.town  = townName
        }
        
        if let tCode = self.titleCode {
            occInterface.titleCode = tCode
        }
        
        occInterface.defaultAddress = self.isDefault
        
        if let line = self.addressLine1 {
            occInterface.addressLine1 = line
        }
        
        if let line = self.addressLine2 {
            occInterface.addressLine2 = line
        }
        
        if let pCode = self.postalCode {
            occInterface.postalCode = pCode
        }
        
        if let cCode = self.countryISOCode {
            occInterface.countryCode = cCode
        }
        
        if let number = self.phone1  {
            occInterface.phone1    = number
        }
        
        if let number = self.phone2  {
            occInterface.phone2    = number
        }
        
        if let tCode = self.titleCode {
            occInterface.titleCode      = tCode
        }
        
        if let addressID = self.addressID {
            occInterface.addressID = addressID
        }
        
        if let regionCode = self.regionCode {
            occInterface.regionCode = regionCode
        }
        if let houseNumber = self.houseNumber {
            occInterface.houseNumber = houseNumber
        }
    }
    
    // MARK:
    // MARK: Interface initialising method for user and cart id
    
    func initialiseUserAndCartIDForInterface(_ occInterface:IAPOCCPaymentAddressBaseInterface){
        occInterface.userID = self.userID
        occInterface.cartID = self.cartID
    }
}
