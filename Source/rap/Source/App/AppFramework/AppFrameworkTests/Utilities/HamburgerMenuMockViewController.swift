//
//  HamburgerMenuMockViewController.swift
//  AppFramework
//
//  Created by Philips on 1/17/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation
@testable import PhilipsUIKitDLS
@testable import AppFramework

class HamburgerMenuMockViewController: HamburgerMenuViewController {
    
    
    internal func intialiazeMock() {
        //super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = HamburgerMenuPresenter(_viewController: self)
        let mockMenuData = BAHamburgerMenuData(menuID: "Mock Menu", screenTitle:"Mock Title", icon: "Mock Icon")
        showHamburgerMenu(menu: mockMenuData)
        
    }
    
  }
