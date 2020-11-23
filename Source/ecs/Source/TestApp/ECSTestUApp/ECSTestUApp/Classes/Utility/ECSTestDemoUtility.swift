/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

class ECSTestDemoUtility: NSObject {
    
    static func parseDisplayPlist() {
        if let path = Bundle(for: ECSTestDemoUtility.self).path(forResource: "ECSTestConfigure", ofType: "plist") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let plistDecoder = PropertyListDecoder()
                let configureData = try plistDecoder.decode(ECSTestMicroservicsData.self, from: data)
                ECSTestDemoConfiguration.sharedInstance.displayData = configureData
            } catch {}
        }
    }
}

extension UITextField {
    
    func extractCTNs() -> [String] {
        if let textFieldText = self.text, textFieldText.count > 0 {
            let commaSeparatedCTNs = textFieldText.components(separatedBy: ",")
            return commaSeparatedCTNs
        }
        return []
    }
}
