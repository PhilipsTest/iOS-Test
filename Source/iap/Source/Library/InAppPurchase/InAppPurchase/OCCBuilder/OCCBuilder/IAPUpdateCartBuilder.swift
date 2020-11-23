/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPUpdateCartBuilder:IAPCartBuilder {
    fileprivate var entryNumber:Int!
    
    init(inCartID:String,inUserID:String,inEntryNumber:Int){
        self.entryNumber = inEntryNumber
        super.init(cartID: inCartID, userID: inUserID)
    }
    
    func getUpdateCartURL()->String {
        let entryNo = String(self.entryNumber)
        return super.getAddProductURL() + "/" + entryNo
    }
}
