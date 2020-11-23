//
//  MyDetailsStateMock.swift
//  AppFrameworkTests
//
//  Created by philips on 4/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
@testable import AppFramework
@testable import ConsentWidgets

class ConsentWidgetsInterfaceMock: ConsentWidgetsInterface {
    var viewControllerToReturn : UIViewController?
    

    override func instantiateViewController(_ launchInput: UAPPLaunchInput?, withErrorHandler completionHandler: ((Error?) -> Void)?) -> UIViewController? {
        return viewControllerToReturn
    }
}

