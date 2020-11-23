//
//  AICustomURLCache.h
//  AppInfra
//
//  Created by leslie on 31/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"

@interface AICustomURLCache : NSURLCache

- (instancetype)initWithAppInfra:(id <AIAppInfraProtocol>)appInfra;

@end
