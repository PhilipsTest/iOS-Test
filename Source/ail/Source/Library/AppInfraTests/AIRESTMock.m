//
//  AIRESTMock.m
//  AppInfra
//
//  Created by Hashim MH on 24/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIRESTMock.h"

@interface AIRESTMock (){
    NSMutableArray *expectedMethods;
}

@end
@implementation AIRESTMock

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    

    NSDictionary *mockData = self.mockData[URLString];
    if (!mockData){
        return  [super GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
    }
    else{
      
        id successData = mockData[@"success"];
        NSError *error = mockData[@"fail"];
        if (error){
            failure(nil,error);
        }
        else{
            success(nil,successData);
 
        }
    }
    
    return  nil;
}

- (void)GETWithServiceID:(NSString *)serviceID
              preference:(AIRESTServiceIDPreference)preference
           pathComponent:(nullable NSString *)pathComponent
    serviceURLCompletion:(nullable void (^)(NSURLSessionDataTask *task))serviceURLCompletion
              parameters:(nullable id)parameters
                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    [self updateExpectation:_cmd];
    NSString *serviceURL = self.mockData[serviceID];
        
        if (serviceURL) {
            [self GET:serviceURL parameters:parameters progress:downloadProgress success:success failure:failure];
            
        }
        else {
            NSError *error = [[NSError alloc]initWithDomain:@"ail.ServiceDiscovery"
                                                       code:0
                                                   userInfo:[NSDictionary dictionaryWithObject:@"ServiceDiscovery cannot find URL" forKey:NSLocalizedDescriptionKey]];
            failure(nil, error);

      }
        
}

-(void)updateExpectation:(SEL)method{
    [expectedMethods removeObject:NSStringFromSelector(method)];
}
-(void)verifyCall{
 
    NSAssert(!expectedMethods ||expectedMethods.count==0 , @"Expected Methods not called on RESTMock: %@",[expectedMethods description] );
}

-(void)expect:(NSString*)method{
    if (!expectedMethods) expectedMethods = [[NSMutableArray alloc]init];
    [expectedMethods addObject:method];
    
}
@end
