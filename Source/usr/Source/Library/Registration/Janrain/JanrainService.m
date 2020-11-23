//
//  JanrainService.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "JanrainService.h"
#import "JREngage.h"
#import "JRCapture.h"
#import "JRCaptureData.h"
#import "JRCaptureUser+Extras.h"
#import "JRCaptureUser+Storage.h"
#import "JRCaptureError.h"
#import "DIHTTPUtility.h"
#import "DIConstants.h"
#import "URURXErrorParser.h"
#import "URSettingsWrapper.h"
#import "URJanRainConfiguration.h"
#import "URJanRainRequestFormatter.h"
#import "URJanrainErrorParser.h"

static NSString *const CONSUMER_ROLE = @"consumer";

@interface JanrainService ()<JRCaptureDelegate, JRCaptureObjectDelegate, JRCaptureUserDelegate>

@property (nonatomic, strong) JanrainServiceSuccessHandler          successHandler;
@property (nonatomic, strong) JanrainServiceFailureHandler          failureHandler;
@property (nonatomic, strong) JanrainServiceAuthenticationHandler   authenticationHandler;
@property (nonatomic, strong) JanrainServiceSuccessHandler          refreshSuccessHandler;
@property (nonatomic, strong) JanrainServiceFailureHandler          refreshFailureHandler;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) URJanRainConfiguration *janrainConfiguration;
@property (nonatomic, strong) URJanRainRequestFormatter *janrainRequestFormatter;
@property (nonatomic, strong) DIHTTPUtility *httpUtility;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *locale;

@end

@implementation JanrainService

- (void)downloadConfigurationForCountryCode:(NSString *)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs completion:(void(^)(NSError *error))completion {
    self.janrainConfiguration = [[URJanRainConfiguration alloc] initWithCountry:countryCode locale:locale serviceURLs:serviceURLs flowDownloadCompletion:^(NSError *error) {
        self.httpUtility = [[DIHTTPUtility alloc] init];
        self.countryCode = countryCode;
        self.locale = locale;
        self.janrainRequestFormatter = [[URJanRainRequestFormatter alloc] initWithJanRainURL:serviceURLs[kJanRainBaseURLKey]
                                                                                  urxBaseURL:serviceURLs[kURXSMSVerificationURLKey]];
        self.janrainRequestFormatter.resetPasswordRedirectURI = serviceURLs[kResetPasswordURLKey];
        completion(error);
    }];
}

#pragma mark - Traditional Login Methods
#pragma mark -

- (void)loginToTraditionalUsingEmail:(NSString *)email password:(NSString *)password withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!email || !password) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        self.successHandler = success;
        self.failureHandler = failure;
        [JRCapture startCaptureTraditionalSignInForUser:email withPassword:password mergeToken:nil forDelegate:self];
    }
}


//JR SDK Delegate Methods
- (void)captureSignInDidSucceedForUser:(JRCaptureUser *)newCaptureUser status:(JRCaptureRecordStatus)captureRecordStatus {
    self.successHandler(newCaptureUser, NO);
    self.successHandler = nil;
    self.failureHandler = nil;
}


- (void)captureSignInDidFailWithError:(NSError *)error {
    self.failureHandler(error);
    self.successHandler = nil;
    self.failureHandler = nil;
}

#pragma mark - Refresh Access Token Methods
#pragma mark -

- (void)refreshAccessTokenWithSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (![JRCaptureData sharedCaptureData].accessToken) {
        failure([URJanrainErrorParser errorForErrorCode:DIAcesssTokenIsNil]);
    }else {
        self.refreshSuccessHandler = (JanrainServiceSuccessHandler)success;
        self.refreshFailureHandler = failure;
        [JRCapture refreshAccessTokenForDelegate:self context:nil];
    }
}


