//
//  URJWTParserTests.m
//  RegistrationTests
//
//  Created by Adarsh Kumar Rai on 20/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URJWTParser.h"
#import "Kiwi.h"

SPEC_BEGIN(JWTParserSpec)

describe(@"URJWTParser", ^{
    
    context(@"when initialized with nil token", ^{
        it(@"should have payload and headers as nil", ^{
            URJWTParser *parser = [[URJWTParser alloc] initWithJWTToken:nil];
            [[parser.headers should] beNil];
            [[parser.payload should] beNil];
            
        });
    });
    
    context(@"when initialized with wrong token format", ^{
        it(@"should have payload and headers as nil", ^{
            NSString *wrongToken = @"some-dummy-string";
            URJWTParser *parser = [[URJWTParser alloc] initWithJWTToken:wrongToken];
            [[parser.headers should] beNil];
            [[parser.payload should] beNil];
            
        });
    });
    
    context(@"when initialized with invalid token in propert format", ^{
        it(@"should have payload and headers as nil", ^{
            NSString *wrongToken = @"some.dummy.string";
            URJWTParser *parser = [[URJWTParser alloc] initWithJWTToken:wrongToken];
            [[parser.headers should] beNil];
            [[parser.payload should] beNil];
        });
    });
    
    context(@"when initialized with valid token in proper format", ^{
        it(@"should have correct payload and headers", ^{
            NSString *token = @"eyJhbGciOiJSUzI1NiIsImtpZCI6ImE3NDhlOWY3NjcxNTlmNjY3YTAyMjMzMThkZTBiMjMyOWU1NDQzNjIifQ.eyJhenAiOiIzNDYwMDA1NzEyNjItcjNuNTBvdWNvZW5vbWdncmZqdmhkcGZ2bTk1a2RsNXEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIzNDYwMDA1NzEyNjItcjNuNTBvdWNvZW5vbWdncmZqdmhkcGZ2bTk1a2RsNXEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDMyNDc1NzI5MDY0Mzg3MTMwMTkiLCJlbWFpbCI6ImFkcmFpNzVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJLdlBkWmtpb1JiM2NIYVFBQkthdEN3IiwiZXhwIjoxNTI2MzcwNDQzLCJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJpYXQiOjE1MjYzNjY4NDMsIm5hbWUiOiJBRCBSQUkiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy0wemFJQlZ3Y29aWS9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BSWNmZFhDYmFDZXp5Q3JNNjB1WTIxZmk1OTd5bF8taG93L3M5Ni1jL3Bob3RvLmpwZyIsImdpdmVuX25hbWUiOiJBRCIsImZhbWlseV9uYW1lIjoiUkFJIiwibG9jYWxlIjoiZW4ifQ.mKN0e7v0QBNRb2PZgXiwU_--NgOwxOO-fh3Qs6863RmaEra9_32XfkDJoeTW4nxYf3DsIkPCIroQip-2j8meRMbFaOryAhwPrj8a5bs4vihlxQ691pyt-AXeopr0b7VjMwTXLLGATkt3CBosSw9gF849acP0wYzGQ318wu9yU0CB8ufE4BeMUS__G1r5N3jckVW3pyxuixvs-FYRO-zNOw6wT7KPVtsfSEs-p16WQAiEQIOW6Xg8-qOJqe4K2voN3dGo3p5mFJB781LfFQdMUWULTUa2wIiWTh6qC3Bw9CFBxXdcALq8aFOu1oe39qjjBMsL2Q2Bz3I3I8gV3hranQ";
            URJWTParser *parser = [[URJWTParser alloc] initWithJWTToken:token];
            [[parser.payload shouldNot] beNil];
            [[parser.headers shouldNot] beNil];
            [[parser.payload[@"email"] shouldNot] beNil];
            [[parser.payload[@"email"] should] equal:@"adrai75@gmail.com"];
            [[parser.headers[@"alg"] shouldNot] beNil];
            [[parser.headers[@"alg"] should] equal:@"RS256"];
        });
    });
});

SPEC_END
