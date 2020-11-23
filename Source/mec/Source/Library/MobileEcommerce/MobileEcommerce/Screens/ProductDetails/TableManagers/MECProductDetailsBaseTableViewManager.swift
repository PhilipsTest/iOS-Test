/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class MECProductDetailsBaseTableViewManager: NSObject {

    weak var presenter: MECProductDetailsPresenter!

    init(detailsPresenter: MECProductDetailsPresenter) {
        self.presenter = detailsPresenter
        super.init()
    }
}
