//
//  AICloudApiSigner.h
//  AppInfra
//
//  Created by Hashim MH on 07/06/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfra.h"
@interface AICloudApiSigner : NSObject <AIAPISigningProtocol>
- (id)initApiSigner:(NSString *)sharedKey andhexKey:(NSString *)hexKey;
@end
