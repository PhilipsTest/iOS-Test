//
//  UILabel+UILabel_DCExternal.m
//  DigitalCare
//
//  Created by sameer sulaiman on 21/03/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "UILabel+DCExternal.h"
#import "DCConstants.h"

@implementation UILabel (DCExternal)

- (void)setConsumerCareLocalizedText:(NSString *)localizationKey
{
    NSString *localizedText = LOCALIZE(localizationKey);
    if (localizedText != nil) {
        if(self.attributedText != nil) {
            if (LOCALIZE(localizationKey)) {
                NSDictionary *info = [self.attributedText attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0,self.attributedText.length)];
                NSParagraphStyle *paragraphStyle = info[NSParagraphStyleAttributeName];
                UIFont *font = info[NSFontAttributeName];
                NSDictionary *attributes  = @{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName:paragraphStyle};
                NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:localizedText attributes:attributes];
                self.attributedText = attributedStr;
            }
        } else {
            self.text = localizedText;
        }
    }
}

@end