//JR SDK Delegate Methods
- (void)refreshAccessTokenDidSucceedWithContext:(id<NSObject>)context {
    if (self.refreshSuccessHandler) {
        ((dispatch_block_t)self.refreshSuccessHandler)();
        self.refreshSuccessHandler = nil;
        self.refreshFailureHandler = nil;
    }
}


- (void)refreshAccessTokenDidFailWithError:(NSError *)error context:(id<NSObject>)context {
    if (self.refreshFailureHandler) {
        self.refreshFailureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
        self.refreshSuccessHandler = nil;
        self.refreshFailureHandler = nil;
    }
}

#pragma mark - Logout Methods
#pragma mark -

- (void)logoutWithCompletion:(dispatch_block_t)completion {
    [JRCapture clearSignInState];
    [JREngage clearSharingCredentialsForAllProviders];
    if (completion) {
        ((dispatch_block_t)completion)();
    }
}

#pragma mark - Traditional Registration Methods
#pragma mark -

- (void)registerNewUserUsingEmail:(NSString *)email orMobileNumber:(NSString *)mobileNumber password:(NSString *)password
                        firstName:(NSString *)firstName lastName:(NSString *)lastName ageLimitPassed:(BOOL)ageLimitPassed marketingOptIn:(BOOL)optIn
               withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure {
    if ((!email && !mobileNumber) || !firstName || !ageLimitPassed || !password) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        self.successHandler = success;
        self.failureHandler = failure;
        JRCaptureUser *jrProfile = [[JRCaptureUser alloc] init];
        [jrProfile setEmail:email];
        [jrProfile setMobileNumber:mobileNumber];
        [jrProfile setGivenName:firstName];
        if (lastName.length > 0) {
            [jrProfile setFamilyName:lastName];
        }
        [jrProfile setPassword:password];
        [jrProfile setOlderThanAgeLimitWithBool:ageLimitPassed];
        [jrProfile setReceiveMarketingEmailWithBool:optIn];
        jrProfile = [self addControlFieldForRussianUser:jrProfile];
        jrProfile = [self updatePrimaryAddressAndLanguageOfUser:jrProfile];
        [JRCapture registerNewUser:jrProfile socialRegistrationToken:nil forDelegate:self];
    }
}

//JR SDK Delegate Methods
- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser {
    self.successHandler(registeredUser, NO);
    self.successHandler = nil;
    self.failureHandler = nil;
}


- (void)registerUserDidFailWithError:(NSError *)error {
    self.failureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
    self.successHandler = nil;
    self.failureHandler = nil;
}

#pragma mark - Resend Verification Email Methods
#pragma mark -

- (void)resendVerificationMailForEmail:(NSString *)email withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!email) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    } else {
        self.successHandler = (JanrainServiceSuccessHandler)success;
        self.failureHandler = failure;
        [JRCapture resendVerificationEmail:email delegate:self];
    }
}


//JR SDK Delegate Methods
-(void)resendVerificationEmailDidSucceed {
    ((dispatch_block_t)self.successHandler)();
    self.successHandler = nil;
    self.failureHandler = nil;
}


-(void)resendVerificationEmailDidFailWithError:(NSError *)error {
    self.failureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
    self.successHandler = nil;
    self.failureHandler = nil;
}

#pragma mark - Update Janrain User Method Methods
#pragma mark -

- (void)updateFields:(NSDictionary *)fields forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success
      failureHandler:(JanrainServiceFailureHandler)failure {
    if (!user || fields.count == 0) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    self.successHandler = success;
    self.failureHandler = failure;
    JRCaptureUser *duplicateUser = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:user]];
    for (NSString *fieldName in fields.allKeys) {
        [duplicateUser setValue:fields[fieldName] forKey:fieldName];
    }
    [duplicateUser updateOnCaptureForDelegate:self context:@[user, fields]];
}


//JR SDK Delegate Methods
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context {
    if ([object isKindOfClass:[JRCaptureUser class]] && self.successHandler) {
        self.successHandler((JRCaptureUser*)object, YES);
        self.successHandler = nil;
        self.failureHandler = nil;
    }
}


- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context {
    NSError *parsedError = [URJanrainErrorParser mappedErrorForJanrainError:error];
    if (parsedError.code == DISessionExpiredErrorCode) {
        JanrainServiceSuccessHandler success = self.successHandler;
        JanrainServiceFailureHandler failure = self.failureHandler;
        [self refreshAccessTokenWithSuccessHandler:^{
            [self updateFields:[(NSArray *)context lastObject] forUser:[(NSArray *)context firstObject] withSuccessHandler:success failureHandler:failure];
        } failureHandler:^(NSError *refreshError) {
            failure([URJanrainErrorParser mappedErrorForJanrainError:refreshError]);
        }];
    } else {
        self.failureHandler(parsedError);
    }
}

#pragma mark - Replace Consumer Interests Methods
#pragma mark -

- (void)replaceConsumerInterests:(NSArray<DIConsumerInterest *> *)interests forUser:(JRCaptureUser *)user
              withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!interests || !user) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    } else {
        self.successHandler = (JanrainServiceSuccessHandler)success;
        self.failureHandler = failure;
        NSMutableArray *newInterests = [[NSMutableArray alloc]init];
        for (DIConsumerInterest *interest in interests) {
            JRConsumerInterestsElement *jrInterest = [[JRConsumerInterestsElement alloc]initWithSubjectArea:interest.subjectArea andTopicCommunicationKey:interest.topicCommunicationKey andTopicValue:interest.topicValue];
            jrInterest.campaignName = interest.campaignName;
            [newInterests addObject:jrInterest];
        }
        user.consumerInterests = newInterests;
        [user replaceConsumerInterestsArrayOnCaptureForDelegate:self context:nil];
    }
}


//JR SDK Delegate Methods
-(void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName withError:(NSError *)error context:(NSObject *)context {
    if ([arrayName isEqualToString:@"consumerInterests"] || [arrayName isEqualToString:@"consents"]) {
        self.failureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
        self.successHandler = nil;
        self.failureHandler = nil;
    }
}


-(void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray named:(NSString *)arrayName
                               context:(NSObject *)context {
    if ([arrayName isEqualToString:@"consumerInterests"]) {
        ((dispatch_block_t)self.successHandler)();
        self.successHandler = nil;
        self.failureHandler = nil;
    } else if ([arrayName isEqualToString:@"consents"]) {
        self.successHandler((JRCaptureUser*)object, NO);
        self.successHandler = nil;
        self.failureHandler = nil;
    }
}

#pragma mark - Update COPPA Consent and Approval Methods
#pragma mark -

- (void)updateCOPPAConsentAcceptance:(BOOL)accepted forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success
                      failureHandler:(JanrainServiceFailureHandler)failure {
    self.successHandler = success;
    self.failureHandler = failure;
    [[self user:user byReplacingConsentOrConsentApproval:YES accepted:accepted] replaceConsentsArrayOnCaptureForDelegate:self context:nil];
}


- (void)updateCOPPAConsentApproval:(BOOL)accepted forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure {
    self.successHandler = success;
    self.failureHandler = failure;
    [[self user:user byReplacingConsentOrConsentApproval:NO accepted:accepted] replaceConsentsArrayOnCaptureForDelegate:self context:nil];
}


- (JRCaptureUser *)user:(JRCaptureUser *)user byReplacingConsentOrConsentApproval:(BOOL)updateConsent accepted:(BOOL)accepted {
    user = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:user]];//Create a copy of object when it does not implement NSCopying protocol
    JRConsentsElement *consentElement = [[user.consents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"campaignId MATCHES %@", self.janrainConfiguration.campaignID]] lastObject];
    if (!consentElement) {
        consentElement = [[JRConsentsElement alloc]init];
        consentElement.campaignId = self.janrainConfiguration.campaignID;
        consentElement.microSiteID = self.janrainConfiguration.micrositeID;
    }
    if (updateConsent) {//Consent needs to be updated not the confrimation
        consentElement.given = @(accepted);
        consentElement.locale = [self.locale stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        consentElement.storedAt = [DIRegistrationAppTime getUTCTime];
    }else {//confirmation needs to be updated not consent.
        consentElement.confirmationGiven = @(accepted);
        consentElement.confirmationStoredAt=[DIRegistrationAppTime getUTCTime];
    }
    NSMutableArray *newConsents=[[NSMutableArray alloc]initWithArray:user.consents];
    BOOL didReplaceConsent=NO;
    for (NSUInteger i = 0; i < newConsents.count; i++) {
        JRConsentsElement *consent = newConsents[i];
        if ([consent.campaignId isEqualToString:consentElement.campaignId]) {
            [newConsents replaceObjectAtIndex:i withObject:consentElement];
            didReplaceConsent = YES;
            break;
        }
    }
    if (!didReplaceConsent) {
        [newConsents addObject:consentElement];
    }
    user.consents = newConsents;
    return user;
}

