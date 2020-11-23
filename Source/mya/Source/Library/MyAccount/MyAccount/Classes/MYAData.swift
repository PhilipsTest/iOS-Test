//
//  MYAData.swift
//  MyAccount
//
//  Created by Hashim MH on 16/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
import UAPPFramework
import AppInfra
import PlatformInterfaces
internal var _shared: MYAData?

@objc internal class MYAData: NSObject {
    var dependency: UAPPDependencies!
    static let configGroup = MYA.tla
    var settings: UAPPSettings?
    var userProvider : UserDataInterface?
    var logger:AILoggingProtocol
    var tagging:AIAppTaggingProtocol
    var profileMenuList:[String]?
    var settingsMenuList:[String]?
    var additionalTabConfig:MYATabConfig?
    open weak var delegate: MYADelegate?

    @objc public class func setup(_ dependency: UAPPDependencies) -> MYAData {
        _shared = MYAData(dependency: dependency)
        return _shared!
    }

    public static let shared : MYAData = {
        assert((_shared != nil), "error: shared called before setup");
        return _shared!
    }()

    @objc public init(dependency: UAPPDependencies) {
        self.logger = dependency.appInfra.logging.createInstance(forComponent: MYA.tla, componentVersion: MYA.version)
        self.tagging = dependency.appInfra.tagging.createInstance(forComponent: MYA.tla, componentVersion: MYA.version)
        super.init()
        self.dependency = dependency
    }

    public func config(forKey key: String) throws ->  Any{
      return  try dependency.appInfra.appConfig.getPropertyForKey(key, group: MYAData.configGroup)
    }
    
   
}


