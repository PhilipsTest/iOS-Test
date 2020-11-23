/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSDeleteAddressRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.savedAddresses = nil
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        return ECSTestMasterData.sharedInstance.savedAddresses?.count ?? 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        return ECSTestMasterData.sharedInstance.savedAddresses?[row].addressID ?? ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        guard let addresses = ECSTestMasterData.sharedInstance.savedAddresses, addresses.count > 0 else {
            return
        }
        let selectedAddress = addresses[row].addressID
        let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
        addressTextField?.text = selectedAddress
    }
    
    func executeRequest() {
        
        let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
        var responseData, errorData: String?
        
        if let selectedAddress = ECSTestMasterData.sharedInstance.savedAddresses?.first(where: { $0.addressID == addressTextField?.text }) {
            
            switch inputViewController?.microServiceInput?.microServiceIdentifier {
            case ECSMicroServicesIndentifier.deleteAddressWithAddressListReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.deleteAddress(address: selectedAddress, completionHandler: { (addressList, error) in
                    if let addressList = addressList {
                        ECSTestMasterData.sharedInstance.savedAddresses = addressList
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        if let data = try? encoder.encode(addressList) {
                            responseData = String(data: data, encoding: .utf8)
                        }
                    }
                    errorData = error?.fetchResponseErrorMessage()
                    self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
                })
                
            case ECSMicroServicesIndentifier.deleteAddressWithSuccessReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.deleteAddress(savedAddress: selectedAddress, completionHandler: { (success, error) in
                    if success {
                        if let addressIndex = ECSTestMasterData.sharedInstance.savedAddresses?.firstIndex(where: { $0.addressID == selectedAddress.addressID }) {
                            ECSTestMasterData.sharedInstance.savedAddresses?.remove(at: addressIndex)
                        }
                    }
                    responseData = success.description
                    if success {
                        ECSTestMasterData.sharedInstance.savedAddresses?.removeAll(where: { $0 === selectedAddress })
                    }
                    errorData = error?.fetchResponseErrorMessage()
                    self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
                })
            default:
                break
            }
        } else {
            inputViewController?.executeRequestButton.isActivityIndicatorVisible = false
            inputViewController?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
}
