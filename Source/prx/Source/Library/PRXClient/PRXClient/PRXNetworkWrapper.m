//
//  PRXNetworkWrapper.m
//  PRXClient
//
//  Created by sameer sulaiman on 10/27/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXNetworkWrapper.h"
#import "PRXRequest.h"
@import AppInfra;
#define kPRXNetworkWrapperEvent @"PRXNetworkWrapper"
@interface PRXNetworkWrapper (){
}
    
    @property (strong, nonatomic) id <AILoggingProtocol>prxLogging;
    @end

@implementation PRXNetworkWrapper
    
    
- (instancetype)initWithDependencies:(PRXDependencies*)prxdependency
    {
        if (self = [super init]) {
            _dependencies = prxdependency;
            self.prxLogging = self.dependencies.prxLogging;
        }
        return self;
    }
    
-(void)setDependencies:(PRXDependencies *)dependencies{
    _dependencies = dependencies;
    self.prxLogging = self.dependencies.prxLogging;
}
    
- (void) sendRequest:(PRXRequest *)request
          completion:(void (^)(id response))success
             failure:(void(^)(NSError *error))failure {
    
    if (!self.dependencies.appInfra) {
        
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"You must inject Appinfra to PRX, use  [[PRXNetworkWrapper alloc]initWithDependencies:dependencies]"
                                     userInfo:nil];
    }
    
    PRXRequest *aRequest = request;
    
    NSDictionary *parameters = [aRequest getBodyParameters];
    NSString *requestType = [PRXRequestEnums stringWithRequestType:[request getRequestType]];
    NSTimeInterval timeoutInterval = [aRequest getTimeoutInterval];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    id<AIRESTClientProtocol> prxRest = [self.dependencies.appInfra.RESTClient createInstanceWithSessionConfiguration:configuration];
    
    if (!prxRest) {
        NSString *message = @"Couldn't initialise REST Client" ;
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
        NSError *customError = [[NSError alloc] initWithDomain:@"PRXNetworkWrapper"
                                                          code:0
                                                      userInfo:userInfo];
        [self.prxLogging log:AILogLevelError eventId:kPRXNetworkWrapperEvent message:message];
        failure(customError);
    }
    
    
    prxRest.requestSerializer.timeoutInterval = timeoutInterval;
    
    __block id weakSelf = self;
    
    
    [request getRequestUrlFromAppInfra:(id<AIAppInfraProtocol>)_dependencies.appInfra completionHandler:^(NSString *serviceURL, NSError *error) {
        NSDictionary *headerParameters = [aRequest getHeaderParam];
        for (NSString *key in [headerParameters allKeys]) {
            NSString *value = [headerParameters objectForKey:key];
            [prxRest.requestSerializer setValue:value forHTTPHeaderField:key];
        }
        
        NSString *urlEncoded = [self urlEncode:serviceURL];
        NSString *message = [NSString stringWithFormat:@"fetching url: %@",urlEncoded];
        [self.prxLogging  log:AILogLevelDebug eventId:kPRXNetworkWrapperEvent message:message];
        if (!urlEncoded && !error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                           @"Invalid URL"};
            NSError *customError = [[NSError alloc] initWithDomain:@"PRXNetworkWrapper"
                                                              code:0
                                                          userInfo:userInfo];
            failure(customError);
            
        }
        else if ([urlEncoded containsString:@"%"]) {
            [self.prxLogging  log:AILogLevelError eventId:kPRXNetworkWrapperEvent message:@"Incomplete parameter injection"];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                           @"Incomplete parameter injection"};
            NSError *customError = [[NSError alloc] initWithDomain:@"PRXNetworkWrapper"
                                                              code:0
                                                          userInfo:userInfo];
            failure(customError);
        }
        else
        if (error) {
            [self.prxLogging  log:AILogLevelError eventId:kPRXNetworkWrapperEvent message:error.localizedDescription];
            failure(error);
        }
        else if([requestType isEqualToString:@"GET"]){
           [self.prxLogging log:AILogLevelDebug eventId:kPRXNetworkWrapperEvent message:[NSString stringWithFormat:@"URL : %@,\n Headers  : %@,\n Body parameters : %@",urlEncoded,headerParameters.description,parameters.description]];
            
            [prxRest GET:urlEncoded parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                [self.prxLogging log:AILogLevelDebug eventId:kPRXNetworkWrapperEvent message:[NSString stringWithFormat:@"ResponseObject : %@",responseObject]];
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.prxLogging  log:AILogLevelError eventId:kPRXNetworkWrapperEvent message:error.localizedDescription];
                [weakSelf createCustomError:task error:error withFailure:failure];
            }];
        } else if([requestType isEqualToString:@"POST"]){
            [self.prxLogging log:AILogLevelDebug eventId:kPRXNetworkWrapperEvent message:[NSString stringWithFormat:@"URL : %@,\n Headers  : %@,\n Body parameters : %@",urlEncoded,headerParameters.description,parameters.description]];
            [prxRest POST:urlEncoded parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self.prxLogging log:AILogLevelDebug eventId:kPRXNetworkWrapperEvent message:[NSString stringWithFormat:@"ResponseObject : %@",responseObject]];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.prxLogging  log:AILogLevelError eventId:kPRXNetworkWrapperEvent message:error.localizedDescription];
                [weakSelf createCustomError:task error:error withFailure:failure];
            }];
        }
        
    }];
    
}
    
    
- (void)createCustomError:(NSURLSessionDataTask *)task
                    error:(NSError *)error
              withFailure:(void(^)(NSError *error))failure
    {
        if (task.error != nil) {
            failure(error);
        } else {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *userInfo = @{@"TaskIdentifier":
                                           [NSNumber numberWithUnsignedInteger:task.taskIdentifier],
                                       @"OriginalRequest":
                                           task.originalRequest ? task.originalRequest : [NSNull null],
                                       @"CurrentRequest":
                                           task.currentRequest ? task.currentRequest : [NSNull null],
                                       @"Response":
                                           response ? response : [NSNull null]};
            NSError *customError = [[NSError alloc] initWithDomain:@"NSURLSessionDataTask"
                                                              code:response.statusCode
                                                          userInfo:userInfo];
            failure(customError);
        }
    }
    
- (NSString *)urlEncode:(NSString *)unencodedString
    {
        // based on: http://stackoverflow.com/questions/8086584/objective-c-url-encoding
        NSString *charactersToEscape = @" ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *urlEncodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        return urlEncodedString;
    }
    
    @end
