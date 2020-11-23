//
//  DIUser+DataInterface.m
//  PhilipsRegistration
//
//  Created by nikilesh  on 1/29/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "DIUser+DataInterface.h"
#import "DIUser+PrivateData.h"
#import "URBaseErrorParser.h"

@implementation DIUser (DataInterface)


- (BOOL)isUserLoggedIn {
    return self.userLoggedInState == UserLoggedInStateUserLoggedIn;
}

-(UserLoggedInState)loggedInState{
    return self.userLoggedInState;
}

- (NSString * _Nullable)hsdpAccessToken {
    return self.hsdpUser.accessToken;
}


- (NSString * _Nullable)hsdpUUID {
    return self.hsdpUser.userUUID;
}


- (void)addUserDataInterfaceListener:(nonnull id<UserDataDelegate>)listener {
    NSAssert(listener != nil, @"User DataInterface Listeners can not be nill");
    if ([self.userDataInterfaceListeners containsObject:listener]) {
        return;
    }
    [self.userDataInterfaceListeners addObject:listener];
}


- (void)removeUserDataInterfaceListener:(nonnull id<UserDataDelegate>)listener {
    if ([self.userDataInterfaceListeners containsObject:listener]) {
        [self.userDataInterfaceListeners removeObject:listener];
    }
}


- (void)authorizeLoginToHSDPWithCompletion:(void(^)(BOOL success, NSError *error))completion{
    [self authorizeWithHSDPWithCompletion:completion];
}


- (NSDictionary<NSString *, id> * _Nullable)userDetails:(NSArray<NSString *> * _Nullable)fields error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    if (self.userLoggedInState <= UserLoggedInStatePendingVerification) {
        if (error != NULL) {
            *error = [URBaseErrorParser userNotLoggedInError];
        }
        return nil;
    }
    if ([[NSSet setWithArray: fields] isSubsetOfSet:[NSSet setWithArray: [self allowedUserFields]]]) {
        
        fields = fields.count == 0 ? [self allowedUserFields] : fields;
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithCapacity: fields.count];
        NSDictionary *mappedUserFields = [self mapUserFields];
        if ([fields containsObject:UserDetailConstants.ACCESS_TOKEN] || fields.count == 0) {
            id accessToken = [JRCapture getAccessToken];
            if (accessToken) {
                [userData setObject:accessToken forKey:UserDetailConstants.ACCESS_TOKEN];
            }
        }
        for (NSString *fieldName in fields) {
            if (![fieldName isEqualToString:UserDetailConstants.ACCESS_TOKEN]){
                id value = [self.userProfile valueForKey:[mappedUserFields valueForKey:fieldName]];
                if (value) {
                    [userData setObject:value forKey:fieldName];
                }
            }
        }
        return userData;
    } else {
        if(error != NULL) {
            *error = [NSError errorWithDomain:UserDetailConstants.USER_ERROR_DOMAIN code:UserDetailErrorInvalidFields userInfo:@{NSLocalizedDescriptionKey:@"Invalid User Field key", NSLocalizedFailureReasonErrorKey:@"Invalid User Field key"}];
        }
        return nil;
    }
}


- (NSArray *)allowedUserFields {
    return @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.GENDER, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.ACCESS_TOKEN, UserDetailConstants.UUID];
}


- (NSDictionary *)mapUserFields {
    NSDictionary *mappedFileds = @{UserDetailConstants.GIVEN_NAME:@"givenName", UserDetailConstants.FAMILY_NAME:@"familyName", UserDetailConstants.MOBILE_NUMBER:@"mobileNumber", UserDetailConstants.GENDER:@"gender", UserDetailConstants.EMAIL:@"email", UserDetailConstants.BIRTHDAY:@"birthday", UserDetailConstants.UUID:@"uuid", UserDetailConstants.ACCESS_TOKEN:UserDetailConstants.ACCESS_TOKEN,  UserDetailConstants.RECEIVE_MARKETING_EMAIL:@"receiveMarketingEmail"};
    return mappedFileds;
}


- (void)updateUserDetails:(NSDictionary<NSString *, id> * _Nonnull)fields {
    if (self.userLoggedInState <= UserLoggedInStatePendingVerification) {
        NSError *error = [URBaseErrorParser userNotLoggedInError];
        [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
        return;
    }
    if ([[NSSet setWithArray: [fields allKeys]] isSubsetOfSet:[NSSet setWithArray: [self allowedUserFields]]] ) {
        [self.suspendableUpdateQueue addOperationWithBlock:^{
            self.suspendableUpdateQueue.suspended = YES;
            [self checkIfJanrainFlowDownloadedWithCompletion:^(NSError * _Nullable flowDownloadError) {
                if (!flowDownloadError) {
                    [self.janrainService updateFields:fields forUser:self.userProfile withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                        [self storeUserProfile:user];
                        [self sendMessage:@selector(updateUserDetailsSuccess) toListeners:self.userDataInterfaceListeners withObject:nil andObject:nil];
                    } failureHandler:^(NSError *error) {
                        [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
                    }];
                } else {
                    [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:flowDownloadError andObject:nil];
                }
            }];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:UserDetailConstants.USER_ERROR_DOMAIN code:UserDetailErrorInvalidFields userInfo:@{NSLocalizedDescriptionKey:@"Invalid key sent ", NSLocalizedFailureReasonErrorKey:@"Invalid key sent"}];
        [self sendMessage:@selector(updateUserDetailsFailed:) toListeners:self.userDataInterfaceListeners withObject:error andObject:nil];
        return;
    }
}


- (void)logoutSession {
    [self logout];
}


- (void)refetchUserDetails {
    [self refetchUserProfile];
}


- (void)refreshSession {
    [self refreshLoginSession];
}


- (BOOL)isOIDCToken {
    return false;
}


- (void)updateReceiveMarketingEmail:(BOOL)receiveMarketingEmail {
    [self updateReciveMarketingEmail:receiveMarketingEmail];
}

@end

@implementation DIUser (HSDPUserDataInterface)

//- (void)add:(nonnull id<UserDataDelegate>)listener {
    
//}

- (void)addHSDPUserDataInterfaceListener:(id<HSDPRefreshSessionResultDelegate> _Nonnull)listener {
    NSAssert(listener != nil, @"User DataInterface Listeners can not be nill");
    if ([self.hsdpUserDataInterfaceListeners containsObject:listener]) {
        return;
    }
    [self.hsdpUserDataInterfaceListeners addObject:listener];
}

- (void)removeHSDPUserDataInterfaceListener:(id<HSDPRefreshSessionResultDelegate> _Nonnull)listener {
    if ([self.hsdpUserDataInterfaceListeners containsObject:listener]) {
        [self.hsdpUserDataInterfaceListeners removeObject:listener];
    }
}

@end
