/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsEcommerceSDK
import PlatformInterfaces

class ECSTestDemoConfiguration: NSObject {
    
    static let sharedInstance = ECSTestDemoConfiguration()
    var displayData: ECSTestMicroservicsData?
    var sharedAppInfra: AIAppInfra?
    var ecsServices: ECSServices?
    var userDataInterface: UserDataInterface?
}

enum ECSTextFieldType: Int {
    case stringText
    case integerText
    case picker
}

class ECSTestMasterData: NSObject {
    
    static let sharedInstance: ECSTestMasterData = ECSTestMasterData()
    
    var janrainAccessToken: String?
    var refreshToken: String?
    var productList: [ECSProduct]?
    var deliveryModes: [ECSDeliveryMode]?
    var regions: [ECSRegion]?
    var savedAddresses: [ECSAddress]?
    var savedPayments: [ECSPayment]?
    var placedOrderDetail: ECSOrderDetail?
    var orderHistory: ECSOrderHistory?
    
    // MARK: - PIL Microservices Variables
    
    var pilProductList: [ECSPILProduct]?
    var pilShoppingCart: ECSPILShoppingCart?
    
    func clearAllData() {
        productList = nil
        deliveryModes = nil
        regions = nil
        savedAddresses = nil
        savedPayments = nil
        placedOrderDetail = nil
        orderHistory = nil
        pilProductList = nil
        pilShoppingCart = nil
    }
}

extension ECSPILProduct {
    
    func ctn() -> String {
        return ctn ?? productPRXSummary?.ctn ?? ""
    }
}
