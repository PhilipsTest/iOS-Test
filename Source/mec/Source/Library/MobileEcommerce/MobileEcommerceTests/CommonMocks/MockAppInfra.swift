/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra

class MockAppInfra: AIAppInfra {
    
    override init() {
        super.init()
        self.logging = MockLogger()
        self.appIdentity = MockAppIdentity()
        self.serviceDiscovery = ServiceDiscoveryMock()
        self.restClient = RESTClientMock()
        self.storageProvider = MockStorageProvider()
        self.appConfig = MockAppConfig()
    }
    
    deinit {
        self.logging = nil
        self.appIdentity = nil
        self.serviceDiscovery = nil
        self.restClient = nil
        self.storageProvider = nil
        self.appConfig = nil
    }
}

class MockLogger: NSObject, AILoggingProtocol {
    
    var logLevel: AILogLevel?
    var logEventID: String?
    var logMessage: String?
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return self
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {
        logLevel = level
        logEventID = eventId
        logMessage = message
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {}
}

class RESTClientMock: NSObject, AIRESTClientProtocol {

    var responseData: Any?
    var secondResponseData: Any?
    var requestCounter: Int = 0
    var errorData: Error?
    var secondErrorData: Error?
    var requestSerializer: AFHTTPRequestSerializer & AFURLRequestSerialization = MockRequestSerializer()
    var isMockInternetReachable: Bool = true

    func getNetworkReachabilityStatus() -> AIRESTClientReachabilityStatus { return .reachableViaWiFi }

    func isInternetReachable() -> Bool { return isMockInternetReachable }

    func startNotifier() -> Bool { return false }

    func stopNotifier() { }

    var baseURL: URL?

    func manager() -> AIRESTClientProtocol { return self}

    func createInstance(withBaseURL url: URL?) -> AIRESTClientProtocol {return self }

    func createInstance(withBaseURL url: URL?,
                        sessionConfiguration
        configuration: URLSessionConfiguration?) -> AIRESTClientProtocol { return self }

    func createInstance(with configuration: URLSessionConfiguration?) -> AIRESTClientProtocol { return self}

    func createInstance(withBaseURL url: URL?,
                        sessionConfiguration configuration: URLSessionConfiguration?,
                        with cachePolicy: AIRESTURLRequestCachePolicy) -> AIRESTClientProtocol { return self}

    func get(_ URLString: String,
             parameters: Any?,
             progress downloadProgress: ((Progress) -> Void)?,
             success: ((URLSessionDataTask, Any?) -> Void)?,
             failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil}

