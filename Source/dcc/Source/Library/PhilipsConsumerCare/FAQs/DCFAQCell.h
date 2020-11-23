//
//  DCQuestionCell.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 07/04/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DCFAQCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDHyperLinkLabel *lblDownIcon;
@property (weak, nonatomic) IBOutlet UIDLabel *lblQuestionAndAnswer;
@property (weak, nonatomic) IBOutlet UIDSeparator *separatorLine;

@end
