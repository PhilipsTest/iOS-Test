//
//  CCBMessageViewController.swift
//  ConversationalChatbotDev
//
//  Created by Shravan Kumar on 14/07/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS
import SafariServices
import WebKit
import youtube_ios_player_helper
import AppInfra


class CCBMessageViewController : UIViewController,CCBMessageListner {
    
    @IBOutlet weak var endConversationButton: UIDButton!
    @IBOutlet weak var messageView: UITableView!
    @IBOutlet weak var restartConversationButton: UIDButton!
    @IBOutlet weak var bottomView: UIDView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressIndicator: UIDProgressIndicator!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var closeYTPlayerButton: UIDButton!
    
    
    var leftChatIcon:UIImage?
    private var playingYoutubeID:String?
    private var isSocketRetryCalled:Bool = false
    private var socketCompletionHandler:((_ error:NSError?) -> Void)?
    private var typingCellTimeOutTimer:Timer?
    private var messages:[Activity] = [Activity]()
    private let appInfra = CCBManager.shared.ccbDependencies?.appInfra
    private var socketRetryCount:Int = 0
    private enum Constants {
      static let incomingMessageCell = "incomingMessageCell"
      static let outgoingMessageCell = "outgoingMessageCell"
      static let contentInset: CGFloat = 24
      static let typingCellTimeOut: Int = 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CCBTaggingUtility.tagCCBPageWithInfo(page: CCBConstants.TaggingKeys.messageUI, params: nil)
        self.setUpMyViewItems()
        self.startConversation()
//        self.addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.createDummyMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CCBManager.shared.removeBotMessageListner(listner: self)
        self.appInfra?.restClient.reachabilityManager.stopMonitoring()
        self.appInfra?.restClient.stopNotifier()
        NotificationCenter.default.removeObserver(self)
        self.typingCellTimeOutTimer?.invalidate()
    }
    
    
    private func showAlert(error:NSError,completionHandler:(()-> ())? = nil) {
        self.stopProgressAnimating()
        self.removeTypingMessageCell()
        self.checkOptions()
        self.messageView.reloadData()
        CCBTaggingUtility.tagCCBError(error: error)
        let errorMessage = "\(error.localizedDescription) [\(error.code)]"
        let alert = UIDAlertController(title: "Error", attributedMessage: NSAttributedString(string: errorMessage ))
        alert.addAction(UIDAction(title: "Ok", style: .primary, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completionHandler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    private func setUpMyViewItems() {
        
        self.title = "Messages"
        let backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        self.view.backgroundColor = backgroundColor
        self.messageView.backgroundColor = backgroundColor
        
        //Setup UI elements
        self.setUpNavBarButtons()
        self.setUpTableView()
        self.setUpProgressIndicatorStyle()
        self.setUpOptionsCollectionView()

    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(webSocketDisconnected), name: NSNotification.Name(rawValue: CCBWebSocketDisconnectedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChange), name: NSNotification.Name(rawValue: kAILReachabilityChangedNotification), object: nil)
        self.appInfra?.restClient.startNotifier()
        self.appInfra?.restClient.reachabilityManager.startMonitoring()
    }
    
    private func setUpTableView() {
        messageView.rowHeight = UITableView.automaticDimension
        messageView.estimatedRowHeight = 600
        messageView.tableFooterView = UIView()
        messageView.separatorStyle = .none
        messageView.contentInset = UIEdgeInsets(top: Constants.contentInset, left: 0, bottom: 0, right: 0)
        messageView.allowsSelection = false
        messageView.backgroundColor = UIColor.clear
    }
    
    private func setUpNavBarButtons() {
        //Set up all UIButtons
        self.restartConversationButton.buttonStyle = .iconOnly
        self.endConversationButton.buttonStyle = .iconOnly
        self.closeYTPlayerButton.buttonStyle = .iconOnly
        
        
        if (self .navigationController?.viewControllers.count ?? 0 > 1) {
            let refreshImage = UIImage(named: "RefreshIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let endImage = UIImage(named: "CloseIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(restartConversation(_:)))
            let endButton =  UIBarButtonItem(image: endImage, style: .plain, target: self, action:#selector(endConversation(_:)))
            self.navigationItem.rightBarButtonItems = [refreshButton,endButton]
            self.restartConversationButton.isHidden = true
            self.endConversationButton.isHidden = true
        }
    }
    
    private func setUpProgressIndicatorStyle() {
        progressIndicator.progressIndicatorType = .circular
        progressIndicator.progressIndicatorStyle = .indeterminate
        progressIndicator.hidesWhenStopped = true
    }
    
    private func setUpOptionsCollectionView() {
        self.optionsCollectionView.backgroundColor = .clear
        self.bottomView.layer.addShadow(opacity: 1.0, radius: 1.0, offset: self.bottomView.frame.size)
    }
    
    private func scrollToLastCell() {
      let lastRow = messageView.numberOfRows(inSection: 0) - 1
      guard lastRow > 0 else {
        return
      }
      let lastIndexPath = IndexPath(row: lastRow, section: 0)
      messageView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
    }
    
    private func resetCCBUI() {
        CCBManager.shared.removeBotMessageListner(listner: self)
        self.messages.removeAll()
        self.messageView.reloadData()
        self.animateBottomView(height: 0)
    }
    
    private func animateBottomView(height:CGFloat) {
        
        UIView.animate(withDuration: 0.75, animations: {
            self.bottomViewHeightConstraint.constant = height
        }) { (completed) in
            self.scrollToLastCell()
        }
    }
    
    private func checkDoTypingMessageToBeAdded() {
        guard let message = messages.last else {
            return;
        }
            
        if message.isInputMessage() == false { self.showTypingMessageInCell() }
    }
    
    private func tagUserResponseTime() {
        guard let date = UserDefaults.standard.value(forKey: CCBConstants.TaggingKeys.dateDefaultsKey) as? Date else {
            return;
        }
        let difference = Date().timeIntervalSince(date)
        let event = "userResponseTime"
        let parameters = ["time":"\(difference)"]
        CCBTaggingUtility.tagCCBEvent(event, parameters: parameters as [String : AnyObject])
    }
    
    private func checkOptions() {
        let lastMessageActions = self.messages.last?.suggestedActions?.actions
        let isActionsPresent = ((lastMessageActions?.count ?? 0) > 0)
        if isActionsPresent == true {
            let newHeight = CGFloat((((lastMessageActions?.count ?? 0)) * 40))
            self.optionsCollectionView.reloadData()
            self.animateBottomView(height: (newHeight + 20))
            UserDefaults.standard.set(Date(), forKey: CCBConstants.TaggingKeys.dateDefaultsKey)
        } else {
            self.animateBottomView(height: 0)
        }
        print("No of options present \(isActionsPresent) \(String(describing:self.messages.last?.suggestedActions?.actions?.count))")
    }
    
    private func startProgressAnimating() {
        self.view.isUserInteractionEnabled = false
        self.progressIndicator.startAnimating()
    }
    
    private func stopProgressAnimating() {
        self.view.isUserInteractionEnabled = true
        self.progressIndicator.stopAnimating()
    }
    
    private func showTypingMessageInCell() {
        let activity = Activity()
        activity.type = .typing
        activity.text = " ";
        activity.inputHint = .acceptingInput
        self.messages.append(activity)
        self.messageView.reloadData()
        self.typingCellTimeOutTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.typingCellTimeOut) , repeats: false, block: { (timer) in
            self.removeTypingMessageCell()
            self.messageView.reloadData()
            CCBUtility.logDebugMessage(eventId: "CCB Typing Timer Fired", message: "Typing sign removed")
        })
    }
    
    private func removeTypingMessageCell() {
        self.typingCellTimeOutTimer?.invalidate()
        self.typingCellTimeOutTimer = nil;
        self.messages = self.messages.filter({ $0.type != .typing })
    }
}

// All Azure related functions
extension CCBMessageViewController  {
    func createDummyMessages() {
        for i in 0...1 {
            let message = Activity()
            //Dummy text to test UI cells
            message.text = "![Wake Up light](https://i.ibb.co/XSCmhvT/5b58db84b354cd1f008b45ce.jpg)\n\nPlease let me know the issue you are facing 😀 [Google](https://www.google.com/) Check this [video](https://www.youtube.com/watch?v=BC2UlVAEwi4)"
            message.id = "asdasds"
            let sActions = SuggestedActions()
            var actions = [CardAction]()
            for _ in 0...0 {
                let action = CardAction()
                //Dummy text to test UI cells
                action.title = "Checking BLE:usr:check_Device"
                //Dummy text to test UI cells
                action.value = "Tuscany"
                action.type = "Some type"
                actions.append(action)
            }
            message.inputHint = (i%2 == 0) ? .acceptingInput : nil ;
//            message.inputHint = .acceptingInput
            sActions.actions = actions
            message.suggestedActions = sActions
            self.messages.append(message)
        }
//        self.showTypingMessageInCell()
        self.chatBotRecieved(messages: self.messages)
    }
    
