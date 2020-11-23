//
//  CloudRestClientMock.swift
//  AppInfraTests
//
//  Created by Philips on 5/31/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit
@testable import AppInfra

public class CloudRestClientMock: AICloudLoggerRestClient {

    
    public override init(appinfra: AIAppInfraProtocol, sharedKey:String?, secretKey:String? ) {
        
        super.init(appinfra: appinfra, sharedKey: sharedKey, secretKey: secretKey)
    }
    
    override public func uploadLog(logData:Data,  success: (() -> Swift.Void)?, failure: ((Bool ,Error?) -> Swift.Void)? = nil)   {
        success!()
    }
}
