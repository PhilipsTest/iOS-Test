/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PlatformInterfaces

class AIConsentCallBackMapper: NSObject {
    
    private lazy var consentCallbackInfo: [ConsentDefinition:[AIConsentStatusChangeProtocol]] = [:]
    
    func addConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefiniton: ConsentDefinition) {
        
        var consentCallbacks = consentCallbackInfo[consentDefiniton] ?? []
        if !consentCallbacks.contains { $0 === delegate } {
            consentCallbacks.append(delegate)
            consentCallbackInfo[consentDefiniton] = consentCallbacks
        }
    }
    
    func removeConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefinition: ConsentDefinition) {
        
        var consentCallbacks = consentCallbackInfo[consentDefinition]
        guard let callBacks = consentCallbacks, callBacks.count > 0 else {
            return
        }
        if let index = callBacks.firstIndex(where: { $0 === delegate }) {
            if consentCallbacks?.count == 1 {
                consentCallbackInfo.removeValue(forKey: consentDefinition)
            } else {
                consentCallbacks?.remove(at: index)
                consentCallbackInfo[consentDefinition] = consentCallbacks
            }
        }
    }
    
    func consentStatusChanged(for consentDefinition: ConsentDefinition, error: NSError?, requestedStatus: Bool) {
        if let listeners = consentCallbackInfo[consentDefinition], listeners.count > 0 {
            listeners.forEach { $0.consentStatusChanged(for: consentDefinition, error: error, requestedStatus: requestedStatus) }
        }
    }
}
