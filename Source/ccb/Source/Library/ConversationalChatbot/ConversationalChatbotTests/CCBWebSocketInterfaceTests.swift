//
//  CCBWebSocketInterfaceTests.swift
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
@testable import Starscream

class CCBWebSocketInterfaceTests: XCTestCase, WebSocketHandlerInterface {
    
    var socketInterface:CCBWebSocketInterface!
    var socketConnectErrorCalled:Bool!
    
    var socketDelegateCalled:Bool!
    var socketText:String?
    var socketEvent:WebSocketEvent?
    let streamURLString = "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw"
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConnectSocketFunction() {
        let mockSocket = MockSocket(request: URLRequest(url: URL(string: self.streamURLString)!))
        socketInterface = CCBWebSocketInterface(with: mockSocket)
        let conversatiion = AzureConversation.provideDummyConversation()
        conversatiion.updateWebsocketURL(urlString: streamURLString)
        socketInterface.connectSocket(toURL: streamURLString)
        XCTAssert(mockSocket.isConnectCalled == true,"Connect has to be called")
    }
    
    func testConnectSocketFunctionForWrongURL() {
        let mockSocket = MockSocket(request: URLRequest(url: URL(string: self.streamURLString)!))
        socketInterface = CCBWebSocketInterface(with: mockSocket)
        socketInterface.delegate = self
        self.socketConnectErrorCalled = false;
        socketInterface.connectSocket(toURL: "")
        XCTAssert(mockSocket.isConnectCalled == false,"Connect must not be called")
        XCTAssert(self.socketConnectErrorCalled == true,"Connection error must not be called")
    }
    
    
    func testConnectSocketFunctionForDelegateCalls() {
        let mockSocket = MockSocket(request: URLRequest(url: URL(string: self.streamURLString)!))
        socketInterface = CCBWebSocketInterface(with: mockSocket)
        socketInterface.delegate = self
        let conversatiion = AzureConversation.provideDummyConversation()
        conversatiion.updateWebsocketURL(urlString: self.streamURLString)
        socketInterface.connectSocket(toURL: streamURLString)
        self.socketConnectErrorCalled = false;
        
        var event:WebSocketEvent? = WebSocketEvent.connected(["String" : "String"])
        self.socketDelegateCalled = false
        self.socketEvent = nil
        mockSocket.callDelegateFunction(event: event!)
        XCTAssert(self.socketDelegateCalled == true, "COnnect success didn't get called")
        event = nil
        
        event = WebSocketEvent.ping(nil)
        self.socketDelegateCalled = false
        self.socketEvent = nil
        mockSocket.callDelegateFunction(event: event!)
        XCTAssert(self.socketDelegateCalled == true, "COnnect success didn't get called")
        event = nil
        
        event = WebSocketEvent.pong(nil)
        self.socketDelegateCalled = false
        self.socketEvent = nil
        mockSocket.callDelegateFunction(event: event!)
        XCTAssert(self.socketDelegateCalled == true, "COnnect success didn't get called")
        event = nil
        
        event = WebSocketEvent.text("Strings")
        self.socketDelegateCalled = false
        self.socketEvent = nil
        mockSocket.callDelegateFunction(event: event!)
        XCTAssert(self.socketDelegateCalled == true, "Connect success didn't get called")
        XCTAssert(self.socketText == "Strings","")
        event = nil
    }
    
    
    func socketDidConnectSuccess() {
        self.socketDelegateCalled = true
    }
    func socketDidConnectFailure(error:NSError?) {
        self.socketConnectErrorCalled = true
    }
    func socketRecievedEvent(event:WebSocketEvent) {
        self.socketDelegateCalled = true
        self.socketEvent = event
    }
    func socketRecievedText(text:String) {
        self.socketDelegateCalled = true
        self.socketText = text
    }
    
    func socketRecievedData(data:Data) {
        self.socketDelegateCalled = true
    }


}

class MockSocket: WebSocket {
    
    var isConnectCalled:Bool = false
    
    override func connect() {
        self.isConnectCalled = true
    }
    
    func callDelegateFunction(event:WebSocketEvent) {
        self.delegate?.didReceive(event: event, client: self)
    }
}

extension AzureConversation {
    static func provideDummyConversation() -> AzureConversation {
        return AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
    }
}
