//
//  CCBAzureAuthenticatorTests.swift
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

class CCBAzureAuthenticatorTests: XCTestCase {
    
    var authenticator:CCBAzureAuthenticator!
    var mockRestClient:AIRESTClientMock!
    
    override func setUp() {
        Bundle.loadSwizzler()
        mockRestClient = AIRESTClientMock()
        authenticator = CCBAzureAuthenticator()
        if CCBManager.shared.ccbDependencies == nil {
            let appInfra = AIAppInfra(builder: nil)
            let dependency = CCBDependencies()
            dependency.appInfra = appInfra
            CCBManager.shared.ccbDependencies = dependency
        }
//        CCBAzureAuthenticator
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAuthenticateUser() {
        let data = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA",
                    "expires_in": 3600] as [String : Any]

        let user = CCBUser(key: "userKey")
        user.userID = "userID"
        user.userName = "userName"
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        
        authenticator.authenticateUser(user: user) { (conversation, error) in
            XCTAssert(conversation != nil,"Conversation has to be not nil")
            XCTAssert(error == nil,"Error has to be nil")
            XCTAssert(conversation?.conversationID == (data["conversationId"] as! String), "Conversation ID is different")
            XCTAssert(conversation?.token == (data["token"] as! String), "Conversation ID is different")
        }
        
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        let bodyString = String(data: (request?.httpBody)!, encoding: .utf8)
        let string = "{\"user\": {\"id\": \(user.userID!),\"name\": \(user.userName!)}}"
        XCTAssert(headers?["Authorization"] == "Bearer userKey","Azure key is not properly mapped")
        XCTAssert(bodyString != nil,"Body has to be present")
        XCTAssert(bodyString == string,"Body string must have same name and user id")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testAuthenticateUserError() {
        let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]

        let user = CCBUser(key: "userKey")
        user.userID = "userID"
        user.userName = "userName"
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        
        authenticator.authenticateUser(user: user) { (conversation, error) in
            XCTAssert(conversation == nil ,"Conversation token has to be nil")
            XCTAssert(error != nil,"Error should not be nil")
            XCTAssert((error as! NSError).localizedDescription == "Token has expired","Error description is not mapped")
        }
        
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        let bodyString = String(data: (request?.httpBody)!, encoding: .utf8)
        let string = "{\"user\": {\"id\": \(user.userID!),\"name\": \(user.userName!)}}"
        XCTAssert(headers?["Authorization"] == "Bearer userKey","Azure key is not properly mapped")
        XCTAssert(bodyString != nil,"Body has to be present")
        XCTAssert(bodyString == string,"Body string must have same name and user id")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testStartConversationForUser() {
        
        let data = ["conversationId": "FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ","expires_in": 3600,"streamUrl": "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw",
          "referenceGrammarId": "cd9653f6-f7e6-f153-aa58-7a6ae394d547"
        ] as [String : Any]
            
        
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
        authenticator.startConversation(conversation: conversation) { (error) in
            XCTAssert(conversation.conversationToken == (data["token"] as! String) ,"Conversation token has to be properly mapped")
            XCTAssert(conversation.webSocketURL == (data["streamUrl"] as! String) ,"Websocket stream URL has to be properly mapped")
            XCTAssert(error == nil,"Error has to be nil")
        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.token!))","Azure key is not properly mapped")
        XCTAssert(request?.httpBody == nil,"Body has to be nil")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testStartConversationErrorForUser() {
        
        let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]
            
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
        authenticator.startConversation(conversation: conversation) { (error) in
            XCTAssert(conversation.conversationToken == nil ,"Conversation token has to be nil")
            XCTAssert(conversation.webSocketURL == nil ,"Websocket stream URL has to be nil")
            XCTAssert(error != nil,"Error should not be nil")
            XCTAssert((error as! NSError).localizedDescription == "Token has expired","Error description is not mapped")
        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.token!))","Azure key is not properly mapped")
        XCTAssert(request?.httpBody == nil,"Body has to be nil")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    
    func testRefreshConversationForUser() {
        
        let data = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalAss",
        "expires_in": 3600] as [String : Any]
        
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
        authenticator.refreshConversation(conversation: conversation) { (error) in
            XCTAssert(conversation.token == (data["token"] as! String) ,"Conversation token has to be properly mapped")
            XCTAssert(error == nil,"Error has to be nil")
        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.token!))","Azure key is not properly mapped")
        XCTAssert(request?.httpBody == nil,"Body has to be nil")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }

    func testRefreshConversationForUserError() {
        let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]
        
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "accessToken"
        let oldToken = conversation.token
        authenticator.refreshConversation(conversation: conversation) { (error) in
            XCTAssert(conversation.token == oldToken ,"Conversation token has to be same old")
            XCTAssert(error != nil,"Error should not be nil")
            XCTAssert((error as! NSError).localizedDescription == "Token has expired","Error description is not mapped")

        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
        XCTAssert(headers?["Authorization"] == "Bearer accessToken","Azure key is not properly mapped")
        XCTAssert(request?.httpBody == nil,"Body has to be nil")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }

    
    func testEndOfConversationForUser() {
        
        let data = ["id":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
        conversation.updateConversationToken(token: conversation.token)
        authenticator.endConversation(conversation: conversation) { (error) in
            XCTAssert(error == nil,"Error has to be nil")
        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
         XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.conversationToken!))","Azure key is not properly mapped")
        XCTAssert(request?.httpBody != nil,"Body has to be not nil")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    func testEndOfConversationErrorForUser() {
        
        let data = ["error": ["code": "TokenExpired","message": "Token has expired"]] as [String : Any]
            
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
        conversation.updateConversationToken(token: conversation.token)
        authenticator.endConversation(conversation: conversation) { (error) in
            XCTAssert(error != nil,"Error has to be nil")
            XCTAssert((error!).localizedDescription == "Token has expired","Error description is not mapped")
        }
        let request = mockRestClient.currentRequest
        XCTAssert(request != nil, "Request has to be present")
        let headers = request?.allHTTPHeaderFields
         XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.conversationToken!))","Azure key is not properly mapped")
        XCTAssert(request?.httpBody != nil,"Body has to be not nil")
        let bodyString = "{\"type\": \"endOfConversation\",\"from\": {\"id\": \"UserID\"}}"
        XCTAssert(String(data: (request?.httpBody)!, encoding: .utf8) == bodyString,"Body is different")
        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
    }
    
    
}
