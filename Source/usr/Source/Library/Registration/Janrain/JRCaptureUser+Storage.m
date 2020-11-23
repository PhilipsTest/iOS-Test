//
//  JRCaptureUser+Storage.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "JRCaptureUser+Storage.h"
#import "URSettingsWrapper.h"
#import "DIConstants.h"

@implementation JRCaptureUser (Storage)

- (void)saveCurrentInstance {
    [DIRegistrationStorageProvider storeValueForKey:KJRCaptureUser value:(JRCaptureUser<NSCoding> *)self error:nil];
}


+ (JRCaptureUser *)loadPreviousInstanceWithError:(NSError **)error {
    JRCaptureUser *fetchedUser = [DIRegistrationStorageProvider fetchValueForKey:KJRCaptureUser error:error];
    if (fetchedUser && fetchedUser.password) {
        fetchedUser.password = nil;
        [fetchedUser saveCurrentInstance];
    }
    return fetchedUser;
}

- (void)removeCurrentInstance {
    [DIRegistrationStorageProvider removeValueForKey:KJRCaptureUser];
}
@end
