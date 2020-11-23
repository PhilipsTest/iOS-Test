//
//  DBLoggingComponent.m
//  AppInfraTests
//
//  Created by Philips on 11/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "AILogging.h"
#import "AILoggingProtocol.h"
#import <CocoaLumberjack/DDLog.h>
#import "AILogMetaData.h"
#import "NSBundle+Bundle.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AppInfra.h"
@import CoreData;

//#import "AILoggingManager"

@interface DBLoggingComponent : XCTestCase
@property(nonatomic,strong)AILogCoreDataStack* sut;
@property(nonatomic,strong)NSManagedObjectModel* managedObjectModel;
@property(nonatomic,strong)NSPersistentContainer* container;
@end

@implementation DBLoggingComponent

- (void)setUp {
    [super setUp];
    NSArray* bundles = [[NSArray alloc]initWithObjects:[NSBundle bundleForClass:[self class]], nil];
    _managedObjectModel =  [NSManagedObjectModel mergedModelFromBundles:bundles];
    _container = [NSPersistentContainer persistentContainerWithName:@"AILogging" managedObjectModel:_managedObjectModel];
    [self.container loadPersistentStoresWithCompletionHandler:
     ^(NSPersistentStoreDescription *storeDescription, NSError *error) {
         if (error != nil) {
             NSLog(@"Failed to load store: %@", error);
             abort();
         }
         
     }];
    _sut = [AILogCoreDataStack shared];
    _sut.managedObjectContext = [self.container newBackgroundContext];
}

-(void)testManageObjectContext{
    XCTAssertNotNil([_sut managedObjectContext],"managedObjectContext returned is nil despite registering it with newBackgroundContext");
}
/*
-(void)testCloudLoggingShouldStoreDataInDB{
    id config = OCMClassMock([AILoggingConfig class]);
    AIAppInfra *appInfra = OCMClassMock([AIAppInfra class]);
    OCMStub([config setCloudLogEnabled:YES]);
    id configProtocolMock  = OCMProtocolMock(@protocol(AIAppConfigurationProtocol));
    id appIdentityProtocolMock  = OCMProtocolMock(@protocol(AIAppIdentityProtocol));
    OCMStub([appIdentityProtocolMock getAppState]).andReturn(AIAIAppStateTEST);
    NSArray * component = [[NSArray alloc]initWithObjects:@"CM1",@"CM2", nil];
    NSDictionary *logConfigDic = @{ @"componentIds" : component,
                                     @"componentLevelLogEnabled" : @1,
                                    @"cloudLogEnabled":@1,
                                    @"cloudBatchLimit":@26,
                                    @"consoleLogEnabled":@1,
                                    @"fileName": @"AppInfraLog",
                                    @"fileSizeInBytes":@5000,
                                    @"logLevel": @"All",
                                    @"numberOfFiles":@5};
    
    OCMStub([configProtocolMock getPropertyForKey:@"logging.debugConfig" group:@"appinfra" error:[OCMArg anyObjectRef]]).andReturn(logConfigDic);
    OCMStub([appInfra appConfig]).andReturn(configProtocolMock);
    OCMStub([appInfra appIdentity]).andReturn(appIdentityProtocolMock);
    AILogging * logger = [[AILogging alloc]initWithAppInfra:appInfra];
    NSString * testForDBInsertion = @"TestForBDInsertion";
    [logger log:AILogLevelWarning eventId:@"event111" message:testForDBInsertion];
    NSArray * items = [self getItemsFromDB];
    AILog * value = [items firstObject];
    XCTAssertTrue([[value eventID] isEqualToString:@"event111"],
                  @"Strings are not equal %@ %@", @"event111", [value eventID]);
    XCTAssertTrue([[value logDescription] isEqualToString:@"TestForBDInsertion"],
                  @"Strings are not equal %@ %@", @"TestForBDInsertion", [value eventID]);
    
}

*/
-(NSArray *)getItemsFromDB{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AILog"];
    
    NSArray *items = [[_sut managedObjectContext] executeFetchRequest:request error:nil];
    return items;
}

@end
