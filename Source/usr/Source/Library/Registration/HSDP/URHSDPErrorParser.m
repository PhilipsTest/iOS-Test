//
//  URHSDPErrorParser.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 16/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URHSDPErrorParser.h"
#import "DIRegistrationConstants.h"
#import "URErrorAppTaggingUtility.h"

#define DIHSDPSignatureExpiredTimeErrorCode 3056

@implementation URHSDPErrorParser

+ (NSError *)mappedErrorForError:(NSError *)error response:(NSDictionary *)response {
    NSError *mappedError;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        [userInfo addEntriesFromDictionary:response];
    }
    if ([self mapCommonErrorCode:error.code] == DINetworkErrorCode) {
        userInfo[NSLocalizedDescriptionKey] = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
    } else if (error.code == DIHSDPSignatureExpiredTimeErrorCode || [response[@"responseCode"] integerValue] == DIHSDPSignatureExpiredTimeErrorCode) {
        userInfo[NSLocalizedDescriptionKey] = LOCALIZE(@"USR_HSDP_Signature_Expired_TimeErrorMsg");
    } else {
        userInfo[NSLocalizedDescriptionKey] = (error.code) ? [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), error.code] : [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), [response[@"responseCode"] integerValue]];
    }
    mappedError = [NSError errorWithDomain:@"HSDP" code:DINetworkErrorCode userInfo:userInfo];
    [URErrorAppTaggingUtility trackAppMappedError:mappedError serverErrorCode:(error ? error.code : [response[@"responseCode"] integerValue]) serverErrorMessage:(error.userInfo[@"responseMessage"] ? error.userInfo[@"responseMessage"] : response[@"responseMessage"])];
    DIRErrorLog(@"%@", [self getFormattedErrorLog:error andMappedError:mappedError]);
    return mappedError;
}

+ (NSError *)errorForErrorCode:(NSInteger)errorCode {
    NSError *mappedError;
    switch (errorCode) {
        case DIHsdpStateJanrainNotSignedIn:
            mappedError = [NSError errorWithDomain:@"HSDPErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"USR Janrain not SignedIn"}];
            break;
        case DIHsdpStateNotConfiguredForCountry:
            mappedError = [NSError errorWithDomain:@"HSDPErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"USR Hsdp is not configured for country"}];
            break;
        case DIHsdpStateNotSignedIn:
            mappedError = [NSError errorWithDomain:@"HSDPErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"USR Hsdp is not SignedIn"}];
            break;
        case DIHsdpStateAlreadySignedIn:
            mappedError = [NSError errorWithDomain:@"HSDPErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"USR Hsdp is already SignedIn"}];
            break;
        default:
            mappedError = [NSError errorWithDomain:@"HSDPErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"USR Hsdp unable to fetch error"}];
            break;
    }
    return mappedError;
}

@end
