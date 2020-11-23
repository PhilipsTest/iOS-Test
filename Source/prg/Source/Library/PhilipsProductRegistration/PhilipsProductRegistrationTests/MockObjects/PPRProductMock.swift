//
//  PPRProductMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
@testable import PhilipsProductRegistrationDev

class PPRProductMock: PPRProduct {
    var requestManagerMock: PRXRequestManagerMock!
    override init(ctn: String, sector: Sector, catalog: Catalog)
    {
        super.init(ctn: ctn, sector: sector, catalog: catalog)
    }
    /*
    override func getProductMetaData(success: @escaping PPRSuccess, failure: @escaping PPRFailure) {
        let metaData: PRXProductMetaDataRequest = PRXProductMetaDataRequest(product: self)
        self.requestManagerMock.execute(metaData, completion: success, failure: failure)
    } */
}
