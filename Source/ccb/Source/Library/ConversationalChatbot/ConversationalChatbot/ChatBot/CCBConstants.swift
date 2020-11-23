//
//  CCBConstants.swift
//  ConversationalChatbotDev
//
//  Created by Shravana Kumar on 05/08/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation

struct CCBConstants {
    struct AzureURLConstants{
        static let azureBaseURL:String = "https://directline.botframework.com/v3/directline"
        static let authenticationURL:String = "/tokens/generate"
        static let conversationURL:String = "/conversations"
        static let activityURL:String = "/activities"
        static let waterMark:String = "?watermark="
        static let refreshURL:String = "/tokens/refresh"
    }
    
    struct Error {
        static let InvalidToken = "Invalid token or secret"
        static let Error = "error"
        static let Message = "message"
        
        static let CCBErrorDomain = "com.philips.componentError"
        static let NetworkErrorDomain = "com.philips.networkError"
        static let AzureErrorDomain = "com.philips.azureError"
        static let ErrorMessage = "Cannot connect to bot. Retry later"
    }
    
    struct AzuerUser {
        static let userName:String = "AUser"
        static let userID:String = "UserID"
    }
    
    struct HTTPConstants {
        static let httpMethodGet = "GET"
        static let httpMethodPost = "POST"
        static let Contenttype = "Content-Type"
        static let appJSON = "application/json"
        static let Bearer = "Bearer"
        static let Authorization = "Authorization"
    }
    
    struct AzureResponse {
        static let token = "token"
        static let conversationID = "conversationId"
        static let streamURL = "streamUrl"
        static let idConstant = "id"
        static let watermark = "watermark"
    }
    
    struct Bot {
        static let commandBot = "bot"
        static let commandUSR = "usr"
        static let commandWiFi = "check_WiFi"
        static let commandBLE = "check_BLE"
        static let commandDevice = "check_Device"
        static let BLE = "BLE"
        static let WiFi = "WiFi"
        static let Device = "Device"
        static let commandSeperator = ":"
    }
    
    struct TaggingKeys {
        static let setError = "setError"
        static let technicalError = "technicalError"
        static let dateDefaultsKey = "com.CCB.optionsTime"
        static let messageUI = "CCBMessageScreen"
        static let endConversation = "closeChat"
        static let restartConversation = "resetChat"
        static let resumeConversation = "resumeChat"
    }
}
