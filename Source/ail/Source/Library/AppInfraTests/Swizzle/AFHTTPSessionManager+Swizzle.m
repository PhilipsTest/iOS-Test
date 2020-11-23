//
//  AFHTTPSessionManager+Swizzle.m
//  AppInfra
//
//  Created by leslie on 25/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "AFHTTPSessionManager+Swizzle.h"
#import <objc/runtime.h>

@implementation AFHTTPSessionManager (Swizzle)

+(void)loadSwizzler {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        Method originalMethodGet = class_getInstanceMethod(self, @selector(GET:parameters:progress:success:failure:));
        Method extendedMethodGet = class_getInstanceMethod(self, @selector(GETForTest:parameters:progress:success:failure:));
        method_exchangeImplementations(originalMethodGet, extendedMethodGet);
        
        Method originalMethodHead = class_getInstanceMethod(self, @selector(HEAD:parameters:success:failure:));
        Method extendedMethodHead = class_getInstanceMethod(self, @selector(HEADForTest:parameters:success:failure:));
        method_exchangeImplementations(originalMethodHead, extendedMethodHead);
        
        Method originalMethodPost = class_getInstanceMethod(self, @selector(POST:parameters:progress:success:failure:));
        Method extendedMethodPost = class_getInstanceMethod(self, @selector(POSTForTest:parameters:progress:success:failure:));
        method_exchangeImplementations(originalMethodPost, extendedMethodPost);
        
        Method originalMethodPut = class_getInstanceMethod(self, @selector(PUT:parameters:success:failure:));
        Method extendedMethodPut = class_getInstanceMethod(self, @selector(PUTForTest:parameters:success:failure:));
        method_exchangeImplementations(originalMethodPut, extendedMethodPut);
        
        Method originalMethodPatch = class_getInstanceMethod(self, @selector(PATCH:parameters:success:failure:));
        Method extendedMethodPatch = class_getInstanceMethod(self, @selector(PATCHForTest:parameters:success:failure:));
        method_exchangeImplementations(originalMethodPatch, extendedMethodPatch);
        
        Method originalMethodDelete = class_getInstanceMethod(self, @selector(DELETE:parameters:success:failure:));
        Method extendedMethodDelete = class_getInstanceMethod(self, @selector(DELETEForTest:parameters:success:failure:));
        method_exchangeImplementations(originalMethodDelete, extendedMethodDelete);
    });
}

- (NSURLSessionDataTask *)GETForTest:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [NSURLSessionDataTask new];
}

- (nullable NSURLSessionDataTask *)HEADForTest:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [NSURLSessionDataTask new];
}

- (nullable NSURLSessionDataTask *)POSTForTest:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [NSURLSessionDataTask new];
}

- (nullable NSURLSessionDataTask *)PUTForTest:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [NSURLSessionDataTask new];
}

- (nullable NSURLSessionDataTask *)PATCHForTest:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
   return [NSURLSessionDataTask new]; 
}

- (nullable NSURLSessionDataTask *)DELETEForTest:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [NSURLSessionDataTask new];
}

@end
