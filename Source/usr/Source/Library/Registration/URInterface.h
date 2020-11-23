//
//  URInterface.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UAPPFramework/UAPPFramework.h>
@import PlatformInterfaces;

/**
 * This class defines methods of UAPPProtocol to allow applications be able to initialize `PhilipsRegistration` and/or instantiate appropriate UIViewController and launch user authentication process.
 *
 * @since 1.0.0
 */
@interface URInterface : NSObject<UAPPProtocol>
- (instancetype _Nonnull)init NS_UNAVAILABLE;
    
/**
* This interface shall include APIs to share user data.
* @return object conforming to UserDataInterface protocol
* @since 2018.1.0
 */
- (id<UserDataInterface> _Nonnull)userDataInterface;
    
@end
