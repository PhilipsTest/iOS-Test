//
//  AISSLPinManager.h
//  AppInfra
//
//  Created by Anthony G on 24/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"

@interface AILSSLPublicKeyManager : NSObject

@property (nonatomic, weak) id<AIAppInfraProtocol> _Nullable appInfra;


+ (instancetype _Nonnull)sharedSSLPublicKeyManager;

-(void)setPublicPinsInfo:(id<NSCoding> _Nonnull)pinsInfo forHostName:(NSString* _Nonnull)hostName
                   error:(NSError *_Nullable*_Nullable)error;

-(NSDictionary *_Nullable)publicPinsInfoForHostName:(NSString*_Nonnull)hostName error:( NSError *_Nullable* _Nullable)error;

- (void)logWithEventId:(NSString *_Nonnull)eventId message:(NSString *_Nonnull)message hostName:(NSString *_Nonnull)hostName;

+(NSArray *_Nullable)extractPublicKeysFromText:(NSString *_Nonnull)publicKeyPinInfoStr;

+(NSString *_Nullable)extractMaxAgeFromText:(NSString *_Nonnull)publicKeyPinInfoStr ;


@end
