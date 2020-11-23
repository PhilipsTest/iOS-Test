//
//  PSUtility.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSUtility.h"
#import "PSConstants.h"
#import "PSAppInfraWrapper.h"
@import CoreText;
@import PhilipsIconFontDLS;

@implementation PSUtility

// Check For Phone or Tab
+ (BOOL)isIphone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

// Orientation Check

+ (BOOL)isPortraitMode
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

//Reachablity Check
+(BOOL)isNetworkReachable
{
    return [[PSAppInfraWrapper sharedInstance].appInfra.RESTClient isInternetReachable];
}

+ (BOOL)isRequiredTypeImage:(NSString *)fileType
{
    NSArray *typeArray=[NSArray arrayWithObjects:@"RTP",@"APP",@"DPP",@"MI1",@"PID", nil];
    if([typeArray containsObject:fileType])
        return YES;
    return NO;
}

+ (NSString *)getVersion {
    NSDictionary *info = [StoryboardBundle infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    return [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (UIImage*)imageForText:(NSString*)text withFontSize:(CGFloat)size withColor:(UIColor *)color {
    UIFont *font = [UIFont iconFontWithSize:size];
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    CGRect charRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(charRect.size.width + 1, charRect.size.height), NO, 2.0);
    [text drawInRect:charRect withAttributes:attributes];
    UIImage *closeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    closeImage = [closeImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, charRect.size.width, 0, 0) resizingMode:UIImageResizingModeStretch];
    return closeImage;
}

@end
