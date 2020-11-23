//
//  DCServiceTaskFactory.h
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "DCServiceTaskHandler.h"
#import "DCRequestBaseUrl.h"

@interface DCServiceTaskFactory : NSObject

- (DCServiceTaskHandler*) getInstanceforRequest:(DCRequestBaseUrl*)requestBase;

@end
