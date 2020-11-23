/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MECErrorUtility: NSObject {
    class func prepareNoAutherizationError() -> NSError {
        return NSError(domain: MECErrorDomain.MECAuthentication,
                       code: MECErrorCode.MECAuthentication,
                       userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_cart_login_error_message")])
    }

    class func prepareHybrisDisabledError() -> NSError {
        return NSError(domain: MECErrorDomain.MECHybrisDisabled,
                       code: MECErrorCode.MECHybrisDisabled,
                       userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_no_philips_shop")])
    }

    class func checkHybrisEntryValidation() -> NSError? {
        guard MECConfiguration.shared.supportsHybris == true else {
            return MECErrorUtility.prepareHybrisDisabledError()
        }
        guard MECConfiguration.shared.isUserLoggedIn else {
            return MECErrorUtility.prepareNoAutherizationError()
        }
        return nil
    }
}
