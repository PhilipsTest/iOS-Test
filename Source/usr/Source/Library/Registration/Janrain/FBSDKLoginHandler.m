//
//  FBSDKLoginHandler.m
//  PhilipsRegistration
//
//  Created by Adarsh Kumar Rai on 19/03/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "FBSDKLoginHandler.h"
#import "DIRegistrationConstants.h"
#import "DIConstants.h"

@implementation FBSDKLoginHandler
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (BOOL)isNativeFBLoginAvailable {
    if (NSClassFromString(@"FBSDKLoginManager") != nil &&
        NSClassFromString(@"FBSDKApplicationDelegate") != nil &&
        [NSClassFromString(@"FBSDKLoginManager") instancesRespondToSelector:NSSelectorFromString(@"logInWithPermissions:fromViewController:handler:")] &&
        [NSClassFromString(@"FBSDKApplicationDelegate") instancesRespondToSelector:NSSelectorFromString(@"application:openURL:options:")]) {
        return true;
    }
    return false;
}


- (void)startFacebookLoginFrom:(UIViewController *)controller completion:(FBSDKLoginHandlerCompletion)completion {
    id scope = @[@"public_profile", @"email"];
    void(^handler)(id, NSError *) = ^(id result, NSError *error) {
        if (error) {
            completion(nil, nil, error);
        } else if ([result performSelector:@selector(isCancelled)]) {
            NSError *authError = [NSError errorWithDomain:@"engageAuthenticationDidCancel" code:DIRegAuthenticationError
                                             userInfo:@{@"providerName": kProviderNameFacebook,
                                                        @"errorMessage": @"engage Authentication cancelled"}];
            completion(nil, nil, authError);
        } else {
            NSString *tokenString = [result valueForKeyPath:@"token.tokenString"];
            if (tokenString) {
                [self getUserEmailWithCompletion:^(NSString *email, NSError *completionError) {
                    completion(tokenString, email, completionError);
                }];
            } else {
                completion(nil, nil, nil);
            }
        }
    };
    id loginManager = [[NSClassFromString(@"FBSDKLoginManager") alloc] init];
    SEL selector = NSSelectorFromString(@"logInWithPermissions:fromViewController:handler:");
    NSMethodSignature *signature = [NSClassFromString(@"FBSDKLoginManager") instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:loginManager];
    [invocation setArgument:&scope atIndex:2];
    [invocation setArgument:&controller atIndex:3];
    [invocation setArgument:&handler atIndex:4];
    [invocation invoke];
    
}


- (void)logout {
    if ([FBSDKLoginHandler isNativeFBLoginAvailable]) {
        id loginManager = [[NSClassFromString(@"FBSDKLoginManager") alloc] init];
        [loginManager performSelector:NSSelectorFromString(@"logOut") withObject:nil];
    }
}


- (void)getUserEmailWithCompletion:(void(^)(NSString *email, NSError *error))completion {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    id fbSDKGraphRequest = [[NSClassFromString(@"FBSDKGraphRequest") alloc] performSelector:NSSelectorFromString(@"initWithGraphPath:parameters:") withObject:@"me" withObject:parameters];
    void(^handler)(id, id, NSError *) = ^(id connection, id result, NSError *error) {
        completion(result[@"email"], error);
    };
    SEL selector = NSSelectorFromString(@"startWithCompletionHandler:");
    NSMethodSignature *signature = [NSClassFromString(@"FBSDKGraphRequest") instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:fbSDKGraphRequest];
    [invocation setArgument:&handler atIndex:2];
    [invocation invoke];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    id fbApplicationDelegate = [NSClassFromString(@"FBSDKApplicationDelegate") performSelector:NSSelectorFromString(@"sharedInstance")];
    SEL selector = NSSelectorFromString(@"application:openURL:options:");
    NSMethodSignature *signature = [NSClassFromString(@"FBSDKApplicationDelegate") instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:fbApplicationDelegate];
    [invocation setArgument:&app atIndex:2];
    [invocation setArgument:&url atIndex:3];
    [invocation setArgument:&options atIndex:4];
    [invocation invoke];
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}
#pragma clang diagnostic pop
@end
