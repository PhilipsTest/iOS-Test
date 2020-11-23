//
//  DCUtilities.m
//  DigitalCare
//
//  Created by sameer sulaiman on 18/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.


#import "DCUtilities.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCAppInfraWrapper.h"
@import CoreText;
@import PhilipsIconFontDLS;

static NSDictionary *baseUrlCacheDictionary;
@implementation DCUtilities

// Image Check
+ (BOOL)isSameImage:(UIImage*)image1 image:(UIImage*)image2{
    return  [UIImagePNGRepresentation(image1) isEqualToData:
             UIImagePNGRepresentation(image2)];
}

//Reachablity Check
+(BOOL)isNetworkReachable{
  return [[DCAppInfraWrapper sharedInstance].appInfra.RESTClient isInternetReachable];
}

// Check For Phone or Tab
+ (BOOL)isIphone{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

+ (NSString*)formattedPhoneNumber:(NSString*)number{
    NSString *formattedNumber = number;
    if ([number rangeOfString:@"Toll-free"].location == NSNotFound){
        NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"&^<"];
        [characterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
        NSArray *phoneNumberArray=[formattedNumber componentsSeparatedByCharactersInSet:characterSet];
        formattedNumber = [phoneNumberArray count] > 0?[phoneNumberArray objectAtIndex:0]:formattedNumber;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        formattedNumber =[[formattedNumber componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@" "];
    }
    else
        formattedNumber = [[[number componentsSeparatedByString:@"(Toll-free)"] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return  formattedNumber;
}

+ (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary*)dict{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

+ (NSString*)urlEncode:(NSString*)unencodedString{
    NSString *charactersToEscape = @" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *urlEncodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return urlEncodedString;
}

+ (BOOL)isDeviceLanguageRTL {
    return ([NSLocale characterDirectionForLanguage:[[NSLocale preferredLanguages] objectAtIndex:0]] == NSLocaleLanguageDirectionRightToLeft);
}

+(NSString*)appName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBUNDLENAME];
    return appName;
}

+ (UIImage*)imageForText:(NSString*)text withFontSize:(CGFloat)size withColor:(UIColor*)color{
    UIFont *font = [UIFont iconFontWithSize:size];
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    CGRect charRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(charRect.size.width + 1, charRect.size.height), NO, 2.0);
    [text drawInRect:charRect withAttributes:attributes];
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iconImage = [iconImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, charRect.size.width, 0, 0) resizingMode:UIImageResizingModeStretch];
    return iconImage;
}

+ (NSDictionary*)dcMenuIconIcons{
    NSDictionary *menuIcon = @{@"GettingStarted" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeQuestionMark],
                               @"FAQs" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeQuestionMark24],
                               @"ProductInformation" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeInformation],
                               @"ContactUs" :[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeBalloonSpeech],
                               @"TellUs" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeConversationSpeech],
                               @"ChangeProduct" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeRevise],
                               @"facebook" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeSocialMediaFacebook],
                               @"twitter" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeSocialMediaTwitter],
                               @"email" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeMessage],
                               @"RegisterYourProduct" : [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeShield]
                               };
    return menuIcon;
}

+ (NSMutableAttributedString*)convertToBoldString:(NSString*)completeString stringToBold:(NSString*)boldString withFont:(UIFont*)font{
    NSMutableAttributedString *twitterAccntString = [[NSMutableAttributedString alloc] initWithString:completeString];
    NSRange boldRange = [completeString rangeOfString:boldString];
    [twitterAccntString addAttribute:NSFontAttributeName value:font range:boldRange];
    return twitterAccntString;
}

+ (void)ccOpenURL:(NSURL*)url{
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if(success)
                 [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"Opening app or web page out of app:" Message:@"User going out of app"];
        }];
}

+ (NSString*)getTwitterPageName{
    NSString *twiterPage;
    if([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"])
        twiterPage = [self getSDTwitterName];
    else
        twiterPage = SharedInstance.socialConfig.twitterPage;
    return twiterPage;
}

+(NSString*)getSDTwitterName{
    return [[NSURL URLWithString:[ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"]] lastPathComponent];
}

+ (UIViewController*)topViewController:(UIViewController*)viewController {
    if (!viewController) {
        viewController = [[[UIApplication sharedApplication] keyWindow]rootViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        if (navigationController.viewControllers.count != 0) {
            return [self topViewController:navigationController.viewControllers.lastObject];
        }
    }
    else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        if (tabBarController.selectedViewController) {
            return [self topViewController:tabBarController.selectedViewController];
        }
    }
    else if (viewController.presentedViewController) {
        return [self topViewController:viewController.presentedViewController];
    }
    return viewController;
}

@end
