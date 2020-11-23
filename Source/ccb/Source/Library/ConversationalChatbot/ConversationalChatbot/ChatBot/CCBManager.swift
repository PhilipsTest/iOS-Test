//
//  CCBManagerswift
//  CCBManager
//
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/

import Foundation

public let CCBWebSocketDisconnectedNotification = "com.Azure.WebSocket.Disconnocted";

public protocol CCBMessageListner :NSObject {
    func chatBotRecieved(messages:[Activity])
    func chatBotRecieved(error:NSError)
}


public protocol CCBComponentInterface: NSObject {
    func startConversation(forUser user:CCBUser,completionHandler: @escaping (_ error:NSError?) -> Void)
    func postMessage(message:String, completionHandler: @escaping (_ error:NSError?) -> Void)
       
    func getAllMessages(completionHandler: @escaping (_ messages:[Activity]?, _ error:NSError?) -> Void)
   
    func endTheConversation(completionHandler: @escaping (_ error:NSError?) -> Void)
   
    func refreshConversation(completionHandler: @escaping (_ error:NSError?) -> Void)
       
    func addBotMessageListner(listner:CCBMessageListner?)
   
    func removeBotMessageListner(listner:CCBMessageListner?)
}


@objc public enum CCBWebSocketStatus : Int {
    case connecting = 0, disconnected = 1, connected = 2
}

@objc public class CCBManager: NSObject, CCBComponentInterface {
    
    @objc public static let shared = CCBManager()
    @objc public var socketStatus:CCBWebSocketStatus {
        get {
            return (self.conversationHandler as! CCBAzureConversationHandler).socketStatus;
        }
    }
    
    
    @objc private var conversation: AzureConversation?
    private var authenticator:CCBAutenticatorInterface!
    private var conversationHandler:CCBConversationHandlerInterface!
    
