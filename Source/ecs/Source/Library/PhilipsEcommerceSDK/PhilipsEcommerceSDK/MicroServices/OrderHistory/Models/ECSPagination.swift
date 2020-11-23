/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPagination
@objcMembers public class ECSPagination: NSObject, Codable {
    public var currentPage: Int?
    public var pageSize: Int?
    public var sort: String?
    public var totalPages, totalResults: Int?
}
