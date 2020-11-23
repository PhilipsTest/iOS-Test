//
//  AIRESTClientInterface.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 17/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIRESTClientProtocol.h"
#import "AIAppInfraProtocol.h"
@import AFNetworking;

@interface AIRESTClientInterface : AFHTTPSessionManager<AIRESTClientProtocol>

@property(nonatomic,weak)id <AIRESTClientDelegate>delegate;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol> )appInfra;

@end
