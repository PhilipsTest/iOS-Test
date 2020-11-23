//
//  ConsentDefinitionTests.swift
//  ConsentAccessToolKitTests
//
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import PlatformInterfacesDev

class ConsentDefinitionTests: XCTestCase {
    
    func testConsentDefinitionCreationWithSingleType() {
        let consentDefinitionForMoments = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForCoaching = ConsentDefinition(type: "Coaching", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForBinary = ConsentDefinition(type: "binary", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        thenConsentDefinitionsAreNotNil(for: [consentDefinitionForCoaching, consentDefinitionForMoments, consentDefinitionForBinary])
    }

    func testConsentDefinitionWithMultipleType() {
        let expectedTypes = ["Moment", "Coaching", "Binary"]
        let consentDefinitionForMoments = ConsentDefinition(types: expectedTypes, text: "text", helpText: "helpText", version: 1, locale: "en-US")
        thenConsentDefinitionsAreNotNil(for: [consentDefinitionForMoments])
        thenTheConsentTypesAre(of: [consentDefinitionForMoments], with: expectedTypes)
    }
    
    func testConsentDefinitionCreationWithMultipleTypeValues() {
        let expectedTypes = ["Moment", "Coaching", "Binary"]
        thenTheConsentTypesAre(of: [ConsentDefinition(types: expectedTypes, text: "text", helpText: "helpText", version: 1, locale: "en-US")], with: expectedTypes)
    }
    
    func testConsentDefinitionWithRevokeMessage() {
        let expectedMessage = "Revoke consent message"
        let consent = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US", revokeMessage: expectedMessage)
        XCTAssertTrue(expectedMessage == consent.revokeMessage)
    }
    
    func testConsentDefinitionWithMultipleTypesAndRevokeMessage() {
        let expectedMessage = "Revoke consent message"
        let expectedTypes = ["Moment", "Coaching", "Binary"]
        let consent = ConsentDefinition(types: expectedTypes, text: "text", helpText: "helpText", version: 1, locale: "en-US", revokeMessage: expectedMessage)
        XCTAssertTrue(expectedMessage == consent.revokeMessage)
    }

    func testEquality() {
        let consentDefinitionForMoment1 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForMoment2 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForArray1 = ConsentDefinition(types: ["Moment", "Coaching"], text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForArray2 = ConsentDefinition(types: ["Moment", "Coaching"], text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForArray3 = ConsentDefinition(types: ["Moment", "Moment"], text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForArray4 = ConsentDefinition(types: ["Coaching", "Moment"], text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForCoaching = ConsentDefinition(type: "Coaching", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        XCTAssertTrue(consentDefinitionForMoment1 == consentDefinitionForMoment2)
        XCTAssertTrue(consentDefinitionForArray1 == consentDefinitionForArray2)
        XCTAssertFalse(consentDefinitionForArray1 == consentDefinitionForArray3)
        XCTAssertTrue(consentDefinitionForArray1 == consentDefinitionForArray4)
        XCTAssertFalse(consentDefinitionForMoment1 == consentDefinitionForCoaching)
    }
    
    func testConsentWithoutRevokeMessageIsDifferentToSameConsentWithRevokeMessage() {
        let consentDefinitionForMoment1 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US")
        let consentDefinitionForMoment2 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US", revokeMessage: "Revoke message")
        XCTAssertFalse(consentDefinitionForMoment1 == consentDefinitionForMoment2)
    }
    
    func testConsentEqualityWithRevokeMessage() {
        let consentDefinitionForMoment1 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US", revokeMessage: "Revoke message")
        let consentDefinitionForMoment2 = ConsentDefinition(type: "Moment", text: "text", helpText: "helpText", version: 1, locale: "en-US", revokeMessage: "Revoke message")
        XCTAssertTrue(consentDefinitionForMoment1 == consentDefinitionForMoment2)
    }
    
    private func thenConsentDefinitionsAreNotNil(for expectedDefinitions: [ConsentDefinition]) {
        for consentDefinition in expectedDefinitions {
            XCTAssertNotNil(consentDefinition, "Consent Definition passed as input is nil")
        }
    }

    private func thenTheConsentTypesAre(of consentDefinitions: [ConsentDefinition], with expectedTypes: [String]) {
        for consentDefinition in consentDefinitions {
            XCTAssert(consentDefinition.getTypes().count == expectedTypes.count, "Count of types are not matching")
        }
        
        for consentDefinition in consentDefinitions {
            let consentDefinitionSet = Set(consentDefinition.getTypes())
            let passedExpectedTypesSet = Set(expectedTypes)
            let intersectingSet = consentDefinitionSet.intersection(passedExpectedTypesSet)
            XCTAssert(intersectingSet.count == expectedTypes.count, "The intersecting set count is not what is expected by the caller of this method.")
        }
    }
    
}
