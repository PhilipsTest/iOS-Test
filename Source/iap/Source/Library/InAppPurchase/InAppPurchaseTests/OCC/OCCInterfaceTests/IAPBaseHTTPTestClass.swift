//
//  IAPBaseHTTPTestClass.swift
//  InAppPurchase
//
//  Created by Rayan Sequeira on 29/06/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import XCTest
@testable import InAppPurchaseDev

protocol IAPTestModelPreparationProtocol {
    func deserializeData (_ withJSONName:String) -> [String: AnyObject]?
}

class IAPHTTPInterfaceTestClass: IAPHttpConnectionInterface, IAPTestModelPreparationProtocol {
    
    fileprivate var httpConnection: HttpConnection!
    fileprivate var url: String!
    fileprivate var httpHeaders: [String: String]?
    fileprivate var successCompletion: (([String: AnyObject]) -> ())!
    fileprivate var errorFailure: ((NSError)->())!
    fileprivate var bodyParameters: [String: String]?
    fileprivate var methodName: String!
    fileprivate var oldJAnrainToken: String!
    var jsonName: String = ""
    var invokeFailure = false
    
    override init(request: String,
                  httpHeaders: [String: String]?,
                  bodyParameters: [String: String]?,
                  success: @escaping ([String: AnyObject]) -> (),
                  failure: @escaping (NSError) -> ()){
        var passedURLString = String(request)
        self.url = passedURLString.appendedLanguageURL()
        self.httpConnection = HttpConnection()
        if let parameters = httpHeaders {
            self.httpHeaders = parameters
        }
        if let parameters = bodyParameters {
            self.bodyParameters = parameters
        }
        self.successCompletion = success
        self.errorFailure = failure
        super.init(request: request, httpHeaders: httpHeaders,
                   bodyParameters: bodyParameters, success: success, failure: failure)
    }

    override func performGetRequest() {
        guard self.invokeFailure == false else { self.errorFailure(self.createDummyError()); return }
        self.successCompletion(self.deserializeData(self.jsonName)!)
    }

    fileprivate func createDummyError() -> NSError {
        return NSError.init(domain: "Test Error", code: 20000, userInfo: nil)
    }
}

extension IAPTestModelPreparationProtocol where Self: IAPHTTPInterfaceTestClass {
    func deserializeData (_ withJSONName:String) -> [String: AnyObject]? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: withJSONName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }
        var jsonDict: [String: AnyObject]?
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data,
                                    options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
        } catch _ as NSError{
        }
        return jsonDict
    }
}

extension XCTestCase {
    func deserializeData (_ withJSONName:String) -> [String: AnyObject]? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: withJSONName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }
        var jsonDict: [String: AnyObject]?
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
        } catch _ as NSError {
        }
        return jsonDict
    }
}
