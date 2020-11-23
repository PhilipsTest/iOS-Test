/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPMakePaymentInfo {
    
    var worldPayURL:String = ""
    
    init (inDict: [String: AnyObject]) {
        if let wpurl = inDict[IAPConstants.IAPMakePaymentKeys.kWorldPaykey] as? String {
            self.worldPayURL = wpurl
        }
    }
    
    func getWorldPayURL()->String {
        return self.worldPayURL
    }
}
