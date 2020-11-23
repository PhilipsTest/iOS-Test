/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import InAppPurchaseDev

extension IAPHttpConnectionInterface {
    func deserializeData (_ withJSONName: String) -> [String: AnyObject]? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: withJSONName, ofType: "json")
        let data = NSData(contentsOfFile: path!)
        var jsonDict: [String: AnyObject]? //= [String: AnyObject]()
        
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data! as Data,
                                        options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: AnyObject]
        } catch let inError as NSError{
            print("\(inError) is the error while converting JSON")
        }
        return jsonDict
    }
}

class IAPBaseHTTPInterfaceTest : IAPHttpConnectionInterface {
    var isErrorToBeInvoked = false
    var jsonNameToUse: String = ""
    func performRequest() {
        
        guard isErrorToBeInvoked == false else {
            let error = NSError(domain: "Mocked Error", code: 1000, userInfo: nil)
            let failure = self.getFailureClosure()
            failure(error)
            return
        }

        guard self.jsonNameToUse.length > 0 else {
            let closure = self.getCompletionClosure()
            closure([String: AnyObject]())
            return
        }
        
        let dictionary = self.deserializeData(self.jsonNameToUse)
        let closure = self.getCompletionClosure()
        closure(dictionary!)
    }
    
    override func performGetRequest() {
        self.performRequest()
    }
    
    override func performPostRequest() {
        self.performRequest()
    }
    
    override func performPutRequest() {
        self.performRequest()
    }
    
    override func performDeleteRequest() {
        self.performRequest()
    }
    
    override func performOAuthRequest(_ isFromError: Bool) {
        self.performRequest()
    }
}
