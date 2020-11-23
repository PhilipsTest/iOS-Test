/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

enum OIDCConfigDownload {
    case notDownloaded
    case inProgress
    case downloaded
    case failed
}

extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Bundle {
    static func getPIMBundle() -> Bundle {
        return Bundle(for: PIMInterface.classForCoder())
    }
}

extension String {
    func localiseString(args: CVarArg...) -> String {
        let localizedFormat = NSLocalizedString(self, bundle: Bundle.getPIMBundle() , comment: self)
        return args.count == 0
            ? localizedFormat
            : String(format: localizedFormat, arguments: args)
    }
}

extension Notification.Name {
    static let configDownloadCompleted = Notification.Name(
        rawValue: "configDownloadCompleted")
}
