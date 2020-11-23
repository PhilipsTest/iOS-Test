/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

public class AppInfraTimeMock: NSObject, AITimeProtocol {
    
    public func getUTCTime() -> Date! { return Date() }
    
    public func refreshTime() {}
    
    public func isSynchronized() -> Bool { return false }
}
