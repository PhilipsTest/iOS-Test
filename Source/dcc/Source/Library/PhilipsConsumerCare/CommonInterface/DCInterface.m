//
//  CCInterface.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 8/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DCInterface.h"
#import "DCConstants.h"
#import "DCSupportViewController.h"
#import "DCLaunchInput.h"
#import "DCAppInfraWrapper.h"
#import "DCDependencies.h"
#import "DCPluginManager.h"
#import "DCHandler.h"
#import "DCContentConfiguration.h"
#import <PlatformInterfaces/PlatformInterfaces-Swift.h>

@implementation DCInterface

/**
 Convenience initializer

 @param dependencies UAPPDependencies object
 @param settings UAPPSettings object
 @return return instance of DCInterface
 @since 1.0.0
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (instancetype)initWithDependencies:(UAPPDependencies *)dependencies andSettings:(UAPPSettings *)settings
{
    self = [super init];
    if (self)
    {
        [DCAppInfraWrapper sharedInstance].appInfra = ((DCDependencies*)dependencies).appInfra;
        [[DCAppInfraWrapper sharedInstance].appInfra.serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
            if(countryCode)
                [DCPluginManager sharedInstance].strHomeCountry = countryCode;
        }];
    }
    return self;
}

/**
 Description: method for returning CC ViewController with parameter launchinput

 @param launchInput takes the launch input
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and take one arguments error that occurred, if any.
 @return "return"  CC ViewController
 @since 1.0.0
 */
- (UIViewController *)instantiateViewController:(UAPPLaunchInput *) launchInput withErrorHandler:(void (^)(NSError *error))completionHandler
{
    UIStoryboard *dcStoryboard = [UIStoryboard storyboardWithName:kDCSupport bundle:StoryboardBundle];
    DCSupportViewController *dcRootViewController = [dcStoryboard instantiateViewControllerWithIdentifier:kDCSupportView];
    dcRootViewController.dCMenuDelegates = ((DCLaunchInput*)launchInput).dCMenuDelegates;
    [DCHandler setAppSpecificLiveChatURL:((DCLaunchInput*)launchInput).chatURL];
    PSProductModelSelectionType *modelType = ((DCLaunchInput*)launchInput).productModelSelectionType;
    dcRootViewController.productList = (PSHardcodedProductList*)modelType;
    [DCHandler setAppSpecificConfigFilePath:((DCLaunchInput*)launchInput).appSpecificConfigFilePath];
    [[[DCPluginManager sharedInstance] configData] refreshConfigurations];
    ConsentDefinition *locationConsentDefinition = ((DCLaunchInput*)launchInput).locationConsentDefinition;
    if (locationConsentDefinition != nil) {
        [DCHandler setLocationConsentDefinition:locationConsentDefinition];
    }
    DCContentConfiguration *contentConfiguration = ((DCLaunchInput*)launchInput).contentConfiguration;
    [DCHandler setContentConfiguration:contentConfiguration];

    return dcRootViewController;
}

#pragma clang diagnostic pop
@end
