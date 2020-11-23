/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXCDLSRequest.h"
#import "PRXCDLSResponse.h"

static NSString *const kPRXCDLSServiceID = @"cc.cdls";
static NSString *const kPRXCDLSSector = @"productSector";
static NSString *const kPRXCDLSSCatalog = @"productCatalog";
static NSString *const kPRXCategory = @"productCategory";

@interface PRXCDLSRequest ()

@property (strong, nonatomic) NSString *category;

@end

@implementation PRXCDLSRequest

- (instancetype)initWithSector:(Sector) sec
                      category:(NSString *) category
                       catalog:(Catalog) cat {
    self = [super initWithSector:sec catalog:cat ctnNumber:@"" serviceID:kPRXCDLSServiceID];
    self.category = category;
    return self;
}

- (PRXResponseData *)getResponse:(id)data {
    return [[PRXCDLSResponse alloc] parseResponse:data];
}

- (void) getRequestUrlFromAppInfra:(id<AIAppInfraProtocol>)appInfra
                 completionHandler:(void(^)(NSString *serviceURL, NSError *error))completionHandler {
    NSMutableDictionary *placeHolders = [@{kPRXCDLSSector:[PRXRequestEnums stringWithSector:[self getSector]],
                                           kPRXCDLSSCatalog:[PRXRequestEnums stringWithCatalog:[self getCatalog]]} mutableCopy];
    if (self.category.length > 0) {
        [placeHolders setObject:self.category forKey:kPRXCategory];
    }
    [appInfra.serviceDiscovery getServicesWithCountryPreference:[NSArray arrayWithObject:self.serviceID] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *sdError) {
        AISDService *service = services[kPRXCDLSServiceID];
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
