//
//  PPRRegisterProductDelegateMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import XCTest

@testable import PhilipsProductRegistrationDev

class PPRRegisterProductDelegateMock: PPRRegisterProductDelegate {
    var product: PPRRegisteredProduct?
    var userProduct: PPRUserWithProducts?
    var asyncExpectation: XCTestExpectation?
    
    @objc func productRegistrationDidFail(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        guard let expectation = asyncExpectation else {
            XCTFail("PPRRegisterProductDelegateMock was not setup correctly")
            return
        }
        self.userProduct = userProduct
        self.product = product
        expectation.fulfill()
    }
    
    @objc func productRegistrationDidSucced(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        guard let expectation = asyncExpectation else {
            XCTFail("PPRRegisterProductDelegateMock was not setup correctly")
            return
        }
        self.userProduct = userProduct
        self.product = product
        expectation.fulfill()
    }
}
