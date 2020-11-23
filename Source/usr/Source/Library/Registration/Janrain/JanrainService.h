//
//  JanrainService.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "JRCaptureUser.h"
#import "DIConsumerInterest.h"
#import "DIRegistrationConstants.h"

typedef void (^JanrainServiceSuccessHandler)(JRCaptureUser *user, BOOL isUpdated);
typedef void (^JanrainServiceFailureHandler)(NSError *error);
typedef void (^JanrainServiceAuthenticationHandler)(NSDictionary *userInfo,NSError *error);

@interface JanrainService : NSObject

- (void)downloadConfigurationForCountryCode:(NSString *)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs completion:(void(^)(NSError *error))completion;
- (void)resetPasswordForEmail:(NSString *)email withSuccessHandler:(dispatch_block_t)success
               failureHandler:(JanrainServiceFailureHandler)failure;
- (void)resendVerificationCodeForMobileNumber:(NSString *)mobileNumber withSuccessHandler:(dispatch_block_t)success
                               failureHandler:(JanrainServiceFailureHandler)failure;
- (void)activateAccountWithVerificationCode:(NSString *)code forUUID:(NSString *)uuid withSuccessHandler:(dispatch_block_t)success
                             failureHandler:(JanrainServiceFailureHandler)failure;
- (void)resetPasswordForMobileNumber:(NSString *)mobileNumber withSuccessHandler:(void(^)(NSString *token))success
                      failureHandler:(JanrainServiceFailureHandler)failure;
- (void)loginToTraditionalUsingEmail:(NSString *)email password:(NSString *)password
                  withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)refreshAccessTokenWithSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)logoutWithCompletion:(dispatch_block_t)completion;

- (void)registerNewUserUsingEmail:(NSString *)email orMobileNumber:(NSString *)mobileNumber password:(NSString *)password
                        firstName:(NSString *)firstName lastName:(NSString *)lastName ageLimitPassed:(BOOL)ageLimitPassed marketingOptIn:(BOOL)optIn
               withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)resendVerificationMailForEmail:(NSString *)email withSuccessHandler:(dispatch_block_t)success
                       failureHandler:(JanrainServiceFailureHandler)failure;
- (void)updateMobileNumber:(NSString *)mobileNumber withSuccessHandler:(dispatch_block_t)success
            failureHandler:(JanrainServiceFailureHandler)failure;
- (void)addRecoveryEmailToMobileNumberAccount:(NSString *)recoveryEmail forUser:(JRCaptureUser*)user withSuccessHandler:(JanrainServiceSuccessHandler)success
                               failureHandler:(JanrainServiceFailureHandler)failure;
- (void)replaceConsumerInterests:(NSArray<DIConsumerInterest *> *)interests forUser:(JRCaptureUser *)user
              withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)updateFields:(NSDictionary *)fields forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success
      failureHandler:(JanrainServiceFailureHandler)failure;
- (void)updateCOPPAConsentAcceptance:(BOOL)accepted forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success
                      failureHandler:(JanrainServiceFailureHandler)failure;
- (void)updateCOPPAConsentApproval:(BOOL)accepted forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)refetchUserProfileWithSuccessHandler:(JanrainServiceSuccessHandler)success failure:(JanrainServiceFailureHandler)failure;
- (void)loginUsingProvider:(NSString *)provider nativeToken:(NSString *)token mergeToken:(NSString *)mergeToken withAuthenticationHandler:(JanrainServiceAuthenticationHandler)authentication
            successHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure;
- (void)completeSocialLoginForProfile:(JRCaptureUser *)user registrationToken:(NSString *)token withSuccessHandler:(JanrainServiceSuccessHandler)success
                       failureHandler:(JanrainServiceFailureHandler)failure;
- (void)handleTraditionalToSocialMergeWithEmail:(NSString *)email password:(NSString *)password mergeToken:(NSString *)mergeToken
                                 successHandler:(JanrainServiceSuccessHandler)success
                                 failureHandler:(JanrainServiceFailureHandler)failure;
@end
