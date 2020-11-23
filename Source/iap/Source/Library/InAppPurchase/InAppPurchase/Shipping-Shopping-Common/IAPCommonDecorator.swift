/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

protocol IAPAddressDecoratorProtocol: class {
    // MARK: Address Decorator Delegate methods
    func didSelectEditAddress(_ inAddress:IAPUserAddress)
    func didSelectAddAddress(_ inAddress:IAPUserAddress?)
    func didSelectDeliverToAddress(_ inAddress:IAPUserAddress)
    func didSelectDeleteAddress(_ inAddress:IAPUserAddress)
}

protocol IAPShoppingDecoratorProtocol: class {
    //MARK: Adjust view
    func adjsutView(_ shouldEnable:Bool)
    
    // MARK: Shopping Decorator Delegate methods
    func pushDetailView(_ withObject:IAPProductModel)
    //func pushToVoucherView()
    func displayDeliveryModeView()
    func updateQuantity(_ objectToBeUpdated:IAPProductModel,withCartInfo:IAPCartInfo,quantityValue:Int)
    func displayVoucherView()
}

