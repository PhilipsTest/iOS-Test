/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPConfigurationManager {
    
    fileprivate var localeMatch : String!
    fileprivate var propositionId : String!
    
    init() {

        //Locale is Fetched in IAPHandler class from PRX
        self.localeMatch = IAPConfiguration.sharedInstance.locale!
        //Parent app sets propositionId in configuration file
        self.propositionId = (IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kPropositionId)) as? String
    }

    func getlocaleMatch() -> String {
        return self.localeMatch
    }
    
    func getPropositionId() -> String {
        return self.propositionId
    }
    
    func getConfigurationDataWithInterface(_ interface: IAPHttpConnectionInterface, successCompletion:@escaping (IAPConfigurationData)->(), errorFailure:@escaping (NSError)->()) {
        
        guard let configuration = IAPConfiguration.sharedInstance.configuration else {
            interface.setSuccessCompletion({ (data: [String: AnyObject]) -> () in
                let configuration = IAPConfigurationData(inDictionary: data as NSDictionary)
                IAPConfiguration.sharedInstance.configuration = configuration
                successCompletion(configuration)
            })
            interface.setFailurHandler({ (error:NSError) in
                errorFailure(error)
            })
            interface.performGetRequest()
            return
        }
        successCompletion(configuration)
    }
    
    func getInterfaceForConfiguration() -> IAPHttpConnectionInterface {
        let requestURL = getConfigURL()
        let httpConnectionInterface = IAPHttpConnectionInterface(request: requestURL, httpHeaders: nil, bodyParameters: nil)
        return httpConnectionInterface
    }
    
    fileprivate func getConfigURL() -> String {
        let url = IAPBaseURLBuilder().proivdeAppConfigurationBaseURL(self.getlocaleMatch(), withProposition:self.getPropositionId())
        return url
    }
}
