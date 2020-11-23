//
//  PPRInterfaceInput.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 18/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import UAPPFramework

private var _interfaceSharedInstance: PPRInterfaceInput?
private var setupOnceToken: Int = 0
public typealias PPRComplectionHandler = (Error?) -> Void

/// - Since: 1.0.0
@objc open class PPRInterfaceInput: NSObject {

    var appDependency: PPRInterfaceDependency
    var appSettings: UAPPSettings!
    var tagging: AIAppTaggingProtocol
    var pprCompletionHandler: PPRComplectionHandler?
    var appinfraLocale: String?
    
    /// userWithProduct is the class for registering a product and getting list of all registered products for a valid signed in user.
    /// - Since: 1.0.0
    @objc open lazy var userWithProduct: PPRUserWithProducts = {
        return PPRProductRegistrationHelper().getSignedInUserWithProudcts()
    }()!
    
    class func setup(_ dependency: PPRInterfaceDependency) -> PPRInterfaceInput {
        _interfaceSharedInstance = PPRInterfaceInput(dependency: dependency)
        return _interfaceSharedInstance!
    }
    
    /// provides the sharedInstance of the userWithProduct object
    /// - Since: 1.0.0
    @objc public static let sharedInstance : PPRInterfaceInput = {
        assert((_interfaceSharedInstance != nil), "error: shared called before setup");
        return _interfaceSharedInstance!
    }()
    
    func setAppLocale(with locale: String) {
        appinfraLocale = locale
    }
    
    func getAppLocale() -> String? {
        return appinfraLocale?.replacingOccurrences(of: "-", with: "_")
    }
    
    init(dependency: PPRInterfaceDependency) {
        let versionNumberString = Bundle.applicationVersionNumber

        self.appDependency = dependency
        self.tagging = self.appDependency.appInfra.tagging.createInstance(forComponent: PPRTagging.kPPRAppName, componentVersion:versionNumberString)
    }
}
