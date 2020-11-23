//
//  CCBMessageViewControllerTests.swift
//  ConversationalChatbotTests
//
//  Created by Shravana Kumar on 28/07/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import AppInfra
@testable import ConversationalChatbotDev

class CCBMessageViewControllerTests: XCTestCase {

    
    var mockRestClient:AIRESTClientMock!
    var mockTagClient:MockTagger!
    var interface: CCBInterface!
    var user:CCBUser!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Bundle.loadSwizzler()
        mockRestClient = AIRESTClientMock()
        mockTagClient = MockTagger()
        if CCBManager.shared.ccbDependencies == nil {
            let appInfra = AIAppInfra(builder: nil)
            let dependency = CCBDependencies()
            let config = CCBConfiguration()
            user = CCBUser(key: "secretkey")
            user.userID = "ccbusermailID"
            user.userName = "ccbuser"
            config.chatbotSecretKey = "secretkey"
            config.chatbotUserName = "ccbuser"
            config.chatbotEmailId = "ccbusermailID"
            dependency.chatbotConfiguration = config
            dependency.appInfra = appInfra
            CCBManager.shared.ccbDependencies = dependency
        }
        interface = CCBInterface(dependencies: CCBManager.shared.ccbDependencies!, andSettings: nil)

    }

    override func tearDown() {
        Bundle.deSwizzle()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewCreation()  {
        let launchIP = CCBLaunchInput()
        let vc = interface.instantiateViewController(launchIP);
        XCTAssert(vc!.view != nil,"View must not be nil")
    }

//
    func testStartConversationCalledFromVC() {
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockTagClient, forKeyPath: "tagging")
//        let launchIP = CCBLaunchInput()
//        let vc = interface.instantiateViewController(launchIP);
//        _ = vc?.view
//        vc?.viewDidLoad()
//
//        let authenticatdata = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA",
//        "expires_in": 3600] as [String : Any]
//        let authenticateRequest = mockRestClient.currentRequest
//        XCTAssert(authenticateRequest != nil, "Request has to be present")
//        let authheaders = authenticateRequest?.allHTTPHeaderFields
//        let bodyString = String(data: (authenticateRequest?.httpBody)!, encoding: .utf8)
//        let string = "{\"user\": {\"id\": \(user.userID!),\"name\": \(user.userName!)}}"
//        XCTAssert(authheaders?["Authorization"] == "Bearer \(user.azureSecretKey!)","Azure key is not properly mapped")
//        XCTAssert(bodyString != nil,"Body has to be present")
//        XCTAssert(bodyString == string,"Body string must have same name and user id")
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: authenticatdata, error: nil)

//        let startConvdata = ["conversationId": "FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ","expires_in": 3600,"streamUrl": "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw",
//          "referenceGrammarId": "cd9653f6-f7e6-f153-aa58-7a6ae394d547"
//        ] as [String : Any]
//
//        let convRequest = mockRestClient.currentRequest
//        XCTAssert(convRequest != nil, "Request has to be present")
//        XCTAssert(convRequest?.httpBody == nil,"Body has to be nil")
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: startConvdata, error: nil)
    }
