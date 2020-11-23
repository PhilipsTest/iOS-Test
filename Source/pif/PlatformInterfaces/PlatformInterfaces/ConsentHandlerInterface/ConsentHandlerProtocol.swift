/* Copyright (c) Koninklijke Philips N.V., 2019
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

@objc public protocol ConsentHandlerProtocol {
   @objc func fetchConsentTypeState(for consentType: String, completion: @escaping (_ consent: ConsentStatus?, _ error: NSError?) -> Void)
    @objc func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (_ success: Bool, _ error: NSError? ) -> Void)
}