#pragma mark - Refetch User Profile Methods
#pragma mark -

- (void)refetchUserProfileWithSuccessHandler:(JanrainServiceSuccessHandler)success failure:(JanrainServiceFailureHandler)failure {
    if (![JRCaptureData sharedCaptureData].accessToken) {
        failure([URJanrainErrorParser errorForErrorCode:DIAcesssTokenIsNil]);
    }else {
        self.successHandler = success;
        self.failureHandler = failure;
        [JRCaptureUser fetchCaptureUserFromServerForDelegate:self context:nil];
    }
}


//JR SDK Delegate Methods
- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context {
    if (self.successHandler != nil) {
      self.successHandler(fetchedUser, NO);
    }
    self.successHandler = nil;
    self.failureHandler = nil;
}


- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context {
    JanrainServiceSuccessHandler successHandler = self.successHandler;
    JanrainServiceFailureHandler failureHandler = self.failureHandler;
    self.successHandler = nil;
    self.failureHandler = nil;
    failureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
}


#pragma mark - Add Recovery Email Methods
#pragma mark -

- (void)addRecoveryEmailToMobileNumberAccount:(NSString *)recoveryEmail forUser:(JRCaptureUser *)user withSuccessHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!recoveryEmail.length) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    self.successHandler = success;
    self.failureHandler = failure;
    JRCaptureUser *newUser = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:user]];
    newUser.email = recoveryEmail;
    [JRCapture updateProfileForUserWithForm:newUser withEditProfileForm:EDIT_PROFILE_FORM delegate:self];
}


//JR SDK Delegate Methods
- (void)updateUserProfileDidSucceed {
    [self refetchUserProfileWithSuccessHandler:self.successHandler failure:self.failureHandler];
}


- (void)updateUserProfileDidFailWithError:(NSError *)error {
    self.failureHandler([URJanrainErrorParser mappedErrorForJanrainError:error]);
    self.successHandler = nil;
    self.failureHandler = nil;
}


#pragma mark - Social Login Methods
#pragma mark -

- (void)loginUsingProvider:(NSString *)provider nativeToken:(NSString *)token mergeToken:(NSString *)mergeToken withAuthenticationHandler:(JanrainServiceAuthenticationHandler)authentication
            successHandler:(JanrainServiceSuccessHandler)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!provider) {
        NSError *noProviderError = [URJanrainErrorParser errorForErrorCode:DIRegNoProviderErrorCode];
        failure(noProviderError);
    }else {
        self.provider = provider;
        self.authenticationHandler = authentication;
        self.successHandler = success;
        self.failureHandler = failure;
        if (token.length > 0) {
            [JRCapture startEngageSignInWithNativeProviderToken:provider withToken:token andTokenSecret:nil mergeToken:mergeToken withCustomInterfaceOverrides:nil forDelegate:self];
        } else {
            [JRCapture startEngageSignInDialogOnProvider:provider withCustomInterfaceOverrides:nil mergeToken:mergeToken forDelegate:self];
        }
    }
}


