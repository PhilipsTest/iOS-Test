//
//  RegistrationTestObserver.m
//  RegistrationTests
//
//  Created by Adarsh Kumar Rai on 23/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "RegistrationTestObserver.h"
#import <XCTest/XCTest.h>

static NSInteger const testExpirationTime = 300;

@interface RegistrationTestObserver()<XCTestObservation>

@property (nonatomic, strong) NSTimer *testExpirationTimer;

@end


@implementation RegistrationTestObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
        _testExpirationTimer = [NSTimer scheduledTimerWithTimeInterval:testExpirationTime target:self selector:@selector(maxTestRuntimeTimer:) userInfo:nil repeats:NO];
    }
    return self;
}


- (void)maxTestRuntimeTimer:(NSTimer *)timer {
    fprintf(stderr, "%s:%d: error: %s : Hit UR testing timeout!\n", __FILE__, __LINE__, __func__);
    fflush(stderr);
    exit(1);
}


#pragma mark - XCTTestObservation Methods -
- (void)testBundleDidFinish:(NSBundle *)testBundle {
    [self.testExpirationTimer invalidate];
    self.testExpirationTimer = nil;
}

@end
