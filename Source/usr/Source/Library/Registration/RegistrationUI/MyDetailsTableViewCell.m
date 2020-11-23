//
//  MyDetailsTableViewCell.m
//  PhilipsRegistration
//
//  Created by Sagarika Barman on 2/7/18.
//  Copyright © 2018 Philips. All rights reserved.
//

#import "MyDetailsTableViewCell.h"

@implementation MyDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.myDetailsTitlelabel.font = [[UIFont alloc] initWithUidFont:UIDFontBook size:16];
    self.myDetailsContentLabel.font = [[UIFont alloc] initWithUidFont:UIDFontBook size:16];
}

@end
