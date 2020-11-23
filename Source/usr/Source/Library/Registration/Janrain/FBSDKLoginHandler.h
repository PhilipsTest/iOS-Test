//
//  FBSDKLoginHandler.h
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 19/03/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^FBSDKLoginHandlerCompletion)(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error);

@interface FBSDKLoginHandler : NSObject

+ (BOOL)isNativeFBLoginAvailable;
- (void)logout;
- (void)startFacebookLoginFrom:(UIViewController * _Nonnull)controller completion:(FBSDKLoginHandlerCompletion _Nonnull )completion;
- (BOOL)application:(UIApplication * _Nonnull)app openURL:(NSURL * _Nonnull)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;

@end
