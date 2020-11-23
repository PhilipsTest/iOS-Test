//
//  PRXRequestEnums.h
//  PRXClient
//
//  Created by Sumit Prasad on 28/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET,
    POST
} REQUESTTYPE;

typedef enum{
    DEFAULT,
    B2C,
    B2B_LI,
    B2B_HC
}Sector;

typedef enum{
    ERROR_DEFAULT,
    SERVER_ERROR,
    INPUT_VALIDATION_ERROR,
    NOT_FOUND
}LocaleMatchError;

typedef enum{
    CATALOG_DEFAULT,
    CONSUMER,
    NONCONSUMER,
    CARE,
    PROFESSIONAL,
    LP_OEM_ATG,
    LP_PROF_ATG,
    HC,
    HHSSHOP,
    MOBILE,
    COPPA,
    EXTENDEDCONSENT
}Catalog;


typedef enum  {
    PLATFORM_DEFAULT,
    PRX,
    JANRAIN
}Platform;

@interface PRXRequestEnums : NSObject


+(NSString *)stringWithRequestType:(REQUESTTYPE)input;
+(NSString *)stringWithPlatform:(Platform) input;
+(NSString *)stringWithCatalog:(Catalog)input;
+(NSString *)stringWithLocaleMatchError:(LocaleMatchError)input;
+(NSString *)stringWithSector:(Sector)input;

@end
