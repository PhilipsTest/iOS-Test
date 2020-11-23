//
//  PRXRequestManager.h
//  PRXClient
//
//  Created by sameer sulaiman on 10/22/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXResponseData.h"

@class PRXDataBuilder;
@class PRXRequest;
@interface PRXRequestManager : NSObject 
- (void)execute:(PRXRequest*) request
     completion:(void (^)(PRXResponseData *response))success
        failure:(void(^)(NSError *error))failure;
@end
