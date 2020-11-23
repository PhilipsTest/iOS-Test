//
//  AIRESTServiceIDTests.m
//  AppInfra
//
//  Created by leslie on 20/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIRESTClientProtocol.h"
#import "AIAppInfra.h"
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>
#import "AIRESTClientInterface.h"

@interface AIRESTClientInterface()

-(void)serviceURLWithServiceID:(NSString *)serviceID
                    preference:(AIRESTServiceIDPreference)preference
                 pathComponent:(nullable NSString *)pathComponent
                    completion:(void(^)(NSString*serviceURL,NSError *error))completionHandler;

@end

@interface AIRESTServiceIDTests : XCTestCase

@property (nonatomic,strong)AIRESTClientInterface * restClient;

@end

@implementation AIRESTServiceIDTests

+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    AIAppInfra * appInfra = [AIRESTServiceIDTests sharedAppInfra];
    self.restClient = (AIRESTClientInterface *)[appInfra.RESTClient manager];
}


-(void)testGetWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient GETWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
    
    
    [self.restClient GETWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceLanguage pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceLanguage pathComponent:@"test" completion:[OCMArg any]]);
}

-(void)testPOSTWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient POSTWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
}

-(void)testPUTWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient PUTWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
}

-(void)testHEADWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient HEADWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
}

-(void)testDELETEWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient DELETEWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
}

-(void)testPATCHWithServiceID {
    
    id partialMock = OCMPartialMock(self.restClient);
    
    [self.restClient PATCHWithServiceID:@"userreg.janrain.api.v2" preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" serviceURLCompletion:^(NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"serviceURLCompletion");
    } parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    OCMVerify([partialMock serviceURLWithServiceID:@"userreg.janrain.api.v2"preference:AIRESTServiceIDPreferenceCountry pathComponent:@"test" completion:[OCMArg any]]);
}


@end
