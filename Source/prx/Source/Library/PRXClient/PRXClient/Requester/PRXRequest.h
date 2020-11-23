//
//  PRXRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 04/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRXRequestEnums.h"
#import <AppInfra/AppInfra.h>
#import "PRXConstants.h"

@class PRXResponseData;

/**
 PRX request should implement PRXRequestDelegate methods
 @since 1.0.0
 */
@protocol PRXRequestDelegate <NSObject>
@required

/**
 Returns whether the request is either GET or POST
 @return REQUESTTYPE enum
 @since 1.0.0
 */
- (REQUESTTYPE) getRequestType;

/**
 Returns the header Parameters
 @return headerDictionary NSDictionary
 @since 1.0.0
*/
- (NSDictionary *) getHeaderParam;

/**
 Returns the Body Parameters
 @return bodyParametersDictionary NSDictionary
  @since 1.0.0
 */
- (NSDictionary *) getBodyParameters;

/**
 Returns the Catalog
 @return Catalog Enum
  @since 1.0.0
 */
- (Catalog) getCatalog;

/**
 Returns the Sector
 @return Sector Enum
  @since 1.0.0
 */
- (Sector) getSector;

/**
 Returns the CTN
 @return CTNNumber NSString
  @since 1.0.0
 */
- (NSString*) getCtn;

/**
 Returns the timeOutInterval if a request is timed out
 @return TimeInterval NSTimeInterval
  @since 1.0.0
 */
- (NSTimeInterval)getTimeoutInterval;

/**
 To set the timeOutinterval for a request
 @param timeoutInterval interval time to be set for a request
  @since 1.0.0
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 Parses the given response and returns PRXResponseData model
 @return PRXResponseData model from given data
 @since 1.0.0
 */
- (PRXResponseData*) getResponse:(id) data;

/**
 To be called when we want to get the request URL from the AppInfra
 @param appInfra APPInfra instance
 @param completionHandler success A block object to be executed when the task finishes successfully and failure A block object to be executed when the task finishes unsuccessfully.
 @since 1.0.0
 */
- (void) getRequestUrlFromAppInfra:(id<AIAppInfraProtocol>)appInfra completionHandler:(void(^)(NSString* serviceURL,NSError *error))completionHandler NS_SWIFT_NAME(getRequestUrl(from:completionHandler:));;
@end

/**
 This is the URL Builder base class to build all the PRX relevant URLs.
 @since 1.0.0
 */
@interface PRXRequest : NSObject <PRXRequestDelegate>

/**
 Initializes the PRXRequest
 @param sector Sector
 @param catalog Catalog
 @return PRXRequest instance
 @since 1.0.0
 */
- (instancetype)initWithSector:(Sector) sector
                       catalog:(Catalog) catalog;

/**
 Initializes the PRXRequest
 @param sec Sector
 @param cat Catalog
 @param ctnNumber CTNNumber
 @param serviceID ServiceID
 @return PRXRequest instance
 @since 1.1.0
 */
- (instancetype)initWithSector:(Sector) sec
                       catalog:(Catalog) cat
                     ctnNumber:(NSString *) ctnNumber
                     serviceID:(NSString *) serviceID;
@property(nonatomic,strong)NSString *serviceID;
@end
