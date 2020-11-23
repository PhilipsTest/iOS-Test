//
//  CCBAzureConversationHandlerTests.swift
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

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}


extension CCBWebSocketInterface {

    static let classInit: Void = {
        let originalSelector = #selector(CCBWebSocketInterface.connectSocket(toURL:))
        let swizzledSelector = #selector(swizzled_connectSocket(toURL:))
        swizzling(UIView.self, originalSelector, swizzledSelector)
    }()

    @objc func swizzled_connectSocket(toURL:URL) {
        self.clearWebSocket()
    }

}


class CCBAzureConversationHandlerTests: XCTestCase,CCBMessageListner {

    var mockRestClient:AIRESTClientMock!
    var convHandler:CCBAzureConversationHandler!
    
    var messagesRecieved:Bool = false
    
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

    func testPostConversation() {
       let data = ["id":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.postConversation(conversation: conversation, text: "Hi") { (error) in
           XCTAssert(error == nil,"Error has to be nil")
       }
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testPostConversationForError() {
       let data = ["convid":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.postConversation(conversation: conversation, text: "Hi") { (error) in
            XCTAssert(error != nil,"Error has to be nil")
       }
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testPostConversationForAzureError() {
       let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.postConversation(conversation: conversation, text: "Hi") { (error) in
            XCTAssert(error != nil,"Error has to be nil")
            XCTAssert(error?.localizedDescription == "Token has expired" ,"Error description is not from Azure")
       }
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }

    
    func testGetAllMessages() {
        let data = ["activities": [["type": "message","text":"Hi"],["type": "message","text":"Hi"]],"watermark": "2"] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.getAllMessages(conversation: conversation, completionHandler: { (data, error) in
           XCTAssert(error == nil,"Error has to be nil")
       })
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testGetAllMessagesForError() {
       let data = ["convid":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.getAllMessages(conversation: conversation, completionHandler: { (data, error) in
            XCTAssert(error != nil,"Error has to be nil")
       })
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testGetAllMessagesAzureError() {
       let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]
       CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        convHandler = CCBAzureConversationHandler()
        let conversation = AzureConversation.provideDummyConversation()
        conversation.updateConversationToken(token: "ConvToken")
        convHandler.getAllMessages(conversation: conversation, completionHandler: { (data, error) in
            XCTAssert(error != nil,"Error has to be nil")
            XCTAssert(error?.localizedDescription == "Token has expired" ,"Error description is not from Azure")
       })
       
       let request = mockRestClient.currentRequest
       XCTAssert(request != nil, "Request has to be present")
       let headers = request?.allHTTPHeaderFields
       XCTAssert(headers?["Authorization"] == "Bearer ConvToken","Azure key is not properly mapped")
       mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }

    
    func testWebSocketMessageReceived() {
        let dataString = "{\"activities\": [{\"type\": \"message\",\"text\":\"Hi\"},{\"type\": \"message\",\"text\":\"Hi\"}],\"watermark\": \"2\"}"
          CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
           convHandler = CCBAzureConversationHandler()
           let conversation = AzureConversation.provideDummyConversation()
           conversation.updateConversationToken(token: "ConvToken")
            messagesRecieved = false
            convHandler.addBotMessageListner(listner: self)
            convHandler.socketRecievedText(text: dataString)
            XCTAssert(messagesRecieved == true,"Didn't receive messages")
            convHandler.removeBotMessageListner(listner: self)
        
            messagesRecieved = false
            convHandler.socketRecievedText(text: dataString)
            XCTAssert(messagesRecieved == false,"Messages must not be receied")
    }
    
    func chatBotRecieved(messages:[Activity]) {
        messagesRecieved = true
        XCTAssert(messages.count == 2,"Messages are not correct")
    }
    
    func chatBotRecieved(error:NSError) {
        
    }
    
    func startWSConnctn() {
        
    }
    
    
}
