//
//  DCConfigurationContainer.m
//  DigitalCare
//
//  Created by sameer sulaiman on 18/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCConfigurationContainer.h"
#import "DCConstants.h"
#import "DCHandler.h"

@implementation DCConfigurationContainer

- (id)init{
    if (self = [super init]){
        [self refreshConfigurations];
    }
    return  self;
}

-(void)refreshConfigurations{
    NSString *configFilePath = [DCHandler getAppSpecificConfigFilePath]?[DCHandler getAppSpecificConfigFilePath]:[[NSBundle mainBundle] pathForResource:kCONFIGFILENAME ofType:kCONFIGTYPE];
    if(configFilePath == nil)
        configFilePath =  [self ccConfigFilePath];
    NSDictionary * configurations = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
    _themeConfig= [[DCThemeConfig alloc] initWithDictionary:[configurations objectForKey:kTHEMECONFIG]];
    _supportConfig=[[DCSupportConfig alloc] initWithArrayData:[configurations objectForKey:kSUPPORTCONFIG]];
    _productConfig=[[DCProductConfig alloc] initWithArrayData:[configurations objectForKey:kPRODUCTCONFIG]];
    _socialServiceProvidersConfig=[[DCSocialProvidersConfig alloc] initWithArrayData:[configurations objectForKey:kSOCIALSERVICEPROVIDERS]];
    _socialConfig=[[DCSocialConfig alloc] initWithDictionary:[configurations objectForKey:kSOCIALCONFIG]];
    _feedbackConfig=[[DCFeedbackConfig alloc] initWithDictionary:[configurations objectForKey:kFEEDBACKCONFIG]];
    _environmentValuesDictionary=[[NSDictionary alloc] initWithDictionary:[configurations objectForKey:kENVIRONMENTVARIABLES]];
}

-(NSString*)ccConfigFilePath{
    return [StoryboardBundle pathForResource:kCONFIGFILENAME ofType:kCONFIGTYPE];
}
@end
