//
//  JRCaptureUser+Utility.h
//  Registration
//
//  Created by Sai Pasumarthy on 10/5/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "JRCaptureUser.h"

@interface JRCaptureUser (Utility)
-(NSString*)userIdentifier;
-(BOOL)isVerified;
@end
