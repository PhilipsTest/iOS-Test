/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import UIKit
@testable import InAppPurchaseDev

class IAPSalutationViewControllerTests: XCTestCase {

    var iapSalutationVC: IAPSalutationViewController!
    var selectedSalutation: Salutation!

    override func setUp() {
        super.setUp()

        iapSalutationVC = IAPSalutationViewController()
        iapSalutationVC.completion = { selected in
            self.selectedSalutation = selected
        }
        iapSalutationVC.viewDidLoad()
        iapSalutationVC.didReceiveMemoryWarning()
    }
    
    func testSalutationSelected() {
        let sender: UIButton = UIButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        sender.tag = 111
        iapSalutationVC.salutationSelected(sender)
        XCTAssertTrue(self.selectedSalutation == .mr, "Salutation method is not invoked")

        sender.tag = 222
        iapSalutationVC.salutationSelected(sender)
        XCTAssertTrue(self.selectedSalutation == .ms, "Salutation method is not invoked")
    }
}
