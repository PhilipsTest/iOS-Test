//
//  DCPluginManager.h
//  DigitalCare
//
//  Created by sameer sulaiman on 29/03/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "DCConfigurationContainer.h"

@interface DCPluginManager : NSObject

@property(nonatomic,strong)DCConfigurationContainer *configData;
@property(nonatomic,strong)NSDictionary *serviceiscoveryURLsDictionary;
@property(nonatomic,strong)NSString *strHomeCountry;

+ (DCPluginManager*)sharedInstance;
@end
