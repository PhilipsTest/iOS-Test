//
//  AIConsentTypeSendOperation.swift
//  AppInfra
//
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation
import PlatformInterfaces

class AIConsentTypeSendOperation: Operation {
    private var consentHandler: ConsentHandlerProtocol!
    private var completionCallBack: ((Bool, NSError?) -> ())?
    private var consentType: String!
    private var status: Bool = false
    private var version: Int!
    
    required init(consentHandler: ConsentHandlerProtocol, consentType: String, status: Bool, version: Int, completionBlock: @escaping ((Bool, NSError?) -> ())) {
        self.consentHandler = consentHandler
        self.completionCallBack = completionBlock
        self.consentType = consentType
        self.version = version
        self.status = status
    }
    
    override func main() {
        if self.isCancelled { return }
        let semaphore = DispatchSemaphore(value: 0)
        self.consentHandler.storeConsentState(for: self.consentType, withStatus: self.status, withVersion: self.version) { [weak self] (value, error) in
            self?.completionCallBack?(value, error)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.now() + AIConsentManagerConstants.timeoutInterval)
    }
}
