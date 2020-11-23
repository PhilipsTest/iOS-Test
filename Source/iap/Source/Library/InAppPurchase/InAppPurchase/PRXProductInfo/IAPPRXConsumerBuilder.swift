//
//  IAPPRXConsumerBuilder.swift
//  Pods
//
//  Created by Rohit Nihal on 03/08/16.
//
//

import Foundation

class IAPPRXConsumerURLBuilder {
    fileprivate var locale : String!
    fileprivate var categoryCode : String!
    
    convenience init(inLocale : String, inCategoryCode : String){
        self.init()
        self.locale = inLocale
        self.categoryCode = inCategoryCode
    }
    
    func getPRXConsumerURL() -> String{
        return IAPConstants.IAPPRXConsumerURLBuilderKeys.kScheme + "://"
            + IAPConstants.IAPPRXConsumerURLBuilderKeys.kHostport + "/"
            + IAPConstants.IAPPRXConsumerURLBuilderKeys.kWebroot + "/"
            + IAPConstants.IAPPRXConsumerURLBuilderKeys.kSector + "/"
            + self.locale + "/"
            + IAPConstants.IAPPRXConsumerURLBuilderKeys.kCatalogCode + "/"
            + self.categoryCode + "." + IAPConstants.IAPPRXConsumerURLBuilderKeys.kQuery
    }    
}
