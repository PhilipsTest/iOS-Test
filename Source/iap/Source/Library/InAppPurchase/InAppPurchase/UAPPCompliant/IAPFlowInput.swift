/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 IAPFlowInput initializes the required ctn's for InAppPurchase to set the flow of micro app.
 - Since: 1.0.0
 */
open class IAPFlowInput: NSObject {
    
    fileprivate var productCTN : String?
    fileprivate var productCTNList : [String]?
    
    /**
     IAPFlowInput init method. Default initialization method of IAPFlowInput.
     - Since: 1.0.0
     - Returns: An instance of IAPFlowInput
     */
    public override init() {
        super.init()
    }
    
    /**
     IAPFlowInput init method as a overloaded constructor. It initializes IAPFlowInput with one ctn value
     - Parameter inCTN: product ctn value as a string
     - Since: 1.0.0
     - Returns: An instance of IAPFlowInput
     */
    public init(inCTN:String) {
        super.init()
        self.productCTN = inCTN
    }
    
    /**
     IAPFlowInput init method as a overloaded constructor. It initializes IAPFlowInput with array of ctn list
     - Parameter inCTNList: product ctn list as an array of string
     - Since: 1.0.0
     - Returns: An instance of IAPFlowInput
     */
    public init(inCTNList:[String]) {
        super.init()
        self.productCTNList = inCTNList
    }
    
    func getProductCTN() -> String {
        return self.productCTN!
    }
    
    func getProductCTNList() -> [String]? {
        return self.productCTNList
    }
}
