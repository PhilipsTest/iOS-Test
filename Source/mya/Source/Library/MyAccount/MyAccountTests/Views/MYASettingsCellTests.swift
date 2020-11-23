//
//  MYASettingsCellTests.swift
//  MyAccountTests
//
//  Created by leslie on 20/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import MyAccountDev
import PhilipsUIKitDLS

class MYASettingsCellTests: XCTestCase {
    
    func testsetSelected() {
        let theme = UIDThemeManager.sharedInstance.defaultTheme
        let cell = MYASettingsCell()
        cell.setSelected(true, animated: false)
        XCTAssertEqual(cell.contentView.backgroundColor, theme?.listItemDefaultOnBackground)
        cell.setSelected(false, animated: false)
        XCTAssertEqual(cell.contentView.backgroundColor, UIColor.clear)
    }
    
    func testsetHighlighted() {
        let theme = UIDThemeManager.sharedInstance.defaultTheme
        let cell = MYASettingsCell()
        cell.setHighlighted(true, animated: false)
        XCTAssertEqual(cell.contentView.backgroundColor, theme?.listItemDefaultOnBackground)
        cell.setHighlighted(false, animated: false)
        XCTAssertEqual(cell.contentView.backgroundColor, UIColor.clear)
    }
}
