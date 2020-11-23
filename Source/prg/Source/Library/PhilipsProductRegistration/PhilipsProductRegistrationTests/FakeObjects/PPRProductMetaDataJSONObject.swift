//
//  PPRProductMetaDataJSONObject.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
@testable import PhilipsProductRegistrationDev

class PPRProductMetaDataJSONObject: NSObject {
    
    func fakeValidResponse(with isPurchasedateRequired: Bool, isSerialNumberRequired:Bool)->NSDictionary {
        let str :String = "{\"success\":true, \"data\":{\"message\":\"Als u uw product binnen drie maanden na de aankoopdatum registreert, komt u in aanmerking voor uitgebreide garantie.<br><br>Controleer of de aankoopdatum en het serienummer correct zijn ingevuld.<br><br>Om het serienummer te vinden, raadpleegt u de tekst naast het veld voor het invoeren van het serienummer.<br><br>Houd er rekening mee dat u het aankoopbewijs bij de hand moet hebben voor het geval u uw garantie moet activeren. Daarom bieden we u bij de productregistratie de mogelijkheid om het aankoopbewijs te uploaden.\",\"isConnectedDevice\":false,\"requiresSerialNumber\":\(isSerialNumberRequired),\"extendedWarrantyMonths\":36,\"hasGiftPack\":false,\"ctn\":\"HD8967/01\",\"hasExtendedWarranty\":true,\"serialNumberFormat\":\"^[0-9a-zA-Z]{14}$\",\"requiresDateOfPurchase\":\(isPurchasedateRequired),\"isLicensekeyRequired\":false,\"serialNumberSampleContent\":{\"title\":\"Het serienummer vinden\",\"asset\":\"/consumerfiles/assets/img/registerproducts/HD8.jpg\",\"snFormat\":\"Het serienummer vindt u op het identificatielabel op uw Philips-apparaat.\",\"snExample\":\"voorbeeld: TU901022000001\",\"description\":\"You can find the serial number on inside of the door. The serial number starts with two characters (TU, TV, TW or TX) and is followed by 12 digits.\"}}}"
        return str.parseJSONString as! NSDictionary
    }
    
    func fakeValidStructureWithDifferenValues()->NSDictionary {
        let str :String = "{\"success\":\"1\", \"data\":{\"message\":\"Als u uw product binnen drie maanden na de aankoopdatum registreert, komt u in aanmerking voor uitgebreide garantie.<br><br>Controleer of de aankoopdatum en het serienummer correct zijn ingevuld.<br><br>Om het serienummer te vinden, raadpleegt u de tekst naast het veld voor het invoeren van het serienummer.<br><br>Houd er rekening mee dat u het aankoopbewijs bij de hand moet hebben voor het geval u uw garantie moet activeren. Daarom bieden we u bij de productregistratie de mogelijkheid om het aankoopbewijs te uploaden.\",\"isConnectedDevice\":false,\"requiresSerialNumber\":30,\"extendedWarrantyMonths\":\"39\",\"hasGiftPack\":false,\"ctn\":\"HD8967/01\",\"hasExtendedWarranty\":true,\"serialNumberFormat\":true,\"requiresDateOfPurchase\":true,\"isLicensekeyRequired\":false,\"serialNumberSampleContent\":{\"title\":\"Het serienummer vinden\",\"asset\":\"/consumerfiles/assets/img/registerproducts/HD8.jpg\",\"snFormat\":false,\"snExample\":true,\"description\":\"You can find the serial number on inside of the door. The serial number starts with two characters (TU, TV, TW or TX) and is followed by 12 digits.\"}}}"
        return str.parseJSONString as! NSDictionary
    }
}
