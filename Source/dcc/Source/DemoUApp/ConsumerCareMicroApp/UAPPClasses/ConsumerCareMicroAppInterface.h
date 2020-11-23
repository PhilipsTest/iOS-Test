//
//  ConsumerCareMicroAppInterface.h
//  ConsumerCareMicroApp
//
//  Created by Niharika Bundela on 3/22/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UAPPFramework/UAPPFramework.h>
@interface ConsumerCareMicroAppInterface : NSObject<UAPPProtocol>
@property(nonatomic,strong)AIAppInfra *appInfra;
@end
