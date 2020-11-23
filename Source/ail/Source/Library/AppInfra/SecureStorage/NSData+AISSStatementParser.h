//
//  NSData+Encryption.h
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

#pragma mark - Macro Definitions of Class and Method Names
#define Encryption              AISSStatementParser
#define AES256EncryptWithKey    parseStatement
#define andInitialisationVector andSuffix
#define AES256DecryptWithKey    loadStatement


@interface NSData (Encryption)
// method to generate the secured data
- (NSData *)AES256EncryptWithKey:(NSData *)key
         andInitialisationVector:(NSData*)initialisationVector
                           error:(NSError **)error;
// method to convert into actual data
// method to convert into actual data
- (NSData *)AES256DecryptWithKey:(NSData *)key
                           error:(NSError **)error;


@end
