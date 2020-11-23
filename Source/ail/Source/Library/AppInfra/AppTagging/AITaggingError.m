/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

#import "AITaggingError.h"

@implementation AITaggingError

- (instancetype)initWithErrorType: (NSString *)errorType
                       serverName: (NSString *)serverName
                        errorCode: (NSString *)errorCode
                     errorMessage: (NSString *)errorMessage {
    self = [super init];
    if (self) {
        self.errorType = errorType;
        self.serverName = serverName;
        self.errorCode = errorCode;
        self.errorMessage = errorMessage;
    }
    return self;
}

- (nonnull id)initWithErrorMessage: (nonnull NSString *)errorMessage {
    self = [super init];
    if (self) {
        self.errorType = nil;
        self.serverName = nil;
        self.errorCode = nil;
        self.errorMessage = errorMessage;
    }
    return self;
}

@end
