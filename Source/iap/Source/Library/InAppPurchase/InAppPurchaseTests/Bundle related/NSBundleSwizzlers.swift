//
//  NSBundleSwizzlers.swift
//  InAppPurchase
//
//  Created by Rayan Sequeira on 26/08/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import Foundation
@testable import InAppPurchaseDev

extension Bundle {
    
    class func loadSwizzler() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(getter: main))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))!
        
        //swizzling mainBundle method with our own custom method
        method_exchangeImplementations(originalMethod, extendedMethod)

        /*var dispatchOnceToken: Int = 0
        dispatch_once(&dispatchOnceToken,  {

        let originalMethod : Method  = class_getClassMethod(self, #selector(getter: main))
        let extendedMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))
            
        //swizzling mainBundle method with our own custom method
        method_exchangeImplementations(originalMethod, extendedMethod)
        })*/
        //print("*****")
        //print(NSBundle.mainBundle().pathForResource("AppConfig", ofType: "json"))
    }
    
    class func deSwizzle() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(getter: main))!
        
        //swizzling mainBundle method with our own custom method
        method_exchangeImplementations(originalMethod, extendedMethod)

        /*var dispatchOnceToken: Int = 0
        dispatch_once(&dispatchOnceToken,  {
            let originalMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))
            let extendedMethod : Method  = class_getClassMethod(self, #selector(getter: main))
            
            //swizzling mainBundle method with our own custom method
            method_exchangeImplementations(originalMethod, extendedMethod)
        })*/
    }
    
    @objc class func bundleForTestTarget() -> Bundle {
        return Bundle(identifier: "com.philips.InAppPurchaseTests")!
    }
}
