//
//  APIManager.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/3/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"
#import "AISDURLs.h"

@interface AISDManager : NSObject<NSURLSessionDelegate>

-(instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

-(void)getServiceDiscoveryDataWithcompletionHandler:(void (^)( AISDURLs *  SDURLs, NSError *  error))completionHandler;

-(void)homeCountryCodeWithCompletion:(void(^)(NSString *countryCode, NSString *sourceType, NSError *error))completionHandler;

-(void)saveCountryCode:(NSString *)countryCode sourceType:(NSString *)sourceType;

-(AISDURLs *)getCachedData;

-(void)clearDownloadedURLs;

-(BOOL)isRefreshRequired;

-(BOOL)savedURLsOlderthan24Hours;

-(NSString *)savedCountryCode;

+(NSError *) getSDError:(AISDError) error;

@end
