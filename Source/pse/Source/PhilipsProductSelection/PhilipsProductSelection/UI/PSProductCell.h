//
//  PSProductCell.h
//  ProductSelection
//
//  Created by KRISHNA KUMAR on 29/01/16.
//  Copyright © 2016 Philips. All rights reserved.
//

@import PhilipsUIKitDLS;
@interface PSProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProductIcon;
@property (weak, nonatomic) IBOutlet UIDLabel *lblProductTitle;
@property (weak, nonatomic) IBOutlet UIDLabel *lblProductCTN;
@property (weak, nonatomic) IBOutlet UIDLabel *imgRightArrow;

@end
