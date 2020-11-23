//
//  AIVersion.swift
//  AppInfra
//
//  Created by Hashim MH on 15/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

class AIVersion: NSObject {
    
    
    var versionString:String?
    
    public init(string: String?) {
        self.versionString = string
        super.init()
    }
    
    
    fileprivate func versionToInt() -> [Int] {
        if let versionString = versionString {
            return versionString.components(separatedBy: [".","-"])
                .map { Int.init($0) ?? 0 }
        }
        else{
            return []
        }
    }
    
    
    static func >(lhs: AIVersion, rhs: AIVersion) -> Bool {
        return rhs.versionToInt().lexicographicallyPrecedes(lhs.versionToInt())
    }
    
    
    static func >=(lhs: AIVersion, rhs: AIVersion) -> Bool {
        return lhs > rhs || rhs.versionString == lhs.versionString
    }
    
    
    static func <(lhs: AIVersion, rhs: AIVersion) -> Bool {
        return lhs.versionToInt().lexicographicallyPrecedes(rhs.versionToInt())
    }
    
    static func <=(lhs: AIVersion, rhs: AIVersion) -> Bool {
        return lhs < rhs || rhs.versionString == lhs.versionString
    }
    
    static func ==(lhs: AIVersion, rhs: AIVersion) -> Bool {
        return rhs.versionString == lhs.versionString        
    }
    
    
    override open var description: String { return versionString ?? "" }
    
    
}
