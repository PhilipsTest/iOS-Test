//
//  IAPInterfaceMock.swift
//  AppFramework
//
//  Created by Philips on 9/15/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation
@testable import AppFramework
@testable import InAppPurchase
@testable import UAPPFramework



class IAPInterfaceMock: IAPInterface {
    
    var isHybrisEnabled = false
    var setMockedHybrisFlow = false
    var error :NSError?
    var mockProductCount:Int = 0
    var viewController:UIViewController?
    
    
    override func isCartVisible(_ success: @escaping (Bool) -> (), failureHandler: @escaping (NSError) -> ()) {
       setMockedHybrisFlow = true
        success(isHybrisEnabled)
        if let errorThrow = error{
           failureHandler(errorThrow)
        }
       
    }
    
    override func getProductCartCount(_ success: @escaping (Int) -> (), failureHandler: @escaping (NSError) -> ()) {
        if let errorThrow = error{
            failureHandler(errorThrow)
            UserDefaults.standard.set(0, forKey: Constants.BADGE_COUNT)

        }else{
             UserDefaults.standard.set(5, forKey: Constants.BADGE_COUNT)
           success(mockProductCount)
        }
    }
    
    override func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)?) -> UIViewController? {
        if let controller = self.viewController{
            return controller
        }else{
            if let domainError = self.error{
                if (completionHandler?(domainError)) != nil{
                    completionHandler?(domainError)
                }
            }
            return nil
        }
    }
}
