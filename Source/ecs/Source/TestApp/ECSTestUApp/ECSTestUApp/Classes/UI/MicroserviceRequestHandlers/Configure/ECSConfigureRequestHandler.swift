/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSConfigureRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func executeRequest() {
        var responseData, errorData: String?
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.configureECSWithConfiguration(completionHandler: { (configData, error) in
            if let configData = configData {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(configData) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
}