- (void)completeSocialLoginForProfile:(JRCaptureUser *)user registrationToken:(NSString *)token withSuccessHandler:(JanrainServiceSuccessHandler)success
                       failureHandler:(JanrainServiceFailureHandler)failure {
    if (!token || !user) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    self.successHandler = success;
    self.failureHandler = failure;
    user = [self addControlFieldForRussianUser:user];
    user = [self updatePrimaryAddressAndLanguageOfUser:user];
    [JRCapture registerNewUser:user socialRegistrationToken:token forDelegate:self];
}


//JR SDK Delegate Methods
- (void)engageAuthenticationDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider {
    self.provider = provider;
    NSString *authenticatedEmail = engageAuthInfo[@"profile"][@"email"];
    NSMutableDictionary *responseDict = [NSMutableDictionary new];
    if (provider)[responseDict setValue:provider forKey:@"provider"];
    if (authenticatedEmail)[responseDict setValue:authenticatedEmail forKey:@"email"];
    self.authenticationHandler(responseDict,nil);
}


- (void)engageAuthenticationDidCancel {
    NSError *emailVerificationError = [NSError errorWithDomain:@"engageAuthenticationDidCancel" code:DIRegAuthenticationError
                                                      userInfo:@{@"providerName":self.provider,@"errorMessage":@"engage Authentication cancelled"}];
    self.authenticationHandler(nil,emailVerificationError);
}


- (void)engageAuthenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider {
    self.authenticationHandler(nil,[URJanrainErrorParser mappedErrorForJanrainError:error]);
}


- (void)engageAuthenticationDialogDidFailToShowWithError:(NSError *)error {
    self.authenticationHandler(nil,[URJanrainErrorParser mappedErrorForJanrainError:error]);
}

#pragma mark - Traditional to Social Merge Methods
#pragma mark -

- (void)handleTraditionalToSocialMergeWithEmail:(NSString *)email password:(NSString *)password mergeToken:(NSString *)mergeToken
                                 successHandler:(JanrainServiceSuccessHandler)success
                                 failureHandler:(JanrainServiceFailureHandler)failure {
    if (!password ||!email || !mergeToken) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    self.successHandler = success;
    self.failureHandler = failure;
    [JRCapture startCaptureTraditionalSignInForUser:email withPassword:password mergeToken:mergeToken forDelegate:self];
}

#pragma mark - Helper Methods
#pragma mark -

//- (JRCaptureUser *)addPersonalConsentDataToUser:(JRCaptureUser *)jrProfile fromUser:(DIRegisterUser *)user {
//    URLaunchInput *launchInput = URSettingsWrapper.sharedInstance.launchInput;
//    if ([launchInput isPersonalConsentToBeShown] == false) {
//        return jrProfile;
//    }
//    
//    if (user.personalConsentOptIn == false) {
//        return jrProfile;
//    }
//    
//    [jrProfile setPersonalDataUsageAcceptance:[JRDateTime date]];
//    [jrProfile setPersonalDataMarketingProfiling:[JRDateTime date]];
//    [jrProfile setPersonalDataTransferAcceptance:[JRDateTime date]];
//    
//    return jrProfile;
//}



- (JRCaptureUser *)addControlFieldForRussianUser:(JRCaptureUser *)jrProfile {
    if ([[URSettingsWrapper sharedInstance].countryCode isEqualToString:@"RU"]) {
        JRControlFields *controlField = [[JRControlFields alloc] init];
        controlField.one = @"TRUE";
        JRJanrain *janrain = [[JRJanrain alloc]init];
        janrain.controlFields = controlField;
        [jrProfile setJanrain:janrain];
    }
    return jrProfile;
}

