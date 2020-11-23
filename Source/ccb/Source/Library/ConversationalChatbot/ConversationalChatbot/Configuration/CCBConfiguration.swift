/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import UAPPFramework

@objcMembers open class CCBConfiguration: NSObject {
    
    open var chatbotSecretKey: String?
    
    open var chatbotUserName: String?
    
    open var chatbotEmailId: String?
    
    open var deviceCapability:CCBDeviceCapabilityInterface?
    
    //TODO: decission to be taken for finalizing constructor parameters
    public override init() {
        super.init()
    }
}

public protocol CCBDeviceCapabilityInterface : NSObject {
    
    func isDeviceConnected(deviceID:String) -> Bool
}
