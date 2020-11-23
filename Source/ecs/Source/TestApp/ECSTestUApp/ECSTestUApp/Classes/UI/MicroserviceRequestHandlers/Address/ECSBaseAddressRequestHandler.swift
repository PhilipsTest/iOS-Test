/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK

class ECSBaseAddressRequestHandler: NSObject {
    
    func constructAddress(valueMapper: [Int: String], savedAddress: ECSAddress? = nil) -> ECSAddress {
        let address = savedAddress ?? ECSAddress()
        valueMapper.keys.forEach { (key) in
            switch key {
            case ECSMicroServiceInputIndentifier.firstName.rawValue:
                address.firstName = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.houseNumber.rawValue:
                address.houseNumber = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.lastName.rawValue:
                address.lastName = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.line1.rawValue:
                address.line1 = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.line2.rawValue:
                address.line2 = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.town.rawValue:
                address.town = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.phone.rawValue:
                address.phone = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.phone1.rawValue:
                address.phone1 = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.phone2.rawValue:
                address.phone2 = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.postalCode.rawValue:
                address.postalCode = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.titleCode.rawValue:
                address.titleCode = fetchValueFromMap(valueMapper: valueMapper, key)
                
            case ECSMicroServiceInputIndentifier.countryISO.rawValue:
                let selectedRegionCode = fetchValueFromMap(valueMapper: valueMapper, key)
                let selectedRegion = ECSTestMasterData.sharedInstance.regions?.first(where: { (region) -> Bool in
                    if savedAddress == nil {
                        return region.name == selectedRegionCode
                    } else {
                        return region.name == selectedRegionCode || region.isocodeShort == selectedRegionCode
                    }
                })
                address.region = selectedRegion
                
            case ECSMicroServiceInputIndentifier.country.rawValue:
                if let selectedCountryCode = fetchValueFromMap(valueMapper: valueMapper, key) {
                    let selectedCountry = ECSCountry()
                    selectedCountry.isocode = selectedCountryCode
                    address.country = selectedCountry
                } else {
                    address.country = nil
                }
            default:
                break
            }
        }
        return address
    }
    
    func fetchValueFromMap(valueMapper: [Int: String], _ key: Int) -> String? {
        if let value = valueMapper[key],
            value.count > 0 {
            return value
        }
        return nil
    }
}