//
//    func testViewReloadsMessagesForExistingConversation() {
//
//        let authenticatdata = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA",
//        "expires_in": 3600] as [String : Any]
//
//        let convData = ["conversationId": "FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ","expires_in": 3600,"streamUrl": "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw",
//          "referenceGrammarId": "cd9653f6-f7e6-f153-aa58-7a6ae394d547"
//        ] as [String : Any]
//
//
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockTagClient, forKeyPath: "tagging")
//        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
//        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
//
//        CCBManager.shared.startConversation(forUser: user, completionHandler:{ (error) in
//
//        })
//
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: authenticatdata, error: nil)
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: convData, error: nil)
//
//        let launchIP = CCBLaunchInput()
//        let vc = interface.instantiateViewController(launchIP);
//        vc?.loadView()
//        vc?.viewDidLoad()
//
//        let convRequest = mockRestClient.currentRequest
//        XCTAssert(convRequest != nil, "Request has to be present")
//        XCTAssert(convRequest?.httpBody == nil,"Body has to be nil")
//        XCTAssert(convRequest?.httpMethod == "GET", "Request has to be present")
//        XCTAssert(convRequest?.url?.absoluteString == "https://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/activities", "Request is not the get all messages request")
//    }
//
//    func testViewRestartConversationFunctionality() {
//
//        let authenticatdata = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA",
//        "expires_in": 3600] as [String : Any]
//
//        let convData = ["conversationId": "FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ","expires_in": 3600,"streamUrl": "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw",
//          "referenceGrammarId": "cd9653f6-f7e6-f153-aa58-7a6ae394d547"
//        ] as [String : Any]
//
//
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockTagClient, forKeyPath: "tagging")
//        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
//        conversation.updateConversationToken(token: "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ")
//        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
//
//        CCBManager.shared.startConversation(forUser: user, completionHandler:{ (error) in
//
//        })
//
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: authenticatdata, error: nil)
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: convData, error: nil)
//
//        let launchIP = CCBLaunchInput()
//        let vc = interface.instantiateViewController(launchIP);
//        vc?.loadView()
//        vc?.viewDidLoad()
//        (vc as! CCBMessageViewController).restartConversation(NSObject())
//
//        let data = ["id":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
//        let request = mockRestClient.currentRequest
//        XCTAssert(request != nil, "Request has to be present")
//        let headers = request?.allHTTPHeaderFields
//         XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.conversationToken!))","Azure key is not properly mapped")
//        XCTAssert(request?.httpBody != nil,"Body has to be not nil")
//        var bodyString = "{\"type\": \"endOfConversation\",\"from\": {\"id\": \"\(user.userID!)\"}}"
//        XCTAssert(String(data: (request?.httpBody)!, encoding: .utf8) == bodyString,"Body is different")
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
//    }
//
//    func testEndConversation() {
//
//        let authenticatdata = ["conversationId":"FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA",
//        "expires_in": 3600] as [String : Any]
//
//        let convData = ["conversationId": "FxnUNHXWrgjGAIwZFooId8-j","token": "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ","expires_in": 3600,"streamUrl": "wss://directline.botframework.com/v3/directline/conversations/FxnUNHXWrgjGAIwZFooId8-j/stream?watermark=-&t=ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDAzODE0NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.bDKfNWgE3fBq8NANCSH23FLTL_zXEjsMRIiqC-7y4OdV4rel-USoitlZZbBT4mHDViLLtTMF_W1u1SOPvYp4GxhcW_-SYfZ0r4Oj5cocCAej0gpfcjP5sHT2kbIUZqwdk4JBwGcE5D0OjWEK5sn3NICfuaRo2wgbsh3iIQGeYEuBYmuXdKEOCEEy3iz3zitZ6ZTYCm3kFoDwNeOcmpT8xKUqTZ8t378OWSwgRbdrY2J5Bzmc2YGpKEZIuBYvM6JjInTjqiSNL2KjhLWwmeEX2P-suMF4Rm8_DBSbEMpbZlfTVdanj9dVLDf1V8so9cHGipuZiYo_woLIkEZ2Q_VWPw",
//          "referenceGrammarId": "cd9653f6-f7e6-f153-aa58-7a6ae394d547"
//        ] as [String : Any]
//
//
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
//        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockTagClient, forKeyPath: "tagging")
//        let conversation = AzureConversation(conversationID: "FxnUNHXWrgjGAIwZFooId8-j", userID: nil, name: nil)
//        conversation.updateConversationToken(token: "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDg2LA0KICAiZXhwIjogMTU5NDA0MTY4NiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.l5l2QIlvKca-OWYnAXZWGMFd_Cx6Sdk_GbfjIDHwLRvXHbbTOX7xYa84O4y67NhtwtSGzMK9oIlTmgS7MdncIcoyA7pwR_CexbLx70j9tMwiTinnF3Kqttf16jigguff9BexrlnG7Alm6qhsAtZgUZqXVvcLPC3v-aWjFs82cV1lv7z_L_Y9nSpxnh-VL6Wl7p31ec8-SiAYH0PICAdE9X29kB2Ee0SaHQaP9-RV-G49L6pxiGwYoTtee52Xgj3oqxS7WaKNmoGvDGaR2Q1KLVOo-AeyiDpkDMFBh2-I55AE01DQXV4UyvFCyYZ5W0xFeRZWLypGtfFEL8pIWp4-CQ")
//        conversation.token = "ew0KICAiYWxnIjogIlJTMjU2IiwNCiAgImtpZCI6ICJMaXMyNEY4cUFxa2VQeW1ZUk9xVzd3anJKdFEiLA0KICAieDV0IjogIkxpczI0RjhxQXFrZVB5bVlST3FXN3dqckp0USIsDQogICJ0eXAiOiAiSldUIg0KfQ.ew0KICAiYm90IjogIldDQi1FVVcxLVhMTkNBUkUtVUstMDEtTlAiLA0KICAic2l0ZSI6ICJnOFllX29OcnFzNCIsDQogICJjb252IjogIkZ4blVOSFhXcmdqR0FJd1pGb29JZDgtaiIsDQogICJuYmYiOiAxNTk0MDM4MDgyLA0KICAiZXhwIjogMTU5NDA0MTY4MiwNCiAgImlzcyI6ICJodHRwczovL2RpcmVjdGxpbmUuYm90ZnJhbWV3b3JrLmNvbS8iLA0KICAiYXVkIjogImh0dHBzOi8vZGlyZWN0bGluZS5ib3RmcmFtZXdvcmsuY29tLyINCn0.KLy2WamcOdcD5hDdJ1RujfTvf2KSiONqsVmsuclBHyebijt6Vi0j77DjWkLqLKwl8XPfK46x9XZVoN-xmfOVbYxtUQQgEmpmDS1MoWsa7lsbmcsjOCi2rr-XPG4tCb3QNCDqP3JRQkitu0Vwu9hjzaqVWOR4PruByeztAewqXmxEO0FSqwF8xday_36HvWFi8Tg9Y2Jz2EYHvAfstlaDjPPhHh2v4dCdIyniegFTwpBBDMk20liO3yxa1iNh2I1SyozYRTxAp2daNkSeL7wSP0D0GZQKvmxr6pWLAT4rudxmg0Jt_FOsEsKVxa84E_Q8xNyOryVZuDvzn9PqkatalA"
//
//        CCBManager.shared.startConversation(forUser: user, completionHandler:{ (error) in
//
//        })
//
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: authenticatdata, error: nil)
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: convData, error: nil)
//
//        let launchIP = CCBLaunchInput()
//        let vc = interface.instantiateViewController(launchIP);
//        vc?.loadView()
//        vc?.viewDidLoad()
//        (vc as! CCBMessageViewController).endConversation(NSObject())
//
//        let data = ["id":"FxnUNHXWrgjGAIwZFooId8-j"] as [String : Any]
//        let request = mockRestClient.currentRequest
//        XCTAssert(request != nil, "Request has to be present")
//        let headers = request?.allHTTPHeaderFields
//         XCTAssert(headers?["Authorization"] == "Bearer \(String(describing:conversation.conversationToken!))","Azure key is not properly mapped")
//        XCTAssert(request?.httpBody != nil,"Body has to be not nil")
//        var bodyString = "{\"type\": \"endOfConversation\",\"from\": {\"id\": \"\(user.userID!)\"}}"
//        XCTAssert(String(data: (request?.httpBody)!, encoding: .utf8) == bodyString,"Body is different")
//        mockRestClient.executeCompletionHandler(response: URLResponse(), data: data, error: nil)
//    }
//
    
    func testUITags() {
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockTagClient, forKeyPath: "tagging")
        CCBManager.shared.ccbDependencies?.appInfra.setValue(mockRestClient, forKeyPath: "RESTClient")
        let conversation = AzureConversation(conversationID: "SomeID", userID: "someID", name: "SomeName")
        conversation.conversationToken = "convToken"
        conversation.updateWebsocketURL(urlString: "wss://someURL")
        conversation.updateUserToken(token: "SomeUserToken")
        CCBManager.shared.setValue(conversation, forKeyPath: "conversation")
        let launchIP = CCBLaunchInput()
        let vc = interface.instantiateViewController(launchIP);
        _ = vc?.view
        vc?.viewDidLoad()
        
        XCTAssert(mockTagClient.pageName == CCBConstants.TaggingKeys.messageUI,"Page view is not tagged")
        
        mockTagClient.actionName = nil
        (vc as! CCBMessageViewController).endConversation(UIButton())
        XCTAssert(mockTagClient.actionName == CCBConstants.TaggingKeys.endConversation,"End conversation is not tagged")
        
        mockTagClient.actionName = nil
        (vc as! CCBMessageViewController).restartConversation(UIButton())
        XCTAssert(mockTagClient.actionName == CCBConstants.TaggingKeys.restartConversation,"Restart conversation is not tagged")
        
        mockTagClient.actionName = nil
        mockTagClient.paramValue = nil
        mockTagClient.paramKey = nil
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey:"Test Message"])
        (vc as! CCBMessageViewController).chatBotRecieved(error:error)
        XCTAssert(mockTagClient.actionName == CCBConstants.TaggingKeys.setError ,"Error action is wrong is not tagged")
        XCTAssert(mockTagClient.paramKey == CCBConstants.TaggingKeys.technicalError ,"Error  param key is not tagged")
        let errorString = "CCB:" + error.domain + ":" + "\(error.code):" + error.localizedDescription
        XCTAssert((mockTagClient.paramValue as! String) == errorString ,"Error param value is wrong is not tagged")
        
        let ytURL = URL(string:"https://www.youtube.com/watch?v=KLhKmrSdfNg")
        mockTagClient.actionName = nil
        mockTagClient.paramValue = nil
        mockTagClient.paramKey = nil
        mockTagClient.videoName = nil;
        (vc as! CCBMessageViewController).playVideo(url: ytURL!)
        XCTAssert(mockTagClient.videoName == "KLhKmrSdfNg" ,"Video ID is not tagged properly")
        mockTagClient.actionName = nil
        mockTagClient.paramValue = nil
        mockTagClient.paramKey = nil
        mockTagClient.videoName = nil;
        (vc as! CCBMessageViewController).stopVideoPlaying(ytURL)
        XCTAssert(mockTagClient.videoName == "KLhKmrSdfNg" ,"Video ID is not tagged properly")
        mockTagClient.actionName = nil
        mockTagClient.paramValue = nil
        mockTagClient.paramKey = nil
        mockTagClient.videoName = nil;
        mockTagClient.linkString = nil;
        (vc as! CCBMessageViewController).messageURLClicked(url: ytURL!)
        XCTAssert(mockTagClient.linkString == ytURL?.absoluteString ,"In app URL is not tagged properly")

    }
    
    
}
