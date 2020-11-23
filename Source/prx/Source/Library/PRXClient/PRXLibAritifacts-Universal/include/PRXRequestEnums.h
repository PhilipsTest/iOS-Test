//
//  PRXRequestEnums.h
//  PRXClient
//
//  Created by Sumit Prasad on 28/03/16.
//  Copyright © 2016 sameer sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET,
    POST
} REQUESTTYPE;
@interface PRXRequestEnums : NSObject
+ (NSString *)stringWithRequestType:(REQUESTTYPE)input;
@end
