//
//  MyDetailsTableViewCell.h
//  PhilipsRegistration
//
//  Created by Sagarika Barman on 2/7/18.
//  Copyright © 2018 Philips. All rights reserved.
//

@import PhilipsUIKitDLS;

@interface MyDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDLabel *myDetailsTitlelabel;
@property (weak, nonatomic) IBOutlet UIDLabel *myDetailsContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintForCell;

@end
