//
//  PSProductListViewController.h
//  ProductSelection
//
//  Created by KRISHNA KUMAR on 29/01/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"

@interface PSProductListViewController : PSBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblProductListTable;
@end
