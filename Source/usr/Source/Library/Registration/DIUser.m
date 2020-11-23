//
//  DIUser.m
//  DIUser
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIUser+PrivateData.h"
#import "JREngage.h"
#import "JRCaptureUser+Storage.h"
#import "DIConstants.h"
#import "URSettingsWrapper.h"
#import "DILogger.h"
#import "RegistrationUtility.h"
#import "URErrorAppTaggingUtility.h"
#import "URRSAEncryptor.h"
#import "RegistrationAnalyticsConstants.h"
#import "URHSDPErrorParser.h"

static DIUser *userRegistrationHandler;

@interface DIUser ()

@property (nonatomic, strong, nullable)    dispatch_semaphore_t jrSemaphore;
@property (nonatomic, strong, nullable)    dispatch_semaphore_t hsdpSemaphore;
@property (nonatomic, strong, nullable)    dispatch_queue_t refreshQueue;
@property (nonatomic, strong, nullable)    NSError *jrError;
@property (nonatomic, strong, nullable)    NSError *hsdpError;
@property (nonatomic, strong, nullable)    NSBlockOperation *refreshOperation;
@property (nonatomic,strong) URPersonalConsentHandler *personalConsentHandler;
@end

@implementation DIUser

+ (instancetype)getInstance {
    @synchronized(self) {
        if (userRegistrationHandler == nil) {
            userRegistrationHandler = [[self alloc]init];
        }
    }
    return userRegistrationHandler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if([FBSDKLoginHandler isNativeFBLoginAvailable]) {
            _fbLoginHandler = [[FBSDKLoginHandler alloc] init];
        }
        [self storePersonalConsentForAppUpatedUsers];
        [self fetchPreviousStoredUserAndClearIfNeeded];
        
        _userRegistrationListeners  = [NSHashTable weakObjectsHashTable];
        _userDetailsListeners       = [NSHashTable weakObjectsHashTable];
        _sessionRefreshListeners    = [NSHashTable weakObjectsHashTable];
        _userDataInterfaceListeners = [NSHashTable weakObjectsHashTable];
        _hsdpUserDataInterfaceListeners = [NSHashTable weakObjectsHashTable];
        _serviceDiscoveryWrapper    = [[URServiceDiscoveryWrapper alloc] initWithServiceDiscovery:[URSettingsWrapper sharedInstance].dependencies.appInfra.serviceDiscovery];
        self.personalConsentHandler = [[URPersonalConsentHandler alloc] init];
        _suspendableWaitingQueue = dispatch_queue_create("suspendableWaitingQueue", DISPATCH_QUEUE_CONCURRENT);
        [self countryCodeWithCompletion:^(NSString *countryCode, NSError *error) {}];
    }
    return self;
}


- (NSOperationQueue *)suspendableUpdateQueue {
    if (!_suspendableUpdateQueue) {
        _suspendableUpdateQueue = [[NSOperationQueue alloc] init];
        _suspendableUpdateQueue.maxConcurrentOperationCount = 1;
    }
    return _suspendableUpdateQueue;
}


- (URGoogleLoginHandler *)googleLoginHandler {
    if (!self->_googleLoginHandler) {
        NSString *clientId = [RegistrationUtility configValueForKey:GooglePlusClientId countryCode:nil error:nil];;
        NSString *redirectURI = [RegistrationUtility configValueForKey:GooglePlusRedirectUri countryCode:nil error:nil];
        if (clientId.length <= 0 || redirectURI.length <= 0) {
            return nil;
        }
        self->_googleLoginHandler = [[URGoogleLoginHandler alloc] initWithClientId:clientId redirectURI:redirectURI];
    }
    return self->_googleLoginHandler;
}

-(URAppleSignInHandler *)appleSignInHandler  API_AVAILABLE(ios(13)) {
    if (!self->_appleSignInHandler) {
        self->_appleSignInHandler = [[URAppleSignInHandler alloc] init];
    }
    return self->_appleSignInHandler;
}

#pragma mark - Country Selection Methods
#pragma mark - 

- (void)countryCodeWithCompletion:(void(^)(NSString *countryCode, NSError *error))completion {
    dispatch_async(self.suspendableWaitingQueue, ^{
        if ([URSettingsWrapper sharedInstance].countryCode && self.janrainService) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{completion([URSettingsWrapper sharedInstance].countryCode, nil);}];
        } else {
            [self downloadCountryDetailsWithCompletion:completion];
        }
    });
}


- (void)downloadCountryDetailsWithCompletion:(void(^)(NSString *countryCode, NSError *error))completion {
    self.isCompleteFlowDownloaded = NO;
    dispatch_suspend(self.suspendableWaitingQueue);
    [self.serviceDiscoveryWrapper getHomeCountryWithCompletion:^(NSString *receivedCountryCode, NSString *locale, NSDictionary *serviceURLs, NSError *serviceDiscoveryError) {
        [self initializeSettingForCountryCode:receivedCountryCode locale:locale serviceURLs:serviceURLs error:serviceDiscoveryError withCompletion:^(NSError *initializationError) {
            completion(receivedCountryCode, initializationError);
        }];
    }];
}


