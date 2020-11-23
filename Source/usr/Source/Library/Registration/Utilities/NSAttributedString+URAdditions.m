//
//  NSAttributedString+URAdditions.m
//  Registration
//
//  Created by Abhishek Chatterjee on 02/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "NSAttributedString+URAdditions.h"

@implementation NSAttributedString (URAdditions)

+ (NSMutableAttributedString *)attributedStringWithBoldSubstring:(NSString *)subString originalString:(NSString *)displayString withFont:(UIFont *)font {
    NSRange rangeBold = [displayString rangeOfString:subString];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];

    NSMutableAttributedString *attributedStringWithBoldSubstring = [[NSMutableAttributedString alloc] initWithString:displayString];
    [attributedStringWithBoldSubstring setAttributes:dictBoldText range:rangeBold];

    return attributedStringWithBoldSubstring;
}

@end
