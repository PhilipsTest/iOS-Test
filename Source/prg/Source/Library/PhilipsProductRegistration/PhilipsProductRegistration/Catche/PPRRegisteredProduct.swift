//
//  PPRRegisteredProduct.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
/// State enum denotes the current status of registration for any product
/// - Since: 1.0.0
@objc public enum State: Int {
    /// This state means the registration is still pending for the product.
    /// - Since: 1.0.0
    case PENDING
    /// This state means the registration is failed for the product.
    /// - Since: 1.0.0
    case FAILED
    /// This state means the product is registered successfully.
    /// - Since: 1.0.0
    case REGISTERED
}

/// This class is inherited from **PPRProduct**. After a product is attempted for registration, the object of this class is created with the existing information from object of PPRProduct and additional information of registration status.
/// - Since: 1.0.0
@objc public class PPRRegisteredProduct : PPRProduct,NSCoding  {
    private var _error: NSError?
    /// Its a String property. Gives the contract number.
    /// - Since: 1.0.0
    @objc public var contractNumber: String?
    /// Its a NSDate property. Gives the date when warrenty ends.
    /// - Since: 1.0.0
    @objc public var endWarrantyDate: Date?
    /// Its a String property. Gives the UUID of the user for which the product is registered.
    /// - Since: 1.0.0
    @objc public var userUuid: String?
    /// Its a String property. Gives the locale in which the product is registered.
    /// - Since: 1.0.0
    @objc public var registeredLocale: String?
    /// Its a String property. Gives the status of email for the product registered.
    /// - Since: 1.0.0
    @objc public var emailStatus: String?
    /// Its an enum property. Gives the current state of registration of the product.
    /// - Since: 1.0.0
    @objc public private(set) var state: State
    /// Its a NSError property. Gives the complete error while registering the product.
    /// - Since: 1.0.0
    @objc public var error: NSError? {
        get {
            return _error
        }
        set {
            _error = newValue
            self.registrationStateFor(error: _error)
        }
    }
    
    override init(ctn: String, sector: Sector, catalog: Catalog) {
        self.state = .PENDING
        super.init(ctn: ctn, sector: sector, catalog: catalog)
    }
    
    private func registrationStateFor(error: NSError?) {
        if error == nil || (error?.code == PPRError.PRODUCT_ALREADY_REGISTERD.rawValue) {
            self.state = .REGISTERED
        } else {
            self.state = .FAILED
        }
    }
    /**
     Initializing with a coder.
     
     - parameters:
     
     - decoder: An unarchiver object.
     
     - returns: Returns an object initialized from data in a given unarchiver.
     */
    /// - Since: 1.0.0
    required convenience  public init(coder aDecoder: NSCoder) {
        let strSector = aDecoder.decodeObject(forKey: "sector") as? String
        let ctn = aDecoder.decodeObject(forKey: "ctn") as! String
        let purchaseDate = aDecoder.decodeObject(forKey:"purchaseDate") as?  Date
        let serialNumber = aDecoder.decodeObject(forKey:"serialNumber") as? String
        let strCatalog = aDecoder.decodeObject(forKey:"catalog") as? String
        let isSendingEmail = aDecoder.decodeBool(forKey:"sendEmail") as Bool
        
        let sector: Sector = Sector(rawValue:UInt32(strSector!)!)
        let catalog : Catalog = Catalog(rawValue: UInt32(strCatalog!)!)
        self.init(ctn:ctn, sector: sector, catalog: catalog)
        self.purchaseDate = purchaseDate
        self.serialNumber = serialNumber
        self.sendEmail = isSendingEmail
        self.contractNumber = aDecoder.decodeObject(forKey:"contractNumber") as?  String
        let statenumber: NSNumber = (aDecoder.decodeObject(forKey:"state") as? NSNumber)!
        self.state = State(rawValue:Int(truncating: statenumber))!
        self.endWarrantyDate = aDecoder.decodeObject(forKey:"endWarrantyDate") as? Date
        self.userUuid = aDecoder.decodeObject(forKey:"userUuid") as?  String
        self.registeredLocale = aDecoder.decodeObject(forKey:"registeredLocale") as? String
        self.emailStatus = aDecoder.decodeObject(forKey:"emailStatus") as? String
        self.error = aDecoder.decodeObject(forKey:"error") as? NSError
        self.registrationDate = aDecoder.decodeObject(forKey: "registrationDate") as?  Date
    }
    /**
     Encoding with a coder.
     
     - parameters:
     
     - encoder: An archiver object.
     
     */
    /// - Since: 1.0.0

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ctn, forKey: "ctn")
        aCoder.encode(self.purchaseDate,forKey:"purchaseDate")
        aCoder.encode(self.serialNumber, forKey: "serialNumber")
        aCoder.encode(self.sector.rawValue.description  , forKey: "sector")
        aCoder.encode(self.catalog.rawValue.description , forKey: "catalog")
        aCoder.encode(self.sendEmail, forKey: "sendEmail")
        aCoder.encode(self.contractNumber, forKey: "contractNumber")
        aCoder.encode(NSNumber(value:self.state.rawValue), forKey: "state")
        aCoder.encode(self.endWarrantyDate, forKey: "endWarrantyDate")
        aCoder.encode(self.userUuid, forKey: "userUuid")
        aCoder.encode(self.registeredLocale, forKey: "registeredLocale")
        aCoder.encode(self.emailStatus, forKey: "emailStatus")
        aCoder.encode(self.error, forKey: "error")
        aCoder.encode(self.registrationDate,forKey:"registrationDate")
    }
    
    
    func updateRegisteredProductWith(response: PRXResponseData?) -> PPRRegisteredProduct
    {
        let prxRegisterdProductResponse = response as? PRXRegisterProductResponse
        let infoData = prxRegisterdProductResponse?.data
        self.contractNumber = infoData?.contractNumber
        self.endWarrantyDate = infoData?.warrantyEndDate as Date?
        self.registeredLocale = infoData?.locale
        self.emailStatus = infoData?.emailStatus
        self.error = nil
        self.purchaseDate = infoData?.dateOfPurchase
        self.registrationDate = infoData?.registrationDate as Date?

        return self
    }
    /**
     Provides details of the Product.
     
     - returns: A String with product information.
     
     */
    /// - Since: 1.0.0
    @objc public override var description: String {
        return  super.description+"ContractNumber: \(String(describing: contractNumber)), UserUuid: \(String(describing: userUuid)), EndWarrantyDate: \(String(describing: endWarrantyDate)), RegisteredLocale: \(String(describing: registeredLocale)), EmailStatus: \(String(describing: emailStatus)), Error: \(String(describing: error))"
    }
}
