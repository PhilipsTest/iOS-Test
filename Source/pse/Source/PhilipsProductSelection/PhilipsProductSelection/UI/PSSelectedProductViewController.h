//
//  PSSelectedProductViewController.h
//  ProductSelection
//
//  Created by sameer sulaiman on 2/1/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"
#import <PhilipsPRXClient/PRXSummaryData.h>

@interface PSSelectedProductViewController : PSBaseViewController

@property (nonatomic, strong) PRXSummaryData *selectedProductSummary;

@end