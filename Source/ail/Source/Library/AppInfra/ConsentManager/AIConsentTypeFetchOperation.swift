//
//  AIConsentTypeOperation.swift
//  AppInfra
//
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation
import PlatformInterfaces

class AIConsentTypeFetchOperation: Operation {
    private var consentHandler: ConsentHandlerProtocol!
    private var completionCallBack: ((ConsentStatus?, NSError?) -> ())?
    private var consentType: String!
    
    required init(consentHandler: ConsentHandlerProtocol, consentType: String, completionBlock: @escaping ((ConsentStatus?, NSError?) -> ())) {
        self.consentHandler = consentHandler
        self.completionCallBack = completionBlock
        self.consentType = consentType
    }
    
    override func main() {
        if self.isCancelled { return }
        let semaphore = DispatchSemaphore(value: 0)
        self.consentHandler.fetchConsentTypeState(for: self.consentType) { [weak self] (consentState, error) in
            self?.completionCallBack?(consentState,error)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.now() + AIConsentManagerConstants.timeoutInterval)
    }
}
