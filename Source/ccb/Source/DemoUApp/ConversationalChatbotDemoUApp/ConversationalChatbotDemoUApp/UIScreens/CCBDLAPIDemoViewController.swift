//
//  CCBDLAPIDemoViewController.swift
//  ConversationalChatbotDemoUAppDev
//
//  Created by Shravan Kumar on 29/06/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import UIKit
import AppInfra
import PhilipsUIKitDLS
import ConversationalChatbot


enum CCBAPIType:String {
    case startConversation = "Start Conversation"
    case refreshConversation = "Refresh Conversation"
    case postConversation = "Post Conversation"
    case getAllMessages = "Get All Messages"
    case endConversation = "End Conversation"
    case webSocketStatus = "WebSocket Status"
    case conversationDetails = "Conversation details"
}


class CCBDLAPIDemoViewController: UITableViewController {
    
    let apis = [CCBAPIType.startConversation,CCBAPIType.refreshConversation,CCBAPIType.postConversation,CCBAPIType.getAllMessages,CCBAPIType.endConversation,CCBAPIType.webSocketStatus]
    private var selectedAPIType:CCBAPIType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "APICell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


extension CCBDLAPIDemoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "APICell")
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "APICell")
        }
        cell?.textLabel?.text = apis[indexPath.row].rawValue;
        return cell!
    }
}

extension CCBDLAPIDemoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedAPIType = apis[indexPath.row]
        self.performSegue(withIdentifier: "ShowResponseSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowResponseSegue") {
            let destinationVC = segue.destination as? CCBResponseViewController
            destinationVC?.apiResponseType = self.selectedAPIType
        }
    }
}
