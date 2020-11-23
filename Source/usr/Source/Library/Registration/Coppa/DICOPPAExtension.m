//
//  DICOPPAExtension.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.


#import "DICOPPAExtension.h"
#import "JRConsentsElement.h"
#import "DIRegistrationConstants.h"
#import "DICoppaExtensionUtility.h"
#import "URCOPPAConfiguration.h"
#import "DIUser+DataInterface.h"

typedef void (^CoppaExtensionCompletionHandler)(DICOPPASTATUS status, NSError *error);

@interface DICOPPAExtension ()<UserDetailsDelegate,SessionRefreshDelegate>

@property (nonatomic, strong) DICoppaExtensionUtility *coppaExtensionUtility;
@property (nonatomic, strong) URCOPPAConfiguration *coppaConfiguration;
@property (nonatomic, strong) CoppaExtensionCompletionHandler completionHandler;

@end


@implementation DICOPPAExtension

- (instancetype)init {
    self = [super init];
    if (self) {
        _coppaConfiguration = [[URCOPPAConfiguration alloc] init];
        _coppaExtensionUtility = [[DICoppaExtensionUtility alloc]init];
    }
    return self;
}


- (DICOPPASTATUS)getCoppaEmailConsentStatus {
    JRConsentsElement *consent = [self.coppaExtensionUtility getConsentElementWithCampaignID:self.coppaConfiguration.campaignID];
    return [self.coppaExtensionUtility getCoppaStatusForConsent:consent];
}


- (NSString *)getCoppaConsentLocale {
    JRConsentsElement *consent = [self.coppaExtensionUtility getConsentElementWithCampaignID:self.coppaConfiguration.campaignID];
    return consent.locale;
}


- (void)fetchCoppaEmailConsentStatusWithCompletion:(void(^)(DICOPPASTATUS status, NSError *error))completion {
    self.completionHandler = completion;
    [[DIUser getInstance] addSessionRefreshListener:self];
    [[DIUser getInstance] addUserDetailsListener:self];
    [[DIUser getInstance] refetchUserProfile];
}


- (void)failedToFetchCoppaStatus:(NSError *)error {
    [[DIUser getInstance] removeUserDetailsListener:self];
    [[DIUser getInstance] removeSessionRefreshListener:self];
    if (self.completionHandler) {
        self.completionHandler(-1,error);
        self.completionHandler = nil;
    }
}

#pragma mark - User Profile Refetch Delegate Methods
#pragma mark -

- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    if (error.code == DISessionExpiredErrorCode ) {
        [[DIUser getInstance] refreshLoginSession];
    }else{
        [self failedToFetchCoppaStatus:error];
    }
}


- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile {
    [[DIUser getInstance] removeUserDetailsListener:self];
    [[DIUser getInstance] removeSessionRefreshListener:self];
    DICOPPASTATUS status = [self getCoppaEmailConsentStatus];
    if (self.completionHandler) {
        self.completionHandler(status,nil);
        self.completionHandler = nil;
    }
}

#pragma mark - User Session Refresh Delegate Methods
#pragma mark -

- (void)loginSessionRefreshSucceed {
    [[DIUser getInstance] refetchUserProfile];
}


- (void)loginSessionRefreshFailedWithError:(NSError *)error {
    [self failedToFetchCoppaStatus:error];
}

@end