- (void)updateCountry:(NSString *)country withCompletion:(void(^)(NSError *error))completionHandler {
    dispatch_async(self.suspendableWaitingQueue, ^{
        [self updateCountry:country andDownloadDetailsWithCompletion:completionHandler];
    });
}


- (void)updateCountry:(NSString *)country andDownloadDetailsWithCompletion:(void(^)(NSError *error))completionHandler {
    self.isCompleteFlowDownloaded = NO;
    dispatch_suspend(self.suspendableWaitingQueue);
    __weak typeof(self) weakSelf = self;
    [self.serviceDiscoveryWrapper setHomeCountry:country withCompletion:^(NSString *locale, NSDictionary *serviceURLs, NSError *error) {
        [weakSelf initializeSettingForCountryCode:country locale:locale serviceURLs:serviceURLs error:error withCompletion:^(NSError *initializationError) {
            completionHandler(initializationError);
        }];
    }];
}


- (void)initializeSettingForCountryCode:(NSString *)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs
                                  error:(NSError *)error withCompletion:(void(^)(NSError *error))completion {
    if (error || serviceURLs.count == 0) {
        DIRErrorLog(@"%@", error ? [RegistrationUtility getURFormattedLogError:error withDomain:@"ServiceDiscovery"]:[serviceURLs description]);
        dispatch_resume([DIUser getInstance].suspendableWaitingQueue);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{completion(error);}];
    } else {
        DIRDebugLog(@"Service urls:%@", [serviceURLs description]);
        [URSettingsWrapper sharedInstance].countryCode = countryCode;
        [URSettingsWrapper sharedInstance].serviceURLs = serviceURLs;
        if (serviceURLs[kURXSMSVerificationURLKey]) {
            [URSettingsWrapper sharedInstance].loginFlowType = RegistrationLoginFlowTypeMobile;
        }else {
            [URSettingsWrapper sharedInstance].loginFlowType = RegistrationLoginFlowTypeEmail;
        }
        [[URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration loadCountrySpecificConfigurationsForCountryCode:countryCode serviceURLs:serviceURLs];
        _locale = locale;
        _hsdpService = [[HSDPService alloc] initWithCountryCode:countryCode baseURL:serviceURLs[kHSDPBaseURLKey]];
        _janrainService = [[JanrainService alloc] init];
        [_janrainService downloadConfigurationForCountryCode:countryCode locale:locale serviceURLs:serviceURLs completion:^(NSError *flowDownloadError) {
            if (!flowDownloadError) {
                self.isCompleteFlowDownloaded = YES;
            } else {
                self.janrainService = nil;
                self.hsdpService = nil;
                [URSettingsWrapper sharedInstance].countryCode = nil;
                [URSettingsWrapper sharedInstance].serviceURLs = nil;
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{completion(flowDownloadError);}];
            dispatch_resume(self.suspendableWaitingQueue);
        }];
    }
}


- (void)checkIfJanrainFlowDownloadedWithCompletion:(void(^)(NSError *flowDownloadError))completion {
    if (self.isCompleteFlowDownloaded) {
        DIRInfoLog(@"janrain flow download completed");
        completion(nil);
    } else {
        [self countryCodeWithCompletion:^(NSString * _Nullable countryCode, NSError * _Nullable error) {
            completion(error);
        }];
    }
}

#pragma mark - Listeners Handling Method
#pragma mark - 

- (void)addUserRegistrationListener:(nonnull id<UserRegistrationDelegate, JanrainFlowDownloadDelegate>)listener {
    if ([self.userRegistrationListeners containsObject:listener]) {
        return;
    }
    NSAssert(listener != nil, @"User Registration listener can not be nill");
    [self.userRegistrationListeners addObject:listener];
}


- (void)addUserDetailsListener:(nonnull id<UserDetailsDelegate>)listener {
    if ([self.userDetailsListeners containsObject:listener]) {
        return;
    }
    NSAssert(listener != nil, @"User Details listener can not be nill");
    [self.userDetailsListeners addObject:listener];
}


- (void)addSessionRefreshListener:(nonnull id<SessionRefreshDelegate>)listener {
    if ([self.sessionRefreshListeners containsObject:listener]) {
        return;
    }
    NSAssert(listener != nil, @"Session Refresh listener can not be nill");
    [self.sessionRefreshListeners addObject:listener];
}


- (void)removeUserRegistrationListener:(nullable id<UserRegistrationDelegate, JanrainFlowDownloadDelegate>)listener {
    if ([self.userRegistrationListeners containsObject:listener]) {
        [self.userRegistrationListeners removeObject:listener];
    }
}


- (void)removeUserDetailsListener:(nullable id<UserDetailsDelegate>)listener {
    if ([self.userDetailsListeners containsObject:listener]) {
        [self.userDetailsListeners removeObject:listener];
    }
}


