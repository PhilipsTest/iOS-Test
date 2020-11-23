//
//  PPRProductRegistrationJSONObject.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
@testable import PhilipsProductRegistrationDev

class PPRRegisterProductJSONObject: NSObject {
    
    func fakeValidResponse()->NSDictionary {
        let str :String = "{\"data\":{\"contractNumber\":\"CQ5B00lt3\",\"dateOfPurchase\":\"2016-02-15\",\"emailStatus\":\"success\",\"extendedWarranty\":true,\"isConnectedDevice\":0,\"locale\":\"ru_RU\",\"modelNumber\":\"HD8969/09\",\"productRegistrationID\":\"CQ-28333599-2e61-4b5d-9822-133a28bd83f1HD8969/091455606043477\",\"productRegistrationUuid\":\"3f4ed7d5-a584-4cb7-b890-8c4f0c0ded84\",\"registrationDate\":\"2016-02-16\",\"warrantyEndDate\":\"2019-02-15\"},\"success\":1}"
        return str.parseJSONString as! NSDictionary
    }
    
    func fakeValidStructureWithDifferenValues()->NSDictionary {
        let str :String = "{\"data\":{\"contractNumber\":\"CQ5B00lt3\",\"dateOfPurchase\":\"2016-02-15\",\"emailStatus\":\"success\",\"extendedWarranty\":\"true\",\"isConnectedDevice\":\"false\",\"locale\":\"ru_RU\",\"modelNumber\":\"HD8969/09\",\"productRegistrationID\":\"CQ-28333599-2e61-4b5d-9822-133a28bd83f1HD8969/091455606043477\",\"productRegistrationUuid\":\"3f4ed7d5-a584-4cb7-b890-8c4f0c0ded84\",\"registrationDate\":\"2016-02-16\",\"warrantyEndDate\":\"2019-02-15\"},\"success\":\"1\"}"
        return str.parseJSONString as! NSDictionary
    }
}
