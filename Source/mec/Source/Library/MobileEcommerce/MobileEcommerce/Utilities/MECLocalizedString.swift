/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

func MECLocalizedString(_ key: String?, _ args: CVarArg...) -> String {
    guard let inKey = key else {
        return ""
    }
    let localizedFormat = NSLocalizedString(inKey, bundle: MECUtility.getBundle(), comment: inKey)
    return args.count == 0
        ? localizedFormat
        : String(format: localizedFormat, arguments: args)
}

func MECEnglishString(_ key: String?) -> String {
    if let path = MECUtility.getBundle().path(forResource: MECConstants.MECDefaultLanguage,
                                              ofType: MECConstants.MECLanguageFileType), let key = key {
        let bundle = Bundle(path: path)
        return bundle?.localizedString(forKey: key, value: key, table: nil) ?? ""
    }
    return ""
}
