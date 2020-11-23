/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PlatformInterfaces

class ECSRefreshJanrainRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    
    var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.janrainAccessToken = nil
    }
    
    func executeRequest() {
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.addUserDataInterfaceListener(self)
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.refreshSession()
    }
}

extension ECSRefreshJanrainRequestHandler: UserDataDelegate {
    
    func refreshSessionSuccess() {
        let janrainAccessToken = try? ECSTestDemoConfiguration.sharedInstance.userDataInterface?.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN] as? String
        ECSTestMasterData.sharedInstance.janrainAccessToken = janrainAccessToken ?? ""
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.removeUserDataInterfaceListener(self)
        self.inputViewController?.pushResultView(responseData: "true", responseError: nil)
    }
    
    func refreshSessionFailed(_ error: Error) {
        ECSTestDemoConfiguration.sharedInstance.userDataInterface?.removeUserDataInterfaceListener(self)
        let errorData = error.fetchResponseErrorMessage()
        self.inputViewController?.pushResultView(responseData: nil, responseError: errorData)
    }
}
