//
//  AIABTest.h
//  AppInfra
//
//  Created by Hashim MH on 03/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfra.h"
#import "AIABTestProtocol.h"

@interface AIABTest : NSObject<AIABTestProtocol>

- (nullable instancetype)initWithAppInfra:(nonnull id<AIAppInfraProtocol>)appInfra;
@end
