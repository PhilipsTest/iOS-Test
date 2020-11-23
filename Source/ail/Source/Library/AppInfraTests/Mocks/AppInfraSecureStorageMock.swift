/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

enum AppInfraSecureStorageMockOutputType: Int {
    case postSuccess
    case postError
    case fetchMockError
}

public class AppInfraSecureStorageMock: NSObject {
    
    var mockSecureStorageOutputType: AppInfraSecureStorageMockOutputType = .postSuccess
    var consentData: [String:NSCoding] = [:]
    var fileData: [String:String]? = [:]
    func flushAllConsentData() {
        consentData.removeAll()
    }
}

extension AppInfraSecureStorageMock: AIStorageProviderProtocol {
    public func storeData(toFile filePath: String, type: String, data: Any) throws {
        switch mockSecureStorageOutputType {
        case .postSuccess:
            fileData = data as? [String : String]
        case .postError:
            throw NSError(domain: "TestAppStorage", code: 2222)
        default:
            break
        }
    }
    
    public func fetchData(fromFile filePath: String, type: String) throws -> Any {
        switch mockSecureStorageOutputType {
        case .fetchMockError:
            return true
        default:
            if let storedValue = fileData {
                return storedValue
            } else {
                throw NSError(domain: "TestAppStorageFetch", code: 1111)
            }
        }
    }
    
    public func removeValue(forKey key: String) {}
    
    public func loadData(_ data: NSCoding) throws -> Data { return Data() }
    
    public func parseData(_ data: Data) throws -> Any { return false }
    
    public func deviceHasPasscode() -> Bool { return false }
    
    public func getDeviceCapability() -> String { return "" }
    
    public func fetchValue(forKey key: String) throws -> Any {
        switch mockSecureStorageOutputType {
        case .fetchMockError:
            return true
        default:
            if let storedConsentValue = consentData[key] {
                return storedConsentValue
            } else {
                throw NSError(domain: "TestAppStorageFetch", code: 1111)
            }
        }
    }
    
    public func storeValue(forKey key: String, value object: NSCoding) throws {
        switch mockSecureStorageOutputType {
        case .postSuccess:
            consentData[key] = object
        case .postError:
            throw NSError(domain: "TestAppStorage", code: 2222)
        default:
            break
        }
    }
    
    public func removeFile(fromPath filePath: String, type: String) throws {
        
    }
}
