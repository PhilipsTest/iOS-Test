//
//  StorageProvider.h
// App Infra
//
//  Created by Adarsh Kumar Rai Modified by Ravi Kiran HR on 29/01/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <Foundation/Foundation.h>
#import "AIStorageProviderProtocol.h"
#define AISSSecureStorage    AIStorageProvider

@interface AISSSecureStorage : NSObject <AIStorageProviderProtocol>

@end
