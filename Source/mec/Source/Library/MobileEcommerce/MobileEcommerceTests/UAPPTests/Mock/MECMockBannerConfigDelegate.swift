/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import MobileEcommerceDev
import UIKit

class MECMockBannerConfigDelegate: NSObject, MECBannerConfigurationProtocol {
    
    func viewForBannerInProductListScreen() -> UIView? {
        let mockView = UIView()
        mockView.tag = 999
        return mockView
    }
}
