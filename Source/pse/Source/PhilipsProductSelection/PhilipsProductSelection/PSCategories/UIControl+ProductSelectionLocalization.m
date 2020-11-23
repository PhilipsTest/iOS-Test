//
//  UIControl+ProductSelectionLocalization.m
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 6/9/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "UIControl+ProductSelectionLocalization.h"
#import "PSConstants.h"

@implementation UILabel (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey
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

@implementation UIButton (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey
{
    [self setTitle:LOCALIZE(localizationKey) forState:UIControlStateNormal];
}
@end

@implementation UITextField (Localization)

- (void)setProductSelectionLocalizedText:(NSString *)localizationKey
{
    [self setText:LOCALIZE(localizationKey)];
}
@end
