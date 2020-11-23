//
//  URGoogleLoginHandler.h
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 10/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

typedef void(^URGoogleLoginCompletion)(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error);

@interface URGoogleLoginHandler : NSObject

- (instancetype _Nonnull)initWithClientId:(NSString * _Nonnull)clientId redirectURI:(NSString * _Nonnull)redirectURI;
- (void)startGoogleLoginFrom:(UIViewController * _Nonnull)controller completion:(nonnull URGoogleLoginCompletion)completion;
- (BOOL)application:(UIApplication * _Nonnull)app openURL:(NSURL * _Nonnull)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *_Nullable)options;
@end


@interface AppleUser : NSObject

@property (nonatomic,strong) NSString * _Nullable firstName;
@property (nonatomic,strong) NSString * _Nullable accessToken;
@property (nonatomic,strong) NSString * _Nullable lastName;
@property (nonatomic,strong) NSString * _Nullable appleUser;
@property (nonatomic,strong) NSString * _Nullable appleToken;
@property (nonatomic,strong) NSString * _Nullable emailID;

@end

typedef void(^URAppleLoginCompletion)(AppleUser * _Nullable user, NSError * _Nullable error);

API_AVAILABLE(ios(13.0))
@interface URAppleSignInHandler : NSObject <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

- (void)startAppleLoginFrom:(UIWindow * _Nonnull)controller completion:(nonnull URAppleLoginCompletion)completion;

@end
