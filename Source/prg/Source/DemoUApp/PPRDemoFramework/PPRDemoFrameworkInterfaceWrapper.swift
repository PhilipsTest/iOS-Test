//
//  PPRDemoFrameworkInterfaceWrapper.swift
//  PPRDemoFramework
//
//  Created by Abhishek on 22/03/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit
import PhilipsProductRegistration

class PPRDemoFrameworkInterfaceWrapper: NSObject {
    
    var interfaceDependencies: PPRInterfaceDependency?

    static let sharedInstance: PPRDemoFrameworkInterfaceWrapper = {
        let instance = PPRDemoFrameworkInterfaceWrapper()
        // setup code
        return instance
    }()
    
    override init() {
        super.init()
    }
}
