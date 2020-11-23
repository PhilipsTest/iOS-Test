/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSummaryListRequest.h"
#import "PRXSummaryListResponse.h"

static NSString *const kPRXSummaryListServiceID = @"prxclient.summarylist";

@interface PRXSummaryListRequest ()
@property (strong, nonatomic) NSArray *ctnNumbers;
@end


@implementation PRXSummaryListRequest

- (instancetype)initWithSector:(Sector) sec
                    ctnNumbers:(NSArray *) ctnNumbers
                       catalog:(Catalog) cat
{
    self = [super initWithSector:sec catalog:cat ctnNumber:[self.ctnNumbers componentsJoinedByString:@","] serviceID:kPRXSummaryListServiceID];
    self.ctnNumbers = ctnNumbers;
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXSummaryListResponse alloc] parseResponse:data];
}

-(void) getRequestUrlFromAppInfra:(id<AIAppInfraProtocol>)appInfra completionHandler:(void(^)(NSString* serviceURL,NSError *error))completionHandler {
    
    NSMutableDictionary *placeHolders = [@{kPRXSectorKey:[PRXRequestEnums stringWithSector:[self getSector]],
                                           kPRXCatalogKey:[PRXRequestEnums stringWithCatalog:[self getCatalog]]                                           } mutableCopy];
    if (self.ctnNumbers.count > 0) {
        [placeHolders setObject:[self.ctnNumbers componentsJoinedByString:@","] forKey:kPRXCtnsKey];
    }
    
    [appInfra.serviceDiscovery getServicesWithCountryPreference:[NSArray arrayWithObject:self.serviceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *sdError) {
        AISDService *service = services[kPRXSummaryListServiceID];
        NSString *serviceURL = service.url;
        if (!serviceURL) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                           kPRXServiceURLErrorKey};
            NSError *customError = [[NSError alloc] initWithDomain:kPRXClientKey
                                                              code:0
                                                          userInfo:userInfo];
            completionHandler(nil,customError);
            return;
        }
        completionHandler(serviceURL,sdError);
    } replacement:placeHolders];
}

@end