    @objc @IBAction func endConversation(_ sender: Any) {
        self.startProgressAnimating()
        CCBTaggingUtility.tagCCBEvent(CCBConstants.TaggingKeys.endConversation, parameters: nil)
           CCBManager.shared.endTheConversation { (error) in
               guard error == nil else {
                self.showAlert(error: error!) {
                    self.dismissChatViewController()
                }
                   return
               }
               self.resetCCBUI()
               self.stopProgressAnimating()
               self.dismissChatViewController()
           }
       }
       
       
       @objc @IBAction func restartConversation(_ sender: Any) {
           self.startProgressAnimating()
           CCBTaggingUtility.tagCCBEvent(CCBConstants.TaggingKeys.restartConversation, parameters: nil)
           CCBManager.shared.endTheConversation { (error) in
               guard error == nil else {
                   self.showAlert(error: error!)
                   return
               }
               self.resetCCBUI()
               DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2)) {
                 self.startConversation()
               }
           }
       }
    
    func startConversation() {
        guard let config = CCBManager.shared.ccbDependencies?.chatbotConfiguration else {
            self.showAlert(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Azure key configuration not provided"]))
            return
        }
        self.startProgressAnimating()
        let user = CCBUser(key: config.chatbotSecretKey!,uID: config.chatbotEmailId, name: config.chatbotUserName)
        CCBManager.shared.addBotMessageListner(listner: self)
        CCBManager.shared.startConversation(forUser: user) { (error) in
            guard error == nil else {
                guard error?.code != CCBErrorCode.conversationPresent.rawValue else {
                    self.getAllMessagesOfConversation()
                    return
                }
                
                guard error?.code != CCBErrorCode.WebSocketConnectionError.rawValue else {
                    self.retryWebSocketConnection(isStartConversationFailure: true)
                    return
                }
                self.showAlert(error: error!,completionHandler: {
                    self.endConversationAndPopOut()
                })
                return;
            }
            self.addObservers()
            self.stopProgressAnimating()
        }
    }
    
    private func endConversationAndPopOut() {
        self.startProgressAnimating()
        CCBManager.shared.endTheConversation { (error) in
            self.stopProgressAnimating()
            self.dismissChatViewController()
        }
    }
    
    private func dismissChatViewController() {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func doNeedToRetrySocket() -> Bool {
        var socketRetry = true        
        if self.socketRetryCount >= 3 {
            socketRetry = false
        }
        return socketRetry
    }
    
    private func getSocketCompletionHandler(isStartConversationFailure:Bool) -> ((_ error:NSError?) -> Void) {
        return { (socketError) in
            
            func resetSocketTry() {
                self.socketRetryCount = 0;
                self.socketCompletionHandler = nil
                DispatchQueue.main.async() {
                    self.stopProgressAnimating()
                }

            }
            //If no error then no retry required
            self.isSocketRetryCalled = false
            guard socketError != nil else {
                resetSocketTry()
                return;
            }
            guard socketError?.code != CCBErrorCode.noConversationPresent.rawValue else {
                resetSocketTry()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.retryWebSocketConnection(isStartConversationFailure: isStartConversationFailure)
            }
        }
    }
    
    private func retryWebSocketConnection(isStartConversationFailure:Bool) {
        guard self.doNeedToRetrySocket() == true else {
            self.showAlert(error: NSError.webSocketError(), completionHandler: {
                self.endConversationAndPopOut()
            })
            return;
        }
        self.socketRetryCount = self.socketRetryCount + 1
        self.isSocketRetryCalled = true;
        DispatchQueue.global(qos: .default).async {
            self.socketCompletionHandler = nil;
            self.socketCompletionHandler = self.getSocketCompletionHandler(isStartConversationFailure: isStartConversationFailure)
            if true == isStartConversationFailure {
                CCBManager.shared.reconnectToWebSocketAtStart(completionHandler: self.socketCompletionHandler!)
            } else {
                CCBManager.shared.reconnectToWebSocket(completionHandler: self.socketCompletionHandler!)
            }
        }
    }
    
    private func getAllMessagesOfConversation() {
        CCBTaggingUtility.tagCCBEvent(CCBConstants.TaggingKeys.resumeConversation, parameters: nil)
        CCBManager.shared.getAllMessages { messages,error  in
            guard error == nil  else {
                self.showAlert(error: error!)
                return;
            }
            self.chatBotRecieved(messages: messages!)
            self.stopProgressAnimating()
            self.addObservers()
            if CCBManager.shared.socketStatus != .connected  {
                self.retryWebSocketConnection(isStartConversationFailure: false)
            }
        }
    }
    
    public func chatBotRecieved(messages:[Activity]) {
        self.removeTypingMessageCell()
        self.messages.append(contentsOf: messages)
        self.checkDoTypingMessageToBeAdded()
        self.checkOptions()
        self.messageView.reloadData()
    }
    
    public func chatBotRecieved(error:NSError) {
        self.showAlert(error: error)
        self.removeTypingMessageCell()
    }

    
    @objc func webSocketDisconnected() {
        let appInfra = CCBManager.shared.ccbDependencies?.appInfra
        if (appInfra?.restClient.getNetworkReachabilityStatus() != AIRESTClientReachabilityStatus.notReachable) {
            self.startProgressAnimating()
            self.socketRetryCount = 0;
            self.retryWebSocketConnection(isStartConversationFailure: false)
        }
    }
    
    @objc func reachabilityStatusChange() {
        let appInfra = CCBManager.shared.ccbDependencies?.appInfra
        if (appInfra?.restClient.getNetworkReachabilityStatus() != AIRESTClientReachabilityStatus.notReachable) {
            guard (CCBManager.shared.socketStatus == .disconnected)  else {
                return
            }
            self.startProgressAnimating()
            self.socketRetryCount = 0;
            self.retryWebSocketConnection(isStartConversationFailure: false)
            CCBUtility.logDebugMessage(eventId: "CCB ChatScene", message: "Network Reachable WebSocket retry called")
        } else {
            self.removeTypingMessageCell()
            self.messageView.reloadData()
            let error = NSError(domain: CCBConstants.Error.CCBErrorDomain, code:1001, userInfo: [NSLocalizedDescriptionKey:CCBConstants.Error.ErrorMessage])
            self.showAlert(error: error)
            CCBUtility.logDebugMessage(eventId: "CCB ChatScene", message: "Network Not Reachable")
        }
    }


}

extension CCBMessageViewController {
    
    func messageURLClicked(url: URL) {
        CCBTaggingUtility.tagCCBUserLinkClick(url.absoluteString)
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .formSheet
        present(safariVC, animated: true, completion: nil)
    }
    
   @objc func playVideo(url:URL) {
        
        guard let youTubeID = url.fetchYouYubeID() else {
            self.showAlert(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to fetch YouTube Video ID"]))
            return;
        }
        CCBTaggingUtility.tagCCBVideoStart(youTubeID)
        self.playingYoutubeID = youTubeID
        self.ytPlayerView.isHidden = false;
        let playerVars = ["playsinline": NSNumber(value: true),"autoplay": NSNumber(value: true)]
        self.ytPlayerView.load(withVideoId: youTubeID, playerVars: playerVars)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.ytPlayerView.playVideo()
            self.ytPlayerView.bringSubviewToFront(self.closeYTPlayerButton)
        }
        
    }
    
    @IBAction func stopVideoPlaying(_ sender:Any) {
        self.ytPlayerView.stopVideo()
        self.ytPlayerView.isHidden = true
        guard let youtubeID = self.playingYoutubeID else {
            return;
        }
        CCBTaggingUtility.tagCCBVideoEnd(youtubeID)
        self.playingYoutubeID = nil
    }
}

extension CCBMessageViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.messageURLClicked(url: URL)
        return false
    }

}

