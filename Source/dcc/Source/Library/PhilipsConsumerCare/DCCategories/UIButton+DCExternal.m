//
//  UIButton+UIButton_DCExternal.m
//  DigitalCare
//
//  Created by sameer sulaiman on 21/03/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "UIButton+DCExternal.h"
#import "DCConstants.h"

@implementation UIButton (DCExternal)


- (void)setConsumerCareLocalizedText:(NSString *)localizationKey
{
    [self setTitle:LOCALIZE(localizationKey) forState:UIControlStateNormal];
}

@end



