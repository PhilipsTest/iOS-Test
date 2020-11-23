//
//  CCBWebSocketHandler.swift
//  ConversationalChatbotDev
//
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/

import Foundation
import Starscream

protocol WebSocketHandlerInterface {
    func socketDidConnectSuccess()
    func socketDidConnectFailure(error:NSError?)
    func socketRecievedEvent(event:WebSocketEvent)
    func socketRecievedText(text:String)
    func socketRecievedData(data:Data)
}

protocol CCBGenricWebSocketInterface {
    func connectSocket(toURL urlString:String)
    func disConnectSocket()
}

@objcMembers class CCBWebSocketInterface: NSObject,WebSocketDelegate,CCBGenricWebSocketInterface {
    
    
    private var webSocket:WebSocket?
    var delegate:WebSocketHandlerInterface?
    var isSocketConnected:Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(with socket:WebSocket) {
        self.init()
        self.webSocket = socket
        self.webSocket?.delegate = self
    }
    
    private func initialiseWebSocket(url:URL) {
        guard self.webSocket == nil else {
            return
        }
        let request = URLRequest(url: url)
        webSocket = WebSocket(request: request, certPinner: nil, compressionHandler: nil)
        webSocket?.delegate = self
    }
    
    func disConnectSocket() {
        webSocket?.disconnect(closeCode: CloseCode.normal.rawValue)
    }
        
    @objc func connectSocket(toURL urlString:String) {
        guard let url = URL(string:urlString) else {
            self.delegate?.socketDidConnectFailure(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid socket URL"]))
            return;
        }
        self.initialiseWebSocket(url: url)
        webSocket?.connect()
    }

    func clearWebSocket() {
        self.webSocket = nil
    }
    
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                CCBUtility.logDebugMessage(eventId: "WS delegate", message: "Connected Headers \(headers) ")
                self.isSocketConnected = true
                self.delegate?.socketDidConnectSuccess()
                break
            case .disconnected(let reason, let code):
                self.isSocketConnected = false
                self.delegate?.socketDidConnectFailure(error: NSError(domain: "", code: Int(code), userInfo: [NSLocalizedDescriptionKey:reason]))
               break
            case .text(let string):
                self.delegate?.socketRecievedText(text: string)
                break
            case .binary(let data):
                self.delegate?.socketRecievedData(data: data)
                break
            case .ping(_):
                self.delegate?.socketRecievedEvent(event: event)
                break
            case .pong(_):
                self.delegate?.socketRecievedEvent(event: event)
                break
            case .viabilityChanged(let status):
                print(status)
                self.delegate?.socketRecievedEvent(event: event)
                break
            case .reconnectSuggested(let status):
                print(status)
                self.delegate?.socketRecievedEvent(event: event)
                break
            case .cancelled:
                self.isSocketConnected = false
                self.delegate?.socketDidConnectFailure(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Websocket Connection Cancelled"]))
                break
            case .error(let error):
                 CCBUtility.logDebugMessage(eventId: "WS delegate", message: "Error failed\(error?.localizedDescription ?? " No Error")")
                self.delegate?.socketDidConnectFailure(error: error as NSError? )
                break
            @unknown default:
                CCBUtility.logDebugMessage(eventId: "WS delegate", message: "unknown event recieved")
                break
        }
    }

}
