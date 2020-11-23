//
//  CCLaunchInput.h
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 8/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UAPPFramework/UAPPFramework.h>
#import <PhilipsProductSelection/PSProductModelSelectionType.h>
#import <PhilipsProductSelection/PSHardcodedProductList.h>
#import "DCProductMenuProtocol.h"
#import "DCMainMenuProtocol.h"
#import "DCSocialMenuProtocol.h"
#import "DCContentConfiguration.h"
@class ConsentDefinition;

@protocol DCMenuDelegates<DCMainMenuDelegate,DCProductMenuDelegate,DCSocialMenuDelegate>

@end

@interface DCLaunchInput : UAPPLaunchInput

@property (nonatomic,strong) PSProductModelSelectionType *productModelSelectionType;
@property (nonatomic,assign) id <DCMenuDelegates> dCMenuDelegates;
@property (nonatomic, strong) NSString *chatURL;
@property (nonatomic, strong) NSString *appSpecificConfigFilePath;
@property (nonatomic, strong) ConsentDefinition *locationConsentDefinition;
@property (nonatomic, strong) DCContentConfiguration *contentConfiguration;
@end
