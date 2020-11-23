/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class CTNUtilities {
    static func getProductCTNsForHomeCountry() -> [String]? {
        let country = AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.getHomeCountry() ?? "UNKNOWN"
        
        // TODO: hardcoding return values for a few known demo countries for now.
        // this will be replaced by a more configuration centric approach that should also handle multi CTN configurations.
        switch country {
        case "HK", "MO":
            return ["HX6322/04"]
        case "IN":
            return ["HX6311/07"]
        case "US":
            return [
                "HD8645/47",
                "HD9980/20",
                "HX8918/10",
                "HD9240/94",
                "SCF782/10",
                "HX8332/11",
                "SCF251/03",
                "DIS359/03",
                "DIS362/03",
                "CA6702/00",
                "CA6700/47",
                "SCD393/03",
                "BRE394/60",
                "DIS363/03",
                "DIS364/03"]
        default:
            // For all other countries, preserve existing behavior, read from plist
            let plistKey = country == "CN" ?
                Constants.CONSUMERCARE_PRODUCT_INFO_FILE_CHINA :
                Constants.CONSUMERCARE_PRODUCT_INFO_FILE
            
            //TODO: dependency inject file reader function to improve testability
            return Utilites.readDataFromFile(plistKey) as? [String]
        }
    }
}
