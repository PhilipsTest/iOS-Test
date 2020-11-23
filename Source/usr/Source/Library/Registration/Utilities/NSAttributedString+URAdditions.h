//
//  NSAttributedString+URAdditions.h
//  Registration
//
//  Created by Abhishek Chatterjee on 02/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (URAdditions)

+ (NSMutableAttributedString *)attributedStringWithBoldSubstring:(NSString *)subString originalString:(NSString *)displayString withFont:(UIFont *)font;

@end
