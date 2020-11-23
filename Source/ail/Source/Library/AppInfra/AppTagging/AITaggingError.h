/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface AITaggingError : NSObject

@property(nonatomic, strong, nullable) NSString *errorType;
@property(nonatomic, strong, nullable) NSString *serverName;
@property(nonatomic, strong, nullable) NSString *errorCode;
@property(nonatomic, strong, nonnull) NSString *errorMessage;

- (nonnull id)initWithErrorType: (nullable NSString *)errorType
                       serverName: (nullable NSString *)serverName
                        errorCode: (nullable NSString *)errorCode
                     errorMessage: (nonnull NSString *)errorMessage;

- (nonnull id)initWithErrorMessage: (nonnull NSString *)errorMessage;

@end

//NS_ASSUME_NONNULL_END
