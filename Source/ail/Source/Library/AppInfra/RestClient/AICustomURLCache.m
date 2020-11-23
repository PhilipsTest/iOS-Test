//
//  AICustomURLCache.m
//  AppInfra
//
//  Created by leslie on 31/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "AICustomURLCache.h"
#import "AIAppConfiguration.h"
#import "AIStorageProvider.h"
@interface AICustomURLCache()
@property(nonatomic) AIStorageProvider * storageProvider;
@property(nonatomic, strong)id<AIAppInfraProtocol> appInfra;

@end

@implementation AICustomURLCache

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    NSError * error;
    NSUInteger diskcapacity = ((NSNumber *)[appInfra.appConfig getPropertyForKey:@"restclient.cacheSizeInKB" group:@"appinfra" error:&error]).unsignedIntegerValue;
    if (error != nil) {
        //in case of error setting default disk capacity as 20mb
        diskcapacity = 20 * 1024 * 1024;
    }
    //setting memmory default size as 4mb and disk size read from appconfig
    self = [super initWithMemoryCapacity:4 * 1024 * 1024
                            diskCapacity:diskcapacity * 1024
                                diskPath:nil];
    if (self) {
        self.appInfra = appInfra;
    }
    return self;
}

//- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
//    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
//    BOOL shouldDecrypt = NO;
//    if (cachedResponse.userInfo[@"AIEStatus"] &&
//        [cachedResponse.userInfo[@"AIEStatus"] isEqualToString:@"true"]) {
//        shouldDecrypt = YES;
//    }
//    if (cachedResponse && shouldDecrypt) {
//        NSError * error;
//        NSData* decryptedData = [self.storageProvider parseData:cachedResponse.data error:&error];
//        cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
//                                                                  data:decryptedData
//                                                              userInfo:cachedResponse.userInfo
//                                                         storagePolicy:cachedResponse.storagePolicy];
//    }
//    return cachedResponse;
//}
//

@end
