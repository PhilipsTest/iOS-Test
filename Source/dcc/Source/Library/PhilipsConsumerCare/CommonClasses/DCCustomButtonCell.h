//
//  DCCustomButtonCell.h
//  CollectionView
//
//  Created by KRISHNA KUMAR on 14/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DCCustomButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIconForButton;
@property (weak, nonatomic) IBOutlet UIDLabel *lblMenuTitle;
@property (weak, nonatomic) IBOutlet UIDLabel *lblMenuIcon;

@end
