//
//  DILogger.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#ifndef Registration_Logger_h
#define Registration_Logger_h

#import "DIConstants.h"

#ifdef DEBUG

#define DIRDebugLog(fmt, ...)   [RegistrationUtility log:(AILogLevelDebug) eventId:NSStringFromClass([self class]) format:(@"🐞 %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRErrorLog(fmt, ...)   [RegistrationUtility log:(AILogLevelError) eventId:NSStringFromClass([self class]) format:(@"❌ %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRInfoLog(fmt, ...)    [RegistrationUtility log:(AILogLevelInfo) eventId:NSStringFromClass([self class]) format:(@"💁‍♂️ %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRWarningLog(fmt, ...) [RegistrationUtility log:(AILogLevelWarning) eventId:NSStringFromClass([self class]) format:(@"⚠️ %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

#else

#define DIRDebugLog(fmt, ...)   [RegistrationUtility log:(AILogLevelDebug) eventId:NSStringFromClass([self class]) format:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRErrorLog(fmt, ...)   [RegistrationUtility log:(AILogLevelError) eventId:NSStringFromClass([self class]) format:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRInfoLog(fmt, ...)    [RegistrationUtility log:(AILogLevelInfo) eventId:NSStringFromClass([self class]) format:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
#define DIRWarningLog(fmt, ...) [RegistrationUtility log:(AILogLevelWarning) eventId:NSStringFromClass([self class]) format:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

#endif

#endif
