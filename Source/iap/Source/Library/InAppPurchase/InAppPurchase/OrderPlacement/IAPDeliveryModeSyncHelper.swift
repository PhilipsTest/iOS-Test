/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit

class IAPDeliveryModeSyncHelper: NSObject {
    private func deliveryModeOCCInterface() -> IAPOCCPaymentInterface {
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        return paymentInterfaceBuilder.buildInterface()
    }

    func updateDeliveryMode(_ deliveryModeCode: String, success: @escaping (Bool)-> Void, failure: @escaping (NSError)-> Void) {
        let occInterface = deliveryModeOCCInterface()
        let httpInterface = occInterface.getInterfaceForSettingDeliveryMode(deliveryModeCode)
        occInterface.setDeliveryModeForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) in
            success(inSuccess)
        }) { (inError:NSError) in
            failure(inError)
        }
    }

    func deliveryMode(_ success: @escaping (IAPDeliveryModeDetails)-> Void, failure: @escaping (NSError)-> Void) {
        let occInterface = deliveryModeOCCInterface()
        let httpInterface = occInterface.getInterfaceForRetreivingDeliveryModes()
        occInterface.getDeliveryModesUsingInterface(httpInterface, completionHandler: { (withDeliveryMode) -> () in
            success(withDeliveryMode)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
}
