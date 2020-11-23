//
//  CCBExtensions.swift
//  ConversationalChatbotDev
/*  Copyright (c) Koninklijke Philips N.V., 2020
*   All rights are reserved. Reproduction or dissemination
*   in whole or in part is prohibited without the prior written
*   consent of the copyright holder.
*/

import Foundation
import PhilipsUIKitDLS

extension URLRequest {
    
    static func azureAuthenticationRequest(azureID:String, userID:String?, name:String?) -> URLRequest {
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.authenticationURL
        var urlRequest = URLRequest(url:URL(string: url)!)
        urlRequest.httpMethod = CCBConstants.HTTPConstants.httpMethodPost;
        let authorisationValue = (CCBConstants.HTTPConstants.Bearer) + " " + azureID
        urlRequest.addValue(authorisationValue, forHTTPHeaderField: CCBConstants.HTTPConstants.Authorization)
        urlRequest.addValue(CCBConstants.HTTPConstants.appJSON, forHTTPHeaderField: CCBConstants.HTTPConstants.Contenttype)
        let aUserID = userID ?? CCBConstants.AzuerUser.userID
        let aUserName = name ?? CCBConstants.AzuerUser.userName
        urlRequest.httpBody =  "{\"user\": {\"id\": \(aUserID),\"name\": \(aUserName)}}".data(using: .utf8)// Data(base64Encoded: )
        return urlRequest
    }
    
    static func azureRefreshConversationRequest(token:String) -> URLRequest {
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.refreshURL
        var urlRequest = URLRequest(url:URL(string: url)!)
        urlRequest.httpMethod = CCBConstants.HTTPConstants.httpMethodPost;
        let authorisationValue = (CCBConstants.HTTPConstants.Bearer) + " " + token
        urlRequest.addValue(authorisationValue, forHTTPHeaderField: CCBConstants.HTTPConstants.Authorization)
        urlRequest.addValue(CCBConstants.HTTPConstants.appJSON, forHTTPHeaderField: CCBConstants.HTTPConstants.Contenttype)
        return urlRequest

    }
    
    static func azureConversationRequest(token:String) -> URLRequest {
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.conversationURL
        var urlRequest = URLRequest(url:URL(string: url)!)
        urlRequest.httpMethod = CCBConstants.HTTPConstants.httpMethodPost
        let authorisationValue = (CCBConstants.HTTPConstants.Bearer) + " " + token
        urlRequest.addValue(authorisationValue, forHTTPHeaderField: CCBConstants.HTTPConstants.Authorization)
        urlRequest.addValue(CCBConstants.HTTPConstants.appJSON, forHTTPHeaderField: CCBConstants.HTTPConstants.Contenttype)
        return urlRequest
    }
    
    private static func azureActivitiesRequest(token:String,conversationID:String) -> URLRequest {
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.conversationURL + "/\(conversationID)" + CCBConstants.AzureURLConstants.activityURL
        var urlRequest = URLRequest(url:URL(string: url)!)
        urlRequest.httpMethod = CCBConstants.HTTPConstants.httpMethodPost
        let authorisationValue = (CCBConstants.HTTPConstants.Bearer) + " " + token
        urlRequest.addValue(authorisationValue, forHTTPHeaderField: CCBConstants.HTTPConstants.Authorization)
        urlRequest.addValue(CCBConstants.HTTPConstants.appJSON, forHTTPHeaderField: CCBConstants.HTTPConstants.Contenttype)
        return urlRequest
    }
    
