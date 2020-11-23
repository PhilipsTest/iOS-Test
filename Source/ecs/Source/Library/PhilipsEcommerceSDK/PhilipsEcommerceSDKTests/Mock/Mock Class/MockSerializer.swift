
/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import AFNetworking

class MockRequestSerializer: AFHTTPRequestSerializer {
    
}

class MockResponseSerialization:NSObject, AIRESTClientURLResponseSerialization {
    func responseObject(for response: URLResponse?, data: Data?, error: NSErrorPointer) -> Any? {
        return nil
    }
    
    static var supportsSecureCoding: Bool = false
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
}
