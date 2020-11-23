//
//  CCBExtensionsTests.swift
//  ConversationalChatbotTests
//
//  Created by Shravan Kumar on 23/07/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import ConversationalChatbotDev


class CCBURLRequestExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAuthenticationRequest() {
        let azureKey = "AzureKey"
        let request = URLRequest.azureAuthenticationRequest(azureID: azureKey, userID: nil, name: nil)
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.authenticationURL
        XCTAssert(request.url != nil,"URL must be present")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        let headers = request.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(azureKey)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody != nil,"Body has to be present")
        let aUserID =  CCBConstants.AzuerUser.userID
        let aUserName = CCBConstants.AzuerUser.userName
        let string = "{\"user\": {\"id\": \(aUserID),\"name\": \(aUserName)}}"
        let bodyString = String(data: (request.httpBody)!, encoding: .utf8)
        XCTAssert(bodyString == string,"Body string must have same name and user id")
    }
    
    
    func testAuthenticationRequestWithUserID() {
        let userID = "UserID"
        let azureKey = "AzureKey"
        let request = URLRequest.azureAuthenticationRequest(azureID: azureKey, userID: userID, name: nil)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.authenticationURL
        XCTAssert(request.url != nil,"URL must be present")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        let headers = request.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(azureKey)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody != nil,"Body has to be present")
        let aUserName = CCBConstants.AzuerUser.userName
        let string = "{\"user\": {\"id\": \(userID),\"name\": \(aUserName)}}"
        let bodyString = String(data: (request.httpBody)!, encoding: .utf8)
        XCTAssert(bodyString == string,"Body string must have same name and user id")
    }
    
    func testAuthenticationRequestWithUserName() {
        let userName = "UserName"
        let azureKey = "AzureKey"
        let request = URLRequest.azureAuthenticationRequest(azureID: azureKey, userID: nil, name: userName)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.authenticationURL
        XCTAssert(request.url != nil,"URL must be present")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        let headers = request.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(azureKey)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody != nil,"Body has to be present")
        let aUserID =  CCBConstants.AzuerUser.userID
        let string = "{\"user\": {\"id\": \(aUserID),\"name\": \(userName)}}"
        let bodyString = String(data: (request.httpBody)!, encoding: .utf8)
        XCTAssert(bodyString == string,"Body string must have same name and user id")
    }

    func testAuthenticationRequestWithUserNameAndUserID() {
        let userID = "UserID"
        let userName = "UserName"
        let azureKey = "AzureKey"
        let request = URLRequest.azureAuthenticationRequest(azureID: azureKey, userID: userID, name: userName)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.authenticationURL
        XCTAssert(request.url != nil,"URL must be present")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        let headers = request.allHTTPHeaderFields
        let bodyString = String(data: (request.httpBody)!, encoding: .utf8)
        let string = "{\"user\": {\"id\": \(userID),\"name\": \(userName)}}"
        XCTAssert(headers?["Authorization"] == "Bearer \(azureKey)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody != nil,"Body has to be present")
        XCTAssert(bodyString == string,"Body string must have same name and user id")
    }

    func testConversationRequest() {
        let token = "token"
        let request = URLRequest.azureConversationRequest(token: token)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.conversationURL
        let headers = request.allHTTPHeaderFields
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(headers?["Authorization"] == "Bearer \(token)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody == nil,"Body has to be nil")
    }

    func testRefreshConversationRequest() {
        let token = "token"
        let request = URLRequest.azureRefreshConversationRequest(token: token)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.refreshURL
        let headers = request.allHTTPHeaderFields
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(headers?["Authorization"] == "Bearer \(token)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody == nil,"Body has to be nil")
    }
    
    func testPostActivityRequest() {
        let token = "convID"
        let conversationID = "ConversationID"
        let conversn = AzureConversation(conversationID: conversationID, userID: nil, name: nil)
        conversn.updateConversationToken(token: token)
        let message = "message"
        let request = URLRequest.azurePostActivitiesRequest(conversation: conversn, text: message)
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.conversationURL + "/\(conversationID)" + CCBConstants.AzureURLConstants.activityURL
        let headers = request.allHTTPHeaderFields
        XCTAssert(request.httpMethod == "POST","Wrong http method")
        XCTAssert(request.url!.absoluteString == url,"URL is not correct")
        XCTAssert(headers?["Authorization"] == "Bearer \(token)","Azure key is not properly mapped")
        XCTAssert(headers?["Content-Type"] == "application/json","Content type is improper")
        XCTAssert(request.httpBody != nil,"Body has to be nil")
        let aUserID =  CCBConstants.AzuerUser.userID
        let string = "{\"type\": \"message\",\"from\": {\"id\": \"\(aUserID)\"},\"text\": \"\(message)\"}"
        let bodyString = String(data: (request.httpBody)!, encoding: .utf8)
        XCTAssert(bodyString == string,"Body string must have same name and user id")
    }



}
