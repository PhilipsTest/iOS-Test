//
//  UILabel+RegistrationLocalization.m
//
//
//  Copyright (c) 2014 Philips Innovation Services. All rights reserved.
//

#import "UIObjects+RegistrationLocalization.h"
#import "RegistrationUIConstants.h"

@implementation UILabel (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey
{
    self.text = LOCALIZE(localizationKey);
}

@end

@implementation UIButton (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey
{
    [self setTitle:LOCALIZE(localizationKey) forState:UIControlStateNormal];
}

@end

@implementation UITextField (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey
{
    [self setText:LOCALIZE(localizationKey)];
}

- (void)setRegistrationPlaceHolderLocalizedText:(NSString *)localizationKey
{
    [self setPlaceholder:LOCALIZE(localizationKey)];
}

@end


@implementation UIViewController (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey
{
    [self setTitle:LOCALIZE(localizationKey)];
}

@end
