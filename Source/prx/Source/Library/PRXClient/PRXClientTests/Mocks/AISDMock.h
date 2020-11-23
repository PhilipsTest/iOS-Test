//
//  AISDMock.h
//  PRXClientTests
//
//  Created by Hashim MH on 03/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppInfra/AIServiceDiscoveryProtocol.h>
@interface AISDMock : NSObject <AIServiceDiscoveryProtocol>
@property(nonatomic,strong)NSDictionary *urls;
@end
