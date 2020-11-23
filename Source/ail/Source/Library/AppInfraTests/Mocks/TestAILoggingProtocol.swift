import Foundation
import AppInfra
import PlatformInterfaces

class TestAILoggingProtocol : NSObject,AICloudLoggingProtocol {
    
    var hsdpUserUUID: String!
    
    func getCloudLoggingConsentIdentifier() -> String! {
        return "adsadsada"
    }
    
    public func log(_ level: AILogLevel, eventId: String!, message: String!) {
        
    }
    
    public func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {
        
    }
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
      return TestAILoggingProtocol()
    }
}
