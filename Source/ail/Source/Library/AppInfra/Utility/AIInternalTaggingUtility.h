//
//  AIInternalTaggingUtility.h
//  AppInfra
//
//  Created by Hashim MH on 07/02/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//


// can we tag url
// if item is not there can we put NA
// can we tag home country
// can we put error message in the end


//256 chr limit

#import <Foundation/Foundation.h>

//Tagging Constants

//keys
#define kAilSendData    @"sendData"


//Actions
#define kAilTechnicalError      @"technicalError"
#define kAilInformationalError  @"informationalError"
#define kAilUserError           @"userError"

#define kAilSuccessMessage  @"appInfraSuccessMessage"

////Tecnical Errors
//////Service Discovery
#define kAilTagHomeCountryError   @"get HomeCountry Error"
#define kAilTagSDRefreshError     @"SD refresh failed"
#define kAilTagMalformedUrl       @"malformed url after applying url parameters"
#define kAilTagNotReachable       @"Internet is not reachable"
#define kAILTagSDDataStoreFailed  @"error while saving SD data"

////AppInfra success
//////Service Discovery

#define kAilTagSetHomeCountry       @"Successfully setHomeCountry"
#define kAilTagSetHomeCountryInvalid   @"setHomeCountry invalid country"
#define kAilTagSDRefresh            @"SD force refreshed called"
#define kAilTagSDShouldRefresh      @"SD data refresh due to url mismatch"
#define kAilTagSDDatafromCache      @"SD fetched local cached data"
#define kAilTagClearSDData          @"Clearing SD data"

#define kAilTagDownloadPlatform     @"Downloading platform services"
#define kAilTagDownloadProposition  @"Downloading proposition services"
#define kAilTagCountryFromSim       @"Fetched country code from sim"
#define kAilTagCountryFromIP        @"Fetched country code from GEOIP"
#define kAilTagDownloadCompleted    @"SD download success"
#define kAilTagDownloadError        @"SD download failed"


//////
#define kAilTagSetHomeCountrySaveError        @"setHomeCountry save failed"


@protocol AIAppTaggingProtocol;

@interface AIInternalTaggingUtility : NSObject
+ (void)setSharedTagging:(id<AIAppTaggingProtocol>)tagInstance;

+ (void)resetSharedTagging;

+ (BOOL)isNetworkError: (NSError *)error;

@end
