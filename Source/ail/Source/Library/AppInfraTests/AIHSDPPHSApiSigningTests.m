//
//  AIHSDPPHSApiSigningTests.m
//  AppInfra
//
//  Created by Abhishek on 28/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AIClonableClient.h"
#import "AICloudApiSigner.h"
#define sharedSecret @"cafebabe-1234-dead-dead-1234567890ab"
#define key @"e124794bab4949cd4affc267d446ddd95c938a7428d75d7901992e0cb4bc320cd94c28dae1e56d83eaf19010ccc8574d6d83fb687cf5d12ff2afddbaf73801b5"



@interface AIHSDPPHSApiSigningTests : XCTestCase
{
    AIHSDPPHSApiSigning *apiSigning;
}

@end

@implementation AIHSDPPHSApiSigningTests

- (void)setUp {
    [super setUp];
    
    self->apiSigning = [[AIHSDPPHSApiSigning alloc]initApiSigner:sharedSecret andhexKey:key];
}

- (void)testGetAuthorizationHeader {

    NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:@"2016-11-09T13:31:13.492+0000",@"SignedDate", nil];
    NSString *authorizationHeader = [self->apiSigning createSignature:@"POST" dhpUrl:@"/authentication/login/social" queryString:@"applicationName=uGrow" headers:headerDict requestBody:nil];
    NSString * expectedSignature = [NSString stringWithFormat:@"HmacSHA256;Credential:%@;SignedHeaders:SignedDate;Signature:UDFszoNOtDoqBsdD91S0Wl/IsT/JL9T3xNNy8JjXG1M=",sharedSecret];
    
    XCTAssertTrue([expectedSignature isEqualToString:authorizationHeader]);
}

-(void)testLoggingApiSign{
    AICloudApiSigner *logApiSigning = [[AICloudApiSigner alloc]initApiSigner:@"YMV5QLdKOW9vlQ1fgG0txw8Tdglfe2ePIFwkub68eN8=" andhexKey:@"96a5cd559d9299e4632faae2320777347d0e35acd77e3c1e9edcf244a30443ad3fcefdbb62806f15bb758c5903a0d7be635e0240cc671261f14cb37cc2ef1153"];
    NSDictionary *headerDict = @{@"SignedDate":@"testString"};
    NSString *authorizationHeader = [logApiSigning createSignature:nil dhpUrl:nil queryString:nil headers:headerDict requestBody:nil];
    //NSString *expectedSignature = @"c+ringIImXHGO4CcfN92klYih8/qxwYDMu4LORWsnH8=";
    NSString *expectedSignature = @"HmacSHA256;Credential:YMV5QLdKOW9vlQ1fgG0txw8Tdglfe2ePIFwkub68eN8=;SignedHeaders:SignedDate;Signature:c+ringIImXHGO4CcfN92klYih8/qxwYDMu4LORWsnH8=";
    XCTAssertEqualObjects(authorizationHeader, expectedSignature);
    
}

@end
