//
//  CCBChatBotTests.swift
//  ConversationalChatbotTests
//
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/

import XCTest
@testable import AppInfra
@testable import ConversationalChatbotDev

//extension CCBManager {
//
//    class func changeSharedMethod() {
//        let originalMethod : Method  = class_getInstanceMethod(self, #selector(getter: loadInitialisers))!
//        let extendedMethod : Method  = class_getInstanceMethod(self, #selector(loadInitialisers_test))!
//        method_exchangeImplementations(originalMethod, extendedMethod)
//    }
//    
//    @objc class func loadInitialisers_test() -> self {
//        self.authenticator = CCBAzureAuthenticator()
//        self.conversationHandler = CCBAzureConversationHandler()
//    }
//}

class CCBChatBotTests: XCTestCase {

    var mockRestClient:AIRESTClientMock!
    
    override func setUp() {
        Bundle.loadSwizzler()
        mockRestClient = AIRESTClientMock()
        if CCBManager.shared.ccbDependencies == nil {
            let appInfra = AIAppInfra(builder: nil)
            let dependency = CCBDependencies()
            dependency.appInfra = appInfra
            CCBManager.shared.ccbDependencies = dependency
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartConversation() {
         let streamURLString = "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw"
        let mockSocket = MockSocket(request: URLRequest(url: URL(string: streamURLString)!))
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let socketInterface = CCBWebSocketInterface(with: mockSocket)
        let convHandler = CCBAzureConversationHandler()
        convHandler.setValue(socketInterface, forKey: "websocket")
//        CCBManager.shared.setValue(socketInterface, forKeyPath: "conversationHandler.websocket")
    }
    
    func testPostMessage() {
        let data = ["id":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
         
        let conversation = AzureConversation.provideDummyConversation()
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(conversation, forKeyPath: "conversation")
        
        
//         conversation.updateConversationToken(token: "ConvToken")
//         convHandler.postConversation(conversation: conversation, text: "Hi") { (error) in
//            XCTAssert(error == nil,"Error has to be nil")
//        }
//
//        let request = mockRestClient.currentRequest
//        XCTAssert(request != nil, "Request has to be present")
//        let headers = request?.allHTTPHeaderFields
//        XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)


    }
}
