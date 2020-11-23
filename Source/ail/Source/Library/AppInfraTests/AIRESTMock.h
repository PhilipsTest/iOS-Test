//
//  AIRESTMock.h
//  AppInfra
//
//  Created by Hashim MH on 24/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRESTClientInterface.h"
NS_ASSUME_NONNULL_BEGIN


@interface AIRESTMock : AIRESTClientInterface

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
@property(nonatomic,strong)NSDictionary *mockData;

-(void)verifyCall;
-(void)expect:(NSString*)method;
NS_ASSUME_NONNULL_END
@end

