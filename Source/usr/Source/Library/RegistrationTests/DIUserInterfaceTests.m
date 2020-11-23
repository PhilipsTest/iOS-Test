//
//  DIUserInterface.m
//  RegistrationTests
//
//  Created by Nikilesh on 1/30/18.
//  Copyright © 2018 Philips. All rights reserved.
//
@import PlatformInterfaces;
#import "DIUser+DataInterface.h"
#import "JanrainService.h"
#import "URSettingsWrapper.h"
#import "HSDPService.h"
#import "HSDPUser.h"
#import "JRCapture.h"
#import "Kiwi.h"

SPEC_BEGIN(UserInterface)

describe(@"DIUser+DataInterface ", ^{
    
    context (@"HSDPAccessToken", ^{
        __block DIUser *userHandler;
        __block HSDPUser *mockedHSDPUser;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            mockedHSDPUser = [HSDPUser mock];
            [mockedHSDPUser stub:@selector(userUUID) andReturn:theValue(@"dummyid")];
            [userHandler setValue:mockedHSDPUser forKeyPath:@"hsdpUser"];
        });
        
        afterEach(^{
            [mockedHSDPUser clearStubs];
        });
        
        it(@"should return HSDP access token", ^{
            [mockedHSDPUser stub:@selector(accessToken) andReturn:theValue(@"dummytoken")];
            [[[userHandler hsdpAccessToken]  should] equal:@"dummytoken"];
        });
    });
    
    
    context (@"HSDPUUID", ^{
        __block DIUser *userHandler;
        __block HSDPUser *mockedHSDPUser;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            mockedHSDPUser = [HSDPUser mock];
            [mockedHSDPUser stub:@selector(userUUID) andReturn:theValue(@"dummyid")];
            [userHandler setValue:mockedHSDPUser forKeyPath:@"hsdpUser"];
        });
        
        afterEach(^{
            [mockedHSDPUser clearStubs];
        });
        
        it(@"should return HSDP User id", ^{            
            [[[userHandler hsdpUUID] should] equal:@"dummyid"];
        });
    });
    
    
    context (@"JanrainUUID", ^{
        __block DIUser *userHandler;
        __block JRCaptureUser *mockedUserProfile;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            mockedUserProfile = [JRCaptureUser mock];
            NSDictionary *dict = @{ @"uuid" : @"dummyid"};
            [userHandler stub:@selector(userDetails:error:) andReturn:dict];
            [userHandler setValue:mockedUserProfile forKeyPath:@"userProfile"];
        });
        
        afterEach(^{
            [mockedUserProfile clearStubs];
        });
        
        it(@"should return Janrain User id", ^{
            
            NSDictionary *userDetails = [userHandler userDetails:@[UserDetailConstants.UUID] error:nil];
            [[userDetails[UserDetailConstants.UUID]  should] equal:@"dummyid"];
        });
    });
    
    
    context (@"user logged in", ^{
        __block DIUser *userHandler;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
        });
        
        it(@"should return true if user is logged in", ^{
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            
            [[theValue([userHandler userLoggedInState]) should] equal:theValue(UserLoggedInStateUserLoggedIn)];
        });
    });
    
    
    context (@"method userDetails when user is logged in and data is present", ^{
        __block DIUser *userHandler;
        __block JRCaptureUser *user;
        __block NSDictionary *userDetails;
        NSDateComponents *userBirthday = [[NSDateComponents alloc] init];
        [userBirthday setDay:10];
        [userBirthday setMonth:10];
        [userBirthday setYear:2010];
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            user = [JRCaptureUser new];
            user.givenName = @"Thundergod";
            user.familyName = @"Zeus";
            user.email = @"thundergod.zeus@thundergod.com";
            user.gender = @"MALE";
            user.birthday = [[NSCalendar currentCalendar] dateFromComponents:userBirthday];
            user.mobileNumber = @"1234567890";
            user.receiveMarketingEmail = [NSNumber numberWithBool:true];
            [userHandler setValue:user forKey:@"userProfile"];
        });
        
        afterEach(^{
            [user clearStubs];
        });
        
        it(@"should return a dictionary with all data", ^{
            NSError  *errorObj;
            NSArray *emptyarray = [[NSArray alloc] init];
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            
            userDetails = [userHandler userDetails:nil error:&errorObj];
            [[errorObj should] beNil];
            [[theValue([userDetails count]) should] equal:theValue(8)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL]  should] equal:[NSNumber numberWithBool:true] ];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.GENDER]  should] equal:@"MALE"];
            [[[userDetails valueForKey:UserDetailConstants.ACCESS_TOKEN]  should] equal:@"dummyAccessToken"];

            [[theValue([userDetails valueForKey:UserDetailConstants.BIRTHDAY]) should] equal:theValue([[NSCalendar currentCalendar] dateFromComponents:userBirthday])];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER]  should] equal:@"1234567890"];
            
            userDetails = [userHandler userDetails:emptyarray error:&errorObj];
            [[errorObj should] beNil];
            [[theValue([userDetails count]) should] equal:theValue(8)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL]  should] equal:[NSNumber numberWithBool:true] ];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.GENDER]  should] equal:@"MALE"];
            [[theValue([userDetails valueForKey:UserDetailConstants.BIRTHDAY]) should] equal:theValue([[NSCalendar currentCalendar] dateFromComponents:userBirthday])];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER]  should] equal:@"1234567890"];
        });
        
        it(@"should not return those data which is not asked", ^{
            NSArray *userKeys = @[UserDetailConstants.EMAIL];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[errorObj should] beNil];
            [[theValue([userDetails count]) should] equal:theValue(1)];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.GENDER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.BIRTHDAY] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL] should] beNil];
        });
        
        it(@"should return those data which is being asked", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.GENDER, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[errorObj should] beNil];
            [[theValue([userDetails count]) should] equal:theValue(7)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL]  should] equal:[NSNumber numberWithBool:true] ];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.GENDER]  should] equal:@"MALE"];
            [[theValue([userDetails valueForKey:UserDetailConstants.BIRTHDAY]) should] equal:theValue([[NSCalendar currentCalendar] dateFromComponents:userBirthday])];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER]  should] equal:@"1234567890"];
        });
        
        it(@"should return an error object initilized with UserDetailErrorInvalidFields when invalid keys are mixed with valid keys", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.GENDER, @"isVerified", UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorInvalidFields)];
        });
        
        it(@"should return an error object initilized with UserDetailErrorInvalidFields when keys sent are invalid ", ^{
            NSArray *userKeys = @[@"isVerified"];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorInvalidFields)];
        });
        
        it(@"should return an error object initilized with UserDetailErrorInvalidFields when 3invalid keys are mixed with 3valid keys", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, @"isVerified", UserDetailConstants.FAMILY_NAME, @"thundergod", UserDetailConstants.GENDER, @"dhgjhd"];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorInvalidFields)];
        });
    });
    
    
    context (@"method userDetails when user is not logged in", ^{
        __block DIUser *userHandler;
        __block JRCaptureUser *user;
        __block NSDictionary *userDetails;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            user = [JRCaptureUser new];
            [userHandler setValue:user forKey:@"userProfile"];
        });
        
        afterEach(^{
            [user clearStubs];
        });
        
        it(@"should return an error object initilized with UserDetailErrorNotLoggedIn", ^{
            NSError  *errorObj;
            
            userDetails = [userHandler userDetails:nil error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorNotLoggedIn)];
        });
        
        it(@"should return an error object initilized with UserDetailErrorNotLoggedIn when all valid keys are sent", ^{
            NSError  *errorObj;
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.GENDER, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY];
            
            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorNotLoggedIn)];
        });
        
        it(@"should return an error object initilized with UserDetailErrorNotLoggedIn when Invalid keys are sent", ^{
            NSError  *errorObj;
            NSArray *userKeys = @[@"thundergod"];
            
            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorNotLoggedIn)];
        });
    });
    
    
    context (@"method userDetails when only partial data(givenName, FamilyName, Email) is present and user is loggged in ", ^{
        __block DIUser *userHandler;
        __block JRCaptureUser *user;
        __block NSDictionary *userDetails;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            user = [JRCaptureUser new];
            user.givenName = @"Thundergod";
            user.familyName = @"Zeus";
            user.email = @"thundergod.zeus@thundergod.com";
            [userHandler setValue:user forKey:@"userProfile"];
        });
        
        afterEach(^{
            [user clearStubs];
        });
        
        it(@"should return those data which are available when nil is passed as arguments", ^{
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:nil error:&errorObj];
            [[theValue([userDetails count]) should] equal:theValue(4)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.GENDER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.BIRTHDAY] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.USER_ERROR_DOMAIN] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.ACCESS_TOKEN] should] equal:@"dummyAccessToken"];

        });
        
        it(@"should return those data which are available when all keys are passed as arguments", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.GENDER, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY, UserDetailConstants.ACCESS_TOKEN, UserDetailConstants.UUID];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[errorObj should] beNil];
            [[theValue([userDetails count]) should] equal:theValue(4)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
            [[[userDetails valueForKey:UserDetailConstants.ACCESS_TOKEN] should] equal:@"dummyAccessToken"];
            [[[userDetails valueForKey:UserDetailConstants.GENDER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.MOBILE_NUMBER] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.BIRTHDAY] should] beNil];
            [[[userDetails valueForKey:UserDetailConstants.USER_ERROR_DOMAIN] should] beNil];
        });
        
        it(@"should return an error object initialized with UserDetailErrorInvalidFields when one key is invalid", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.GENDER, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY,UserDetailConstants.ACCESS_TOKEN, UserDetailConstants.UUID,@"isVerified"];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[userDetails should] beNil];
            [[errorObj shouldNot] beNil];
            [[theValue([errorObj code]) should] equal:theValue(UserDetailErrorInvalidFields)];
        });
    });
    
    
    context (@"method userDetails when only partial data(givenName, FamilyName, Email) is present and duplicate key is given ", ^{
        __block DIUser *userHandler;
        __block JRCaptureUser *user;
        __block NSDictionary *userDetails;
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            user = [JRCaptureUser new];
            user.givenName = @"Thundergod";
            user.familyName = @"Zeus";
            user.email = @"thundergod.zeus@thundergod.com";
            [userHandler setValue:user forKey:@"userProfile"];
        });
        
        afterEach(^{
            [user clearStubs];
        });
        
        it(@"should return only those data without any duplicate keys", ^{
            NSArray *userKeys = @[UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.EMAIL, UserDetailConstants.GIVEN_NAME ];
            NSError  *errorObj;
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];

            userDetails = [userHandler userDetails:userKeys error:&errorObj];
            [[theValue([userDetails count]) should] equal:theValue(3)];
            [[[userDetails valueForKey:UserDetailConstants.GIVEN_NAME]  should] equal:@"Thundergod"];
            [[[userDetails valueForKey:UserDetailConstants.FAMILY_NAME]  should] equal:@"Zeus"];
            [[[userDetails valueForKey:UserDetailConstants.EMAIL]  should] equal:@"thundergod.zeus@thundergod.com"];
        });
    });
    
    context (@"method updateUserDetails, when user is logged in ", ^{
        __block DIUser *userHandler;
        __block JanrainService *mockedJanrainService;
        __block id userDataInterfaceListeners;
        NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
        NSDateComponents *userBirthday = [[NSDateComponents alloc] init];
        [userBirthday setDay:10];
        [userBirthday setMonth:10];
        [userBirthday setYear:2010];
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            mockedJanrainService = [JanrainService mock];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userDetails removeAllObjects];
            [userHandler removeUserDataInterfaceListener:userDataInterfaceListeners];
        });
        
        it(@"should receive an success callback when updation is successfull", ^{
            [userDetails setObject:@"Thundergod" forKey:UserDetailConstants.GIVEN_NAME];
            [userDetails setObject:@"Zeus" forKey:UserDetailConstants.FAMILY_NAME];
            [userDetails setObject:@"MALE" forKey:UserDetailConstants.GENDER];
            [userDetails setObject:[[NSCalendar currentCalendar] dateFromComponents:userBirthday]  forKey:UserDetailConstants.BIRTHDAY];
            [userDetails setObject:[NSNumber numberWithBool:true]  forKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL];
            
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            userDataInterfaceListeners = [KWMock mockForProtocol:@protocol(UserDataDelegate)];
            [userHandler addUserDataInterfaceListener:userDataInterfaceListeners];
            [[userDataInterfaceListeners shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(updateUserDetailsSuccess)];
            
            [mockedJanrainService stub:@selector(updateFields:forUser:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[2];
                successHandler([JRCaptureUser new], YES);
                return nil;
            }];
            
            [userHandler stub:@selector(checkIfJanrainFlowDownloadedWithCompletion:) withBlock:^id(NSArray *params) {
                void (^completion)(NSError* ) = params[0];
                completion(nil);
                return nil;
                
            }];
            
            [userHandler updateUserDetails:userDetails];
        });
        
        it(@"should receive an error callback when updation is error", ^{
            [userDetails setObject:@"Thundergod" forKey:UserDetailConstants.GIVEN_NAME];
            [userDetails setObject:@"Zeus" forKey:UserDetailConstants.FAMILY_NAME];
            [userDetails setObject:@"MALE" forKey:UserDetailConstants.GENDER];
            [userDetails setObject:[[NSCalendar currentCalendar] dateFromComponents:userBirthday]  forKey:UserDetailConstants.BIRTHDAY];
            [userDetails setObject:[NSNumber numberWithBool:true]  forKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL];
            
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            userDataInterfaceListeners = [KWMock mockForProtocol:@protocol(RefetchUserDetailsDelegate)];
            [userHandler addUserDataInterfaceListener:userDataInterfaceListeners];
            [[userDataInterfaceListeners shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(updateUserDetailsFailed:)];
            
            [userDataInterfaceListeners stub:@selector(updateUserDetailsFailed:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                [[theValue([error code]) should] equal:theValue(UserDetailErrorInvalidFields)];
                return nil;
            }];
            
            [userHandler stub:@selector(checkIfJanrainFlowDownloadedWithCompletion:) withBlock:^id(NSArray *params) {
                void (^completion)(NSError* ) = params[0];
                NSError *error = [NSError errorWithDomain:@"Dummy URError" code:UserDetailErrorInvalidFields userInfo:@{NSLocalizedDescriptionKey:@"dummy error", NSLocalizedFailureReasonErrorKey:@"dummy error"}];
                completion(error);
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(updateFields:forUser:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[3];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3001 userInfo:nil]);
                return nil;
            }];
            
            [userHandler updateUserDetails:userDetails];
        });
        
        it(@"should receive an error callback when invalid key is sent", ^{
            [userHandler stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            [userDetails setObject:@"dummyValue" forKey:@"dummykey"];
            userDataInterfaceListeners = [KWMock mockForProtocol:@protocol(RefetchUserDetailsDelegate)];
            [userHandler addUserDataInterfaceListener:userDataInterfaceListeners];
            [[userDataInterfaceListeners shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(updateUserDetailsFailed:)];
            
            [userDataInterfaceListeners stub:@selector(updateUserDetailsFailed:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                [[theValue([error code]) should] equal:theValue(UserDetailErrorInvalidFields)];
                return nil;
            }];
            
            [userHandler updateUserDetails:userDetails];
        });
    });
    
    
    context (@"method updateUserDetails when user is not logged in ", ^{
        __block DIUser *userHandler;
        __block id userDataInterfaceListeners;
        NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
        
        beforeEach(^{
            userHandler = [DIUser getInstance];
            [userDetails setObject:@"Thundergod" forKey:UserDetailConstants.GIVEN_NAME];
            [userDetails setObject:[NSNumber numberWithBool:true]  forKey:UserDetailConstants.RECEIVE_MARKETING_EMAIL];
        });
        
        afterEach(^{
            [userDetails removeAllObjects];
            [userHandler removeUserDataInterfaceListener:userDataInterfaceListeners];
        });
        
        it(@"should receive an error callback when user is logged out", ^{
            userDataInterfaceListeners = [KWMock mockForProtocol:@protocol(RefetchUserDetailsDelegate)];
            [userHandler addUserDataInterfaceListener:userDataInterfaceListeners];
            [[userDataInterfaceListeners shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(updateUserDetailsFailed:)];
            
            [userDataInterfaceListeners stub:@selector(updateUserDetailsFailed:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                [[theValue([error code]) should] equal:theValue(UserDetailErrorNotLoggedIn)];
                return nil;
            }];
            
            [userHandler updateUserDetails:userDetails];
        });
    });
});

SPEC_END