- (JRCaptureUser *)updatePrimaryAddressAndLanguageOfUser:(JRCaptureUser *)jrProfile {
    JRPrimaryAddress *addressElement = [JRPrimaryAddress primaryAddress];
    NSString *countryCode = [[URSettingsWrapper sharedInstance] countryCode];
    addressElement.country = countryCode;
    [jrProfile setPrimaryAddress:addressElement];
    [jrProfile setPreferredLanguage:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
    return jrProfile;
}

#pragma mark - Custom Methods to call APIs outside JR SDK
#pragma mark -

- (void)resetPasswordForEmail:(NSString *)email withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!email) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }else {
        NSURLRequest *request = [self.janrainRequestFormatter resetPasswordRequestForEmail:email];
        [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *serverError) {
            [self handleJanrainResponse:response data:data error:serverError withSuccessHandler:success failureHandler:failure];
        }];
    }
}


- (void)activateAccountWithVerificationCode:(NSString *)code forUUID:(NSString *)uuid withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!uuid || !code) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    NSURLRequest *request = [self.janrainRequestFormatter accountActivationRequestForUUID:uuid verificationCode:code];
    [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *serverError) {
        [self handleJanrainResponse:response data:data error:serverError withSuccessHandler:success failureHandler:failure];
    }];
}


- (void)updateMobileNumber:(NSString *)mobileNumber withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!mobileNumber) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    NSURLRequest *request = [self.janrainRequestFormatter updateMobileNumberRequest:mobileNumber];
    [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *serverError) {
        [self handleJanrainResponse:response data:data error:serverError withSuccessHandler:success failureHandler:failure];
    }];
}


- (void)handleJanrainResponse:(id)response data:(NSData *)data error:(NSError *)serverError withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (serverError && ![serverError isKindOfClass:[NSNull class]]) {
        failure([URJanrainErrorParser mappedErrorForJanrainError:serverError]);
    } else {
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError) {
            failure([URJanrainErrorParser mappedErrorForJanrainError:jsonError]);
        } else if (([jsonDictionary[@"stat"] isEqualToString:@"ok"])){
            success();
        } else {
            NSError *error = [NSError errorWithDomain:@"Janrain" code:JRCaptureLocalApidErrorInvalidArgument userInfo:jsonDictionary];
            failure([URJanrainErrorParser mappedErrorForJanrainError:error]);
        }
    }
}


- (void)resendVerificationCodeForMobileNumber:(NSString *)mobileNumber withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!mobileNumber) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    NSURLRequest *request = [self.janrainRequestFormatter resendVerificationCodeRequestForMobile:mobileNumber];
    [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *serverError) {
        [self handleURXResponse:response data:data error:serverError withSuccessHandler:success failureHandler:failure];
    }];
}


- (void)resetPasswordForMobileNumber:(NSString *)mobileNumber withSuccessHandler:(void(^)(NSString *token))success failureHandler:(JanrainServiceFailureHandler)failure {
    if (!mobileNumber) {
        failure([URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
        return;
    }
    NSURLRequest *request = [self.janrainRequestFormatter resetPasswordRequestForMobileNumber:mobileNumber];
    [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *serverError) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        NSError *mappedError;
        NSDictionary *result = [URURXErrorParser mappedErrorForURXResponseData:data statusCode:statusCode serverError:serverError error:&mappedError];
        if (mappedError) {
            failure(mappedError);
        } else {
            success(result[@"payload"][@"token"]);
        }
    }];
}


- (void)handleURXResponse:(id)response data:(NSData *)data error:(NSError *)serverError withSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    NSError *mappedError;
    [URURXErrorParser mappedErrorForURXResponseData:data statusCode:statusCode serverError:serverError error:&mappedError];
    if (mappedError) {
        failure(mappedError);
    } else {
        success();
    }
}
@end
