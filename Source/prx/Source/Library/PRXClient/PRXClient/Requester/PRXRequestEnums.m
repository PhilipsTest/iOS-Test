//
//  PRXRequestEnums.m
//  PRXClient
//
//  Created by Sumit Prasad on 28/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXRequestEnums.h"

@implementation PRXRequestEnums

+(NSString *)stringWithRequestType:(REQUESTTYPE)input {
    NSArray *arr = @[@"GET",@"POST"];
    return (NSString *)[arr objectAtIndex:input];
}

+(NSString *)stringWithPlatform:(Platform) input {
    NSArray *arr = @[@"DEFAULT",@"PRX",@"JANRAIN"];
    return (NSString *)[arr objectAtIndex:input];
}

+(NSString *)stringWithCatalog:(Catalog)input {
    NSArray *arr = @[@"DEFAULT",@"CONSUMER",@"NONCONSUMER",@"CARE",@"PROFESSIONAL",@"LP_OEM_ATG",@"LP_PROF_ATG",@"HC",@"HHSSHOP",@"MOBILE",@"COPPA",@"EXTENDEDCONSENT"];
    return (NSString *)[arr objectAtIndex:input];
}

+(NSString *)stringWithLocaleMatchError:(LocaleMatchError)input{
    NSArray *arr = @[@"DEFAULT",@"SERVER_ERROR",@"INPUT_VALIDATION_ERROR",@"NOT_FOUND"];
    return (NSString *)[arr objectAtIndex:input];
}

+(NSString *)stringWithSector:(Sector)input {
    NSArray *arr = @[@"DEFAULT",@"B2C",@"B2B_LI",@"B2B_HC"];
    return (NSString *)[arr objectAtIndex:input];
}

@end
