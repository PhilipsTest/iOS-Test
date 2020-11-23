//
//  ResponseViewController.swift
//  ChatBot
//
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/


import Foundation
import UIKit
import ConversationalChatbot

class ResponseViewController : UIViewController,CCBMessageListner {


    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    var apiResponseType:CCBAPIType!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.apiResponseType.rawValue
        self.responseTextView.text = ""
        self.responseTextView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareTextField()
        self.prepareButton()
    }
    
    //MARK : IBAction methods
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        self.messageTextField.resignFirstResponder()
    }
    
    @IBAction func postMessage(_ sender: Any) {
        switch self.apiResponseType {
        case .startConversation :
            self.startConversation()
        case .postConversation :
            self.postConversation()
        case .refreshConversation :
            self.refreshConversationOfBot()
            self.postButton.setTitle("Refresh", for: .normal)
        case .getAllMessages :
            self.getAllMessagesOfConversation()
            self.postButton.setTitle("My Messages", for: .normal)
        case .endConversation :
            self.endOfConversation()
            self.postButton.setTitle("End conversation", for: .normal)
        case .webSocketStatus :
            self.showWSStatus()
            self.postButton.setTitle("Check Status", for: .normal)
        case .conversationDetails :
            self.showConversationDetails()
            self.postButton.setTitle("Conversation Details", for: .normal)
        default:
            self.postButton.setTitle("UNknown case", for: .normal)
        }
    }
    
    //MARK: Private methods
    
    private func prepareTextField() {
        if (self.apiResponseType == CCBAPIType.postConversation) {
            self.messageTextField.isEnabled = true
        } else {
            self.messageTextField.isEnabled = false
        }
    }
    
    private func prepareButton() {
        switch self.apiResponseType {
        case .startConversation :
            self.postButton.setTitle("Start", for: .normal)
        case .postConversation :
            self.postButton.setTitle("Post", for: .normal)
        case .refreshConversation :
            self.postButton.setTitle("Refresh", for: .normal)
        case .getAllMessages :
            self.postButton.setTitle("My Messages", for: .normal)
        case .endConversation :
            self.postButton.setTitle("End conversation", for: .normal)
        case .webSocketStatus :
            self.postButton.setTitle("Check Status", for: .normal)
        case .conversationDetails :
            self.postButton.setTitle("Conversation Details", for: .normal)
        default:
            self.postButton.setTitle("UNknown case", for: .normal)
        }
    }
    
    private func startConversation() {
        let user = CCBUser(key: "g8Ye_oNrqs4.n37wCTf_kd2In2X6kXNP1apzryHDZ_1OGR5olkQpRM4")
        CCBManager.shared.startConversation(forUser: user) { (error) in
            guard error == nil  else {
                self.updateResponseTextView(response: error!.localizedDescription)
                return;
            }
            self.updateResponseTextView(response: "Conversation started")
        }
    }
    
    private func refreshConversationOfBot() {
        CCBManager.shared.refreshConversation { (error) in
            guard error == nil  else {
                self.updateResponseTextView(response: error!.localizedDescription)
                return;
            }
            self.updateResponseTextView(response: "Message posted")
        }
    }
    
    private func getAllMessagesOfConversation() {
        CCBManager.shared.getAllMessages { messages,error  in
            guard error == nil  else {
                self.updateResponseTextView(response: error!.localizedDescription)
                return;
            }
            self.chatBotRecieved(messages: messages!)
        }

    }

    
    private func postConversation() {
        let message = self.messageTextField.text
        guard message!.isEmpty || message != " " else {
            self.updateResponseTextView(response: "Please enter proper text")
            return
        }
        CCBManager.shared.addBotMessageListner(listner: self)
        CCBManager.shared.postMessage(message: message!) { (error) in
            guard error == nil  else {
                self.updateResponseTextView(response: error!.localizedDescription)
                return;
            }
            self.updateResponseTextView(response: "Message posted")
        }
    }
    
    private func endOfConversation() {
        CCBManager.shared.endTheConversation { (error) in
            guard error == nil  else {
                self.updateResponseTextView(response: error!.localizedDescription)
                return;
            }
            self.updateResponseTextView(response: "Conversation end posted success")
        }
    }
    
    private func updateResponseTextView(response:String) {
        DispatchQueue.main.async {
            self.responseTextView.text = self.responseTextView.text + "\n\(response)"
        }
    }
    
    private func showWSStatus() {
        DispatchQueue.main.async {
            let statusDict = [0:"Connected",1:"Disconnected",3:"Connecting"]
            let statusMessage = statusDict[CCBManager.shared.socketStatus.rawValue]
            self.responseTextView.text = self.responseTextView.text + "WebSocket is now \(statusMessage ?? "")"
        }
    }
    
    private func showConversationDetails() {
        DispatchQueue.main.async {
            guard let conversation = CCBManager.shared.value(forKeyPath: "conversation") as? AzureConversation else {
                self.responseTextView.text = self.responseTextView.text + "COnversation not present"
                return;
            }
            
            let  message = "\(conversation.conversationID) \n \(conversation.token ?? "token") \n \(conversation.conversationToken ?? "conv token") \n \(conversation.webSocketURL ?? "WS url")"
            self.responseTextView.text = self.responseTextView.text + "WebSocket is now \(message)"
        }
    }
}

extension ResponseViewController {
    func chatBotRecieved(messages:[Activity]) {
        var txtMessage = ""
        for message in messages {
            txtMessage = txtMessage + "\nConversation ID: \(String(describing: message.id!))\nMessage:\(String(describing: message.text ?? " "))\nActions:"
            
            guard let actions = message.suggestedActions?.actions, actions.count > 0 else {
                txtMessage = txtMessage + " No actions"
                continue
            }
            
            for action in actions {
                txtMessage = txtMessage + "\n Title: \(String(describing: action.title ?? "")) value: \(String(describing: action.value ?? ""))"
            }
        }
        self.updateResponseTextView(response: txtMessage)
    }
    func chatBotRecieved(error:NSError) {
        self.updateResponseTextView(response: error.localizedDescription)
    }

}

class AzureConversation : NSObject {
    var userID: String?
    var name: String?
    let conversationID: String
    var token: String!
    var webSocketURL: String!
    var conversationToken: String!
    
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

