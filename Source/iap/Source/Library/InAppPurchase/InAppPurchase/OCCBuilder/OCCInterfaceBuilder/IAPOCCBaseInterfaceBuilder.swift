/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCBaseInterfaceBuilder {
    var userID:String!
    var cartID:String = "current"
    
    init?(inUserID:String) {
        guard inUserID.length > 0 else {return nil}
        self.userID = inUserID
    }
}