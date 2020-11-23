/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSFetchDeliveryModesRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.deliveryModes = nil
    }
    
    func executeRequest() {
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchDeliveryModes(completionHandler: { (deliveryModes, error) in
            if let deliveryModes = deliveryModes {
                ECSTestMasterData.sharedInstance.deliveryModes = deliveryModes
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(deliveryModes) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
