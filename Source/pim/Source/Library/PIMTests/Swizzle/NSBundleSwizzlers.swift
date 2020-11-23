//
//  NSBundleSwizzlers.swift
//  InAppPurchase
//
//  Created by Rayan Sequeira on 26/08/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import Foundation
@testable import PIMDev

extension Bundle {
    
    class func loadSwizzler() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(getter: main))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))!        
        method_exchangeImplementations(originalMethod, extendedMethod)
    }
    
    class func deSwizzle() {
        let originalMethod : Method  = class_getClassMethod(self, #selector(bundleForTestTarget))!
        let extendedMethod : Method  = class_getClassMethod(self, #selector(getter: main))!
        method_exchangeImplementations(originalMethod, extendedMethod)
    }
    
    @objc class func bundleForTestTarget() -> Bundle {
        return Bundle(identifier: "com.philips.PIMTests")!
    }
}
