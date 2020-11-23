//
//  AppInfraTests.m
//  AppInfraTests
//
//  Created by Ravi Kiran HR on 4/4/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <XCTest/XCTest.h>

#import "AIStorageProviderProtocol.h"
#import "AIStorageProvider.h"
#import "AISSKeychainService.h"
#import "AISSUtility.h"
#import <OCMock/OCMock.h>
#import "AISSKeychainService.h"
#import "AISSCloneableClientGenerator.h"
#import "NSData+AISSStatementParser.h"

@interface TestClass : NSObject <NSCoding>

@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSData* data;
@property(nonatomic)int version;
@end

@implementation TestClass

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.data forKey:@"data"];
    [encoder encodeInt:self.version forKey:@"version"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.title = [decoder decodeObjectForKey:@"title"];
        self.data = [decoder decodeObjectForKey:@"data"];
        self.version = [decoder decodeIntForKey:@"version"];
    }
    return self;
}
@end

@interface NonCodedTestClass : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSData* data;
@property(nonatomic)int version;
@end

@implementation NonCodedTestClass

@end



@interface AISSSecureStorageTests : XCTestCase{

    
    id<AIStorageProviderProtocol> storageProvider;
}


@end

@implementation AISSSecureStorageTests

- (void)setUp {
    [super setUp];
     storageProvider =  [[AIStorageProvider alloc]init];
}

// test storeData with a valid key and data
- (void)testStoredata {
    NSString *strData = @"Test data to be encrypted and stored";
    
    [storageProvider storeValueForKey:@"test" value:strData error:nil];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test" error:nil];

    XCTAssertNotNil(strDecryptedData);
    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test storeData with a valid key and data
- (void)testStoredataWhenSecureKeyIsEmpty {
    NSString *strData = @"Test data to be encrypted and stored";
   
    [AISSKeychainService deleteValueForKey:@"KEYCHAIN-STORAGE-KEY" andtokenType:[AISSUtility serviceNameForTokenName:@"keychain_storage_token_type"] error:nil];
    
    [storageProvider storeValueForKey:@"test" value:strData error:nil];
    NSString *strDecryptedData = [storageProvider fetchValueForKey:@"test" error:nil];
    
    XCTAssertNotNil(strDecryptedData);
    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test storeData with a valid key and data
- (void)testNoncodedStoredata {
    NonCodedTestClass *customData = [[NonCodedTestClass alloc]init];
    customData.title =@"testtitle";
    customData.version=111;
    NSError *error;
    [storageProvider storeValueForKey:@"test" value:customData error:&error];
 
    XCTAssertNotNil(error);

    XCTAssertEqualObjects([error localizedDescription],@"Archiving data failed" );
}

// test storeData with empty key and data
- (void)testStoredataWithEmptyKey {
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@" "  value:strData error:nil];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@" "error:nil];

    XCTAssertNil(strDecryptedData);
}

// test storeData with empty key and with no data
- (void)testStoreNoDataWithEmptyKey {
    NSString *strData = @"";

    [storageProvider storeValueForKey:@""  value:strData error:nil];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@""error:nil];

    XCTAssertNil(strDecryptedData);
}

