/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSFetchRegionsForCountryISORequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        if let textField = textField, let text = textField.text {
            switch textField.tag {
            case ECSMicroServiceInputIndentifier.countryISO.rawValue:
                return text.count > 0 ? false : true
            default:
                return false
            }
        }
        return false
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if let textField = textField {
            switch textField.tag {
            case ECSMicroServiceInputIndentifier.countryISO.rawValue:
                textField.text = ECSTestDemoConfiguration.sharedInstance.sharedAppInfra?.serviceDiscovery.getHomeCountry() ?? ""
            default:
                break
            }
        }
    }
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.regions = nil
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        
        let regionTextField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.countryISO.rawValue) as? UITextField
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchRegionsFor(countryISO: regionTextField?.text ?? "", completionHandler: { (regions, error) in
            if let regions = regions {
                ECSTestMasterData.sharedInstance.regions = regions
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(regions) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
