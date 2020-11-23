//
//  PRXNetworkWrapper.h
//  PRXClient
//
//  Created by sameer sulaiman on 10/27/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXDependencies.h"
@class PRXRequest;
/**
 A class which performs HTTP get, maintains request queue, handles caching etc.
 */
@interface PRXNetworkWrapper : NSObject

/**
 Instance of the PRXDependencies
 @since 1.0.0
 */
@property(nonatomic,strong)PRXDependencies *dependencies;

/**
 Initializes Network Wrapper instance.
 @param prxdependency PRXDependencies object
 @returns PRXNetworkWrapper instance
 @since 1.0.0
 */
- (instancetype)initWithDependencies:(PRXDependencies*)prxdependency;

/** 
 Performs a Network Request
 @param success A block object to be executed when the task finishes successfully.
 @param failure A block object to be executed when the task finishes unsuccessfully.
 @since 1.0.0
 */

- (void) sendRequest:(PRXRequest *)request
          completion:(void (^)(id response))success
             failure:(void(^)(NSError *error))failure;
@end
