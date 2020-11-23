//
//  DCUtilities.h
//  DigitalCare
//
//  Created by sameer sulaiman on 18/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCUtilities : NSObject

+ (BOOL)isSameImage:(UIImage*)image1 image:(UIImage*)image2;
+ (BOOL)isNetworkReachable;
+ (BOOL)isIphone;
+ (NSString*)formattedPhoneNumber:(NSString*)number;
+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
+ (BOOL)isDeviceLanguageRTL;
+ (NSString *)urlEncode:(NSString *)unencodedString;
+ (NSString *)appName;
+ (UIImage*)imageForText:(NSString*)text withFontSize:(CGFloat)size withColor:(UIColor *)color;
+ (NSDictionary*)dcMenuIconIcons;
+ (NSMutableAttributedString*)convertToBoldString:(NSString*)completeString stringToBold:(NSString*)boldString withFont:(UIFont*)font;
+ (void)ccOpenURL:(NSURL*)url;
+ (NSString*)getTwitterPageName;
+ (UIViewController*)topViewController:(UIViewController*)viewController;
@end
