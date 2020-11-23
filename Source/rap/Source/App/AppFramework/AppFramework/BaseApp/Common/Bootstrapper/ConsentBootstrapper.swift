import PlatformInterfaces
import PhilipsRegistration
import AppInfra
import PhilipsConsumerCare

public class ConsentBootstrapper: NSObject {
    static let sharedInstance = ConsentBootstrapper()
    var consentDefinitions : [ConsentDefinition]

    private override init() {
        self.consentDefinitions = ConsentBootstrapper.getConsentDefinitions()
    }

    private static func getConsentDefinitions() -> [ConsentDefinition] {
        var consentDefinitions : [ConsentDefinition] = []
        
        guard let appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler else {
            return consentDefinitions
        }
        
        let locale = fetchLocale(appInfra: appInfra)        
    
        let marketingConsent = URConsentProvider.fetchMarketingConsentDefinition(locale)
        guard let cloudConsent = appInfra.cloudLogging.getCloudLoggingConsentIdentifier()else{
            return consentDefinitions
        }
        let cookieConsent = ConsentDefinition(types: [appInfra.tagging.getClickStreamConsentIdentifier(),Constants.Cloud_Logging_Consent_Type,Constants.ABTest_Consent_Type,cloudConsent], text: Utilites.aFLocalizedString("RA_MYA_Click_Stream_Hosting_Consent")!, helpText: Utilites.aFLocalizedString("RA_MYA_Consent_Click_Stream_Help_Text")!, version: 2, locale: locale)

        consentDefinitions += [marketingConsent,cookieConsent]

        appInfra.consentManager.registerConsentDefinitions!(consentDefinitions: consentDefinitions, completion: { _ in  })

        return consentDefinitions
    }
    
    func getClickStreamConsentDefinition() -> ConsentDefinition? {
        var consentDefinition: ConsentDefinition?
        if let appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler {
            consentDefinition = consentDefinitions.first { $0.getTypes().contains(appInfra.tagging.getClickStreamConsentIdentifier()) }
        }
        return consentDefinition
    }
    
    private static func fetchLocale(appInfra: AIAppInfra) -> String {
        return appInfra.internationalization.getBCP47UILocale()
    }
}
