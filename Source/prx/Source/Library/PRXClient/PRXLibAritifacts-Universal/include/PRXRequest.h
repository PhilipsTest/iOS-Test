//
//  PRXRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 04/03/16.
//  Copyright © 2016 sameer sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXLocaleMatch.h"
#import "PRXRequestEnums.h"

#define BaseUrl @"https://www.philips.com/prx/product/"
@class PRXResponseData;
@protocol PRXRequestDelegate <NSObject>
@required
- (REQUESTTYPE) getRequestType;
- (void) setLocaleMatchResult:(NSString *) loc;
- (NSString *) getLocaleMatchResult;
- (NSDictionary *) getHeaderParam;
- (NSDictionary *) getBodyParameters;
- (NSString *) getRequestUrl;
- (Catalog) getCatalog;
- (Sector) getSector;
- (PRXResponseData*) getResponse:(id) data;
@end

@interface PRXRequest : NSObject <PRXRequestDelegate>
- (instancetype)initWithSector:(Sector) sector
                       catalog:(Catalog) catalog;
@end
