/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSSetPaymentDetailRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return ECSTestMasterData.sharedInstance.savedPayments?.count ?? 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.savedPayments?[row].paymentId ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        guard let payments = ECSTestMasterData.sharedInstance.savedPayments, payments.count > 0 else {
            return
        }
        let selectedPayment = payments[row].paymentId
        let paymentTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectPayment.rawValue) as? UITextField
        paymentTextField?.text = selectedPayment
    }
    
    func executeRequest() {
        
        let paymentTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectPayment.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let selectedPayment = ECSTestMasterData.sharedInstance.savedPayments?.first(where: { $0.paymentId == paymentTextField?.text }) {
            
            ECSTestDemoConfiguration.sharedInstance.ecsServices?.setPaymentDetail(paymentDetail: selectedPayment, completionHandler: { (success, error) in
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
