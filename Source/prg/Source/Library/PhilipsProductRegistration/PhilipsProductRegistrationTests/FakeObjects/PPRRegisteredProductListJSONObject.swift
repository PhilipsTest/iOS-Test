//
//  PPRRegisteredProductListJSONObject.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
@testable import PhilipsProductRegistrationDev

class PPRRegisteredProductListJSONObject: NSObject {
    func fakeRegisteredProductList() -> NSDictionary{
        let str: String = "{\"result_count\": 2,\"results\": [{\"productRegistrationID\": \"2512000064\",\"purchaseDate\": \"2013-03-01\",\"productModelNumber\": \"HX8002/05\",\"contractNumber\": null,\"lastSolicitDate\": null,\"purchasePlace\": null,\"warrantyInMonths\": null,\"id\": 139136402,\"productCatalogLocaleId\": \"nl_NL_CONSUMER\",\"deviceId\": null,\"lastUpdated\": \"2014-02-25 21:31:36.161304 +0000\",\"isPrimaryUser\": true,\"isGenerations\": false,\"deviceName\": \"HX8002/05\",\"productID\":\"HX8002_05_NL_CONSUMER\",\"extendedWarranty\": false,\"lastModified\": \"2013-12-03\",\"slashWinCompetition\": false,\"productSerialNumber\": \"12345ASHJFSGA1\",\"created\": \"2014-02-25 21:31:36.161304 +0000\",\"registrationDate\": \"2013-12-03 00:00:00 +0000\",\"uuid\": \"973bd103-6c38-4899-8716-aade4f632cb6\",\"registrationChannel\": \"web\"},{\"productRegistrationID\": \"2512000065\",\"purchaseDate\": \"2013-12-03\",\"productModelNumber\": \"CP9214/01\",\"contractNumber\": null,\"lastSolicitDate\": null,\"purchasePlace\": null,\"warrantyInMonths\": null,\"id\": 139136403,\"productCatalogLocaleId\": \"nl_NL_CONSUMER\",\"deviceId\": null,\"lastUpdated\": \"2014-02-25 21:31:36.167894 +0000\",\"isPrimaryUser\": true,\"isGenerations\": false,\"deviceName\": \"CP9214/01\",\"productId\": \"CP9214_01_NL_CONSUMER\",\"extendedWarranty\": false,\"lastModified\": \"2013-12-03\",\"slashWinCompetition\": false,\"productSerialNumber\": null,\"created\": \"2014-02-25 21:31:36.167894 +0000\",\"registrationDate\": \"2013-12-03 00:00:00 +0000\",\"uuid\": \"8304b9d0-a39d-4042-b146-f50cb28cdce4\",\"registrationChannel\": \"web\"}],\"stat\": \"ok\"}"
       return str.parseJSONString as! NSDictionary
    }
}