    func get(withServiceID serviceID: String,
             preference: AIRESTServiceIDPreference,
             pathComponent: String?,
             serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
             parameters: Any?,
             progress downloadProgress: ((Progress) -> Void)?,
             success: ((URLSessionDataTask, Any?) -> Void)?,
             failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    func head(_ URLString: String,
              parameters: Any?,
              success: ((URLSessionDataTask) -> Void)?,
              failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil }

    func head(withServiceID serviceID: String,
              preference: AIRESTServiceIDPreference,
              pathComponent: String?,
              serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
              parameters: Any?,
              success: ((URLSessionDataTask) -> Void)?,
              failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    func post(_ URLString: String,
              parameters: Any?,
              progress uploadProgress: ((Progress) -> Void)?,
              success: ((URLSessionDataTask, Any?) -> Void)?,
              failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil  }

    func post(_ URLString: String,
              parameters: Any?,
              constructingBodyWith block: ((AFMultipartFormData) -> Void)?,
              progress uploadProgress: ((Progress) -> Void)?,
              success: ((URLSessionDataTask, Any?) -> Void)?,
              failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil  }

    func post(withServiceID serviceID: String,
              preference: AIRESTServiceIDPreference,
              pathComponent: String?,
              serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
              parameters: Any?,
              progress uploadProgress: ((Progress) -> Void)?,
              success: ((URLSessionDataTask, Any?) -> Void)?,
              failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    func put(_ URLString: String,
             parameters: Any?,
             success: ((URLSessionDataTask, Any?) -> Void)?,
             failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil  }

    func put(withServiceID serviceID: String,
             preference: AIRESTServiceIDPreference,
             pathComponent: String?,
             serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
             parameters: Any?,
             success: ((URLSessionDataTask, Any?) -> Void)?,
             failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    func patch(_ URLString: String,
               parameters: Any?,
               success: ((URLSessionDataTask, Any?) -> Void)?,
               failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? {  return nil }

    func patch(withServiceID serviceID: String,
               preference: AIRESTServiceIDPreference,
               pathComponent: String?,
               serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
               parameters: Any?,
               success: ((URLSessionDataTask, Any?) -> Void)?,
               failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    func delete(_ URLString: String,
                parameters: Any?,
                success: ((URLSessionDataTask, Any?) -> Void)?,
                failure: ((URLSessionDataTask?, Error) -> Void)? = nil) -> URLSessionDataTask? { return nil  }

    func delete(withServiceID serviceID: String,
                preference: AIRESTServiceIDPreference,
                pathComponent: String?,
                serviceURLCompletion: ((URLSessionDataTask) -> Void)?,
                parameters: Any?,
                success: ((URLSessionDataTask, Any?) -> Void)?,
                failure: ((URLSessionDataTask?, Error) -> Void)? = nil) { }

    var session: URLSession = URLSession()

    var operationQueue: OperationQueue = OperationQueue()

    var responseSerializer: AIRESTClientURLResponseSerialization = MockResponseSerialization(coder: NSCoder())!

    var securityPolicy: AFSecurityPolicy = AFSecurityPolicy()

    var reachabilityManager: AFNetworkReachabilityManager = AFNetworkReachabilityManager.init(forDomain: "www.google.com")

    var tasks: [URLSessionTask] = []

    var dataTasks: [URLSessionDataTask] = []

    var uploadTasks: [URLSessionUploadTask] = []

    var downloadTasks: [URLSessionDownloadTask] = []

    var completionQueue: DispatchQueue?

    var completionGroup: DispatchGroup?

    var attemptsToRecreateUploadTasksForBackgroundSessions: Bool = true

    func invalidateSessionCancelingTasks(_ cancelPendingTasks: Bool) { }

    func dataTask(with request: URLRequest,
                  completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionDataTask {
        return URLSessionDataTask()
    }

    func dataTask(with request: URLRequest,
                  uploadProgress uploadProgressBlock: ((Progress) -> Void)?,
                  downloadProgress downloadProgressBlock: ((Progress) -> Void)?,
                  completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionDataTask {return URLSessionDataTask()  }

    func uploadTask(with request: URLRequest,
                    fromFile fileURL: URL,
                    progress uploadProgressBlock: ((Progress) -> Void)?,
                    completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {return URLSessionUploadTask()  }

    func uploadTask(with request: URLRequest,
                    from bodyData: Data?,
                    progress uploadProgressBlock: ((Progress) -> Void)?,
                    completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {return URLSessionUploadTask()  }

    func uploadTask(withStreamedRequest request: URLRequest,
                    progress uploadProgressBlock: ((Progress) -> Void)?,
                    completionHandler: ((URLResponse, Any?, Error?) -> Void)? = nil) -> URLSessionUploadTask {return URLSessionUploadTask()  }

    func downloadTask(with request: URLRequest,
                      progress downloadProgressBlock: ((Progress) -> Void)?,
                      destination: ((URL, URLResponse) -> URL)?,
                      completionHandler: ((URLResponse, URL?, Error?) -> Void)? = nil) -> URLSessionDownloadTask { return URLSessionDownloadTask() }

    func downloadTask(withResumeData resumeData: Data,
                      progress downloadProgressBlock: ((Progress) -> Void)?,
                      destination: ((URL, URLResponse) -> URL)?,
                      completionHandler: ((URLResponse, URL?, Error?) -> Void)? = nil) -> URLSessionDownloadTask { return URLSessionDownloadTask() }

    func uploadProgress(for task: URLSessionTask) -> Progress? { return nil }

    func downloadProgress(for task: URLSessionTask) -> Progress? {return nil}

    func setSessionDidBecomeInvalidBlock(_ block: ((URLSession, Error) -> Void)?) {}

    func setSessionDidReceiveAuthenticationChallenge(_ block: ((URLSession, URLAuthenticationChallenge,
        AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition)?) { }

    func setTaskNeedNewBodyStreamBlock(_ block: ((URLSession, URLSessionTask) -> InputStream)?) {}

    func setTaskWillPerformHTTPRedirectionBlock(_ block: ((URLSession, URLSessionTask, URLResponse, URLRequest) -> URLRequest)?) {}

    func setTaskDidReceiveAuthenticationChallenge(_ block: ((URLSession,
        URLSessionTask,
        URLAuthenticationChallenge,
        AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition)?) {}

    func setTaskDidSendBodyDataBlock(_ block: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?) {}

    func setTaskDidComplete(_ block: ((URLSession, URLSessionTask, Error?) -> Void)?) {}

    func setDataTaskDidReceiveResponseBlock(_ block: ((URLSession,
        URLSessionDataTask,
        URLResponse) -> URLSession.ResponseDisposition)?) {}

    func setDataTaskDidBecomeDownloadTaskBlock(_ block: ((URLSession,
        URLSessionDataTask,
        URLSessionDownloadTask) -> Void)?) {}

    func setDataTaskDidReceiveDataBlock(_ block: ((URLSession, URLSessionDataTask, Data) -> Void)?) {}

    func setDataTaskWillCacheResponseBlock(_ block: ((URLSession,
        URLSessionDataTask,
        CachedURLResponse) -> CachedURLResponse)?) {}

    func setDidFinishEventsForBackgroundURLSessionBlock(_ block: ((URLSession) -> Void)?) { }

    func setDownloadTaskDidFinishDownloadingBlock(_ block: ((URLSession, URLSessionDownloadTask, URL) -> URL?)?) { }

    func setDownloadTaskDidWriteDataBlock(_ block: ((URLSession,
        URLSessionDownloadTask,
        Int64,
        Int64,
        Int64) -> Void)?) { }

    func setDownloadTaskDidResumeBlock(_ block: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?) { }

    func clearCacheResponse() { }

    weak var delegate: AIRESTClientDelegate?
}

class MockRequestSerializer: AFHTTPRequestSerializer { }

class MockResponseSerialization:NSObject, AIRESTClientURLResponseSerialization {
    func responseObject(for response: URLResponse?, data: Data?, error: NSErrorPointer) -> Any? { return nil }
    static var supportsSecureCoding: Bool = false
    func copy(with zone: NSZone? = nil) -> Any { return self }
    func encode(with aCoder: NSCoder) { }
    required init?(coder aDecoder: NSCoder) { }
}

class MockStorageProvider: NSObject, AIStorageProviderProtocol {
    
    var storedValue: NSDictionary?
    var storeError: NSError?
    var fetchedValue: NSDictionary?
    var fetchError: NSError?
    
    func storeValue(forKey key: String, value object: NSCoding) throws {
        guard let storeError = storeError else {
            storedValue = [key: object]
            return
        }
        throw storeError
    }
    
    func fetchValue(forKey key: String) throws -> Any {
        guard let fetchError = fetchError else {
            return fetchedValue as Any
        }
        throw fetchError
    }
    
    func removeValue(forKey key: String) {}
    
    func loadData(_ data: NSCoding) throws -> Data {
        return Data()
    }
    
    func parseData(_ data: Data) throws -> Any {
        return Data()
    }
    
    func deviceHasPasscode() -> Bool {
        return false
    }
    
    func getDeviceCapability() -> String {
        return ""
    }
    
    func storeData(toFile filePath: String, type: String, data: Any) throws {}
    
    func fetchData(fromFile filePath: String, type: String) throws -> Any { return Data() }
    
    func removeFile(fromPath filePath: String, type: String) throws {}
}
