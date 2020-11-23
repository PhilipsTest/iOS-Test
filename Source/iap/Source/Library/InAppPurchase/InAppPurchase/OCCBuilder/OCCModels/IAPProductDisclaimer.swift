//
//  IAPProductDisclaimer.swift
//  InAppPurchase
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import UIKit
import PhilipsPRXClient
struct IAPProductDisclaimer {

    var disclaimerText: String?
    var referenceName: String?

    init(with disclaimer: PRXDisclaimer ) {
        disclaimerText = disclaimer.disclaimerText
        referenceName = disclaimer.referenceName
    }
}
