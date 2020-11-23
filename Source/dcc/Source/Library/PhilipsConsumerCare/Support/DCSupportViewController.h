//
//  ViewController.h
//  DigitalCare
//
//  Created by sameer sulaiman on 05/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
#import "DCBaseViewController.h"
#import "DCMainMenuProtocol.h"
@import PhilipsProductSelection;

@interface DCSupportViewController : DCBaseViewController
@property (strong, nonatomic) PSHardcodedProductList *productList;
@end

