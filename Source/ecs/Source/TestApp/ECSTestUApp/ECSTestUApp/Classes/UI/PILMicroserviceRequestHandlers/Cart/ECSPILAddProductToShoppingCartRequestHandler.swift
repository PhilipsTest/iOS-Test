/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILAddProductToShoppingCartRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
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
    
    func executeRequest() {
        var responseData, errorData: String?
        let ctnTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productCTN.rawValue) as? UITextField
        let quantityTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productQuantity.rawValue) as? UITextField
        let quantityTextFieldValue = quantityTextField?.text ?? ""
        let quantity = quantityTextFieldValue.isEmpty == true ? 1 : Int(quantityTextFieldValue)
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.addECSProductToShoppingCart(ctn: ctnTextField?.text ?? "",
                                                                                         quantity: quantity ?? 0) { (shoppingCart, error) in
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
        }
        
    }
}
