//
//  PRXRequest.m
//  PRXClient
//
//  Created by Sumit Prasad on 04/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXRequest.h"
#import "PRXResponseData.h"
@import AppInfra;
static const NSTimeInterval DEFAULT_TIMEOUT_INTERVAL = 30;

@interface PRXRequest (){
    NSString *locale;
    Catalog catalog;
    Sector sector;
    NSTimeInterval _timeoutInterval;
    NSString *ctn;
}
@end

@implementation PRXRequest

- (instancetype)init{
    if (self = [super init]){
        _timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
    }
        return self;
}

- (instancetype)initWithSector:(Sector) sec
                       catalog:(Catalog) cat
{
    if (self = [super init]) {
        sector = sec;
        catalog = cat;
        _timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
    }
    return self;
}

- (instancetype)initWithSector:(Sector) sec
                       catalog:(Catalog) cat
                     ctnNumber:(NSString *) ctnNumber
                     serviceID:(NSString *) serviceID{
    if (self = [super init]) {
        sector = sec;
        catalog = cat;
        _serviceID = serviceID;
        _timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
        ctn = ctnNumber;
    }
    return self;

}


- (PRXResponseData*) getResponse:(id) data{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass of PRXRequest", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return nil;
}


- (Catalog) getCatalog{
    return catalog;
}

- (Sector) getSector{
    return sector;
}

- (NSString*) getCtn{
    return ctn;
}


- (NSTimeInterval)getTimeoutInterval {
    return _timeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
}

- (NSDictionary *) getHeaderParam{

    return nil;
}

- (NSDictionary *) getBodyParameters{
    return nil;
}

- (REQUESTTYPE) getRequestType{
    return GET;
}

-(void) getRequestUrlFromAppInfra:(id<AIAppInfraProtocol>)appInfra completionHandler:(void(^)(NSString* serviceURL,NSError *error))completionHandler{
    
    if (self.serviceID) {

        NSMutableDictionary *placeHolders = [@{@"sector":[PRXRequestEnums stringWithSector:[self getSector]],
                                           @"catalog":[PRXRequestEnums stringWithCatalog:[self getCatalog]]                                           } mutableCopy];
        if (ctn && ctn.length>0) {
            [placeHolders setObject:ctn forKey:@"ctn"];
            
        }
        [appInfra.serviceDiscovery getServicesWithCountryPreference:@[self.serviceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *error) {
            AISDService *service = services[self.serviceID];
            if (!service.url) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                               @"Service URL not found"};
                NSError *customError = [[NSError alloc] initWithDomain:@"PRXClient"
                                                                  code:0
                                                              userInfo:userInfo];
                completionHandler(nil,customError);
                
                return ;
            }
            
            completionHandler(service.url,error);
        } replacement:placeHolders];
    }
    else{
        completionHandler(nil,nil);
    }
    
}

@end
