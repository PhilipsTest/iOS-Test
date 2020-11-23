/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSFetchOrderDetailsForOrderDetailRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return 1
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.placedOrderDetail?.orderID ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        let selectedOrderID = ECSTestMasterData.sharedInstance.placedOrderDetail?.orderID
        let orderIDTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectOrder.rawValue) as? UITextField
        orderIDTextField?.text = selectedOrderID
    }
    
    func executeRequest() {
        
        let orderTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectOrder.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let _ = orderTextField?.text,
            let selectedOrderDetail = ECSTestMasterData.sharedInstance.placedOrderDetail {
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchOrderDetailsFor(orderDetail: selectedOrderDetail, completionHandler: { (orderDetail, error) in
                if let orderDetail = orderDetail {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(orderDetail) {
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