extension CCBMessageViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 150))
        let imgVW = UIImageView(frame: headerView.frame)
        imgVW.image = UIImage(named: "WelcomeImageIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        imgVW.contentMode = .scaleAspectFit
        headerView.addSubview(imgVW)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let message = messages[indexPath.row]
      let cellIdentifier = message.isInputMessage() ?
        Constants.incomingMessageCell :
        Constants.outgoingMessageCell
      
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: cellIdentifier, for: indexPath)
        as? CCBMessageCell & CCBMessageBaseTableViewCell else {
          return UITableViewCell()
      }
        cell.delegate = self
        cell.message = message
        let placeHolderImage = self.leftChatIcon ?? UIImage(named: "WelcomeImageIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        cell.updateChatIcon(image: placeHolderImage!)
      return cell
    }
}

extension CCBMessageViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.last?.suggestedActions?.actions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath as IndexPath) as! CCBOptionsCell
        if let action = self.messages.last?.suggestedActions?.actions?[indexPath.row] {
            cell.action = action
            cell.delegate = self
        }
        cell.backgroundColor = .clear
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let action = self.messages.last?.suggestedActions?.actions?[indexPath.row]  else {
            return;
        }
        self.postMessageToBot(message: action.value ?? "")
    }
    
    @objc func postMessageToBot(message:String) {
        guard message != "" else {
            return;
        }
        self.startProgressAnimating()
        self.showTypingMessageInCell()
        self.tagUserResponseTime()
        CCBManager.shared.postMessage(message: message) { (error) in
                DispatchQueue.main.async {
                    guard error == nil else {
                        self.showAlert(error: error!)
                        return
                    }
                    self.stopProgressAnimating()
                }
            }
    }
}

extension CCBMessageViewController : UITableViewDelegate {
    
}

extension CCBMessageViewController: CCBMessageCellAction {
    func userClicked(onLink link: URL) {
        self.messageURLClicked(url: link)
    }
    
    func userClicked(onVideo link: URL) {
        self.playVideo(url: link)
    }
}

extension CCBMessageViewController : CCBOptionCellSelected {
    func commandRecievedError(error: Error) {
        //Will be used in future
    }
    
        

    func optionSelected(value:String?) {
        guard let aValue = value else {
            self.showAlert(error: NSError.errorWithLocalisedDesctiption("No value present for action"))
            return
        }
        self.animateBottomView(height: 0)
        self.showTypingMessageInCell()
        CCBManager.shared.postMessage(message:aValue) { (error) in
            guard error == nil else {
                self.showAlert(error: error!)
                return;
            }
            self.stopProgressAnimating()
        }
    }
}
