/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILUpdateShoppingCartRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilShoppingCart = nil
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return ECSTestMasterData.sharedInstance.pilShoppingCart?.data?.attributes?.items?.count ?? 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.pilShoppingCart?.data?.attributes?.items?[row].ctn ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        guard let items = ECSTestMasterData.sharedInstance.pilShoppingCart?.data?.attributes?.items, items.count > 0 else {
            return
        }
        let selectedCTN = items[row].ctn
        let ctnTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.entryNumber.rawValue) as? UITextField
        ctnTextField?.text = selectedCTN
    }
    
    func executeRequest() {
        
        let entryNumberTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.entryNumber.rawValue) as? UITextField
        let quantityTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.productQuantity.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let selectedEntry = ECSTestMasterData.sharedInstance.pilShoppingCart?.data?.attributes?.items?.first(where: { $0.ctn == entryNumberTextField?.text }) {
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.updateECSShoppingCart(cartItem: selectedEntry, quantity: Int(quantityTextField?.text ?? "") ?? 0, completionHandler: { (shoppingCart, error) in
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
        } else {
            inputViewController?.executeRequestButton.isActivityIndicatorVisible = false
            inputViewController?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
}
