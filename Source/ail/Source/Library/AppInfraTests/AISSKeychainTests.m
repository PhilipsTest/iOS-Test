//
//  secKeychainTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 4/6/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <XCTest/XCTest.h>
#import "AISSKeychainService.h"

@interface AISSKeychainTests : XCTestCase

@end

@implementation AISSKeychainTests

// test store data into keychain with valid token and key
- (void)testStoreDataIntoKeychainWithValidKeyWithToken {
    
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
}

// test store nil data into keychain with valid token and key
- (void)testStoreNilDataIntoKeychainWithValidKeyWithToken {
    
    BOOL blnReturn = [AISSKeychainService storeValue:nil forKey:@"test" andTokenType:@"testToken"];
    XCTAssertFalse(blnReturn);
}


// test store data into keychain with valid token with no key
- (void)testStoreDataIntoKeychainWithNoKeyWithToken
{
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:nil andTokenType:@"testToken"];
    XCTAssertFalse(blnReturn);
}

// test store data into keychain with No token with  key
- (void)testStoreDataIntoKeychainWithKeyWithNoToken
{
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:nil];
    XCTAssertFalse(blnReturn);
}


// test store data into keychain with valid no token with no key
- (void)testStoreDataIntoKeychainWithNoKeyWithNoToken
{
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:nil andTokenType:nil];
    XCTAssertFalse(blnReturn);
}

// test fetch from keychain with valid token and key
- (void)testFetchDataFromKeychainWithValidKeyWithToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
}

// test fetch from keychain with valid token and invalid key
- (void)testFetchDataFromKeychainWithInValidKeyWithToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test_invalid" error:nil];
    XCTAssertNil(fetchedData);
}

// test fetch from keychain with invalid token and valid key
- (void)testFetchDataFromKeychainWithValidKeyWithInvalidToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken_invalid" andKey:@"test" error:nil];
    XCTAssertNil(fetchedData);
}

// test fetch from keychain with invalid token and invalid key
- (void)testFetchDataFromKeychainWithInValidKeyWithInvalidToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken_invalid" andKey:@"test_invalid" error:nil];
    XCTAssertNil(fetchedData);
}

// test fetch from keychain with valid token and with No key
- (void)testFetchDataFromKeychainWithNoKeyWithvalidToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:nil error:nil];
    XCTAssertNil(fetchedData);
}

// test fetch from keychain with No token and with valid key
- (void)testFetchDataFromKeychainWithKeyWithNoToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:nil andKey:@"test" error:nil];
    XCTAssertNil(fetchedData);
}

// test fetch from keychain with No token and with No key
- (void)testFetchDataFromKeychainWithNoKeyWithNoToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:nil andKey:nil error:nil];
    XCTAssertNil(fetchedData);
}

// test delete from keychain with valid token and key
- (void)testDeleteDataFromKeychainWithValidKeyWithValidToken {
    // store
    NSString *strData = @"test Data to be stored";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    BOOL blnDeleted = [AISSKeychainService deleteValueForKey:@"test" andtokenType:@"testToken" error:nil];
    XCTAssertTrue(blnDeleted);
}

// test delete from keychain with Invalid token and key
- (void)testDeleteDataFromKeychainWithValidKeyWithInValidToken {
    // store
    NSString *strData = @"test Data to be deleted_1";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:@"test" andtokenType:@"testToken_Invalid" error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
    
}

// test delete from keychain with valid token and invalid key
- (void)testDeleteDataFromKeychainWithInValidKeyWithValidToken {
    // store
    NSString *strData = @"test Data to be deleted_2";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:@"test_Invalid" andtokenType:@"testToken" error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
    
}

// test delete from keychain with Invalid token and invalid key
- (void)testDeleteDataFromKeychainWithInValidKeyWithInValidToken {
    // store
    NSString *strData = @"test Data to be deleted_2_2";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:@"test_Invalid" andtokenType:@"testToken_invalid" error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
    
}
// test delete from keychain with Invalid token and No key
- (void)testDeleteDataFromKeychainWithNoKeyWithValidToken {
    // store
    NSString *strData = @"test Data to be deleted_3";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:nil andtokenType:@"testToken" error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
}
// test delete from keychain with No token and valid key
- (void)testDeleteDataFromKeychainWithValidKeyWithNoToken {
    // store
    NSString *strData = @"test Data to be deleted_4";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:@"test" andtokenType:nil error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
}
// test delete from keychain with No token and No key
- (void)testDeleteDataFromKeychainWithNoKeyWithNoToken {
    // store
    NSString *strData = @"test Data to be deleted_5";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    BOOL blnReturn = [AISSKeychainService storeValue:data forKey:@"test" andTokenType:@"testToken"];
    XCTAssertTrue(blnReturn);
    // fetch
    [AISSKeychainService deleteValueForKey:nil andtokenType:nil error:nil];
    
    NSData *fetchedData = [AISSKeychainService getValueForTokenType:@"testToken" andKey:@"test" error:nil];
    XCTAssertEqualObjects(data, fetchedData);
}

@end
