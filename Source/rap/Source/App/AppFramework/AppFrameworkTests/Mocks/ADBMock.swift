//
//  ADBMock.swift
//  AppFramework
//
//  Created by Philips on 3/28/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation
@testable import AdobeMobileSDK

class ADBMock : ADBMobile {
    private static var __once1: () = {
        var originalMethod = class_getClassMethod(ADBMobile.classForCoder(), #selector(ADBMobile.trackAction(_:data:)))
        var swizzledMethod = class_getInstanceMethod(ADBMock().classForCoder, #selector(ADBMock.mockTrackAction(_:data:)))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod{
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        }()
    private static var __once: () = {
        
        var originalMethod = class_getClassMethod(ADBMobile.classForCoder(), #selector(ADBMobile.trackState(_:data:)))
        var swizzledMethod = class_getInstanceMethod(ADBMock().classForCoder, #selector(ADBMock.mockTrackState(_:data:)))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod{
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        }()
    struct StaticSwizzleToken {
        static var mockActionToken: Int = 0
        static var mockStateToken: Int = 0
    }
    
    static let sharedInstance = ADBMock()
    var taggingParameterDict : [String:AnyObject]
     var actionParameterDict : [String:AnyObject]
    override fileprivate init() {
        taggingParameterDict =  [:]
        actionParameterDict  =  [:]
    }
    
    
    
    func swizzleADBTrackState(){
        _ = ADBMock.__once
    }
    
    
    func swizzleADBTrackAction(){
        _ = ADBMock.__once1
    }
    
    @objc func mockTrackState(_ state: String, data: NSDictionary){
      ADBMock.sharedInstance.taggingParameterDict.removeAll()
      ADBMock.sharedInstance.taggingParameterDict = data as! [String : AnyObject]
    }
   @objc func mockTrackAction(_ state: String, data: NSDictionary){
    ADBMock.sharedInstance.actionParameterDict.removeAll()
     ADBMock.sharedInstance.actionParameterDict = data as! [String : AnyObject]
    }
    
}
