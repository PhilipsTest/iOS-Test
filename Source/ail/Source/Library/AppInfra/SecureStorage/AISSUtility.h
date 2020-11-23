//
// App InfraUtility.h
// App Infra
//
//  Created by Abhinav Jha on 5/5/15.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kErrorDomainAISecureStorage         @"com.philips.platform.appinfra.SecureStorage"
#define kErrorDomainAIDataParsing           @"com.philips.platform.appinfra.DataParsing"
#define kErrorDescriptionEmptyKey           @"Key provided is nil"
#define kErrorDescriptionAccessKey          @"Access Key failure"
#define kErrorDescriptionInvalidParam       @"NullData"
#define kErrorDescriptionEmptyData          @"No data found for the key provided"
#define kErrorDescriptionUnarchive          @"Unarchiving decrypted data failed"
#define kErrorDescriptionDecryptionFailure  @"Data decryption failed"
#define kErrorDescriptionEncryptionFailure  @"Data Encryption failed"
#define kErrorDescriptionArchive            @"Archiving data failed"
#define kErrorDescriptionEmptyDataParsing   @"No data is passed for parsing"
#define kErrorDescriptionDataParsing        @"Parsing data failed"

@interface AISSUtility : NSObject

// method to get the service name
+ (NSString *)serviceNameForTokenName:(NSString *)tokenName;

@end
