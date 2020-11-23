//
//  AILoggingFormatter.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V., 
 All rights are reserved. Reproduction or dissemination in whole or 
 in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppInfra.h"

@protocol DDLogFormatter;

@interface AILoggingFormatter : NSObject<DDLogFormatter>

@property(nonatomic,retain) NSDateFormatter *dateFormatter;

@end
