// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "UITextView+HighlightText.h"
@import PhilipsUIKitDLS;

@implementation UITextView (HighlightText)

- (void)setAttributedText:(NSString *)text highlitedKeyWords:(NSDictionary *)highlightDict color:(UIColor *)color {
    [self setAttributedText:text highlitedKeyWords:highlightDict textColor:color highlightedColor:[UIDThemeManager sharedInstance].defaultTheme.hyperlinkDefaultText];
}


- (void)setAttributedText:(NSString *)text highlitedKeyWords:(NSDictionary *)highlightDict textColor:(UIColor *)textColor highlightedColor:(UIColor *)highlightedColor {
    
    NSMutableAttributedString * legalNoticeAttrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *blackText = @{NSForegroundColorAttributeName: textColor,  NSFontAttributeName:[UIFont fontWithName:@"CentraleSansBook" size:16]};
    NSDictionary *linkText = @{NSForegroundColorAttributeName: highlightedColor, NSFontAttributeName: [UIFont fontWithName:@"CentraleSansBook" size:16], NSUnderlineStyleAttributeName: @1};
    
    [legalNoticeAttrString setAttributes:blackText range:NSMakeRange(0, [legalNoticeAttrString length])];
    
    for (NSString *string in highlightDict.allKeys) {
        NSRange highlightTextRange = [text rangeOfString:string];
        
        [legalNoticeAttrString setAttributes:linkText range:highlightTextRange];
        [legalNoticeAttrString addAttribute:NSLinkAttributeName value:highlightDict[string] range:highlightTextRange];
    }
    
    self.tintColor = highlightedColor;
    self.attributedText = legalNoticeAttrString;
}


- (void)setAttributedText:(NSMutableAttributedString *)text WithFont:(UIFont *)font ForRange:(NSRange)fontRange {
    NSDictionary *attributesDict = @{NSFontAttributeName:font};
    [text setAttributes:attributesDict range:fontRange];
    self.attributedText = text;
}


- (void)setAttributedText:(NSMutableAttributedString *)text WithFont:(UIFont *)font ForRange:(NSRange)fontRange andColor:(UIColor *)fontColor {
    NSDictionary *attributesDict = @{NSFontAttributeName : font, NSForegroundColorAttributeName : fontColor};
    [text setAttributes:attributesDict range:fontRange];
    self.attributedText = text;
}

@end
