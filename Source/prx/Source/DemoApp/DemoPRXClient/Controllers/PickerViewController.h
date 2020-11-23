//
//  PickerViewController.h
//  DemoPRXClient
//
//  Created by Prasad Devadiga on 07/12/18.
//  Copyright © 2018 sameer sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerViewController : UIViewController

@property (strong, nonatomic) NSArray * sectors;
@property (strong, nonatomic) NSArray * countries;
@property (strong, nonatomic) NSArray * catalogs;

@end

NS_ASSUME_NONNULL_END
