//
//  JRCaptureUser+Utility.m
//  Registration
//
//  Created by Sai Pasumarthy on 10/5/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "JRCaptureUser+Utility.h"

@implementation JRCaptureUser (Utility)
-(NSString*)userIdentifier {
    return self.mobileNumber != nil ? self.mobileNumber : self.email;
}
-(BOOL)isVerified {
    return (self.emailVerified != nil) || (self.mobileNumberVerified != nil);
}
@end
