//
//  DCProductVideoCollectionCell.m
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 11/4/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCViewProductCollectionCell.h"
#import "UIButton+DCExternal.h"
#import "DCConstants.h"
#import "DCUtilities.h"
#import "UIButton+DCExternal.h"
@import PhilipsIconFontDLS;
@import PhilipsUIKitDLS;

@implementation DCViewProductCollectionCell

- (void)awakeFromNib {
    self.videoPlayButton.titleLabel.font = [UIFont iconFontWithSize:25.0];
    [self.videoPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.videoPlayButton setTitle:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeStartAction] forState:UIControlStateNormal];
    [super awakeFromNib];
}

@end