    var ccbSettings: CCBSettings!
    var ccbDependencies: CCBDependencies?
    
    
    //Mark: Initialiser methods
    private override init() {
        super.init()
        self.loadInitialisers()
    }
        
    
    /*
     * Start a new conversation with the Azure bot.
     * Returns nil if operation succeeds
     * Returns error if fails.
     */
    public func startConversation(forUser user:CCBUser,completionHandler: @escaping (_ error:NSError?) -> Void) {
        guard self.conversation == nil else {
            CCBUtility.logDebugMessage(eventId: "Start conversation", message: "Conversation already present")
            completionHandler(NSError.ongoingConversationError())
            return;
        }
        self.authenticator.authenticateUser(user: user) { (conversation, error) in
            guard error == nil else {
                CCBUtility.logDebugMessage(eventId: "Start conversation", message: "Chat authentication failed\(error?.localizedDescription ?? " No Error")")
                completionHandler(error)
                return
            }
            
            guard let aConversation = conversation else {
                CCBUtility.logDebugMessage(eventId: "Start conversation", message: "Failed to create conversation with\(error?.localizedDescription ?? " No Error")")
                completionHandler(error)
                return
            }
            
            self.initiateConversationWithBot(conversation: aConversation) { (socketError) in
                completionHandler(socketError)
                CCBUtility.logDebugMessage(eventId: "Start conversation", message: "Initiate conversation with\(error?.localizedDescription ?? " No Error")")
            }
        }
    }
    
    
    /*
     * Post user message/selected option to ongoing conversation.
     * Returns nil if operation succeeds
     * Returns error if fails.
     */
    public func postMessage(message:String, completionHandler: @escaping (_ error:NSError?) -> Void) {
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "Post conversation", message: "No Conversation error")
            completionHandler(NSError.noConversationError())
            return;
        }
        
        self.conversationHandler.postConversation(conversation: aConversation, text: message) { (error) in
             completionHandler(error)
            CCBUtility.logDebugMessage(eventId: "Post conversation", message: "Post conversation with\(error?.localizedDescription ?? " No Error")")
        }
    }
    
    
    /*
     * Fetch all messages/conversations of the ongoing conversation.
     * Returns nil error if operation succeeds
     * Returns error with empty/nil list of messages if operation fails.
     */
    public func getAllMessages(completionHandler: @escaping (_ messages:[Activity]?, _ error:NSError?) -> Void) {
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "Get all conversation", message: "No Conversation error")
            completionHandler(nil,NSError.noConversationError())
            return;
        }
        self.conversationHandler.getAllMessages(conversation: aConversation) { (messages, error) in
            CCBUtility.logDebugMessage(eventId: "Get all conversations", message: "Messages recieved count \(messages?.count ?? 0) with \(error?.localizedDescription ?? " No Error")")
            completionHandler(messages,error)
        }
    }
    
    
    /*
     * End the ongoing conversation even from the bot end.
     * Returns nil if operation succeeds
     * Returns error if fails.
     */
    public func endTheConversation(completionHandler: @escaping (_ error:NSError?) -> Void) {
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "End conversation", message: "No Conversation error")
            completionHandler(NSError.noConversationError())
            return;
        }
        self.authenticator.endConversation(conversation: aConversation) { (error) in
                    
            self.conversationHandler.endWebSocketConnection { (error) in
                self.conversation = nil
                CCBUtility.logDebugMessage(eventId: "End conversation", message: "Conversation ended with \(error?.localizedDescription ?? " No Error")")
                completionHandler(error)
            }
        }
    }
    
    
    /*
     * Refresh the ongoing conversation token to get new access token which is valid for more than hour.
     * Returns nil if operation succeeds
     * Returns error if fails.
     */
    public func refreshConversation(completionHandler: @escaping (_ error:NSError?) -> Void) {
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "Refresh conversation", message: "No Conversation error")
            completionHandler(NSError.noConversationError())
            return;
        }
        self.authenticator.refreshConversation(conversation: aConversation) { (error) in
            CCBUtility.logDebugMessage(eventId: "Refresh conversation", message: "Refresh chat completion with \(error?.localizedDescription ?? " No Error")")
            completionHandler(error)
        }
    }
    
    /*
     * This function is used to reconnect to websocket connection to receive messages.
     * This method has to be used if the reconnect web socket fails at the start of the conversation.
     * Returns nil if operation succeeds.
     * Returns error if fails.
     */
    public func reconnectToWebSocketAtStart(completionHandler: @escaping (_ error:NSError?) -> Void) {
        //Conversation not present
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "Reconnect conversation", message: "No Conversation error")
            completionHandler(NSError.noConversationError())
            return;
        }
        
        // Socket is already connected or connecting hence no error will be provided.
        guard self.socketStatus != .connected else {
            CCBUtility.logDebugMessage(eventId: "Reconnect socket", message: "Socket is connected")
            completionHandler(nil);
            return;
        }
        self.initiateConversationWithBot(conversation: aConversation, completionHandler: completionHandler)
    }
    
    /*
     * This function is used to reconnect to websocket connection to receive messages.
     * This method has to be used if the reconnect web socket fails in the middle of the conversation.
     * Returns nil if operation succeeds.
     * Returns error if fails.
     */
    public func reconnectToWebSocket(completionHandler: @escaping (_ error:NSError?) -> Void) {
        //Conversation not present
        guard let aConversation = self.conversation else {
            CCBUtility.logDebugMessage(eventId: "Reconnect conversation", message: "No Conversation error")
            completionHandler(NSError.noConversationError())
            return;
        }
        
        // Socket is already connected or connecting hence no error will be provided.
        guard self.socketStatus != .connected else {
            CCBUtility.logDebugMessage(eventId: "Reconnect socket", message: "Socket is connected")
            completionHandler(nil);
            return;
        }
        self.conversationHandler.reconnectToWebSocket(conversation: aConversation) { (error) in
            completionHandler(error)
        }
    }

    
    /*
     * Add listner to receive messages. Listner must be adhering to CCBMessageListner protocol.
     */
    public func addBotMessageListner(listner:CCBMessageListner?) {
        guard let aListner = listner else {
            return
        }
        self.conversationHandler.addBotMessageListner(listner: aListner)
    }
    
    /*
     * Remove listner to stop receiving messages. Listner .
     */
    public func removeBotMessageListner(listner:CCBMessageListner?) {
        guard let aListner = listner else {
            return
        }
        self.conversationHandler.removeBotMessageListner(listner: aListner)
    }
    
    /*
     * Clear the conversation details. This can be used to clear out the conversaion without ending it in the bot.
     */
    public func clearCurrentConversation() {
        self.conversation = nil
        CCBUtility.logDebugMessage(eventId: "CCB Manager", message: "Cleared existing conversation")
    }

    //MARK: Private functions
    private func initiateConversationWithBot(conversation:AzureConversation, completionHandler: @escaping (_ error:NSError?) -> Void) {
        self.authenticator.startConversation(conversation: conversation) { (error) in
            guard error == nil else {
                CCBUtility.logDebugMessage(eventId: "Initiate conversation", message: "Initiate conversation with\(error?.localizedDescription ?? " No Error")")
                completionHandler(error)
                return;
            }
            self.conversation = conversation
            self.conversationHandler.startWebSocketConnection(conversation: conversation) { (socketError) in
                guard socketError == nil else {
                    CCBUtility.logDebugMessage(eventId: "Start websocket Conversation", message: "Failed with \(socketError?.localizedDescription ?? " No Error")")
                    completionHandler(socketError)
                    return;
                }
                completionHandler(nil)
            }
        }
    }
    
    private func loadInitialisers() {
        self.authenticator = CCBAzureAuthenticator()
        self.conversationHandler = CCBAzureConversationHandler()
    }


}


