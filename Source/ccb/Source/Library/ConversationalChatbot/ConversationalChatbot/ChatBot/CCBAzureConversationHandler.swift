//
//  CCBAzureConversationHandler.swift
//  ConversationalChatbotDev
//
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/

import Foundation
import Starscream

protocol CCBConversationHandlerInterface {
//    associatedtype var socketStatus;
    func startWebSocketConnection(conversation:AzureConversation, completionHandler: @escaping (_ error:NSError?) -> Void)
    func endWebSocketConnection(completionHandler: @escaping (_ error:NSError?) -> Void)
    func postConversation(conversation:AzureConversation,text:String,completionHandler: @escaping (_ error:NSError?) -> Void)
    func getAllMessages(conversation:AzureConversation,completionHandler: @escaping (_ activities:[Activity]?, _ error:NSError?) -> Void)
    func reconnectToWebSocket(conversation:AzureConversation, completionHandler: @escaping (_ error:NSError?) -> Void)
    func addBotMessageListner(listner:CCBMessageListner)
    func removeBotMessageListner(listner:CCBMessageListner)
}



@objc class CCBAzureConversationHandler: NSObject, CCBConversationHandlerInterface {
    
    @objc private var websocket:CCBWebSocketInterface?
    private var socketCompletionHandler:((_ error:NSError?) -> Void)?
    private var messageListners:NSMutableArray = NSMutableArray()
    private var isDisconnectRequested:Bool = false
    private var waterMarkID:String?
    
    var socketStatus: CCBWebSocketStatus = .disconnected
    
    override init() {
        super.init()
        self.websocket = CCBWebSocketInterface()
        self.websocket?.delegate = self
    }
    
    func startWebSocketConnection(conversation:AzureConversation, completionHandler: @escaping (_ error:NSError?) -> Void) {
        //No URL present
        guard let url = conversation.webSocketURL else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Socket URL not present"])
            completionHandler(error)
            return
        }
        self.socketCompletionHandler =  { error in
            guard error == nil else {
             completionHandler(error as NSError?)
                return
            }
            let request = URLRequest.azureUpdateConversationActivitiesRequest(conversation: conversation)
            CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                              guard error == nil else {
                               completionHandler(error as NSError?)
                                  return
                              }
                              guard let json = data as? [String:AnyObject] else {
                                  let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                                  completionHandler(error)
                                  return
                              }
                       
                               let azureError = NSError.parseForAzureError(json)
                               guard azureError == nil else {
                                   completionHandler(azureError)
                                   return
                               }
                       
                               guard json[CCBConstants.AzureResponse.idConstant] != nil else {
                                   let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "Conversation did not succeed"])
                                   completionHandler(error)
                                   return
                               }
                       
                               completionHandler(nil)
                       }).resume()
            
        }   //completionHandler
        self.websocket?.connectSocket(toURL: url)
        self.socketStatus = .connecting
    }
    
    func endWebSocketConnection(completionHandler: @escaping (_ error:NSError?) -> Void) {
        self.isDisconnectRequested = true
        guard self.socketStatus == .connected else {
            self.isDisconnectRequested = false
            completionHandler(nil)
            return
        }
        self.socketCompletionHandler = completionHandler
        self.websocket?.disConnectSocket()
    }
    
    func postConversation(conversation:AzureConversation,text:String,completionHandler: @escaping (_ error:NSError?) -> Void) {
        let request = URLRequest.azurePostActivitiesRequest(conversation: conversation, text: text)
        CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                   guard error == nil else {
                    completionHandler(error as NSError?)
                       return
                   }
                   guard let json = data as? [String:AnyObject] else {
                       let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                       completionHandler(error)
                       return
                   }
            
                    let azureError = NSError.parseForAzureError(json)
                    guard azureError == nil else {
                        completionHandler(azureError)
                        return
                    }
            
                    guard json[CCBConstants.AzureResponse.idConstant] != nil else {
                        let error = NSError(domain: CCBConstants.Error.AzureErrorDomain, code: 2, userInfo: [NSLocalizedFailureErrorKey : "Conversation did not succeed"])
                        completionHandler(error)
                        return
                    }
            
                    completionHandler(nil)
            }).resume()
       }
       
       func getAllMessages(conversation:AzureConversation,completionHandler: @escaping (_ activities:[Activity]?, _ error:NSError?) -> Void) {
        let request = URLRequest.azureGetActivitiesRequest(conversation: conversation)
        CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                   guard error == nil else {
                        completionHandler(nil, error as NSError?)
                       return
                   }
                   guard let json = data as? [String:AnyObject] else {
                       let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                       completionHandler(nil,error)
                       return
                   }
                
                    let azureError = NSError.parseForAzureError(json)
            
                    guard azureError == nil else {
                        completionHandler(nil,azureError)
                        return
                    }
            
                guard json[CCBConstants.AzureResponse.watermark] != nil else {
                    let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "Watermark is not present"])
                    completionHandler(nil,error)
                    return
                }
            
                var aError:NSError? = nil
                let decoder = JSONDecoder()
                do {
                    decoder.dateDecodingStrategy = .custom(DateFormatter.roundTripIso8601Decoder)
                    let activitySet = try decoder.decode(ActivitySet.self, from: JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted))
                    CCBUtility.logDebugMessage(eventId: "CCB fetch All WaterMark", message: "Watermark arrived \(activitySet.watermark)")
                    if activitySet.watermark != nil {
                      self.waterMarkID = activitySet.watermark
                      conversation.lastWaterMarkID = self.waterMarkID
                    }
                    let messages = activitySet.activities.filter({ true == $0.isDisplayableMessage() })
                    completionHandler(messages,nil)
                } catch {
                    aError = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                    completionHandler(nil,aError)
                }
            }).resume()
       }
    
    func reconnectToWebSocket(conversation:AzureConversation, completionHandler: @escaping (_ error:NSError?) -> Void) {
         
        //Socket completion handler
         self.socketCompletionHandler =  { error in
                    completionHandler(error)
            }
        
         conversation.lastWaterMarkID = self.waterMarkID
         let request = URLRequest.azureReConnectWSRequest(conversation: conversation)
         CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                    guard error == nil else {
                     completionHandler(error as NSError?)
                        return
                    }
                    guard let json = data as? [String:AnyObject] else {
                        let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                        completionHandler(error)
                        return
                    }
             
                     let azureError = NSError.parseForAzureError(json)
                     guard azureError == nil else {
                         completionHandler(azureError)
                         return
                     }
             
                    conversation.updateWebsocketURL(urlString: json[CCBConstants.AzureResponse.streamURL] as! String)
                    conversation.updateConversationToken(token: json[CCBConstants.AzureResponse.token] as! String)
                    self.websocket?.connectSocket(toURL: conversation.webSocketURL)
                    self.socketStatus = .connecting
             }).resume()
    }
    
    func addBotMessageListner(listner:CCBMessageListner) {
        if !self.messageListners.contains(listner) {
            self.messageListners.add(listner)
        }
    }
    
    func removeBotMessageListner(listner:CCBMessageListner) {
        if self.messageListners.contains(listner) {
            self.messageListners.remove(listner)
        }

    }
    
}

