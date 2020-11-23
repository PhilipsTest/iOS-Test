//
//  UIViewController+URAdditions.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 05/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "UIViewController+URAdditions.h"


@implementation UIViewController (URAdditions)

- (BOOL)navigationControllerContainsClass:(Class)classType {
    //Get all view controllers in navigation controller currently
    for(UIViewController *tempVC in self.navigationController.viewControllers) {
        if([tempVC isKindOfClass:classType]) {
            return YES;
        }
    }
    return NO;
}

@end
