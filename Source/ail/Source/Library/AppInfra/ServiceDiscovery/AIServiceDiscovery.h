//
//  AISDServiceDiscoveryInterface.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/8/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <Foundation/Foundation.h>
#import "AIServiceDiscoveryProtocol.h"
#import "AIAppInfraProtocol.h"

@interface AIServiceDiscovery : NSObject<AIServiceDiscoveryProtocol>

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

@end

