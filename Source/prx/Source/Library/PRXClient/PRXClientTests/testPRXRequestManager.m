//
//  testPRXRequestManager.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 25/11/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "PRXRequestManager.h"
#import "PRXAssetRequest.h"
#import "PRXSummaryRequest.h"
#import "PRXSupportRequest.h"
#import "PRXDependencies.h"
#import "NSBundle+Bundle.h"
#import <AppInfra/AppInfra.h>
#import "PRXAssetResponse.h"
#import "PRXSummaryResponse.h"
#import "PRXSupportResponse.h"
#import "PRXNetworkWrapper.h"
#import "AISDMock.h"

#define TIMEOUT 15


@interface PRXNetworkMock:PRXNetworkWrapper{
    
}
- (void) sendRequest:(PRXRequest *)request
          completion:(void (^)(id response))success
             failure:(void(^)(NSError *error))failure;
@property(nonatomic,strong)NSDictionary *mockData;
@end

@interface PRXNetworkMock(){

}
@end

@implementation PRXNetworkMock
- (void) sendRequest:(PRXRequest *)request
          completion:(void (^)(id response))success
             failure:(void(^)(NSError *error))failure {
    
    if (self.mockData[@"response"]){
        success(self.mockData[@"response"]);
    }else{
        failure(self.mockData[@"error"]);
    }
}
@end



@interface PRXRequestManager(){
    @protected
    PRXNetworkWrapper *networkWrapper;
}
@property(nonatomic,strong)NSDictionary *mockData;
@end

@interface PRXRequestManagerTestable:PRXRequestManager {
}
@end

@implementation PRXRequestManagerTestable
- (instancetype)initWithDependencies:(PRXDependencies*)dependencies mockData:(NSDictionary *)mockData;
    {
        self = [super initWithDependencies:dependencies];
        if (self) {
            PRXNetworkMock *nwMock = [[PRXNetworkMock alloc]init];
            nwMock.mockData =mockData;
            self->networkWrapper = nwMock;
        }
        return self;
    }

@end


@interface testPRXRequestManager : XCTestCase{
    id <AIAppInfraProtocol> appinfra ;
}

@property (nonatomic,assign)BOOL isWaitingForResponse;
@property (nonatomic,assign)BOOL isFetchedResponse;

@end

@implementation testPRXRequestManager

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    appinfra = [[AIAppInfra alloc]initWithBuilder:nil];

}

- (void)testPerformPRXRequestWithDataAppInfra
{
    PRXDependencies *dependencies = [[PRXDependencies alloc]initWithAppInfra:appinfra parentTLA:@"PRX"];
    NSDictionary *mockData = @{@"response":@{@"success":@1}};
    PRXRequestManagerTestable *requestManager = [[PRXRequestManagerTestable alloc]initWithDependencies:dependencies mockData:mockData];
  
    PRXAssetRequest *data=[[PRXAssetRequest alloc] initWithSector:B2C ctnNumber:@"HP8632/00" catalog:CONSUMER];
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testPerformPRXRequestWithDataAppInfra"];
    
    [requestManager execute:data completion:^(PRXResponseData *response)
     {
         XCTAssertNotNil(response);
         XCTAssertTrue([response isKindOfClass:[PRXAssetResponse class]]);
         XCTAssertTrue(((PRXAssetResponse*)response).success);
         self.isFetchedResponse = YES;
         [expectation fulfill];
     }failure:nil];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}


- (void)testPerformPRXRequestWithDataAppInfraError
{
    PRXDependencies *dependencies = [[PRXDependencies alloc]initWithAppInfra:appinfra parentTLA:@"PRX"];
    NSDictionary *mockData = @{@"error":@"someerror"};
    PRXRequestManagerTestable *requestManager = [[PRXRequestManagerTestable alloc]initWithDependencies:dependencies mockData:mockData];
    
    PRXAssetRequest *data=[[PRXAssetRequest alloc] initWithSector:B2C ctnNumber:@"HP8632/00" catalog:CONSUMER];
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testPerformPRXRequestWithDataAppInfra"];
    
    [requestManager execute:data completion:nil failure:^(NSError *error)
     {
         XCTAssertNotNil(error);
         self.isFetchedResponse = YES;
        [expectation fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}



- (void)testPerformPRXSummeryRequestWithDataAppInfra
{
    
    PRXDependencies *dependencies = [[PRXDependencies alloc]init];
    dependencies.appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
    
    NSDictionary *mockData = @{@"response":@{@"success":@1}};
    PRXRequestManagerTestable *requestManager = [[PRXRequestManagerTestable alloc]initWithDependencies:dependencies mockData:mockData];
    

    PRXSummaryRequest *data=[[PRXSummaryRequest alloc] initWithSector:B2C ctnNumber:@"HP8632/00" catalog:CONSUMER];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testPerformPRXSummeryRequestWithDataAppInfra"];
    

    [requestManager execute:data completion:^(PRXResponseData *response)
     {
         XCTAssertNotNil(response);
         XCTAssertTrue([response isKindOfClass:[PRXSummaryResponse class]]);
         self.isFetchedResponse = YES;
         [expectation fulfill];
         
     }failure:nil];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    
}


- (void)testPerformPRXSupportRequestWithDataAppInfra
{
    
    PRXDependencies *dependencies = [[PRXDependencies alloc]init];
    dependencies.appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
    NSDictionary *mockData = @{@"response":@{@"success":@1}};
    PRXRequestManagerTestable *requestManager = [[PRXRequestManagerTestable alloc]initWithDependencies:dependencies mockData:mockData];

    
    PRXSupportRequest *data=[[PRXSupportRequest alloc] initWithSector:B2C ctnNumber:@"HP8632/00" catalog:CONSUMER];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testPerformPRXSupportRequestWithDataAppInfra"];
    

    
    [requestManager execute:data completion:^(PRXResponseData *response)
     {
         XCTAssertNotNil(response);
         XCTAssertTrue([response isKindOfClass:[PRXSupportResponse class]]);
         self.isFetchedResponse = YES;
         [expectation fulfill];
         
     }failure:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

}
    
@end
