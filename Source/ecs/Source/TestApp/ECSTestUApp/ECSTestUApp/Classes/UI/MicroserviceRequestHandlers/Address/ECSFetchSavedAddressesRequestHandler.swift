/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSFetchSavedAddressesRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.savedAddresses = nil
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchSavedAddresses(completionHandler: { (addresses, error) in
            if let addresses = addresses {
                ECSTestMasterData.sharedInstance.savedAddresses = addresses
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(addresses) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
