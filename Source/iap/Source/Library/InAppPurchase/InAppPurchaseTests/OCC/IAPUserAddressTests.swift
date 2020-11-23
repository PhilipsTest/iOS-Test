/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPUserAddressTests: XCTestCase {
    
   func testModelCreation() {
        let addressDictionary = self.deserializeData("IAPUserAddress")
        XCTAssertNotNil(addressDictionary, "Dictionary created is nil")
        
        let userAddress = IAPUserAddressInfo(inDict: addressDictionary!)
        XCTAssertNotNil(userAddress, "User address Info is not initialised")
        XCTAssert (userAddress.address.count > 0, "User addresses is not right")
        
        for address in userAddress.address {
            XCTAssert (address.addressId.length > 0, "Address ID is not right")
            XCTAssert (address.addressLine1.length > 0, "Address Line1 is not right")
            XCTAssert (address.firstName.length > 0, "Address first name is not right")
            XCTAssert (address.lastName.length > 0, "Address last name is not right")
            XCTAssert (address.postalCode.length > 0, "Address postal code is not right")
            XCTAssert (address.countryIsoCode.length > 0, "Address country code is not right")
            XCTAssert (address.town.length > 0, "Address town is not right")
        }
        
        let lastUserAddress = userAddress.address.last!
        let userCreated = IAPUserAddress(address: lastUserAddress)
        XCTAssertNotNil(userCreated, "Address is not initialised with the other address")
    }
    
    func testModelMerging() {
        let address1 = IAPUserAddress()
        address1.defaultAddress = false
        address1.addressId = "12345"
        
        let address2 = IAPUserAddress()
        address2.defaultAddress = false
        address2.addressId = "12455"
        
        let address3 = IAPUserAddress()
        address3.defaultAddress = false
        address3.addressId = "54321"
        
        let defaultAddress = IAPUserAddress()
        defaultAddress.defaultAddress = true
        defaultAddress.addressId = "12345"
        
        let addressInfo = IAPUserAddressInfo()
        addressInfo.address = [address1,address2,address3]
        addressInfo.mergeDefaultAddress(defaultAddress)
        XCTAssert(address1.defaultAddress == true, "Model merging is not proper")
    }
    
}
