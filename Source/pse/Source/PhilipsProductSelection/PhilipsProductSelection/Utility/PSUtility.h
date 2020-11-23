//
//  PSUtility.h
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSUtility : NSObject

+ (BOOL)isIphone;
+ (BOOL)isPortraitMode;
+ (NSString *)getVersion;
+ (BOOL)isNetworkReachable;
+ (BOOL)isRequiredTypeImage:(NSString *)fileType;
+ (UIImage*)imageForText:(NSString*)text withFontSize:(CGFloat)size withColor:(UIColor *)color;
@end
