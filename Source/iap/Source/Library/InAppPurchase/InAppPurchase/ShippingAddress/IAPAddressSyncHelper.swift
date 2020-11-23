//
//  IAPAddressSyncHelper.swift
//  InAppPurchase
//
//  Created by Prasad Devadiga on 26/11/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import UIKit

class IAPAddressSyncHelper: NSObject {

    func getDeliveryAddressesForUser(_ success:@escaping (IAPUserAddressInfo)->(),failure:@escaping (NSError)->()){
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        let occInterface  = addressInterfaceBuilder.buildInterface()
        let httpInterface = occInterface.getInterfaceForGetAddress()
        occInterface.getAddressesForUser(httpInterface, completionHandler: {(inAddress:IAPUserAddressInfo)->() in
            success(inAddress)
        }) {(inError:NSError)->() in
            failure(inError)
        }
    }

    func addDeliveryAddress(_ inAddress:IAPUserAddress, success:@escaping (IAPUserAddress)->(),failure:@escaping (NSError)->()) {
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        addressInterfaceBuilder.initialiseBuilder(with: inAddress)
        let occInterface = addressInterfaceBuilder.buildInterface()
        let httpInterface = occInterface.getInterfaceForAddDeliveryAddress()
        occInterface.addDeliveryAddressForUser(httpInterface, completionHandler: {(inAddress:IAPUserAddress)->() in
            success(inAddress)
        }) {(inError:NSError)->() in
            failure(inError)
        }
    }

    func updateDeliveryAddress(_ inAddress:IAPUserAddress, isDefaultAddress:Bool = false, success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        addressInterfaceBuilder.initialiseBuilder(with: inAddress)
        let occInterface = addressInterfaceBuilder.withAddressID(inAddress.addressId).withDefault(isDefaultAddress).buildInterface()
        let httpInterface = occInterface.getInterfaceForUpdateAddress()
        occInterface.updateDeliveryAddressForUser(httpInterface, completionHandler: {(inSuccess:Bool)->() in
            success(inSuccess)})
        {(inError:NSError) in
            failure(inError)}
    }

    func getDefaultAddress(_ success:@escaping (IAPUserAddress?)->(), failure:@escaping (NSError)->()) {
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        let occInterface = addressInterfaceBuilder.buildInterface()
        let httpInterface = occInterface.getInterfaceForDefaultAddress()
        occInterface.getDefaultAddressForUserUsingInterface(httpInterface, completionHandler: {(defaultAddress) -> () in
            success(defaultAddress)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }

    func setDeliveryAddressID(_ addressID:String, success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        let occInterface = addressInterfaceBuilder.withAddressID(addressID).buildInterface()
        let httpInterface = occInterface.getInterfaceForSetDeliveryAddressID()
        occInterface.setDeliveryAddressIDForUser(httpInterface, completionHandler : { (inSuccess) -> () in
            success(inSuccess)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }

    func deleteAddress(_ addressID:String, success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        let occInterface = addressInterfaceBuilder.withAddressID(addressID).buildInterface()
        let httpIterface = occInterface.getInterfaceForDeleteAddress()
        occInterface.deleteAdress(httpIterface, completionHandler : { (inSuccess) -> () in
            success(inSuccess)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
}