// test storeData API by calling multiple times
-(void)testMultipleStoreData
{
    NSString *strData;
    for(int intIndex=0;intIndex<10;intIndex++)
    {
        strData = @"Test data to be encrypted and stored";

        [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    }
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test"error:nil];

    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test storeData API by calling multiple times
-(void)testMultipleStoreFetch
{
    NSString *strData;
    NSString *strDecryptedData;
    for(int intIndex=0;intIndex<10;intIndex++)
    {
        strData = @"Test data to be encrypted and stored";

        [storageProvider storeValueForKey:@"test"  value:strData error:nil];
        strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test"error:nil];

    }
    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test storeData with a valid key with empty data
- (void)testStoredataWithEmptyValue {
    NSString *strData = @"";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test"error:nil];

    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test fetchdata with a valid key with data
-(void)testFetchData{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    NSString *strDecryptedData = [storageProvider fetchValueForKey:@"test"error:nil];

    XCTAssertEqualObjects(strData, strDecryptedData);
}

// test fetch Data with an invalid key with data
-(void)testFetchDataWithWrongKey{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test_wrong"error:nil];

    XCTAssertNil(strDecryptedData);
}

// test fetch Data with an empty key with data
-(void)testFetchDataWithEmptyKey{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    NSString *strDecryptedData = [storageProvider fetchValueForKey:@""error:nil];

    XCTAssertNil(strDecryptedData);
}

// test delete data with a key
-(void)testDeleteData
{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test2"  value:strData error:nil];
    [storageProvider removeValueForKey:@"test2"];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test2"error:nil];

    XCTAssertNil(strDecryptedData);
}

// test delete data with an invalid key
-(void)testDeleteDataWithWrongKey
{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    [storageProvider removeValueForKey:@"test_wrong"];
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test"error:nil];

    XCTAssertEqualObjects(strDecryptedData, strData);
}
// test storeData API by calling multiple times
-(void)testMultipleDelete
{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test_delete" value:strData error:nil];
    for(int intIndex=0;intIndex<10;intIndex++)
    {
        [storageProvider removeValueForKey:@"test_delete"];
    }
    NSString *strDecryptedData = (NSString *)[storageProvider fetchValueForKey:@"test_delete"error:nil];

    XCTAssertNil(strDecryptedData);
}


// test delete data with an invalid key
-(void)testDeleteDataWithEmptyKey
{
    NSString *strData = @"Test data to be encrypted and stored";

    [storageProvider storeValueForKey:@"test"  value:strData error:nil];
    [storageProvider removeValueForKey:@""];
    NSString *strDecryptedData = [storageProvider fetchValueForKey:@"test"error:nil];

    XCTAssertEqualObjects(strDecryptedData, strData);
}

-(void)testloadData{
    NSString* testString = @"string to be encrypted";
    NSData* inputData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [storageProvider loadData:inputData error:nil];
    XCTAssertNotNil(encryptedData);
    NSData *decryptedData = (NSData*)[storageProvider parseData:encryptedData error:nil];
    NSString *decryptedString = [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding];
     XCTAssertEqualObjects(testString, decryptedString);
}

-(void)testloadDataNillInput{
    NSError *error;
    NSData *encryptedData = (NSData *)[storageProvider loadData:nil error:&error];
    XCTAssertNil(encryptedData);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects([error localizedDescription], @"NullData");
}

-(void)testparseDataNillInput{
    
    NSError *error;
    NSData *encryptedData = (NSData *)[storageProvider parseData:nil error:&error];
    XCTAssertNil(encryptedData);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects([error localizedDescription], @"NullData");
}


-(void)testloadDataCustomObject{
    
    TestClass* inputData = [[TestClass alloc]init];
    inputData.title = @"Test Object";
    inputData.data = [inputData.title  dataUsingEncoding:NSUTF8StringEncoding];
    inputData.version = 3;
    
    NSData* encryptedData = [storageProvider loadData:inputData error:nil];
    XCTAssertNotNil(encryptedData);
    TestClass* decryptedData = (TestClass*)[storageProvider parseData:encryptedData error:nil];

    XCTAssertEqualObjects(decryptedData.title,  inputData.title);
    XCTAssertEqualObjects(decryptedData.data,  inputData.data);
    XCTAssertTrue(decryptedData.version == inputData.version);
}

-(void)testloadDataCustomObjectNonCoded{
    
    NonCodedTestClass* inputData = [[NonCodedTestClass alloc]init];
    inputData.title = @"Test Object";
    inputData.data = [inputData.title  dataUsingEncoding:NSUTF8StringEncoding];
    inputData.version = 3;
    
    NSError *error;
    NSData* encryptedData = [storageProvider loadData:inputData error:&error];
    XCTAssertNil(encryptedData);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects([error localizedDescription],@"Archiving data failed" );

}



-(void)testparseData{
    
    NSString* testString = @"string to be encrypted";
    NSData* inputData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [storageProvider loadData:inputData error:nil];
    NSData *decryptedData = (NSData*)[storageProvider parseData:encryptedData error:nil];
    XCTAssertNotNil(decryptedData);
    NSString *decryptedString = [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(testString, decryptedString);
}

-(void)testparseDataNoKey{
    NSString* testString = @"string to be encrypted";
    NSData* inputData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *keychainerror;
    [AISSKeychainService deleteValueForKey:@"KEYCHAIN-STORAGE-KEY"
                              andtokenType:[AISSUtility serviceNameForTokenName:@"keychain_storage_token_type"]
                                     error:&keychainerror];

    NSError *error;
    NSData *decryptedData = (NSData*)[storageProvider parseData:inputData error:&error];
    XCTAssertNil(decryptedData);
    XCTAssertNil(keychainerror);
    XCTAssertNotNil(error);
    XCTAssertTrue(error.code == 5);
    

}

-(void)testparseDataInvalidInput{
    
    NSString* testString = @"string to be encrypted";
    NSData* inputData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *decryptedData = (NSData*)[storageProvider parseData:inputData error:&error];
    XCTAssertNil(decryptedData);
    XCTAssertNotNil(error);
    XCTAssertTrue(error.code == 5);

}

-(void)testCurreptedKey{
    
    NSError *keychainerror;
    [AISSKeychainService deleteValueForKey:@"KEYCHAIN-STORAGE-KEY"
                              andtokenType:[AISSUtility serviceNameForTokenName:@"keychain_storage_token_type"]
                                     error:&keychainerror];
    

    
    id keyChainGeneratoe = [OCMockObject mockForClass:[AISSCloneableClientGenerator class]];
    [[[[keyChainGeneratoe stub] classMethod] andReturn:nil] generateSecureAccessKey];
     
     NSString* testString = @"string to be encrypted";
     NSData* inputData = [testString dataUsingEncoding:NSUTF8StringEncoding];
     NSError *error;
     NSData *decryptedData = (NSData*)[storageProvider parseData:inputData error:&error];
     XCTAssertNil(decryptedData);
     XCTAssertNotNil(error);
     XCTAssertTrue(error.code == 1);
}


-(void)testDecryptDecryptionError{
    
    id mockData = [OCMockObject niceMockForClass:[NSData class]];
    NSError *error;
    [(NSData*)[[mockData stub] andReturn:nil] AES256DecryptWithKey:nil error:&error];
    
    NSError *decError;
    NSData *decryptedData = (NSData*)[storageProvider parseData:mockData error:&decError];
    XCTAssertNil(decryptedData);
    XCTAssertNotNil(decError);
    XCTAssertTrue(decError.code == 3);

    
}

-(void)testDecryptValueWithoutEncrypting{
    [[NSUserDefaults standardUserDefaults]setObject:@"Test object" forKey:@"TestWithoutDecrypt"];
    NSError * errorToDecryptWithoutEncrypt = [[NSError alloc]init];
     id value  = [storageProvider fetchValueForKey:@"TestWithoutDecrypt" error:& errorToDecryptWithoutEncrypt];
     XCTAssertNil(value);
    XCTAssertTrue(errorToDecryptWithoutEncrypt.code == 9);
  }

-(void)testDecryptNSDataWithoutEncrypting{
    NSString* str = @"H";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"TestDataWithoutDecrypt"];
    NSError * errorToDecryptDataWithoutEncrypt = [[NSError alloc]init];
    id value  = [storageProvider fetchValueForKey:@"TestDataWithoutDecrypt" error:& errorToDecryptDataWithoutEncrypt];
    XCTAssertNil(value);
    XCTAssertTrue(errorToDecryptDataWithoutEncrypt.code == 3);
}

-(void)testDefaultFileStorage{
    NSDictionary *sampleDictionary = @{@"iOS": @{
                                               @"version": @{
                                                       @"minimumVersion": @"100.0.0",
                                                       @"deprecatedVersion": @"200.0.0",
                                                       @"deprecationDate": @"2019-07-12",
                                                       @"currentVersion": @"300.1.0"
                                                       },
                                               @"messages": @{
                                                       @"minimumVersionMessage": @"The current version is outdated in. Please update the app.",
                                                       @"sunsetVersionMessage": @"The current version will be outdated by 2019-07-12. Please update the app soon.",
                                                       @"currentVersionMessage": @"A new version is now available."
                                                       },
                                               @"requirements": @{
                                                       @"minimumOSVersion": @"9.0"
                                                       }
                                               }
                                       };
    
    NSError *error;
    [storageProvider storeDataToFile:@"/AIUtility/AIUtilityTest" type:@"pim" data:sampleDictionary error:&error];
    XCTAssertNil(error);
}

-(void)testDetectFileFetchWithSuccessCase{
    NSError *error;
    [storageProvider fetchDataFromFile:@"/AIUtility/AIUtilityTest" type:@"pim" error:&error];
    XCTAssertNil(error);
}

-(void)testFileFetchWithFailureCase{
    NSError *error;
    [storageProvider fetchDataFromFile:@"/AIUtility/AIFileNotExist" type:@"json" error:&error];
    XCTAssertNotNil(error);
}

-(void)testFileDeleteWithFailureCase{
    NSError *error;
    [storageProvider removeFileFromPath:@"/AIUtility/AIFileNotExist" type:@"json" error:&error];
    XCTAssertNotNil(error);
}

-(void)testFileDeleteWithSuccessCase{
    NSError *error;
    [storageProvider removeFileFromPath:@"/AIUtility/AIUtilityTest" type:@"pim" error:&error];
    XCTAssertNil(error);
}



@end