    static func azurePostActivitiesRequest(conversation:AzureConversation,text:String) -> URLRequest {
        var request = URLRequest.azureActivitiesRequest(token: conversation.conversationToken, conversationID: conversation.conversationID)
        request.httpMethod = CCBConstants.HTTPConstants.httpMethodPost
        let userID = conversation.userID ?? CCBConstants.AzuerUser.userID
        let bodyString = "{\"type\": \"message\",\"from\": {\"id\": \"\(userID)\"},\"text\": \"\(text)\"}"
        request.httpBody = bodyString.data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
    static func azureEndOfConversationActivitiesRequest(conversation:AzureConversation) -> URLRequest {
        var request = URLRequest.azureActivitiesRequest(token: conversation.conversationToken, conversationID: conversation.conversationID)
        request.httpMethod = CCBConstants.HTTPConstants.httpMethodPost
        let userID = conversation.userID ?? CCBConstants.AzuerUser.userID
        let bodyString = "{\"type\": \"endOfConversation\",\"from\": {\"id\": \"\(String(describing: userID))\"}}"
        request.httpBody = bodyString.data(using: .utf8, allowLossyConversion: false)
        return request
    }
    static func azureUpdateConversationActivitiesRequest(conversation:AzureConversation) -> URLRequest {
        var request = URLRequest.azureActivitiesRequest(token: conversation.conversationToken, conversationID: conversation.conversationID)
        request.httpMethod = CCBConstants.HTTPConstants.httpMethodPost
        let userID = conversation.userID ?? CCBConstants.AzuerUser.userID
        let bodyString = "{\"type\": \"conversationUpdate\",\"from\": {\"id\": \"\(String(describing: userID))\"}}"
        request.httpBody = bodyString.data(using: .utf8, allowLossyConversion: false)
        return request
    }


    
    static func azureGetActivitiesRequest(conversation:AzureConversation) -> URLRequest {
        var request = URLRequest.azureActivitiesRequest(token: conversation.conversationToken, conversationID: conversation.conversationID)
        request.httpMethod = CCBConstants.HTTPConstants.httpMethodGet
        return request
    }
    
    static func azureReConnectWSRequest(conversation:AzureConversation) -> URLRequest {
        let url = CCBConstants.AzureURLConstants.azureBaseURL + CCBConstants.AzureURLConstants.conversationURL + "/\(conversation.conversationID)" + CCBConstants.AzureURLConstants.waterMark + "\(conversation.lastWaterMarkID ?? "0")"
        var urlRequest = URLRequest(url:URL(string: url)!)
        urlRequest.httpMethod = CCBConstants.HTTPConstants.httpMethodGet
        let authorisationValue = (CCBConstants.HTTPConstants.Bearer) + " " + conversation.token
        urlRequest.addValue(authorisationValue, forHTTPHeaderField: CCBConstants.HTTPConstants.Authorization)
        urlRequest.addValue(CCBConstants.HTTPConstants.appJSON, forHTTPHeaderField: CCBConstants.HTTPConstants.Contenttype)
        return urlRequest
    }
}


extension URLRequest {

    public var curlString: String {
        // Logging URL requests in whole may expose sensitive data,
        // or open up possibility for getting access to your user data,
        // so make sure to disable this feature for production builds!
        #if !DEBUG
            return ""
        #else
            var result = "curl -k "

            if let method = httpMethod {
                result += "-X \(method) \\\n"
            }

            if let headers = allHTTPHeaderFields {
                for (header, value) in headers {
                    result += "-H \"\(header): \(value)\" \\\n"
                }
            }

            if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
                result += "-d '\(string)' \\\n"
            }

            if let url = url {
                result += url.absoluteString
            }

            return result
        #endif
    }
}



extension NSError {
    
    static func noConversationError() -> NSError {
        return NSError(domain: CCBConstants.Error.CCBErrorDomain, code: CCBErrorCode.noConversationPresent.rawValue, userInfo: [NSLocalizedFailureErrorKey : "Conversation is not present"])
    }
    
    static func ongoingConversationError() -> NSError {
        return NSError(domain: CCBConstants.Error.CCBErrorDomain, code: CCBErrorCode.conversationPresent.rawValue, userInfo: [NSLocalizedFailureErrorKey : "A Conversation is already present"])
    }
    
    static func parseForAzureError(_ json:[String:AnyObject]) -> NSError? {
        var error:NSError?
        guard  let errorDict = json[CCBConstants.Error.Error] as? [String:AnyObject] else {
            return error
        }
        error = NSError(domain: CCBConstants.Error.AzureErrorDomain, code: CCBErrorCode.AzureTokenExpiredError.rawValue, userInfo: [NSLocalizedFailureErrorKey : errorDict[CCBConstants.Error.Message]!])
        return error;
    }
    
    static func errorWithLocalisedDesctiption(_ Description:String) -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedFailureErrorKey : Description]);
    }
    
    static func webSocketError() -> NSError {
        return NSError(domain: CCBConstants.Error.NetworkErrorDomain, code: CCBErrorCode.WebSocketConnectionError.rawValue, userInfo: [NSLocalizedDescriptionKey:CCBConstants.Error.ErrorMessage]);
    }
}

