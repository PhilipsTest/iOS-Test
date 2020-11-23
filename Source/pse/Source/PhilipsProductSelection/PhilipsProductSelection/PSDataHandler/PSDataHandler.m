//
//  PSDataHandler.m
//  ProductSelection
//
//  Created by sameer sulaiman on 2/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSHardcodedProductList.h"
#import "PSHandler.h"
#import "PSDataHandler.h"
#import "PSAppInfraWrapper.h"
#import "PSConstants.h"
@import PhilipsPRXClient;

@interface PSDataHandler ()

@property (strong,nonatomic) NSMutableArray *productSummary;
@property (strong,nonatomic) PSHardcodedProductList *hardcodedProductList;

@end

@implementation PSDataHandler

- (id)init
{
    self =[super init];
    return self;
}

- (void)requestPRXSummaryWith:(PSProductModelSelectionType*)productModelSelectionType completion:(void (^)(NSArray *summaryList))success failure:(void(^)(NSString *error))failure
{
    self.hardcodedProductList = (PSHardcodedProductList*)productModelSelectionType;
    if(self.hardcodedProductList.hardcodedProductListArray.count <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(@"No product list available for this region");
        });
        return;
    }
    PRXSummaryListRequest *summaryListRequest = [[PRXSummaryListRequest alloc]initWithSector:self.hardcodedProductList.sector ctnNumbers:self.hardcodedProductList.hardcodedProductListArray catalog:self.hardcodedProductList.catalog];
    PRXDependencies *prxDependencies = [[PRXDependencies alloc]init];
    prxDependencies.appInfra = [PSAppInfraWrapper sharedInstance].appInfra;
    PRXRequestManager *requestManager = [[PRXRequestManager alloc]initWithDependencies:prxDependencies];
    [requestManager execute:summaryListRequest completion:^(PRXResponseData *response) {
        PRXSummaryListResponse *listResponseData=(PRXSummaryListResponse *)response;
        NSArray *responseList = listResponseData.data;
        if(responseList.count != self.hardcodedProductList.hardcodedProductListArray.count) {
            [self tagErrorForUnavailableCTNsFrom:responseList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            listResponseData.success ? success(responseList) : failure(@"No product list available for this region");
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(@"No product list available for this region");
        });
    }];
}

- (void)tagErrorForUnavailableCTNsFrom:(NSArray *)summaryListData {
    NSMutableArray *availableCTNs = [[NSMutableArray alloc]init];
    NSMutableArray *requestedCTNs = [NSMutableArray arrayWithArray:_hardcodedProductList.hardcodedProductListArray];
    for (PRXSummaryData *productData in summaryListData) {
        [availableCTNs addObject:productData.ctn];
    }
    if (availableCTNs.count > 0) {
        [requestedCTNs removeObjectsInArray:availableCTNs];
    }
    NSString *errorMessage = [NSString stringWithFormat:@"%@ CTNs not found",[requestedCTNs componentsJoinedByString:@","]];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData paramKey:kTechnicalError andParamValue:errorMessage];
}

@end
