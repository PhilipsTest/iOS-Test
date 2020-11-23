//
//  AILoggingFormatter.m
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  
 All rights are reserved. Reproduction or dissemination in whole or
 in part is prohibited without the prior written consent of the copyright holder.*/
//


#import "AILoggingFormatter.h"
#import "AILogMetaData.h"
#import <AppInfra/AppInfra-Swift.h>

@implementation AILoggingFormatter

- (instancetype)init
{
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS Z"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [self.dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return self;
}

/*
 Setting Log Level
 @param: flag: DDLogFlag
 @return NSString: String Value
 */
- (NSString *)logLevel:(DDLogFlag )flag {
    NSString *logLevel = @"";
    switch (flag) {
        case DDLogFlagError  : logLevel = @" ERROR "; break;
        case DDLogFlagWarning: logLevel = @"WARNING"; break;
        case DDLogFlagInfo   : logLevel = @" INFO  "; break;
        case DDLogFlagDebug  : logLevel = @" DEBUG "; break;
        default             : logLevel = @"VERBOSE"; break;
    }
    return logLevel;
}

-(NSString *)formattedUTCTimeString:(NSDate*)networkDate {
    return [self.dateFormatter stringFromDate:networkDate];
}

/*
 Setting Log Message Format
 @param: logMessage: DDLogMessage
 @return NSString: Log String Value
 */
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    AILogMetaData *metadata = (AILogMetaData*)logMessage.tag;
    NSString *component = metadata.component ;
    NSString *eventId = metadata.eventId;
    NSString *utcTime = [self formattedUTCTimeString:metadata.networkDate];
    
    NSMutableString *logDescription = [@"" mutableCopy];
    if (component){
        [logDescription appendFormat:@"%@ | ",component];
    }
    [logDescription appendFormat:@"%@ |",eventId?eventId:@"NA"];
    [logDescription appendFormat:@" %@ ",logMessage->_message?logMessage->_message:@"NA"];
    if (metadata.params && [metadata.params isKindOfClass:[NSDictionary class]]){
        [logDescription appendFormat:@"\n %@ ",metadata.params.description];
    }
    
    NSString *message = [NSString stringWithFormat:@" %@ | %@ | %@ \n ",
                         utcTime,[self logLevel:logMessage->_flag],logDescription];
    return message;
}

@end
