/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import PhilipsRegistration

class DIUserMock : DIUser {
    fileprivate static var __once: () = {
        
        var originalMethod = class_getClassMethod(DIUser().classForCoder,
                                                     #selector(DIUser.getInstance))
        var swizzledMethod = class_getInstanceMethod(DIUserMock.classForCoder(),
                                                     #selector(DIUserMock.mockInstance))
            
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        originalMethod = class_getInstanceMethod(DIUser().classForCoder,
                                                 NSSelectorFromString("hsdpAccessToken"))
        swizzledMethod = class_getInstanceMethod(DIUserMock.classForCoder(),
                                                 #selector(getter: DIUserMock.varHsdpAccessToken))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        originalMethod = class_getInstanceMethod(DIUser().classForCoder,
                                                 NSSelectorFromString("hsdpUUID"))
        swizzledMethod = class_getInstanceMethod(DIUserMock.classForCoder(),
                                                 #selector(getter: DIUserMock.varHsdpUUID))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        }()
    fileprivate static var __deswizzle: () = {
        var originalMethod = class_getInstanceMethod(DIUserMock().classForCoder, #selector(DIUserMock.mockInstance))
        var swizzledMethod = class_getClassMethod(DIUser.classForCoder(), #selector(DIUser.getInstance))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod{
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
    }()
    struct StaticSwizzleToken {
        static var mockInstanceToken: Int = 0
    }
    
    
    @objc internal var varHsdpAccessToken: String?
    @objc internal var varHsdpUUID: String?
    
    static let sharedInstance = DIUserMock()
    
    override fileprivate init() {
        varHsdpAccessToken = "4d9fgk98zdvady4z"
        varHsdpUUID = "e20e30ab-5705-41f5-979d-d76f2beaabff"
    }
        
    override var userLoggedInState: UserLoggedInState {
        get {
            return UserLoggedInState.userLoggedIn
        }
    }
    
    override var hsdpAccessToken: String?{
        get{
            return self.varHsdpAccessToken
        }
    }
    
    override var hsdpUUID: String?{
        get{
            return self.varHsdpUUID
        }
    }
    
    class func mockDIUser(with isUserLoggedIn : Bool) -> DIUserMock {
        let userMock = DIUserMock.sharedInstance
        return userMock
    }
    
    class func mockHsdpAccessToken(with isHsdpAccessToken : String) -> DIUserMock {
        let userMock = DIUserMock.sharedInstance
        userMock.varHsdpAccessToken = isHsdpAccessToken
        return userMock
    }
    
    class func mockHsdpUUID(with isHsdpUUID : String) -> DIUserMock {
        let userMock = DIUserMock.sharedInstance
        userMock.varHsdpUUID = isHsdpUUID
        return userMock
    }
    
    func swizzleDIUserInstance(){
             _ = DIUserMock.__once
    }
    func deswizzleDIUserInstance(){
        _ = DIUserMock.__deswizzle
    }
    @objc func mockInstance() -> DIUserMock{
        return DIUserMock.sharedInstance
    }
}



