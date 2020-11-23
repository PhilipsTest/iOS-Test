//
//  DCProductVideoCollectionCell.h
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 11/4/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DCViewProductCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIDProgressButton *videoPlayButton;

@end
