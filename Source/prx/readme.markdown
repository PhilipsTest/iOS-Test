## Latest Version 2018.5.0

Updated Apple docs

##Platform 2.2.0
TLA is added as component identifier for logging purpose.<br/>

##Platform 2.0.0
###changes

> Removed :
>>- (void) setLocaleMatchResult:(NSString *) loc;
>>- (NSString *) getLocaleMatchResult;
>>- (NSString *) getRequestUrl;

>Added :

>>- (void) getRequestUrlFromAppInfra:(AIAppInfra *)appInfra completionHandler:(void(^)(NSString* serviceURL,NSError *error))completionHandler;
<br>-- This method returns the base url of prx from service discovery based on country. Replacement method for getRequestUrl 
>>- (NSString*) getCtn;


>1) AppInfra no longer depends on PRXClient ,so if anyone consuming PRXClient should add it directly to their pod file <br>
>2) Added AppInfra dependency in PRX.<br>
>3) We are taking Locale from ServiceDiscovery , Hence setting LocaleMatch in PRX is not required . We are using LocaleMatch only to get the Sector and CTN enum definitions. This we are planning to bring to PRXClient so the we can remove PILocaleMatch completely. <br>
>4) Created PRXDependency class in PRX to inject AppInfra .<br>
>5) If you are subclassing PRXRequest, (NSString *) getRequestUrl method is deprecated. You should use getRequestUrlFromAppInfra which already have the default implentation .

PRXRequestManager *requestManager = [[PRXRequestManager alloc]init];

will change to

PRXDependencies *dependencies = [[PRXDependencies alloc]initWithAppInfra:<<Your instance of appinfra>>];
PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:dependencies];

deprecated <br>
class ->  PRXLocaleMatch

##Platform 1.1.0
Removed dependency on AFNetworking.<br/>
Modified APIs to communicate with App infra’s REST client for making networking calls.<br/>


##Platform 1.0.0
First version of the component is created.<br/>
Added APIs to dowloand product support information.<br/>
Added APIs to dowloand product summary information.<br/>
Added APIs to dowloand product Asset information.<br/>


## Description

The main functionality of this library is to download any data related to product present on PRX. It can be used by consumer care, registration and different applications. This library can be reused by other projects with minimal development changes as a generic network component as well.
PRX client library exposes classes and APIs to clients to send a request and get a response. Library also helps clients to customise the requests.

1	Client
It can be an application, consumer care component or registration component. <br>
2	RequestManager 
It provides set of public APIs for placing requests from client and also talks to Network wrapper class for performing network operations. <br>
3	Responsehandler
Handles response like invoking respective builders to build the response. It also invokes listener/blocks.<br>
4	Product/ProductSummary/ProductAssets
Model data for each request type.<br>


## Installation

* Using cocoapods - add philips cocoapod repo and add  ``` pod 'PhilipsPRXClient' ``` to pod file
* Using Frameworks - 


## Code Example - Quick integration

#import "PRXRequestManager.h"
#import "PRXAssetRequest.h"


* Create Any request

objc
  PRXAssetRequest *data=[[PRXAssetRequest alloc] initWithSector:B2C ctnNumber:@"HP8632/00" catalog:CONSUMER];


* Create Request Manager and call execute API

objc
    //Dont create new instance of Appinfra instead inject the existing instance
   PRXDependencies *dependencies = [[PRXDependencies alloc]initWithAppInfra:[[AIAppInfra alloc]initWithBuilder:nil]];
   PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:dependencies];
   [requestManager execute:data completion:^(PRXResponseData *response)
     {
                
     }failure:^(NSError *error)
     {
       
     }];

## PRXRequest Subclass


@interface PRXRequestSubclass : PRXRequest
- (instancetype)initWithSector:(Sector)sec ctnNumber:(NSString *)ctnNumber catalog:(Catalog)cat <#more params if needed#>;
@end


@implementation PRXRequestSubclass
- (instancetype)initWithSector:(Sector) sec ctnNumber:(NSString *) ctnNumber catalog:(Catalog) cat
{
 self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:@"serviceID"];
 <#set more params if any#>
return self;
}

//Implement following functions if needed
- (REQUESTTYPE) getRequestType;
- (NSDictionary *) getHeaderParam;
- (NSDictionary *) getBodyParameters;
- (NSTimeInterval)getTimeoutInterval;
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;
- (PRXResponseData*) getResponse:(id) data;
- (void) getRequestUrlFromAppInfra:(AIAppInfra *)appInfra completionHandler:(void(^)(NSString* serviceURL,NSError *error))completionHandler;
@end


*note :<br/>
1) getRequestUrlFromAppInfra have default implementation which will return serviceUrl from service discovery based on the serviceID. It will also replace placeholders in serviceURl like sector, catalog and ctn.<br/>

2) For further Integration details , Refer [Integration document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Griffin/_git/ail-ios-prxclient?path=%2FDocuments%2FExternal%2FPRX000008_Integration%20Document_PRXClient_iOS_2.4.0.docx&version=GBdevelop&_a=contents)

## <a name="Contact details"></a>Contact details
 * Deepthi Shivakumar - <deepthi.shivakumar@philips.com> - Architect
 * Ravi Kiran - <ravi.kiran@philips.com> - Developer
 * Hashim MH - <hashim.mh@philips.com> - Developer
 * Leslie Sebastian - <leslie.sebastian@philips.com> - Developers

## License
 * Copyright (c) Koninklijke Philips N.V., 2017 All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*

