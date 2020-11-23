//
//  PRXRequestManager.h
//  PRXClient
//
//  Created by sameer sulaiman on 10/22/15.
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXResponseData.h"
#import "PRXDependencies.h"
@class PRXDataBuilder;
@class PRXRequest;

/**
 PRXRequestManager class is used for executing PRXClient requests.
 This is the entry class to start the PRX Request.
 It provides set of public APIs for placing requests from client.
 */
@interface PRXRequestManager : NSObject

/**
 instance of the PRXDependencies
 @since 1.0.0
 */
@property(nonatomic,strong)PRXDependencies *dependencies;

/**
  Initializes request manager instance.
  @param prxdependency PRXDependencies object
  @returns PRXRequestManager instance
  @since 1.0.0
 */
- (instancetype)initWithDependencies:(PRXDependencies*)prxdependency;

/**
  Executes a network Request
  @param success A block object to be executed when the task finishes successfully.
  @param failure A block object to be executed when the task finishes unsuccessfully.
  @since 1.0.0
 */
- (void)execute:(PRXRequest*) request
     completion:(void (^)(PRXResponseData *response))success
        failure:(void(^)(NSError *error))failure;

@end
