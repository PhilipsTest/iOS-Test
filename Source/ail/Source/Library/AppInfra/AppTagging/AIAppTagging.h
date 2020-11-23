//
//  AIAppTagging.h
//  AppInfra
//
//  Created by Ravi Kiran HR 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AIAppTaggingProtocol.h"
#import "AIAppInfraProtocol.h"

@interface AIAppTagging : NSObject <AIAppTaggingProtocol>

@property(nonatomic,strong)id<AIAppInfraProtocol> aiAppInfra;

- (NSDictionary *)getAnalyticsDefaultParams;
- (void)registerClickStreamConsentHandler;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

@end
