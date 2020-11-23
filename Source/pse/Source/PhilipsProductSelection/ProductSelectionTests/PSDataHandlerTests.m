//
//  PSDataHandlerTest.m
//  ProductSelection
//
//  Created by sameer sulaiman on 2/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSDataHandler.h"
#import "PSHardcodedProductList.h"

#define TIMEOUT 15

@interface PSDataHandlerTest : XCTestCase
@property (nonatomic) PSDataHandler *dataHandler;
@property (nonatomic,assign)BOOL isWaitingForResponse;
@property (nonatomic,assign)BOOL isFetchedResponse;
@end

@implementation PSDataHandlerTest

- (void)setUp {
    [super setUp];
    self.dataHandler = [[PSDataHandler alloc] init];
}

-(void)testDataHandlerWithNilObject
{
    [self.dataHandler requestPRXSummaryWith:nil completion:^(NSArray *summaryList) {
        XCTAssertEqual([summaryList count],0);
    } failure:^(NSString *error) {
        self.isFetchedResponse = YES;
        XCTAssertTrue(self.isFetchedResponse);
    }];
    [self waitForResponseWithTimeout];

}

//appinfra object is nil
//-(void)testDataHandlerWithObject
//{
//    PSHardcodedProductList *hardcodedList = [[PSHardcodedProductList alloc] initWithArray:[NSMutableArray arrayWithObjects:@"HX9371/04",@"HF3330/01",@"HP6581/03",@"HP8656/03",@"S9031/26",@"SCF693/17",@"SCF145/06",@"FC6168/62",@"GC9550/02",@"PR3743/00", nil]];
//    hardcodedList.sector=CONSUMER;
//    hardcodedList.catalog=B2C;
//    [self.dataHandler requestPRXSummaryWith:hardcodedList completion:^(NSArray *summaryList) {
//        XCTAssertNotEqual([summaryList count], 0);
//    } failure:^(NSString *error) {
//        self.isFetchedResponse = YES;
//        XCTAssertTrue(self.isFetchedResponse);
//    }];
//    [self waitForResponseWithTimeout];
//    
//}

//-(void)testDataHandlerWithWrongCTN
//{
//    PSHardcodedProductList *hardcodedList = [[PSHardcodedProductList alloc] initWithArray:[NSMutableArray arrayWithObjects:@"ABCD",@"EFGH", nil]];
//    hardcodedList.sector=CONSUMER;
//    hardcodedList.catalog=B2C;
//    [self.dataHandler requestPRXSummaryWith:hardcodedList completion:^(NSArray *summaryList) {
//        XCTAssertEqual([summaryList count],0);
//    } failure:^(NSString *error) {
//        self.isFetchedResponse = YES;
//        XCTAssertTrue(self.isFetchedResponse);
//    }];
//    [self waitForResponseWithTimeout];
//}

- (void)waitForResponseWithTimeout
{
    self.isWaitingForResponse = YES;
    NSDate* giveUpDate = [NSDate dateWithTimeIntervalSinceNow:TIMEOUT];
    while (self.isWaitingForResponse && [giveUpDate timeIntervalSinceNow] > 0)
    {
        NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        [[NSRunLoop currentRunLoop] runUntilDate:stopDate];
    }
    
    self.isWaitingForResponse = NO;
}
@end