- (void)removeSessionRefreshListener:(nullable id<SessionRefreshDelegate>)listener {
    if ([self.sessionRefreshListeners containsObject:listener]) {
        [self.sessionRefreshListeners removeObject:listener];
    }
}


- (void)sendMessage:(nonnull SEL)selector toListeners:(nonnull NSHashTable *)listeners withObject:(nullable id)object1 andObject:(nullable id)object2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSUInteger count = 0;
    @try {
        for (id listener in listeners) {
            if (listener && [listener respondsToSelector:selector]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [listener performSelector:selector withObject:object1 withObject:object2]; }];
            }
            count++;
        }
    } @catch(NSException *exception) {
        for (NSUInteger i = count; i < listeners.allObjects.count; i++) {
            id listener = listeners.allObjects[i];
            if (listener && [listener respondsToSelector:selector]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [listener performSelector:selector withObject:object1 withObject:object2]; }];
            }
        }
    }
    if (self.suspendableUpdateQueue.isSuspended) {
        self.suspendableUpdateQueue.suspended = NO;
    }
#pragma clang diagnostic pop
}

#pragma mark - Session Handling Methods
#pragma mark -

- (void)logoutUserUpdate:(NSError *)error {
    if (error) {
        [self sendMessage:@selector(logoutFailedWithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
        [self sendMessage:@selector(logoutSessionFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
    }else {
        [self clearUserData];
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegLogoutSuccess];
        [self sendMessage:@selector(logoutDidSucceed) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
        [self sendMessage:@selector(logoutSessionSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
    }
}


- (void)logout {
    [self.suspendableUpdateQueue addOperationWithBlock:^{
        self.suspendableUpdateQueue.suspended = YES;
        [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
            if (!flowDownloadError) {
                if (self.hsdpAccessToken && self.hsdpUUID && self.hsdpService) {
                    [self.hsdpService logoutUserWithUUID:self.hsdpUUID accessToken:self.hsdpAccessToken completion:^(NSError *error) {
                        if ([error.userInfo[@"responseCode"] integerValue] == 1009) {
                            [self logoutUserUpdate:nil];
                        }else {
                            [self logoutUserUpdate:error];
                        }
                    }];
                } else {
                    [self logoutUserUpdate:nil];
                }
            } else {
                [self logoutUserUpdate:flowDownloadError];
            }
        }];
    }];
}


- (void)refreshLoginSession {
    @synchronized (self) {
        if (self.userLoggedInState <= UserLoggedInStatePendingTnC) {
            [self sendMessage:@selector(loginSessionRefreshFailedWithError:) toListeners:self.sessionRefreshListeners
            withObject:[URBaseErrorParser userNotLoggedInError] andObject:nil];
            return;
        }

        if ([self isAnyRefreshCallRunning] == true) {
            return;
        }
        
        self.refreshOperation = [NSBlockOperation blockOperationWithBlock: ^ {
            [self refreshLoginSessionOverSuspendableQueue];
        }];
        
        [self.suspendableUpdateQueue addOperation:self.refreshOperation];
    }
}

-(void)refreshJRSession {
    dispatch_async(self.refreshQueue, ^{
        [self.janrainService refreshAccessTokenWithSuccessHandler:^{
            dispatch_semaphore_signal(self.jrSemaphore);
        } failureHandler:^(NSError *error) {
            self.jrError = error;
            dispatch_semaphore_signal(self.jrSemaphore);
        }];
    });
}

-(BOOL)isAnyRefreshCallRunning {
    return (self.refreshOperation != nil);
}

-(void)refreshHSDPSession {
    @synchronized (self) {
        if ([self isAnyRefreshCallRunning] == true) {
            return;
        }
        self.refreshOperation = [NSBlockOperation blockOperationWithBlock: ^ {
            self.suspendableUpdateQueue.suspended = YES;
            [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
                if (flowDownloadError) {
                    [self sendMessage:@selector(refreshHSDPSessionFailed:) toListeners:self.hsdpUserDataInterfaceListeners withObject:flowDownloadError andObject:nil];
                    return;
                }
                
                [self initiateRefreshQueuesAndSemaphores];
                self.jrError = nil;
                //Janrain refresh will not be called hence release semaphore.
                dispatch_semaphore_signal(self.jrSemaphore);
                //If hsdp is not available.
                if (self.hsdpService == nil) {
                    self.hsdpError = [URHSDPErrorParser errorForErrorCode:DIHsdpStateNotConfiguredForCountry];
                }
                [self startRefreshHSDPSession];
                //intentionally made false to facilitate callback to listener who calls refresh JR session while HSDP is going on.
                [self handleJRAndHSDPErrors:false];
            }];
        }];
         
        [self.suspendableUpdateQueue addOperation:self.refreshOperation];
    }
}

-(void)startRefreshHSDPSession {
    dispatch_async(self.refreshQueue, ^{
        if (!self.hsdpService || ([self.hsdpUser isSignedIn] == false)) {
            dispatch_semaphore_signal(self.hsdpSemaphore);
            return;
        }
            if (self.hsdpUser.refreshToken) {
                [self.hsdpService refreshSessionForUUID:self.hsdpUUID refreshToken:self.hsdpUser.refreshToken completion:^(HSDPUser *user, NSError *error) {
                    [self handleHSDPResponse:user andError:error];
                }];
            } else {
                [self.hsdpService refreshSessionForUUID:self.hsdpUUID accessToken:self.hsdpUser.accessToken refreshSecret:self.hsdpUser.refreshSecret completion:^(HSDPUser *user, NSError *error) {
                    [self handleHSDPResponse:user andError:error];
                }];
            }
    });
}

-(void)handleHSDPResponse:(HSDPUser *)user andError:(NSError *)error {
    self.hsdpError = error;
    if (!error && user) {
        [self storeHSDPUser:user];
    }
    if (self.hsdpSemaphore != nil) {
        dispatch_semaphore_signal(self.hsdpSemaphore);
    }
}

-(void)handleJRAndHSDPErrors:(BOOL)isHSDPRefreshOnly {
    __block BOOL wasNetworkTimeSynchronized = [DIRegistrationAppTime isSynchronized];
    __block NSUInteger utcDate = [[DIRegistrationAppTime getUTCTime] timeIntervalSinceReferenceDate];
    __block NSUInteger deviceDate = [[NSDate date] timeIntervalSinceReferenceDate];
    __block NSInteger timeDifference = deviceDate - utcDate;
    __block BOOL refreshHSDPOnly = isHSDPRefreshOnly;
    dispatch_async(self.refreshQueue, ^{
        //Wait both operations to close
        dispatch_semaphore_wait(self.jrSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.hsdpSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.jrError || self.hsdpError) {
            if ([self.hsdpError.userInfo[@"responseCode"] integerValue] == 1151 || (self.jrError.code == 3413 && wasNetworkTimeSynchronized)) {
                NSInteger errorCode = 1151;
                NSString *domain = @"HSDP";
                if (self.jrError && self.jrError.code == 3413) {
                    errorCode = 3413;
                    domain = @"Janrain";
                }
                [URErrorAppTaggingUtility tagForcelogoutWithDomain:domain errorCode:errorCode timeDifference:timeDifference wasNetworkTimeSynchronized:wasNetworkTimeSynchronized];
                [self clearUserData];
                 if (refreshHSDPOnly == false) {
                     [self sendMessage:@selector(loginSessionRefreshFailedAndLoggedout) toListeners:self.sessionRefreshListeners
                       withObject:nil andObject:nil];
                     [self sendMessage:@selector(forcedLogout) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
                 }
                [self sendMessage:@selector(hsdpUserSessionInvalid:) toListeners:self.hsdpUserDataInterfaceListeners withObject:self.hsdpError andObject:nil];
            } else {
                if (refreshHSDPOnly == false) {
                    [self sendMessage:@selector(loginSessionRefreshFailedWithError:) toListeners:self.sessionRefreshListeners
                       withObject:(self.jrError != nil ? self.jrError : self.hsdpError) andObject:nil];
                    [self sendMessage:@selector(refreshSessionFailed:) toListeners:self.userDataInterfaceListeners withObject:(self.jrError != nil ? self.jrError : self.hsdpError) andObject:nil];
                }
                [self sendMessage:@selector(refreshHSDPSessionFailed:) toListeners:self.hsdpUserDataInterfaceListeners withObject:self.hsdpError andObject:nil];
            }
        } else {
            if (refreshHSDPOnly == false) {
                [self sendMessage:@selector(loginSessionRefreshSucceed) toListeners:self.sessionRefreshListeners withObject:nil andObject:nil];
                [self sendMessage:@selector(refreshSessionSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
            }
            [self sendMessage:@selector(refreshHSDPSessionSucceed) toListeners:self.hsdpUserDataInterfaceListeners withObject:nil andObject:nil];
        }
        //Release all unwanted objects
        self.jrError = nil;
        self.hsdpError = nil;
        self.jrSemaphore = nil;
        self.hsdpSemaphore = nil;
        self.refreshQueue = nil;
        self.refreshOperation = nil;
    });});
}


-(void)initiateRefreshQueuesAndSemaphores {
    self.jrSemaphore = dispatch_semaphore_create(0);
    self.hsdpSemaphore = dispatch_semaphore_create(0);
    self.refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}


- (void)refreshLoginSessionOverSuspendableQueue {
    @synchronized (self) {
        self.suspendableUpdateQueue.suspended = YES;
        [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
            if (flowDownloadError) {
                [self sendMessage:@selector(loginSessionRefreshFailedWithError:) toListeners:self.sessionRefreshListeners withObject:flowDownloadError andObject:nil];
                [self sendMessage:@selector(refreshSessionFailed:) toListeners:self.userDataInterfaceListeners withObject:flowDownloadError andObject:nil];
                return;
            }
            
            [self initiateRefreshQueuesAndSemaphores];
            [self refreshJRSession];
            [self startRefreshHSDPSession];
            [self handleJRAndHSDPErrors:false];
        }];
    }
}


- (void)refetchUserProfile {
    @synchronized (self) {
        [self.suspendableUpdateQueue addOperationWithBlock:^{
            self.suspendableUpdateQueue.suspended = YES;
            [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
                if (!flowDownloadError) {
                    [self.janrainService refetchUserProfileWithSuccessHandler:^(JRCaptureUser *jrUser, BOOL isUpdated) {
                        [self storeUserProfile:jrUser];
                        if (jrUser.isVerified && self.hsdpService && !self.hsdpUser && ![HSDPService isHSDPSkipLoadingEnabled]) {
                            //FIXME: Change the below line back to what it was before 17.5 platform release
                            //NSString *userIdentifierForHSDP = self.userProfile.email.length > 0 ? self.userProfile.email : self.userProfile.mobileNumber;
                            [self.hsdpService loginWithSocialUsingEmail:self.hsdpUserIdentifier accessToken:[JRCapture getAccessToken]
                                                          refreshSecret:[JRCaptureData sharedCaptureData].refreshSecret completion:^(HSDPUser *user, NSError *error) {
                                                              if (error) {
                                                                  [self sendMessage:@selector(didUserInfoFetchingFailedWithError:) toListeners:self.userDetailsListeners withObject:error andObject:nil];
                                                                  [self sendMessage:@selector(refetchUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
                                                              } else {
                                                                  [self storeHSDPUser:user];
                                                                  [self sendMessage:@selector(didUserInfoFetchingSuccessWithUser:) toListeners:self.userDetailsListeners withObject:self andObject:nil];
                                                                  [self sendMessage:@selector(refetchUserDetailsSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
                                                              }
                                                          }];
                        } else {
                            [self sendMessage:@selector(didUserInfoFetchingSuccessWithUser:) toListeners:self.userDetailsListeners withObject:self andObject:nil];
                            [self sendMessage:@selector(refetchUserDetailsSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
                        }
                    } failure:^(NSError *error) {
                        if (error.code == DISessionExpiredErrorCode) {
                            [self.janrainService refreshAccessTokenWithSuccessHandler:^{//If janrain token has expired, HSDP token should also have been expired. Both should be refreshed and not a single one. Calling refreshUserSession is a better option here.
                                self.suspendableUpdateQueue.suspended = NO;
                                [self refetchUserProfile];
                            } failureHandler:^(NSError *refreshAccessTokenerror) {
                                [self sendMessage:@selector(didUserInfoFetchingFailedWithError:) toListeners:self.userDetailsListeners withObject:refreshAccessTokenerror andObject:nil];
                                [self sendMessage:@selector(refetchUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:refreshAccessTokenerror andObject:nil];
                            }];
                        } else {
                            [self sendMessage:@selector(didUserInfoFetchingFailedWithError:) toListeners:self.userDetailsListeners withObject:error andObject:nil];
                            [self sendMessage:@selector(refetchUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
                        }
                    }];
                } else {
                    [self sendMessage:@selector(didUserInfoFetchingFailedWithError:) toListeners:self.userDetailsListeners withObject:flowDownloadError andObject:nil];
                    [self sendMessage:@selector(refetchUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:flowDownloadError andObject:nil];
                }
            }];
        }];
    }
}

#pragma mark - Update Profile
#pragma mark - 

- (void)updateUserConsent:(BOOL)accepted withCompletion:(void(^)(NSError *error))completion {
    [self.janrainService updateCOPPAConsentAcceptance:accepted forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [self storeUserProfile:user];
        completion(nil);
    } failureHandler:^(NSError *error) {
        if (error.code == DISessionExpiredErrorCode) {
            [self.janrainService refreshAccessTokenWithSuccessHandler:^{//Only HSDP token in refreshed while in ideal case both should be refreshed. What is lifetime of HSDP token and how does it compare to Janrain token?
                [self updateUserConsent:accepted withCompletion:completion];
            } failureHandler:^(NSError *refreshAccessTokenerror) {
                completion(refreshAccessTokenerror);
            }];
        }else{
            completion(error);
        }
    }];
}

- (void)updateUserConsentApproval:(BOOL)accepted withCompletion:(void(^)(NSError *error))completion {
    [self.janrainService updateCOPPAConsentApproval:accepted forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [self storeUserProfile:user];
        completion(nil);
    } failureHandler:^(NSError *error) {
        if (error.code == DISessionExpiredErrorCode) {
            [self.janrainService refreshAccessTokenWithSuccessHandler:^{//Only HSDP token in refreshed while in ideal case both should be refreshed. What is lifetime of HSDP token and how does it compare to Janrain token?
                [self updateUserConsentApproval:accepted withCompletion:completion];
            } failureHandler:^(NSError *refreshAccessTokenerror) {
                completion(refreshAccessTokenerror);
            }];
        }else{
            completion(error);
        }
    }];
}


- (void)replaceConsumerInterest:(NSArray *)newElements {
    [self.janrainService replaceConsumerInterests:newElements forUser:self.userProfile withSuccessHandler:^{//Session expiration is not handled.
        [self sendMessage:@selector(didUpdateSuccess) toListeners:self.userDetailsListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userDetailsListeners withObject:error andObject:nil];
    }];
}


- (void)updateReciveMarketingEmail:(BOOL)reciveMarketingMails {
    [self.suspendableUpdateQueue addOperationWithBlock:^{
        self.suspendableUpdateQueue.suspended = YES;
        [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
            if (!flowDownloadError) {
                JRMarketingOptIn *marketingOptin = [[JRMarketingOptIn alloc] init];
                marketingOptin.locale = self.locale;
                marketingOptin.timestamp = [DIRegistrationAppTime getUTCTime];
                NSDictionary *fields = @{@"receiveMarketingEmail": @(reciveMarketingMails),
                                         @"marketingOptIn": marketingOptin
                                         };
                [self.janrainService updateFields:fields forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                    [self storeUserProfile:user];
                    [self sendMessage:@selector(didUpdateSuccess) toListeners:self.userDetailsListeners withObject:nil andObject:nil];
                    [self sendMessage:@selector(updateUserDetailsSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
                } failureHandler:^(NSError *error) {
                    [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userDetailsListeners withObject:error andObject:nil];
                    [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
                }];
            } else {
                [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userDetailsListeners withObject:flowDownloadError andObject:nil];
                [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:flowDownloadError andObject:nil];
            }
        }];
    }];
}


- (void)updateGender:(UserGender)gender withBirthday:(NSDate *)birthday {
    [self.suspendableUpdateQueue addOperationWithBlock:^{
        self.suspendableUpdateQueue.suspended = YES;
        [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
            if (!flowDownloadError) {
                NSMutableDictionary *fields = [[NSMutableDictionary alloc] initWithCapacity:2];
                if (gender == UserGenderMale) {
                    fields[@"gender"] = @"Male";
                } else if (gender == UserGenderFemale) {
                    fields[@"gender"] = @"Female";
                }
                if (self.userProfile.birthday != birthday) {
                    fields[@"birthday"] = birthday;
                }
                [self.janrainService updateFields:fields forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                    [self storeUserProfile:user];
                    [self sendMessage:@selector(didUpdateSuccess) toListeners:self.userDetailsListeners withObject:nil andObject:nil];
                } failureHandler:^(NSError *error) {
                    [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userDetailsListeners withObject:error andObject:nil];
                }];
            } else {
                [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userDetailsListeners withObject:flowDownloadError andObject:nil];
            }
        }];
    }];
}


- (void)updateMobileNumber:(NSString *)mobileNumber {
    [self.janrainService updateMobileNumber:mobileNumber withSuccessHandler:^{
        [self sendMessage:@selector(didUpdateSuccess) toListeners:self.userDetailsListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        if (error.code == DISessionExpiredErrorCode) {
            [self.janrainService refreshAccessTokenWithSuccessHandler:^{
                [self updateMobileNumber:mobileNumber];
            } failureHandler:^(NSError *refreshAccessTokenerror) {
                [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
            }];
        } else {
            [self sendMessage:@selector(didUpdateFailedWithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
        }
    }];
}


- (void)addRecoveryEmailToMobileNumberAccount:(NSString *)recoveryEmail {
    __weak typeof(self) weakObject = self;
    [self.janrainService addRecoveryEmailToMobileNumberAccount:recoveryEmail forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [weakObject storeUserProfile:user];
        [weakObject sendMessage:@selector(didUpdateSuccess) toListeners:weakObject.userDetailsListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        if (error.code == DISessionExpiredErrorCode) {
            [weakObject.janrainService refreshAccessTokenWithSuccessHandler:^{
                [weakObject addRecoveryEmailToMobileNumberAccount:recoveryEmail];
            } failureHandler:^(NSError *refreshAccessTokenerror) {
                [weakObject sendMessage:@selector(didUpdateFailedWithError:) toListeners:weakObject.userRegistrationListeners withObject:error andObject:nil];
            }];
        } else {
            [weakObject sendMessage:@selector(didUpdateFailedWithError:) toListeners:weakObject.userDetailsListeners withObject:error andObject:nil];
        }
    }];
}


#pragma mark - Published property accessors
#pragma mark -


- (NSString *)userIdentifier {
    return ((self.userProfile.mobileNumber != nil) && (self.userProfile.mobileNumber.length > 0)) ? self.userProfile.mobileNumber : self.userProfile.email;
}


- (NSString *)hsdpUserIdentifier {
    return (self.userProfile.email.length > 0) ? self.userProfile.email : self.userProfile.mobileNumber;
}


- (NSString *)email {
    return self.userProfile.email;
}


- (NSString *)mobileNumber {
    return self.userProfile.mobileNumber;
}


- (NSString *)givenName {
    return self.userProfile.givenName;
}


- (NSString *)familyName {
    return self.userProfile.familyName;
}


- (BOOL)receiveMarketingEmails {
    return [self.userProfile getReceiveMarketingEmailBoolValue];
}

-(NSDate *)marketingConsentTimestamp {
    return  self.userProfile.marketingOptIn.timestamp;
}

- (BOOL)isVerified {
    if (self.userProfile.mobileNumber && self.userProfile.mobileNumberVerified != nil) {
        return true;
    }
    if (self.userProfile.email && self.userProfile.emailVerified != nil) {
        return true;
    }
    return false;
}


- (BOOL)isEmailVerified {
    return self.userProfile.emailVerified != nil;
}


- (BOOL)isMobileNumberVerified {
    return (self.userProfile.mobileNumberVerified != nil);
}


- (BOOL)isOlderThanAgeLimit {
    return [self.userProfile getOlderThanAgeLimitBoolValue];
}


- (NSArray *)consumerInterests {
    return self.userProfile.consumerInterests;
}


- (NSArray *)consents {
    return self.userProfile.consents;
}


- (NSString *)language {
    return self.userProfile.preferredLanguage;
}


- (NSString *)country {
    return self.userProfile.primaryAddress.country;
}


- (NSDate *)birthday {
    return self.userProfile.birthday;
}


- (UserGender)gender {
    if (self.userProfile.gender == nil) {
        return UserGenderNone;
    } else if ([self.userProfile.gender caseInsensitiveCompare:@"Male"] == NSOrderedSame) {
        return UserGenderMale;
    } else if ([self.userProfile.gender caseInsensitiveCompare:@"Female"] == NSOrderedSame) {
        return UserGenderFemale;
    }
    return UserGenderNone;
}


- (BOOL)isLoggedIn {
    return ([self userLoggedInState] == UserLoggedInStateUserLoggedIn);
}


- (UserLoggedInState)userLoggedInState {
    if (!self.userProfile || ![JRCapture getAccessToken] || !self.userProfile.uuid) {
        DIRErrorLog(@"Janrain user not logged in");
        [RegistrationUtility removePersonalConsentForUser];
        return UserLoggedInStateUserNotLoggedIn;
    }
    if ((self.userProfile.mobileNumber != nil && self.userProfile.mobileNumberVerified == nil) || ((self.userProfile.mobileNumber == nil) && (self.userProfile.email != nil) && self.userProfile.emailVerified == nil)) {
        DIRWarningLog(@"User account profile not verified");
        return UserLoggedInStatePendingVerification;
    }
    if (![self hasAcceptedTermsAndConditions]) {
        DIRWarningLog(@"T&C not accepted");
        return UserLoggedInStatePendingTnC;
    }
    if ([HSDPService isHSDPConfigurationAvailableForCountry:[URSettingsWrapper sharedInstance].countryCode] && ![self.hsdpUser isSignedIn]) {
        DIRErrorLog(@"Janrain user info is available but HSDP user info not available");
        return UserLoggedInStatePendingHSDPLogin;
    }
    //Clearing user data if he is not provided personal consent.
    if ([self isPersonalConsentRequiredAndNotProvided]) {
        DIRErrorLog(@"Janrain user not provided personal consent");
        [self clearUserData];
        [URErrorAppTaggingUtility tagClearUserData:DIClearUserDataPersonalConsentNotProvided errorMessage:kRegClearUserDataPersonalConsentNotProvided errorType:kRegUserError];
        return UserLoggedInStateUserNotLoggedIn;
    }
    
    return UserLoggedInStateUserLoggedIn;
}

    
- (void)authorizeWithHSDPWithCompletion:(void(^)(BOOL success, NSError *error))completion{
    NSInteger state = [self hsdpConfigurationState];
    if (state == DIHsdpStateNotSignedIn) {
        [self performHSDPSignIn:completion];
    } else {
        return completion(false, [URHSDPErrorParser errorForErrorCode:state]);
    }
}


-(void)performHSDPSignIn:(void(^)(BOOL success, NSError *error))completion {
    NSString *accessToken = [NSString stringWithFormat:@"%@",[JRCapture getAccessToken]];
    
    // HSDP service is nil will return the error code.
    if (self.hsdpService == nil) {
        return  completion(false, [URHSDPErrorParser errorForErrorCode:DINetworkErrorCode]);;
    }
    
    [self.hsdpService loginWithSocialUsingEmail:self.hsdpUserIdentifier accessToken:accessToken refreshSecret:[JRCaptureData sharedCaptureData].refreshSecret
     completion:^(HSDPUser *user, NSError *error) {
         if (error) {
             return completion(false, error);
         } else {
             [self storeHSDPUser:user];
             return completion(true, nil);
         }
     }];
}


- (NSInteger)hsdpConfigurationState {
    if (!self.userProfile || ![JRCapture getAccessToken] || !self.userProfile.uuid) {
        DIRErrorLog(@"Janrain user not logged in");
        return DIHsdpStateJanrainNotSignedIn;
    }
    if (![HSDPService isHSDPConfigurationAvailableForCountry:[URSettingsWrapper sharedInstance].countryCode]) {
        DIRErrorLog(@"Janrain user info is available but HSDP user info not available");
        return DIHsdpStateNotConfiguredForCountry;
    }
    if ([self.hsdpUser isSignedIn]) {
        DIRErrorLog(@"HSDP Already Signed In");
        return DIHsdpStateAlreadySignedIn;
    }
    return DIHsdpStateNotSignedIn;
}
    
    
- (BOOL)hasAcceptedTermsAndConditions {
    if (![URSettingsWrapper sharedInstance].isTermsAndConditionsRequired) {
        return YES;
    }
    return [RegistrationUtility hasUserAcceptedTermsnConditions:self.userProfile.userIdentifier];
}


- (NSArray *)getConsumerInterestForUser:(NSString *)key {
    if (!key) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicCommunicationKey MATCHES %@", key];
    NSArray *filteredArray = [_userProfile.consumerInterests filteredArrayUsingPredicate:predicate];
    return filteredArray;
}

#pragma mark - Utility Methods
#pragma mark

- (void)storeUserProfile:(JRCaptureUser *)newCaptureUser {
    @synchronized (self) {
        self.userProfile = newCaptureUser;
        self.userProfile.password = nil;
        [self.userProfile saveCurrentInstance];
    }
}


- (void)storeHSDPUser:(HSDPUser *)user {
    self.hsdpUser = user;
    [self.hsdpUser saveCurrentInstance];
}


- (void)fetchPreviousStoredUserAndClearIfNeeded {
    if ([self isPreviousStoredUserDataAvailable]) {
        /*Tagging hsdp uuid on intitilizing UR platform component. This tagging we are doing while hsdp initialization at the first time also.*/
        if ([[RegistrationUtility configValueForKey:HSDPUUIDUpload countryCode:nil error:nil] boolValue]) {
            NSString *secureHSDPId = [URRSAEncryptor encryptString:self.hsdpUUID withPublicKey:kHSDPSecurePubKey];
            [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegistrationUuidKey:secureHSDPId}];
        }
        if ([self userLoggedInState] <= UserLoggedInStatePendingTnC) {
            [self clearUserData];
            [URErrorAppTaggingUtility tagClearUserData:DIClearUserDataLoggedinStateNotSatisfied errorMessage:kRegClearUserDataLoggedinStateNotSatisfied errorType:kRegUserError];
        }
    }
}


- (BOOL)isPreviousStoredUserDataAvailable {
    NSError *error;
    self.userProfile = [JRCaptureUser loadPreviousInstanceWithError:&error];
    if (self.userProfile) {
        self.hsdpUser = [HSDPUser loadPreviousInstance];
        return true;
    }
    DIRDebugLog(@"LoadPreviousStored User : %@ Error : %@",self.userProfile,error.description);
    return false;
}


-(BOOL)isPersonalConsentRequiredAndNotProvided {
    //If personal consent is enabled and its not given
    BOOL isPersonalConsentRequired = [[URSettingsWrapper sharedInstance].launchInput isPersonalConsentToBeShown];
    ConsentStatus *status = [RegistrationUtility providePersonalConsentStateForUser:self.userIdentifier];
    BOOL isPersonalConsentGiven = false;
    if ((status != nil) && (status.status == ConsentStatesActive)) {
        isPersonalConsentGiven = true;
    }
    
    return ((true == isPersonalConsentRequired) && (false == isPersonalConsentGiven));
}


- (void)clearUserData {
    [self.janrainService logoutWithCompletion:^{
        DIRDebugLog(@"User data got cleared");
        mergeRegistrationToken = nil;
        [self.fbLoginHandler logout];
        [RegistrationUtility removePersonalConsentForUser];
        [self.userProfile removeCurrentInstance];
        [self.hsdpUser removeCurrentInstance];
        self.hsdpUser = nil;
        self.userProfile = nil;
    }];
}


- (void)setUserProfile:(JRCaptureUser *)userProfile {
    _userProfile = userProfile;
}

- (void)setHsdpUser:(HSDPUser *)hsdpUser {
    _hsdpUser = hsdpUser;
    [RegistrationUtility setHSDPUserUUID:hsdpUser.userUUID];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([[DIUser getInstance].googleLoginHandler application:application openURL:url options:options]) {
        return true;
    } else if ([[DIUser getInstance].fbLoginHandler application:application openURL:url options:options]) {
        return true;
    }
    return [JREngage application:application openURL:url options:options];
}

-(void)storePersonalConsentForAppUpatedUsers {
    NSString *appUpdatedKey = @"com.philips.registration.app.upgrade";
    BOOL isConsentUpdatedOnce = [[NSUserDefaults standardUserDefaults] boolForKey:appUpdatedKey];
    if (isConsentUpdatedOnce == false) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:appUpdatedKey];
        [RegistrationUtility userProvidedPersonalConsent:@"" andStatus:ConsentStatesActive];
    }
}

@end
