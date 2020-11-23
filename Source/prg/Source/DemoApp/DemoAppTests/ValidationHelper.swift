//
//  ValidationHelper.swift
//  DemoAppTests
//
//  Created by Adarsh Kumar Rai on 28/02/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import EarlGrey
import XCTest


class ValidationHelper {
    
    @discardableResult class func isScreenTitleEqualTo(_ title: String) -> Bool {
        let assertion = GREYAssertionBlock.assertion(withName: "Screen title assertion for title \(title)") { (element, error) -> Bool in
            var errorReason = ""
            if let element = element as? UINavigationBar {
                if let screenTitle = element.topItem?.title, screenTitle == title {
                    return true
                } else {
                    errorReason = "Title did not match."
                }
            } else {
                errorReason = "Could not find the navigation bar."
            }
            error?.pointee = NSError.init(domain: "EarlGrey", code: 1001, userInfo: [kGREYAssertionErrorUserInfoKey : errorReason,
                                                                                     NSLocalizedDescriptionKey      : errorReason])
            return false
        }
        var assertionError: NSError?
        EarlGrey.selectElement(with: grey_kindOfClass(UINavigationBar.self)).assert(assertion, error: &assertionError)
        return (assertionError == nil)
    }
    
    
    class func assertCurrentScreenHasTitle(_ title: String) {
        let assertionDescription = "Expected current screen title to be '\(title)' but could not match it"
        XCTAssertTrue(self.isScreenTitleEqualTo(title), assertionDescription)
    }
    
    
    class func tapNavigationBackButton() {
        var topController = UIApplication.shared.keyWindow!.rootViewController!
        while topController.presentedViewController != nil {
            topController = topController.presentedViewController!
        }
        if let topController = topController as? UINavigationController {
            topController.popViewController(animated: true)
        }
    }
    
}
