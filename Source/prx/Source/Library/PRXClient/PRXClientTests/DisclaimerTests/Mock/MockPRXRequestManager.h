//
//  MockPRXRequestiManager.h
//  PRXClientTests
//
//  Created by Prasad Devadiga on 21/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXRequestManager.h"
#import "PhilipsPRXClientDev.h"

typedef enum : NSUInteger {
    requestTypeAssets,
    requestTypeSupport,
    requestTypeDisclaimer,
    requestTypeError,
} RequestType;

@interface MockPRXRequestManager : PRXRequestManager
@property (nonatomic) RequestType type;
@end
