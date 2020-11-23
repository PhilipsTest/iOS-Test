//
//  DIUser+PrivateData.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DIUser.h"
#import "JRCaptureUser+Extras.h"
#import "JRCaptureUser+Utility.h"
#import "DIUser+DataInterface.h"
#import "JRCaptureData.h"
#import "JRCapture.h"
#import "JRCaptureError.h"
#import "HSDPUser.h"
#import "HSDPService.h"
#import "JanrainService.h"
#import "URServiceDiscoveryWrapper.h"
#import "URGoogleLoginHandler.h"
#import "FBSDKLoginHandler.h"


@interface DIUser(){
    NSString *socialRegistrationToken;
    NSString *mergeRegistrationToken;
}

@property (nonatomic, strong) JRCaptureUser *userProfile;
@property (nonatomic, strong) HSDPUser *hsdpUser;
@property (nonatomic, strong) NSHashTable *userRegistrationListeners;
@property (nonatomic, strong) NSHashTable *userDetailsListeners;
@property (nonatomic, strong) NSHashTable *sessionRefreshListeners;
@property (nonatomic, strong) NSHashTable *userDataInterfaceListeners;
@property (nonatomic, strong) NSHashTable *hsdpUserDataInterfaceListeners;
@property (nonatomic, strong) URServiceDiscoveryWrapper *serviceDiscoveryWrapper;
@property (nonatomic, strong) HSDPService *hsdpService;
@property (nonatomic, strong) JanrainService *janrainService;
@property (nonatomic, strong) dispatch_queue_t suspendableWaitingQueue;
@property (nonatomic, strong) NSOperationQueue *suspendableUpdateQueue;
@property (nonatomic, assign) BOOL isCompleteFlowDownloaded;
@property (nonatomic, strong) URGoogleLoginHandler *googleLoginHandler;
@property (nonatomic, strong) FBSDKLoginHandler *fbLoginHandler;
@property (nonatomic, strong) URAppleSignInHandler *appleSignInHandler API_AVAILABLE(ios(13.0));

- (void)sendMessage:(SEL)selector toListeners:(NSHashTable *)listeners withObject:(id)object1 andObject:(id)object2;
- (void)storeUserProfile:(JRCaptureUser *)newCaptureUser;
- (void)storeHSDPUser:(HSDPUser *)user;
- (void)clearUserData;
- (void)performHSDPSignIn:(void(^)(BOOL success, NSError *error))completion;
@end

