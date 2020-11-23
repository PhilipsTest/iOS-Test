//
//  ChatBotAuthenticator.swift
//  ChatBot
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/


import Foundation

protocol CCBAutenticatorInterface {
    func initialseBot()
    func authenticateUser(user:CCBUser,completionHandler:@escaping (_ conversation:AzureConversation?, _ error:NSError?) -> Void)
    func startConversation(conversation:AzureConversation,completionHandler: @escaping ( _ error:NSError?) -> Void)
    func refreshConversation(conversation:AzureConversation,completionHandler: @escaping ( _ error:NSError?) -> Void)
    func endConversation(conversation:AzureConversation,completionHandler: @escaping ( _ error:NSError?) -> Void)
}



class CCBAzureAuthenticator : NSObject, CCBAutenticatorInterface {
    
    override init() {
        super.init()
        self.initialseBot()
    }
    
    func refreshConversation(conversation: AzureConversation, completionHandler: @escaping (NSError?) -> Void) {
        let request = URLRequest.azureRefreshConversationRequest(token: conversation.token)
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
                conversation.updateUserToken(token: (json[CCBConstants.AzureResponse.token] as! String))
                completionHandler(nil)
            }).resume()
    }
    
    
    func initialseBot() {
        //No intialisation required for Azure
    }
    
    func endConversation(conversation: AzureConversation, completionHandler: @escaping (NSError?) -> Void) {
        let request = URLRequest.azureEndOfConversationActivitiesRequest(conversation: conversation)
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
    }
    
    
   func authenticateUser(user:CCBUser,completionHandler:@escaping (_ conversation:AzureConversation?, _ error:NSError?) -> Void) {
        let request = URLRequest.azureAuthenticationRequest(azureID: user.azureSecretKey as String, userID: user.userID,name: user.userName)
        CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                guard error == nil else {
                    completionHandler(nil,error as NSError?)
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

                    let conversation = AzureConversation(conversationID:json[CCBConstants.AzureResponse.conversationID] as! String, userID: user.userID, name: user.userName)
                    conversation.updateUserToken(token:json[CCBConstants.AzureResponse.token] as! String)
                    completionHandler(conversation,nil)
            }).resume()
    }
    
    func startConversation(conversation:AzureConversation,completionHandler: @escaping ( _ error:NSError?) -> Void) {
        let request = URLRequest.azureConversationRequest(token: conversation.token)
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
                completionHandler(nil)
            }).resume()
        }
}


