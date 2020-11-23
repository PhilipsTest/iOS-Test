//
//  AIHSDPPHSApiSigning.h
//  AppInfra
//
//  Created by Abhishek on 27/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIAPISigningProtocol.h"
#import "AIAppInfraProtocol.h"

#define AIHSDPPHSApiSigning AIClonableClient

@interface AIHSDPPHSApiSigning : NSObject <AIAPISigningProtocol>

- (id)initApiSigner:(NSString *)sharedKey andhexKey:(NSString *)hexKey;

@end
