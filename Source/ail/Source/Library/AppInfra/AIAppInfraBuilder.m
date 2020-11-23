//
//  AIAppInfraBuilder.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/24/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIAppInfraBuilder.h"
#import "AIAppInfra.h"

@implementation AIAppInfraBuilder
@synthesize logging,tagging,storageProvider,internationalization,RESTClient,serviceDiscovery,appIdentity,appConfig,time,abtest,languagePack,appUpdate,consentManager,deviceHandler,cloudLogging;

-(AIAppInfra *)build{
    return [[AIAppInfra alloc] initWithBuilder:self]; 
}

@end
