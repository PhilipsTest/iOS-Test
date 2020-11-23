//
//  AILanguagePack.h
//  AppInfra
//
//  Created by Hashim MH on 13/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AILanguagePackProtocol.h"
#import "AIAppInfraProtocol.h"
@interface AILanguagePack : NSObject<AILanguagePackProtocol>

/**
 *  Initializes an instance of a Language Pack
 *  use initWithAppInfra init method
 *  @return nil as this method is unavailable
 */
- (nullable instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithAppInfra:(nonnull id <AIAppInfraProtocol> )appInfra;
@end
