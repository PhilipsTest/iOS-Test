//
//  AILogUtilities.m
//  AppInfra
//
//  Created by Hashim MH on 30/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AILogUtilities.h"
#import <sys/utsname.h>
#import "AppInfra.h"

@implementation AILogUtilities


+(NSString*)networkTypeFromRESTClient:(id<AIRESTClientProtocol>)restClient {
    if (!restClient) {
        return @"NA";
    }
    AIRESTClientReachabilityStatus nwStatus = [restClient getNetworkReachabilityStatus];
    NSString *status = @"";
    switch (nwStatus) {
        case AIRESTClientReachabilityStatusReachableViaWWAN:
            status = @"MOBILE_DATA";
            break;
        case AIRESTClientReachabilityStatusReachableViaWiFi:
            status = @"WIFI";
            break;
        case AIRESTClientReachabilityStatusNotReachable:
            status = @"NO_NETWORK";
            break;
        default:
            status = @"NA";
            break;
    }
    return status;
}


+(NSString*)stateString:(AIAIAppState)state {
    
    NSString *stateString = @"";
    switch (state) {
        case AIAIAppStateTEST:
            stateString = @"TEST";
            break;
        case AIAIAppStateDEVELOPMENT:
            stateString = @"DEVELOPMENT";
            break;
        case AIAIAppStateSTAGING:
            stateString = @"STAGING";
            break;
        case AIAIAppStateACCEPTANCE:
            stateString = @"ACCEPTANCE";
            break;
        case AIAIAppStatePRODUCTION:
            stateString = @"PRODUCTION";
            break;
    }
    return stateString;
}


+(NSString*)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


+(NSString*)generateLogId {
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid lowercaseString]);
}


+ (NSString *)logLevel:(DDLogFlag )flag {
    NSString *logLevel = @"";
    switch (flag) {
        case DDLogFlagError    : logLevel = @"ERROR"; break;
        case DDLogFlagWarning  : logLevel = @"WARNING"; break;
        case DDLogFlagInfo     : logLevel = @"INFO"; break;
        case DDLogFlagDebug    : logLevel = @"DEBUG"; break;
        default                : logLevel = @"VERBOSE"; break;
    }
    return logLevel;
}


+(NSString *)systemInfo {
    return ([NSString stringWithFormat:@"%@/%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion]);
}


+(DDLogFlag)aiFlagtoDDLogFlag:(AILogLevel)aiLogLevelFlag {
    DDLogFlag flag;
    
    switch (aiLogLevelFlag) {
        case AILogLevelError:
            flag = DDLogFlagError;
            break;
        case 1:
            flag = DDLogFlagWarning;
            break;
        case 2:
            flag = DDLogFlagInfo;
            break;
        case 3:
            flag = DDLogFlagDebug;
            break;
        case 4:
            flag = DDLogFlagVerbose;
            break;
    }
    return flag;
}

@end
