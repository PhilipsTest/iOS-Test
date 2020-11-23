/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILFetchShoppingCartRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilShoppingCart = nil
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchECSShoppingCart(completionHandler: { (shoppingCart, error) in
            if let shoppingCart = shoppingCart {
                ECSTestMasterData.sharedInstance.pilShoppingCart = shoppingCart
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(shoppingCart) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
