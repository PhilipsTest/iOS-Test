//
//  PIMRestClientMock.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 4/30/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import AppInfra

class PIMRESTClientMock: NSObject, AIRESTClientProtocol {

    var responseData: Any?
    var secondResponseData: Any?
    var requestCounter: Int = 0
    var errorData: Error?
    var secondErrorData: Error?
    var requestSerializer: AFHTTPRequestSerializer & AFURLRequestSerialization = MockRequestSerializer()

    func getNetworkReachabilityStatus() -> AIRESTClientReachabilityStatus { return .reachableViaWiFi }

    func isInternetReachable() -> Bool { return false }

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
        return MockSessionDataTask()
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

class MockSessionDataTask: URLSessionDataTask {
    override func resume() {}
}

class MockRequestSerializer: AFHTTPRequestSerializer {
    
}

class MockResponseSerialization:NSObject, AIRESTClientURLResponseSerialization {
    static var supportsSecureCoding: Bool = false
    
    func responseObject(for response: URLResponse?, data: Data?, error: NSErrorPointer) -> Any? {
        return nil
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func encode(with aCoder: NSCoder) {}
    
    required init?(coder aDecoder: NSCoder) {}
}
