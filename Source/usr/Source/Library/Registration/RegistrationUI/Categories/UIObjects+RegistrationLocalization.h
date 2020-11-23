//
//  UILabel+RegistrationLocalization.h
//  Registration
//
//  Copyright (c) 2014 Philips Innovation Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey;
@end

@interface UIButton (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey;

@end


@interface UITextField (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey;
- (void)setRegistrationPlaceHolderLocalizedText:(NSString *)localizationKey;

@end


@interface UIViewController (Localization)

- (void)setRegistrationLocalizedText:(NSString *)localizationKey;

@end