extension DateFormatter {
    
    static func roundTripIso8601() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar      = Calendar(identifier: .iso8601)
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return formatter
    }
    
    func roundTripIso8601DateWithMicroseconds(from dateString: String) -> Date? {
        
        guard let parsedDate = self.date(from: dateString) else {
            return nil
        }
        
        var preliminaryDate = Date(timeIntervalSinceReferenceDate: floor(parsedDate.timeIntervalSinceReferenceDate))
        
        if let fractionStart = dateString.range(of: "."),
            let fractionEnd = dateString.index(fractionStart.lowerBound, offsetBy: 7, limitedBy: dateString.endIndex) {
            let fractionRange = fractionStart.lowerBound..<fractionEnd
            let fractionStr = String(dateString[fractionRange])
            
            if var fraction = Double(fractionStr) {
                fraction = Double(floor(1000000*fraction)/1000000)
                preliminaryDate.addTimeInterval(fraction)
            }
        }
        
        return preliminaryDate
    }
    
    static func roundTripIso8601Decoder(decoder: Decoder) throws -> Date {

        let container = try decoder.singleValueContainer()

        let dateString = try container.decode(String.self)

        guard let microsecondDate = DateFormatter.roundTripIso8601().roundTripIso8601DateWithMicroseconds(from: dateString) else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unable to parse string (\(dateString)) into date"))
        }

        return microsecondDate
    }
}

class CCBNetworkUtility  {
    
    static func performAzureNetworkRequest(request:URLRequest, completionHandler:@escaping (_ response:URLResponse?, _ dict:[String:AnyObject]?, _ error:NSError?) -> Void) {
        CCBManager.shared.ccbDependencies?.appInfra.restClient.dataTask(with: request, completionHandler: { (response, data, error) in
                          guard error == nil else {
                            completionHandler(nil,nil,error as NSError?)
                              return
                          }
                          guard let json = data as? [String:AnyObject] else {
                              let error = NSError(domain: "Some", code: 2, userInfo: [NSLocalizedFailureErrorKey : "JSON data not there in azure response"])
                              completionHandler(nil,nil,error)
                              return
                          }
                   
                           let azureError = NSError.parseForAzureError(json)
                           guard azureError == nil else {
                               completionHandler(nil,nil,azureError)
                               return
                           }
                           completionHandler(response,json,nil)
                   }).resume()
    }
}

extension UITextView {
    
    func highlightURLS() {
        let totalString = NSMutableAttributedString(string: self.text)
        var links = [(url: URL, range: NSRange)]()
        let matches =  self.text.embeddedLinks(range: NSMakeRange(0, self.text.count))
        for match in matches {
            links.append((match.url!,match.range))
        }
        totalString.addLinkAttributes(links: links , fontSize: UIDFontSizeMedium)
        self.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        self.attributedText = totalString
    }
}

extension URL {
        func fetchYouYubeID() -> String? {
            let urlString = self.absoluteString
            let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: urlString.count)

            guard let result = regex?.firstMatch(in: urlString, range: range) else {
                return nil
            }

            return (self.absoluteString as NSString).substring(with: result.range)
        }
}

extension String {
    
    func embeddedLinks(range:NSRange) -> [NSTextCheckingResult] {
        var links = [NSTextCheckingResult]()
        let types: NSTextCheckingResult.CheckingType = [.link]
        guard let detector = try? NSDataDetector(types: types.rawValue) else {
            return links
        }
        links = detector.matches(in: self, options: .reportCompletion, range: range)
        return links
    }
    
    func stringWithEmojis() -> String {
        guard let textData = self.data(using: .utf8) else {
            return self
        }
        return String(bytes: textData, encoding: .nonLossyASCII) ?? self
    }
}

extension NSMutableAttributedString {
    
    func addLinkAttributes(links:[(url:URL,range:NSRange)],fontSize:CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        self.setAttributes([.foregroundColor : (UIDThemeManager.sharedInstance.defaultTheme?.labelRegularText ?? UIColor.black), .font : UIFont(uidFont: .medium, size: fontSize) ?? UIDFont.bold], range: NSRange(location: 0, length: self.length))
        
        for aLink in links {
            self.addAttribute(.link, value: aLink.url, range: aLink.range)
        }
    }
    
}




