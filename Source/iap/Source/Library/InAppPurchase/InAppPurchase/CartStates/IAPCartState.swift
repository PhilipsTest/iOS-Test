/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol IAPCartStateProtocol {
    
    var client:IAPInterface? { set get }
    
    func addProduct(_ productCode:String,success:@escaping(Bool)->(),failureHandler:@escaping(NSError)->())
    func buyProduct(_ productCode:String,success:@escaping(Bool)->(),failureHandler:@escaping(NSError)->())
    func fetchCartCount(_ success:@escaping(Int)->(),failureHandler:@escaping(NSError)->())
    
}

extension IAPCartStateProtocol {
    func addProduct(_ productCode:String,success:@escaping(Bool)->(),failureHandler:@escaping(NSError)->()) {
        
    }
    
    func buyProduct(_ productCode:String,success:@escaping(Bool)->(),failureHandler:@escaping(NSError)->()) {
        print(":::::in cart state protocol")
    }
    
    func fetchCartCount(_ success:@escaping(Int)->(),failureHandler:@escaping(NSError)->()) {
        print(":::::in cart state protocol fetch cart count")
    }
}
