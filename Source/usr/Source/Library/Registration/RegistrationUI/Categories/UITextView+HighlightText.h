// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface UITextView (HighlightText)
- (void)setAttributedText:(NSString *)text highlitedKeyWords:(NSDictionary *)highlightDict color:(UIColor *)color;
- (void)setAttributedText:(NSString *)text highlitedKeyWords:(NSDictionary *)highlightDict textColor:(UIColor *)textColor highlightedColor:(UIColor *)highlightedColor;
- (void)setAttributedText:(NSMutableAttributedString *)attributedText WithFont:(UIFont *)font ForRange:(NSRange)fontRange;
- (void)setAttributedText:(NSMutableAttributedString *)text WithFont:(UIFont *)font ForRange:(NSRange)fontRange andColor:(UIColor*)fontColor;
@end
