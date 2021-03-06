/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MockUtility: NSObject {
    static var service: ECSServices?
    
    @objc dynamic class func serviceObject() -> ECSServices? {
        return MockUtility.service
    }
}
