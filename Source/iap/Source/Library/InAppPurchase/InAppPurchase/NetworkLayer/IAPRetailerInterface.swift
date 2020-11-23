/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPRetailerInterface {
    
    fileprivate var productCode : String!
    fileprivate var locale : String!
    
    init(inProductCode : String, inLocale : String){
        self.productCode = inProductCode
        self.locale = inLocale
    }
    
    func getInterfaceForRetailers() -> IAPHttpConnectionInterface{
        let addressBuilder = IAPRetailerURLBuilder(inProductCode: self.productCode, inLocale: self.locale)
        let urlString = addressBuilder.getWhereToBuyRetailerURL()
        
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: nil,bodyParameters: nil)
        
        return httpConnectionInterface
    }
    
    func getRetailersInfoForProduct(_ interface: IAPHttpConnectionInterface,
                                    completionHandler:@escaping (_ withRetailers:[IAPRetailerModel])->(),
                                    failureHandler:@escaping (NSError)->()) {
       
        interface.setSuccessCompletion{(inDict: [String: AnyObject]) -> () in
        completionHandler(IAPRetailerModelCollection(inDict: inDict).getRetailers())
        }
        interface.setFailurHandler{ (inError:NSError) -> () in
        failureHandler(inError)
        }
        
        interface.performGetRequest()
    }
}
