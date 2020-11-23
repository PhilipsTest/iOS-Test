//
//  CCBOptionsCollectionViewCell.swift
//  ConversationalChatbotDev
//
//  Created by Shravan Kumar on 22/07/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS


protocol CCBOptionCellSelected {
    func optionSelected(value:String?)
    func commandRecievedError(error:Error)
}

class CCBOptionsCell: UICollectionViewCell {
    
    @IBOutlet weak var optionButton:UIDProgressButton!
    var delegate:CCBOptionCellSelected?
    var action:CardAction? {
        didSet {
            guard let title = action?.title else {
                return
            }
            let aTitle = self.fetchDisplayTitle(cardTitle: title)
            self.optionButton.setTitle(aTitle, for: .normal)
            self.optionButton.buttonStyle = .textOnly
            self.optionButton.isActivityIndicatorVisible = false
        }
    }
    var parser:CCBActionParser = CCBActionParser()

    private func fetchDisplayTitle(cardTitle:String) -> String {
        let titles = cardTitle.components(separatedBy: CCBConstants.Bot.commandSeperator)
        //Commands present
        guard titles.count > 1 else {
            return cardTitle
        }
        self.optionButton.progressIndicatorStyle = .indeterminate
        self.optionButton.isActivityIndicatorVisible = true
        self.performCommand(command: cardTitle)
        return titles.first ?? cardTitle
    }
    
    private func performCommand(command:String) {
        self.parser.parseFunction(function: command) { (status, error) in
            guard let aCommand = command.components(separatedBy: CCBConstants.Bot.commandSeperator).last else {
                return;
            }
            var postString = self.constructValueString(command: aCommand, status: " Off")
            guard error == nil else {
                self.delegate?.commandRecievedError(error: error!)
                return;
            }
            if (status == true) {
                postString = self.constructValueString(command: aCommand, status: " On")
            }
            self.delegate?.optionSelected(value: postString)
        }
    }
    
    private func constructValueString(command:String,status:String) -> String{
        return (command.contains(CCBConstants.Bot.commandBLE))  ? CCBConstants.Bot.BLE + status :
               (command.contains(CCBConstants.Bot.commandDevice)) ? CCBConstants.Bot.Device + status : CCBConstants.Bot.WiFi + status
    }
    
    @IBAction func callTargetOnAction(_ sender: Any) {
        self.delegate?.optionSelected(value: self.action?.value)
    }
}
