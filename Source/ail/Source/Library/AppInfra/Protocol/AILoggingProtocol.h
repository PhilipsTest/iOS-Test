//
//  AILoggingProtocol.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
@protocol ConsentHandlerProtocol;

/**
 Defines various log levels
 @since 1.0.0
 */
typedef NS_ENUM(NSInteger, AILogLevel) {
    /**
     *  Error level
     */
    AILogLevelError = 0,
    /**
     *  Warning level
     */
    AILogLevelWarning,
    /**
     *  Info level
     */
    AILogLevelInfo,
    /**
     *  Debug level
     */
    AILogLevelDebug,
    /**
     *  All level
     */
    AILogLevelVerbose
};

/**
 *  A protocol declaring all logging related methods
 */
@protocol AILoggingProtocol <NSObject>

/**
 *  This method creates and returns a logging wrapper object which can be used for logging events and messages.
 *
 *  @param componentId      Identifier of the requesting component
 *  @param componentVersion Version of the requesting component
 *
 *  @return Returns an object that conforms to 'AILoggingProtocol' protocol.
 *  @since 1.0.0
 */
- (id<AILoggingProtocol>)createInstanceForComponent:(NSString *)componentId
                                   componentVersion:(NSString *)componentVersion;

/**
 *  Logs given message to configured output sink
 *
 *  @param level   level of log
 *  @param eventId identifier of the event being logged
 *  @param message message describing the event
 *  @since 1.0.0
 */
- (void)log:(AILogLevel)level
    eventId:(NSString *)eventId
    message:(NSString *)message;

/**
 *  Logs given message to configured output sink
 *
 *  @param level   level of log
 *  @param eventId identifier of the event being logged
 *  @param message log message
 *  @param dictionary containing the key values for logging
 *  @since 1.0.0
 */
- (void)log:(AILogLevel)level
    eventId:(NSString *)eventId
    message:(NSString *)message
 dictionary:(NSDictionary *)dictionary;

@optional

/**
 This gives the Cloud Logging key for DeviceStorageConsentHandle.
 @note Only Consent Definitions containing this key will be considered for Cloud Logging Handling.
 If no such key is found then the app will crash.
 @return a NSString value which should be used as Identifier for Cloud Logging Consent
 @since 2018.2.0
 @deprecated 1901.0.0
 */
-(NSString*)getCloudLoggingConsentIdentifier  __attribute__((deprecated("use AICloudLoggingProtocol to access getCloudLoggingConsentIdentifier")));

/**
 *  To identify log originated from which user
 *  set/reset when user login/logout
 *  can be empty (will not be able to track based on user)
 *
 *  userHSDPUUID HSDP ID of originatingUser
 *  @since 2018.2.0
 *  @deprecated 1901.0.0
 */
@property(nonatomic,strong)NSString* hsdpUserUUID __attribute__((deprecated("use AICloudLoggingProtocol to access hsdpUserUUID")));

@end

