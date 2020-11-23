/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit

class ECSPILCreateShoppingCartRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilShoppingCart = nil
    }
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        return textField?.tag == ECSMicroServiceInputIndentifier.productQuantity.rawValue
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if textField?.tag == ECSMicroServiceInputIndentifier.productQuantity.rawValue {
            textField?.text = "1"
        }
    }
    
    func textFieldString(tag: Int) -> String? {
        let text = (inputViewController?.microserviceInputTableView.viewWithTag(tag) as? UITextField)?.text
        return (text?.isEmpty ?? true) ? nil : text
    }
    
    func executeRequest() {
        let ctnValue = textFieldString(tag: ECSMicroServiceInputIndentifier.productCTN.rawValue) ?? ""
        let quantity = Int(textFieldString(tag: ECSMicroServiceInputIndentifier.productQuantity.rawValue) ?? "1") ?? 0
        
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.createECSShoppingCart(ctn: ctnValue,
                                                                                   quantity: quantity, completionHandler: { (shoppingCart, error) in
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
