/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let addressFieldConfigurationFileName = "addressFieldConfiguration"
let excludedFields                    = "excludedFields"
let fileType                          = "json"

class IAPAddressFieldConfigurator: NSObject {

    private func configurationData()-> [String: [String]]? {
        guard let path = IAPUtility.getBundle().path(forResource: addressFieldConfigurationFileName, ofType: fileType) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any], let excludedFields = jsonResult[excludedFields] as? [String: [String]] {
                return excludedFields
            }
        } catch {
            return nil
        }
        return nil
    }

    func configureAddressView(viewList: [IAPAddressItemView], for country: String) {
        guard let configuration = configurationData() else {
            return
        }
        guard let configure = configuration[country] else { return }
        for view in viewList {
            if let identifier = view.addressItemViewIdentifier {
                view.isHidden = configure.contains(identifier)
            }
        }
    }
}

