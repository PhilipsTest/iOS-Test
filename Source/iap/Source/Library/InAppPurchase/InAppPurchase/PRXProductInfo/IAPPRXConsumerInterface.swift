//
//  IAPPRXConsumerInterface.swift
//  Pods
//
//  Created by Rohit Nihal on 03/08/16.
//
//

import Foundation

class IAPPRXConsumerInterface {
    fileprivate var locale : String!
    fileprivate var categoryCode : String!
    
    init(inLocale : String, inCategoryCode : String) {
        self.locale = inLocale
        self.categoryCode = inCategoryCode
    }
    
    func getInterfaceForConsumerCare() -> IAPHttpConnectionInterface{
        let consumerBuilder = IAPPRXConsumerURLBuilder(inLocale: self.locale, inCategoryCode: self.categoryCode)
        let urlString = consumerBuilder.getPRXConsumerURL()
        
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: nil,bodyParameters: nil)
        
        return httpConnectionInterface
    }
    
    func getConsumerCareInformation(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping (_ withConsumerCare: IAPPRXConsumerModel)->(),
                                    failureHandler: @escaping (NSError)-> ()) {
        
        interface.setSuccessCompletion{(inDict:[String: AnyObject]) -> () in
            completionHandler(IAPPRXConsumerModel(inDict: inDict))
        }
        interface.setFailurHandler{ (inError:NSError) -> () in
            failureHandler(inError)
        }
        
        interface.performGetRequest()
    }
}
