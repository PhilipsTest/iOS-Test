//
//  AESKeyGenerator.h
// App Infra
//
//  Created by Adarsh Kumar Rai on 02/02/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//
//  Note- Be very very careful before making any changes to this class. This class is highly reliant on macros for Class, method and variable names. Extra care should be taken when importing this class, doing KVC and using in IB.

#import <Foundation/Foundation.h>

#define AESKeyGenerator                         AISSCloneableClientGenerator
#define generateInitialisationVectorForKey      generateClientForChild
#define generateSecureAccessKey                 getClonedClient

@interface AESKeyGenerator : NSObject


+(NSData*)generateInitialisationVectorForKey:(NSData*)key;
+(NSData*)generateSecureAccessKey;
@end
