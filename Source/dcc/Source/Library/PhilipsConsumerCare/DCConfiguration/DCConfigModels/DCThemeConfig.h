//
//  DCThemeConfig.h
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface DCThemeConfig : NSObject

@property (nonatomic, strong) NSString *screenBackgroundColor;
@property (nonatomic) BOOL navigationBarTitleRequired;
@property (nonatomic, strong) NSString *headerTextColor;
@property (nonatomic, strong) NSString *subHeaderTextColor;
@property (nonatomic, strong) NSString *buttonBackgroundColor;
@property (nonatomic, strong) NSString *buttonPressedBackgroundColor;
@property (nonatomic, strong) NSString *buttonTextColor;
@property (nonatomic, strong) NSString *registerButtonBackgroundColor;
@property (nonatomic, strong) NSString *backGroundImage;
@property (nonatomic, strong) NSString *registerButtonPressedColor;
@property (nonatomic, strong) NSString *faqTabBackgroundColor;
@property (nonatomic) float iPadLandscapePadding;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
