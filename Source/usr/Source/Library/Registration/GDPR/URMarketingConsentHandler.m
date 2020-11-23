//
// URMarketingConsentHandler.m
// PhilipsRegistration
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URMarketingConsentHandler.h"
#import "DIRegistrationConstants.h"
#import "DIConstants.h"
#import "DIUser.h"
#import "DILogger.h"
#import "RegistrationUtility.h"
#import "URSettingsWrapper.h"
#import "URBaseErrorParser.h"

typedef void (^PostCompletion)(BOOL, NSError * _Nullable);
typedef void (^FetchCompletion)(ConsentStatus * _Nullable, NSError * _Nullable);

@interface URMarketingConsentHandler ()<UserDetailsDelegate>

@property (nonatomic, strong) PostCompletion postCompletion;
@property (nonatomic, strong) FetchCompletion fetchCompletion;

@end

@implementation URMarketingConsentHandler

- (void)fetchConsentTypeStateFor:(NSString * _Nonnull)consentType completion:(void (^ _Nonnull)(ConsentStatus * _Nullable, NSError * _Nullable))completion {
    if([consentType isEqualToString:kUSRMarketingConsentKey]) {
        self.fetchCompletion = completion;
        [[DIUser getInstance] addUserDetailsListener:self];
        [[DIUser getInstance] refetchUserProfile];
    } else {
        completion(nil, [URBaseErrorParser unsupportedConsentError]);
    }
}

- (void)storeConsentStateFor:(NSString * _Nonnull)consentType withStatus:(BOOL)status withVersion:(NSInteger)version completion:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completion {
    if([consentType isEqualToString:kUSRMarketingConsentKey]) {
        self.postCompletion  = completion;
        DIUser *user = [DIUser getInstance];
        [user addUserDetailsListener:self];
        [user updateReciveMarketingEmail:status];
    } else {
        completion(nil, [URBaseErrorParser unsupportedConsentError]);
    }
}


#pragma mark - UserDetailDelegate methods
#pragma mark -

- (void)didUpdateSuccess {
    [DIUser.getInstance removeUserDetailsListener:self];
    if(self.postCompletion) {
        self.postCompletion(true, nil);
        self.postCompletion = nil;
    }
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [DIUser.getInstance removeUserDetailsListener:self];
    if(self.postCompletion) {
        if (!URSettingsWrapper.sharedInstance.dependencies.appInfra.RESTClient.isInternetReachable) {
            error = [[NSError alloc] initWithDomain:@"URConsentErrorDomain" code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey: @"Internet connection appears to be offline"}];
        }
        self.postCompletion(false, error);
        self.postCompletion = nil;
    }
}


- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile {
    [[DIUser getInstance] removeUserDetailsListener:self];
    ConsentStatus *marketingConsentStatus;
    if(profile.marketingConsentTimestamp){
        marketingConsentStatus = [[ConsentStatus alloc]initWithStatus:profile.receiveMarketingEmails ? ConsentStatesActive : ConsentStatesRejected version:0 timestamp:profile.marketingConsentTimestamp];
    }
    else{
        marketingConsentStatus = [[ConsentStatus alloc]initWithStatus:profile.receiveMarketingEmails ? ConsentStatesActive : ConsentStatesRejected version:0 timestamp:[NSDate dateWithTimeIntervalSince1970:0]];
    }
    
    
    if (self.fetchCompletion) {
        self.fetchCompletion(marketingConsentStatus, nil);
        self.fetchCompletion = nil;
    }
}


- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    [[DIUser getInstance] removeUserDetailsListener:self];
    if (self.fetchCompletion) {
        ConsentStatus *marketingConsentStatus;
        if([DIUser getInstance].marketingConsentTimestamp){
            marketingConsentStatus = [[ConsentStatus alloc]initWithStatus:[DIUser getInstance].receiveMarketingEmails ? ConsentStatesActive : ConsentStatesRejected version:0 timestamp:[DIUser getInstance].marketingConsentTimestamp];
        }
        else{
            marketingConsentStatus = [[ConsentStatus alloc]initWithStatus:[DIUser getInstance].receiveMarketingEmails ? ConsentStatesActive : ConsentStatesRejected version:0 timestamp:[NSDate dateWithTimeIntervalSince1970:0]];
        }
        self.fetchCompletion(marketingConsentStatus, nil);
        self.fetchCompletion = nil;
    }
}

@end



@implementation URPersonalConsentHandler

- (void)fetchConsentTypeStateFor:(NSString * _Nonnull)consentType completion:(void (^ _Nonnull)(ConsentStatus * _Nullable, NSError * _Nullable))completion {
    UserLoggedInState userState = [DIUser getInstance].userLoggedInState;
    if ((userState < UserLoggedInStatePendingVerification)) {
        completion(nil,[URBaseErrorParser userNotLoggedInError]);
        return;
    }
    if([consentType isEqualToString:kUSRPersonalConsentKey]) {
        ConsentStatus *status = [RegistrationUtility providePersonalConsentStateForUser:[DIUser getInstance].userIdentifier];
        if (status == nil) {
            completion(nil,[URBaseErrorParser userNotProvidedConsentError]);
        } else  {
            completion(status,nil);
        }
        
    } else {
        completion(nil, [URBaseErrorParser unsupportedConsentError]);
    }
}

- (void)storeConsentStateFor:(NSString * _Nonnull)consentType withStatus:(BOOL)status withVersion:(NSInteger)version completion:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completion {
    UserLoggedInState userState = [DIUser getInstance].userLoggedInState;
    if (userState < UserLoggedInStatePendingVerification) {
        completion(nil,[URBaseErrorParser userNotLoggedInError]);
        return;
    }
    if([consentType isEqualToString:kUSRPersonalConsentKey]) {
        ConsentStates state = (true == status) ? ConsentStatesActive: ConsentStatesRejected;
        [RegistrationUtility userProvidedPersonalConsent:[DIUser getInstance].userIdentifier andStatus:state];
        completion(true, nil);
    } else {
        completion(nil, [URBaseErrorParser unsupportedConsentError]);
    }
}

@end