extension CCBAzureConversationHandler : WebSocketHandlerInterface {
    func socketDidConnectSuccess() {
        CCBUtility.logDebugMessage(eventId: "WS Connected", message: "WebSocket Success")
        self.socketStatus = .connected
        self.socketCompletionHandler?(nil)
        self.socketCompletionHandler = nil;
    }
    
    func socketDidConnectFailure(error: NSError?) {
        //Is disconnect requested
        self.socketStatus = .disconnected
        guard self.isDisconnectRequested == false else {
            self.isDisconnectRequested = false
            self.socketCompletionHandler?(nil)
            self.socketCompletionHandler = nil;
            self.websocket?.clearWebSocket()
            return;
        }
        //Socket completion handler is nil means it got disconnected automatically with out any operation
        guard self.socketCompletionHandler != nil else {
             self.websocket?.disConnectSocket()
             self.websocket?.clearWebSocket()
             CCBUtility.logDebugMessage(eventId: "WS received Failure", message: "Sent notification\(error?.localizedDescription ?? " No Error")")
             NotificationCenter.default.post(Notification(name: NSNotification.Name(rawValue: CCBWebSocketDisconnectedNotification), object: nil) as Notification)
            return;
        }
        
//        guard let aError = error else {
//            let newError = NSError(domain: CCBConstants.Error.NetworkErrorDomain, code: CCBErrorCode.WebSocketConnectionError.rawValue, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
//            self.socketCompletionHandler?(newError)
//            return;
//        }
        let socketError = NSError.webSocketError()
        self.socketCompletionHandler?(socketError)
        self.websocket?.clearWebSocket()
        self.socketCompletionHandler = nil;
    }
    
    func socketRecievedEvent(event: WebSocketEvent) {
        //Received event
//        self.socketStatus = .connected
        CCBUtility.logDebugMessage(eventId: "WS received event", message: "\(event.self)")
    }
    
    func socketRecievedText(text: String) {
        self.socketStatus = .connected
        //Websocket will return empty string sometimes.
        guard !text.isEmpty, let data = text.data(using: .utf8) else { return }
        
        let decoder = JSONDecoder()
        do {
                decoder.dateDecodingStrategy = .custom(DateFormatter.roundTripIso8601Decoder)
                let activitySet = try decoder.decode(ActivitySet.self, from: data)
                CCBUtility.logDebugMessage(eventId: "CCB WaterMark", message: "Watermark arrived \(activitySet.watermark)")
                if activitySet.watermark != nil {
                  self.waterMarkID = activitySet.watermark
                }
            self.updateMessagesToListners(activities: activitySet.activities)
            } catch {
                let aError = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                self.updateErrorToListners(error: aError)
            }
        CCBUtility.logDebugMessage(eventId: "WS received messages", message: "\(text)")
    }
    
    func socketRecievedData(data: Data) {
        self.socketStatus = .connected
        CCBUtility.logDebugMessage(eventId: "WS received data", message: "\(data)")
        self.socketCompletionHandler?(nil)
    }
    
    private func updateMessagesToListners(activities:[Activity]) {
        let messages = activities.filter({ true == $0.isDisplayableMessage() })
        if messages.count > 0 {
            _ = messageListners.map( { ($0 as! CCBMessageListner).chatBotRecieved(messages: messages) } )
        }
    }
    
    private func updateErrorToListners(error:NSError) {
        _ = messageListners.map( { ($0 as! CCBMessageListner).chatBotRecieved(error: error) } )
    }

    
}
