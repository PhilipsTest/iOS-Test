////
////  AIRestCacheTests.m
////  AppInfra
////
////  Created by leslie on 31/08/16.
////  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
////
//
#import <XCTest/XCTest.h>
#import "AIAppInfra.h"
#import "AIRESTClientInterface.h"
#import "AIStorageProvider.h"
#import "AICustomURLCache.h"
#import "NSBundle+Bundle.h"
#import "AIRESTClientURLResponseSerialization.h"
#import <OCMock/OCMock.h>

@interface ResponseSerializerUtility : NSObject

+(NSData *)processResponse:(NSURLResponse *)response
                      data:(NSData *)data;

@end


@interface AIRestClientCachingTests : XCTestCase
{
    id<AIRESTClientProtocol> restClient;
}
@end

@implementation AIRestClientCachingTests

- (void)setUp {
    [super setUp];
    
    [NSBundle loadSwizzler];
    
    AIAppInfra * appInfra = [[AIAppInfra alloc]initWithBuilder:nil];
    restClient = appInfra.RESTClient;
}
-(void)testResponseShouldTryandDecrypt{
    AIRESTClientHTTPResponseSerializer *httpSerializer = [[AIRESTClientHTTPResponseSerializer alloc]init];
    NSData *data = [@"testasdadad" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                       MIMEType:nil
                                          expectedContentLength:data.length
                                               textEncodingName:nil];
    NSError *error;
   NSData *responseData =[httpSerializer responseObjectForResponse:response data:data error:&error];
    XCTAssertEqualObjects(data, responseData);
    
}
-(void)testResponseJsonShouldTryandDecrypt{
    AIRESTClientJSONResponseSerializer *serializer = [[AIRESTClientJSONResponseSerializer alloc]init];
    NSDictionary *testDict =@{@"key":@"value"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:testDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                       MIMEType:nil
                                          expectedContentLength:data.length
                                               textEncodingName:nil];
    NSError *error;
    NSDictionary *responseData =[serializer responseObjectForResponse:response data:data error:&error];
    XCTAssertEqualObjects(responseData[@"key"], @"value");
    
}

-(void)testResponsePlistShouldTryandDecrypt{
    AIRESTClientPropertyListResponseSerializer *serializer = [[AIRESTClientPropertyListResponseSerializer alloc]init];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"Info" ofType:@"plist"]];
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                       MIMEType:nil
                                          expectedContentLength:data.length
                                               textEncodingName:nil];
    NSError *error;
    NSDictionary *responseData =[serializer responseObjectForResponse:response data:data error:&error];
    XCTAssertEqualObjects( responseData[@"CFBundleName"], @"AppInfraTests");
    
}

-(void)testResponseXMLShouldTryandDecrypt{
    AIRESTClientXMLParserResponseSerializer *serializer = [[AIRESTClientXMLParserResponseSerializer alloc]init];
    NSString *xml = @"<note><name>AppInfraTests</name></note>";
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                       MIMEType:nil
                                          expectedContentLength:data.length
                                               textEncodingName:nil];
    NSError *error;
    NSXMLParser *responseData =[serializer responseObjectForResponse:response data:data error:&error];
    
    //responseData.delegate = self;
    //[responseData parse];
    
    id mockDelegate = OCMProtocolMock(@protocol(NSXMLParserDelegate));
    responseData.delegate = mockDelegate;
    OCMExpect([mockDelegate parser:responseData didEndElement:@"note" namespaceURI:OCMOCK_ANY qualifiedName:OCMOCK_ANY   ]);
    OCMExpect([mockDelegate parser:responseData didEndElement:@"name" namespaceURI:OCMOCK_ANY qualifiedName:OCMOCK_ANY   ]);
    [responseData parse];
    OCMVerifyAll(mockDelegate);

    
}

-(void)testResponseShouldTryandDecryptwithCache{
    AIRESTClientHTTPResponseSerializer *httpSerializer = [[AIRESTClientHTTPResponseSerializer alloc]init];
    NSData *data = [@"testasdadad" dataUsingEncoding:NSUTF8StringEncoding];
    
    AIStorageProvider * storageProvider = [[AIStorageProvider alloc]init];
    NSError * decryptError;
    NSData * encrypted;

        @try {
             encrypted = [storageProvider loadData:data error:&decryptError];

        }
        @catch (NSException *exception){
            
        }
    
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[NSURL URLWithString:@"http://example.com"]
                                                       MIMEType:nil
                                          expectedContentLength:encrypted.length
                                               textEncodingName:nil];
    NSError *error;
    NSData *responseData =[httpSerializer responseObjectForResponse:response data:encrypted error:&error];
    XCTAssertEqualObjects(data, responseData);

}

