/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit

protocol IAPPaginationProtocol {
    var paginationModel:IAPPaginationModel! { set get }
    func resetDataFetchingValue(_ inValue:Bool)
    func shouldFetchData()->Bool
}

extension IAPPaginationProtocol {

    func resetDataFetchingValue(_ inValue:Bool) {
        guard let model = self.paginationModel else { return }
        model.setIsFecthing(inValue)
    }

    func shouldFetchData()->Bool {
        guard let model = self.paginationModel , model.isDataPending() else { return false }
        return true
    }
}
