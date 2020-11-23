//
//  SupportTableViewCell.m
//  DigitalCare
//
//  Created by sameer sulaiman on 08/12/14.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCSupportTableViewCell.h"
#import "DCUtilities.h"
#import "DCPluginManager.h"
#import "DCConstants.h"

@interface DCSupportTableViewCell()

@property(nonatomic,weak)IBOutlet UIDLabel*title;
@property(nonatomic,weak)IBOutlet UIImageView*image;
@property (weak, nonatomic) IBOutlet UIImageView *imgRtlSupport;

@end

@implementation DCSupportTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)updateCellWithSupportData:(NSString*)title andImage:(NSString*)image
{
    self.title.text = title;
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.title.textAlignment=NSTextAlignmentNatural;
         self.imgRtlSupport.image = [self getImage:image];
    }
    else
    {
       self.imageView.image = [self getImage:image];
    }
}

-(UIImage *)getImage:(NSString *)imageName
{
    return [[DCUtilities dcMenuIconIcons] objectForKey:imageName]?[DCUtilities imageForText:[[DCUtilities dcMenuIconIcons] objectForKey:imageName] withFontSize:22.0 withColor:[UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground]:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]] ;
    }

@end
