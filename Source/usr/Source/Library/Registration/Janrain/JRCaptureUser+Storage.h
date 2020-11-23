//
//  JRCaptureUser+Storage.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "JRCaptureUser.h"

@interface JRCaptureUser (Storage)
- (void)saveCurrentInstance;
+ (JRCaptureUser *)loadPreviousInstanceWithError:(NSError **)error;
- (void)removeCurrentInstance;
@end
