/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSPILFetchProductDetailsRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return ECSTestMasterData.sharedInstance.pilProductList?.count ?? 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.pilProductList?[row].ctn() ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        guard let products = ECSTestMasterData.sharedInstance.pilProductList, products.count > 0 else {
            return
        }
        let selectedCTN = products[row].ctn()
        let ctnTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectProductCTN.rawValue) as? UITextField
        ctnTextField?.text = selectedCTN
    }
    
    func executeRequest() {
        
        let ctnTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectProductCTN.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let selectedProduct = ECSTestMasterData.sharedInstance.pilProductList?.first(where: { $0.ctn() == ctnTextField?.text }) {
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchECSProductDetailsFor(product: selectedProduct, completionHandler: { (product, error) in
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(product) {
                    responseData = String(data: data, encoding: .utf8)
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
