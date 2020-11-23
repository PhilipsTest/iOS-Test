//
//  AIAppConfiguration.h
//  AppInfra
//
//  Created by leslie on 01/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIAppConfigurationProtocol.h"
#import "AIAppInfraProtocol.h"

@interface AIAppConfiguration : NSObject<AIAppConfigurationProtocol>

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

@end
