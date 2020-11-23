//
//  DIUser+DataInterface.h
//  PhilipsRegistration
//
//  Created by Nikilesh on 1/29/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "DIUser.h"
@import PlatformInterfaces;

@interface DIUser (DataInterface) <UserDataInterface>

@property (readonly, nullable, copy) NSString *hsdpAccessToken;
@property (readonly, nullable, copy) NSString *hsdpUUID;

@end

@interface DIUser (HSDPUserDataInterface) <HSDPUserDetailsProtocol>

@end