//
//-(void)testImageGET {
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
//    [restClient GET:@"https://upload.wikimedia.org/wikipedia/commons/d/da/Internet2.jpg" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        UIImage * image = [UIImage imageWithData:responseObject];
//        NSLog(@"dss");
//        [expectation fulfill];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error.localizedDescription);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
//        
//    }];
//}
//
//-(void)testResponseCache
//{
//    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache"]];
//    
//    NSURLSessionDataTask *dataTask = [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSDictionary * dict = (NSDictionary *)responseObject;
//        NSLog(@"%@",dict);
//        
//        [expectation fulfill];
//    }];
//    
//     [dataTask resume];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
//        
//    }];
//}
//
//-(void)testCacheEncryptionDataTaskJSONSerializer {
//        
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache"]];
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    
//    XCTestExpectation *expectation =[self expectationWithDescription:@"Expectations"];
//    
//    NSURLSessionDataTask *dataTask = [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSLog(@"Success: %@", (NSDictionary *)responseObject);
//        
//        [expectation fulfill];
//    }];
//    [dataTask resume];
//    
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//    sleep(2);
//
//
//    XCTestExpectation *expectation1 =[self expectationWithDescription:@"Expectations1"];
//    
//    NSURLSessionDataTask *dataTask1 = [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSLog(@"Success: %@", (NSDictionary *)responseObject);
//        
//        [expectation1 fulfill];
//    }];
//    [dataTask1 resume];
//    
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//
//}
//
//-(void)testCacheEncryptionDataTaskHTTPSerializer {
//    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache"]];
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    
//    XCTestExpectation *expectation =[self expectationWithDescription:@"Expectations"];
//    
//    NSURLSessionDataTask *dataTask = [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        
//        [expectation fulfill];
//    }];
//    [dataTask resume];
//    
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//    sleep(2);
//    
//    
//    XCTestExpectation *expectation1 =[self expectationWithDescription:@"Expectations1"];
//    
//    NSURLSessionDataTask *dataTask1 = [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        
//        [expectation1 fulfill];
//    }];
//    [dataTask1 resume];
//    
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//    
//}
//
//
//-(void)testCacheEncryptionGETJSONSerializer {
//    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    id<AIRESTClientProtocol> restClientNew = [restClient createInstanceWithBaseURL:nil sessionConfiguration:config withCachePolicy:AIRESTURLRequestUseProtocolCachePolicy];
//    
//    XCTestExpectation *expectation =[self expectationWithDescription:@"Expectations"];
//    
//    [restClientNew GET:@"https://hashim.herokuapp.com/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"Success: %@", (NSDictionary *)responseObject);
//        
//        [expectation fulfill];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Failure: %@", error);
//    }];
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//    
//    sleep(2);
//    
//    XCTestExpectation *expectation1 =[self expectationWithDescription:@"Expectations"];
//    
//    [restClientNew GET:@"https://hashim.herokuapp.com/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"Success: %@", (NSDictionary *)responseObject);
//        
//        [expectation1 fulfill];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Failure: %@", error);
//    }];
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//}
//
//-(void)testCacheEncryptionGETHTTPSerializer {
//    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    id<AIRESTClientProtocol> restClientNew = [restClient createInstanceWithBaseURL:nil sessionConfiguration:config withCachePolicy:AIRESTURLRequestUseProtocolCachePolicy];
//    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    
//    XCTestExpectation *expectation =[self expectationWithDescription:@"Expectations"];
//    
//    [restClientNew GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        
//        [expectation fulfill];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Failure: %@", error);
//    }];
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//    
//    sleep(2);
//    
//    XCTestExpectation *expectation1 =[self expectationWithDescription:@"Expectations"];
//    
//    [restClientNew GET:@"https://www.oldchaphome.nl/RCT/test.php?action=timewithcache" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        
//        [expectation1 fulfill];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Failure: %@", error);
//    }];
//    [self waitForExpectationsWithTimeout:100.0 handler:^(NSError *error) {
//        
//    }];
//}
//
@end
