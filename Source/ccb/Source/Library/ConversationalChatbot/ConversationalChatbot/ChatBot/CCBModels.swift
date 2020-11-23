//
//  CCBModels.swift
//  ConversationalChatbotDev
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/


import Foundation

//MARK:
//MARK: CCBUser class
public class CCBUser: NSObject {
    public var azureSecretKey:String!
    public var userID:String?
    public var userName:String?
    
    private override init() {
        super.init()
    }
    
    public convenience init(key:String) {
        self.init()
        self.azureSecretKey = key
    }
    
    public convenience init(key:String,uID:String? = nil, name:String? = nil) {
        self.init()
        self.azureSecretKey = key
        self.userID = uID
        self.userName = name
    }
}


//MARK:
//MARK: Activity set azure response
public class ActivitySet: Codable {
    public var activities: [Activity] = []
    public var watermark: String?
}
  
public class Activity: Codable {
    public var type: ActivityType?
    public var name: String?
    public var id: String?
    public var timestamp: Date?
    public var localTimestamp: Date?
    public var serviceUrl: String?
    public var channelId: String?
    public var from: ChannelAccount?
    public var conversation: ConversationAccount?
    public var recipient: ChannelAccount?
    public var textFormat: TextFormat?
    public var attachmentLayout: AttachmentLayout?
    public var membersAdded: [ChannelAccount]?
    public var membersRemoved: [ChannelAccount]?
    public var topicName: String?
    public var historyDisclosed: Bool?
    public var locale: String?
    public var text: String?
    public var speak: String?
    public var inputHint: InputHint?
    public var summary: String?
    public var suggestedActions: SuggestedActions?
    public var attachments: [Attachment]?
    public var channelData: Data?
    public var action: String?
    public var replyToId: String?
    public var value: Data?
    public var relatesTo: ConversationReference?
    public var code: String?

    public enum ActivityType: String, Codable {
        case message               = "message"
        case contactRelationUpdate = "contactRelationUpdate"
        case conversationUpdate    = "conversationUpdate"
        case typing                = "typing"
        case endOfConversation     = "endOfConversation"
        case event                 = "event"
        case invoke                = "invoke"
    }

    public enum TextFormat: String, Codable {
        case plain    = "plain"
        case markdown = "markdown"
    }

    public enum AttachmentLayout: String, Codable {
        case list     = "list"
        case carousel = "carousel"
    }
    
    public enum InputHint: String, Codable {
        case acceptingInput = "acceptingInput"
        case expectingInput = "expectingInput"
        case ignoringInput  = "ignoringInput"
    }
        
    func isInputMessage() -> Bool {
        return (self.inputHint != nil)
    }
    
    func isDisplayableMessage() -> Bool {
        return ((self.type == .message) ||  (self.type == .typing) || (self.type == .event))
    }
}

public class ChannelAccount: Codable {
    public var id: String?
    public var name: String?
}

public class ConversationAccount: Codable {
    public var isGroup: Bool?
    public var id: String?
    public var name: String?
    
    init(withId id: String?) {
        self.id = id
    }
}

public class SuggestedActions: Codable {
    public var to: [String]?
    public var actions: [CardAction]?
}

public class Attachment: Codable {
    public var contentType: String?
    public var contentUrl: String?
    public var content: Data?
    public var name: String?          // optional
    public var thumbnailUrl: String?  // optional
}


public class ConversationReference: Codable {
    public var activityId: String?    // optional
    public var user: ChannelAccount?  // optional
    public var bot: ChannelAccount?
    public var conversation: ConversationAccount?
    public var channelId: String?
    public var serviceUrl: String?
}

public class CardAction: Codable {
    public var type: String?
    public var title: String?
    public var image: String?
    public var value: String?
}

public class ResourceResponse: Codable {
    public var id: String?
}


public class ErrorResponse: Codable {
    public var error: ApiError?
    
    public class ApiError: Codable {
        public var code: String?
        public var message: String?
    }
}

//MARK:
//MARK: Azure Conversation reference
class AzureConversation : NSObject {
    var userID: String?
    var name: String?
    let conversationID: String
    var token: String!
    var webSocketURL: String!
    var conversationToken: String!
    var lastWaterMarkID: String?
    
    var conversations:[Activity] = []
    
    init(conversationID:String,userID:String?,name:String?) {
        self.userID = userID
        self.name = name
        self.conversationID = conversationID
    }
    
    func updateWebsocketURL(urlString:String) {
        self.webSocketURL = urlString
    }
    
    func updateUserToken(token:String) {
        self.token = token
    }
    
    func updateConversationToken(token:String) {
        self.conversationToken = token
    }
}



