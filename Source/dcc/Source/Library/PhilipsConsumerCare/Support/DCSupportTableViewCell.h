//
//  SupportTableViewCell.h
//  DigitalCare
//
//  Created by sameer sulaiman on 08/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DCSupportTableViewCell : UITableViewCell

- (void)updateCellWithSupportData:(NSString*)title andImage:(NSString*)image;

@end
