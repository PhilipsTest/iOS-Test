/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSSetDeliveryAddressRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    let defaultPickerValues = ["true", "false"]
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.savedAddresses = nil
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.defaultAddress.rawValue:
            return defaultPickerValues.count
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?.count ?? 0
        default:
            return 0
        }
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.defaultAddress.rawValue:
            return defaultPickerValues[row]
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            return ECSTestMasterData.sharedInstance.savedAddresses?[row].addressID ?? ""
        default:
            return ""
        }
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        switch picker.tag {
        case ECSMicroServiceInputIndentifier.defaultAddress.rawValue:
            let selectedValue = defaultPickerValues[row]
            let textField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.defaultAddress.rawValue) as? UITextField
            textField?.text = selectedValue
        case ECSMicroServiceInputIndentifier.selectAddress.rawValue:
            guard let addresses = ECSTestMasterData.sharedInstance.savedAddresses, addresses.count > 0 else {
                return
            }
            let selectedAddress = addresses[row].addressID
            let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
            addressTextField?.text = selectedAddress
        default:
            break
        }
    }
    
    func executeRequest() {
        
        let addressTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.selectAddress.rawValue) as? UITextField
        let defaultAddressField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.defaultAddress.rawValue) as? UITextField
        let defaultAddressValue: Bool = Bool(defaultAddressField?.text ?? "true") ?? true
        var responseData, errorData: String?
        
        if let selectedAddress = ECSTestMasterData.sharedInstance.savedAddresses?.first(where: { $0.addressID == addressTextField?.text }) {
            
            switch inputViewController?.microServiceInput?.microServiceIdentifier {
            case ECSMicroServicesIndentifier.setDeliveryAddressWithAddressListReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.setDeliveryAddress(address: selectedAddress, isDefaultAddress: defaultAddressValue, completionHandler: { (addesses, error) in
                    if let addesses = addesses {
                        ECSTestMasterData.sharedInstance.savedAddresses = addesses
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        if let data = try? encoder.encode(addesses) {
                            responseData = String(data: data, encoding: .utf8)
                        }
                    }
                    errorData = error?.fetchResponseErrorMessage()
                    self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
                })
                
            case ECSMicroServicesIndentifier.setDeliveryAddressWithSuccessReturn.rawValue:
                ECSTestDemoConfiguration.sharedInstance.ecsServices?.setDeliveryAddress(deliveryAddress: selectedAddress, isDefaultAddress: defaultAddressValue, completionHandler: { (success, error) in
                    if success {
                        if let addressIndex = ECSTestMasterData.sharedInstance.savedAddresses?.firstIndex(where: { $0.addressID == selectedAddress.addressID }) {
                            ECSTestMasterData.sharedInstance.savedAddresses?[addressIndex] = selectedAddress
                        }
                    }
                    responseData = success.description
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
