//
//  DCConfigurationContainer.h
//  DigitalCare
//
//  Created by sameer sulaiman on 18/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "DCThemeConfig.h"
#import "DCSupportConfig.h"
#import "DCProductConfig.h"
#import "DCSocialProvidersConfig.h"
#import "DCSocialConfig.h"
#import "DCFeedbackConfig.h"

@interface DCConfigurationContainer : NSObject

@property(nonatomic,strong)DCThemeConfig *themeConfig;
@property(nonatomic,strong)DCSupportConfig *supportConfig;
@property(nonatomic,strong)DCProductConfig *productConfig;
@property(nonatomic,strong)DCSocialProvidersConfig *socialServiceProvidersConfig;
@property(nonatomic,strong)DCSocialConfig *socialConfig;
@property(nonatomic,strong)DCFeedbackConfig *feedbackConfig;
@property(nonatomic,strong)NSDictionary *environmentValuesDictionary;

-(void)refreshConfigurations;

@end
