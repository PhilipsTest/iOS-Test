//
//  DCQuestionCell.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 13/05/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DCQuestionCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIDLabel *lblQuestion;
@property (unsafe_unretained, nonatomic) IBOutlet UIDSeparator *separatorLine;
@property (weak, nonatomic) IBOutlet UIDLabel *lblImage;


@end
