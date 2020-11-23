/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

enum PIMMethodType: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
}

protocol PIMRequestInterface {
    func getURL() -> URL?
    func getMethodType() -> String
    func getHeaderContent() -> Dictionary<String, String>?
    func getBodyContent() -> Data?
}
