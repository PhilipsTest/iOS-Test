//
//  PSProductUnavailableCell.h
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 6/29/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;
@interface PSProductUnavailableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDLabel*lblMessageTitle;
@property (weak, nonatomic) IBOutlet UIDLabel *lblMessageDescription;
@property (weak, nonatomic) IBOutlet UIDLabel *lblAlert;


@end
