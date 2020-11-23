/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSSetDeliveryModeRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return ECSTestMasterData.sharedInstance.deliveryModes?.count ?? 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.deliveryModes?[row].deliveryModeId ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        guard let deliveryModes = ECSTestMasterData.sharedInstance.deliveryModes, deliveryModes.count > 0 else {
            return
        }
        let selectedDeliveryMode = deliveryModes[row].deliveryModeId
        let deliveryModeField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectDeliveryMode.rawValue) as? UITextField
        deliveryModeField?.text = selectedDeliveryMode
    }
    
    func executeRequest() {
        
        let deliveryModeField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectDeliveryMode.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let selectedDeliveryMode = ECSTestMasterData.sharedInstance.deliveryModes?.first(where: { $0.deliveryModeId == deliveryModeField?.text }) {
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.setDeliveryMode(deliveryMode: selectedDeliveryMode, completionHandler: { (success, error) in
                responseData = success.description
                errorData = error?.fetchResponseErrorMessage()
                self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
            })
        } else {
            inputViewController?.executeRequestButton.isActivityIndicatorVisible = false
            inputViewController?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
}
