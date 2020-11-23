//
//  PPRDemoFrameworkInterfaceWrapper.swift
//  PPRDemoFramework
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit

class MYADemoFrameworkInterfaceWrapper: NSObject {
    
    var interfaceDependencies: MYADemoFrameworkDependencies?
    
    static let sharedInstance: MYADemoFrameworkInterfaceWrapper = {
        let instance = MYADemoFrameworkInterfaceWrapper()
        // setup code
        return instance
    }()
    
    override init() {
        super.init()
    }
}
