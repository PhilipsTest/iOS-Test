//
//  MYAExtensions.swift
//  MyAccount
//
//  Created by philips on 3/5/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func removeDuplicateItemsFromList() -> Array<Element> {
        let uniqueElementsArray = NSOrderedSet(array: self )
        if let uniqueElements = uniqueElementsArray.array as? [Element] {
            return uniqueElements
        }
        return self
    }
}
