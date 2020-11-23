//
//  IAPPRXConsumerModel.swift
//  Pods
//
//  Created by Rohit Nihal on 03/08/16.
//
//

import Foundation

class IAPPRXConsumerModel {
    fileprivate var phoneNumber: String! = ""
    fileprivate var weekdayOpeningHours: String! = ""
    fileprivate var weekendOpeningHours: String! = ""
    
    init(inDict: [String: AnyObject]) {
        if let data = inDict[IAPConstants.IAPPRXConsumerKeys.kData] as? [String: AnyObject] {
            if let phone = data[IAPConstants.IAPPRXConsumerKeys.kPhone] as? [[String: AnyObject]] {
                self.phoneNumber = phone.first![IAPConstants.IAPPRXConsumerKeys.kPhoneNumber] as? String ?? ""
                self.weekdayOpeningHours = phone.first![IAPConstants.IAPPRXConsumerKeys.kWeekdayPhoneHours] as? String ?? ""
                if let weekendHrs = phone.first![IAPConstants.IAPPRXConsumerKeys.kWeekendPhoneHours] {
                    self.weekendOpeningHours = weekendHrs as? String ?? ""
                } else {
                    self.weekendOpeningHours = phone.first![IAPConstants.IAPPRXConsumerKeys.kWeekendPhoneHoursSun] as? String ?? ""
                }
            }
        }
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber
    }
    
    func getWeekendOpeningHours() -> String {
        return self.weekendOpeningHours
    }
    
    func getWeekdayOpeningHours() -> String {
        return self.weekdayOpeningHours
    }
}
