//
//  JITViewControllerMock.swift
//  AppFrameworkTests
//
//  Created by Ravi Kiran HR on 02/07/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
@testable import ConsentWidgets
class JITViewControllerMock: NSObject,JustInTimeViewControllerProtocol {
    public var JITPageInstantiated = false
    func getJustInTimeConsentViewController(justInTimeConsentDelegate: JustInTimeConsentViewProtocol) -> UIViewController {
        JITPageInstantiated = true
        let vc = UIViewController()
        return vc
    }
    
}
