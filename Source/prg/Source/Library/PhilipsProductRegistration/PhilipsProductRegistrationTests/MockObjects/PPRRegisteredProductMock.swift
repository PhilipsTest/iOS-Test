//
//  PPRRegisteredProductMock.swift
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

class PPRRegisteredProductMock: PPRRegisteredProduct  {
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var requestManagerMock: PRXRequestManagerMock!
    class func regististerdProductFrom(_ product: PPRProduct) -> PPRRegisteredProductMock {
        let regProductMock = PPRRegisteredProductMock(ctn: product.ctn, sector: product.sector, catalog: product.catalog)
        regProductMock.purchaseDate = product.purchaseDate
        regProductMock.serialNumber = product.serialNumber
        regProductMock.sendEmail = product.sendEmail
        return regProductMock
    }
    /*
    override func getProductMetaData(_ success: @escaping PPRSuccess, failure: PPRFailure) {
        let metaData: PRXProductMetaDataRequest = PRXProductMetaDataRequest(product: self)
        self.requestManagerMock.execute(metaData, completion: success, failure: failure)
    } */
}
