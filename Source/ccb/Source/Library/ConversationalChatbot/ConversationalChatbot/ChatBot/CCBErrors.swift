//
//  CCBErrors.swift
//  ConversationalChatbotDev
//
//  Created by Shravana Kumar on 23/09/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation


public enum CCBErrorCode: Int {
    // A conversation is ongoing
    case conversationPresent = 9000
    //No conversation present to continue forward
    case noConversationPresent = 9001
    // Websocket failed to open
    case WebSocketConnectionError = 9002
    //Azure token expired
    case AzureTokenExpiredError = 9003
    
}
