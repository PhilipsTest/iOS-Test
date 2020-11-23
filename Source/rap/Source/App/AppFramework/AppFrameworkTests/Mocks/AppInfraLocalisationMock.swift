//
//  AppInfraLocalisationMock.swift
//  AppFrameworkTests
//
//  Created by Niharika Bundela on 7/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import AppInfra

class AppInfraLocalisationMock: NSObject, AIInternationalizationProtocol {
    func getUILocale() -> Locale! {
        return Locale(identifier: "en")
    }
    
    func getUILocaleString() -> String! {
        return "en-US"
    }
    
    func getBCP47UILocale() -> String! {
        return "en-US"
    }
    
    
}
