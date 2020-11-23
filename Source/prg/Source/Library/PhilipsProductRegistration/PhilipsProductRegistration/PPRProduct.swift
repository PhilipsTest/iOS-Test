//
//  PPRProduct.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
import AppInfra

/// This is a model class which takes product inputs.
/// - Since: 1.0.0
@objc open class PPRProduct: NSObject {
    fileprivate struct DateComponents {
        static let minimumDateComponent: Foundation.DateComponents = {
            var component = Foundation.DateComponents()
            component.day = 31
            component.month = 12
            component.year = 2000
            component.hour = 23
            component.minute = 59
            component.second = 59
            return component
        }()
    }
    /// It's a mandatory property. It stores the CTN of any product. This property's setter is private. Use designated initializer.
    /// - Since: 1.0.0
    @objc public private(set) var ctn: String
    /// It's an optional property. Represents the purchase date of the product.
    /// - Since: 1.0.0
    @objc public var purchaseDate: Date?
    /// This is also an optional property. Takes the serial number of the product.
    /// - Since: 1.0.0
    @objc public var serialNumber: String?
    /// This is also an optional property. Takes the friendly name of the product.
    /// - Since: 1.0.0
    @objc public var friendlyName: String?
    /// It's a mandatory property. Expects enum values of **Sector**. This property's setter is private. Use designated initializer.
    /// - Since: 1.0.0
    @objc public private(set) var sector: Sector
    /// It's also a mandatory property. Accepts enum values of **Catalog**. This property's setter is private. Use designated initializer.
    /// - Since: 1.0.0
    @objc public private(set) var catalog: Catalog
    /// It's a date property. Gives product registration date.
    /// - Since: 1.0.0
    @objc public var registrationDate: Date?

    lazy var requestManager: PRXRequestManagerWrapper = {
        return PRXRequestManagerWrapper()
    }()
    
    private lazy var errorHelper: PPRErrorHelper = {
        return PPRErrorHelper()
    }()
    
    private var minimumDate: Date {
        get {
            return Date().dateWith(DateComponents.minimumDateComponent)!
        }
    }
    
    private var maximumDate: Date {
        get {
            return Date()
        }
    }
    
    var isValidDate: Bool {
        get {
            if  let date = self.purchaseDate {
                
                
                return date.compare(self.minimumDate) == ComparisonResult.orderedDescending && date.compare(maximumDate) == ComparisonResult.orderedAscending
            }
            return true
        }
    }
    
    var isCTNNotNil: Bool {
        get{
            return (self.ctn.trimmWhiteSpaces.length > 0)
        }
    }
    private var willSendEmail: Bool = true
    /// This is an optional boolean property. Default value is true. Email will be sent on successful registration of a new product. If email is not required, then set it to false.
    /// - Since: 1.0.0
    @objc public var sendEmail: Bool{
        get {
            return willSendEmail
        }
        set(value){
            willSendEmail = value
        }
    }
    
    /// Designated Initializer.
    ///
    /// - Parameters:
    ///   - ctn: *String* object. CTN value of the product. Can't be nil.
    ///   - sector: Value of enum *Sector*.
    ///   - catalog: Value of enum *Catalog*.
    /// - Since: 1.0.0
    @objc public init(ctn: String, sector: Sector, catalog: Catalog) {
        self.ctn = ctn.trimmWhiteSpaces
        self.sector = sector
        self.catalog = catalog
    }
    
    func getProductMetaData(success: @escaping PPRSuccess, failure: @escaping PPRFailure)
    {
        if self.isCTNNotNil == false {
            self.errorHelper.handleError(statusCode: PPRError.CTN_NOT_ENTERED.rawValue, failure: failure)
        } else {
            let metaData: PRXProductMetaDataRequest = PRXProductMetaDataRequest(product: self)
            self.executeRequest(request: metaData, requestType: REQUEST_TYPE.METADATA, success: success ,failure: failure)
        }
    }
    
    func getProductSummary(success: @escaping PPRSuccess, failure: @escaping PPRFailure) {
        if self.isCTNNotNil == false {
            self.errorHelper.handleError(statusCode: PPRError.CTN_NOT_ENTERED.rawValue, failure: failure)
        } else {
            let metaData: PRXProductSummaryDataRequest = PRXProductSummaryDataRequest(product: self)
            
            self.executeRequest(request: metaData, requestType: REQUEST_TYPE.PRODUCT_SUMMARY, success: success ,failure: failure)
        }
    }
    
    private func executeRequest(request: PRXRequest,
                                requestType: REQUEST_TYPE,
                                success: @escaping PPRSuccess,
                                failure: @escaping PPRFailure)
    {
        self.requestManager.requestType = requestType
        self.requestManager.execute(request, success: success, failure: failure)
    }
    
    /// Provides details of the product.
    /// - Returns: A String with product information.
    /// - Since: 1.0.0
    @objc open override var description: String {
        return "Product: Ctn: \(ctn), SerialNumber: \(String(describing: serialNumber)), PurchaseDate: \(String(describing: purchaseDate)), RegistrationDate: \(String(describing: registrationDate))"
    }
}
