/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

typealias GetRegionsCompletionHandler = (_ regions: NSArray) -> Void

class IAPShippingAddressUtility {
    func getRegionsForCountryCode(_ countryCode: String, completionHandler: @escaping GetRegionsCompletionHandler) {
        var statesArray:NSArray = []
        let addressBuilder = IAPUtility.getAddressInterfaceBuilder()
        let occInteface = addressBuilder.buildInterface()
        let httpInterface = occInteface.getInterfaceForRegions(countryCode)
        occInteface.getRegionsForCountryCode(httpInterface, completionHandler: { (response) -> () in
            //Get regions from server response
            let states = response
            if let statesArray = states["regions"] as? NSArray {
                completionHandler(statesArray)
            } else {
                completionHandler(statesArray)
            }
        }) { _ -> () in
            statesArray = self.readLocalRegions(countryCode)
            completionHandler(statesArray)
        }
    }
    
    fileprivate func readLocalJSONFile(_ fileName:String) -> NSArray? {
        if let path = IAPUtility.getBundle().path(forResource: fileName, ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let regions : NSArray = jsonResult["regions"] as? NSArray {
                            return regions
                        }
                    }
                }
                catch {}
            }
        }
        return []
    }
    
    fileprivate func readLocalRegions(_ countryCode: String) -> NSArray {
        let fileName:String = countryCode + "Regions"
        guard let statesArray = self.readLocalJSONFile(fileName) else { return [] }
        return statesArray
    }
}
